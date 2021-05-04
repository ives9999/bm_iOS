//
//  ShowTeamVC.swift
//  bm
//
//  Created by ives on 2021/5/2.
//  Copyright © 2021 bm. All rights reserved.
//

import UIKit
import WebKit

class ShowTeamVC: BaseViewController, UITableViewDelegate, UITableViewDataSource, WKUIDelegate,  WKNavigationDelegate {
    
    @IBOutlet weak var featured: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var tableView: SuperTableView!
    @IBOutlet weak var signupTableView: SuperTableView!
    
    
    @IBOutlet weak var mainDataLbl: SuperLabel!
    @IBOutlet weak var signupDataLbl: SuperLabel!
    @IBOutlet weak var contentDataLbl: SuperLabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContainerView: UIView!
    
    @IBOutlet weak var tableViewConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var signupTableViewConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var ContainerViewConstraintHeight: NSLayoutConstraint!
    
    @IBOutlet weak var likeButton: LikeButton!
    
    var contentView: WKWebView? = {
        
        //Create configuration
        let configuration = WKWebViewConfiguration()
        //configuration.userContentController = controller
        
        let webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        webView.backgroundColor = UIColor.clear
        webView.scrollView.isScrollEnabled = false
        return webView
    }()
    
    var team_token: String?
    var myTable: TeamTable?
    
    var tableRowKeys:[String] = ["arena","interval_show","ball","leader","mobile_show","fb","youtube","website","email","pv","created_at_show"]
    var tableRows: [String: [String:String]] = [
        "arena":["icon":"arena","title":"球館","content":""],
        "interval_show":["icon":"clock","title":"時段","content":""],
        "ball":["icon":"ball","title":"球種","content":""],
        "leader":["icon":"member1","title":"隊長","content":""],
        "mobile_show":["icon":"mobile","title":"行動電話","content":""],
        "fb": ["icon":"fb","title":"FB","content":""],
        "youtube":["icon":"youtube","title":"Youtube","content":""],
        "website":["icon":"website","title":"網站","content":""],
        "email":["icon":"email1","title":"EMail","content":""],
        "pv":["icon":"pv","title":"瀏覽數","content":""],
        "created_at_show":["icon":"calendar","title":"建立日期","content":""]
    ]
    
    var contentViewConstraintHeight: NSLayoutConstraint?
    
    var isLike: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataService = TeamService.instance
        
        let cellNib = UINib(nibName: "OneLineCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "cell")
        signupTableView.register(cellNib, forCellReuseIdentifier: "cell")
        
        initTableView()
        initSignupTableView()
        initContentView()

        beginRefresh()
        scrollView.addSubview(refreshControl)
        refresh()
    }
    
    override func viewWillLayoutSubviews() {
        mainDataLbl.text = "球隊資料"
        signupDataLbl.text = "臨打報名"
        signupDataLbl.isHidden = true
        contentDataLbl.text = "詳細介紹"
        mainDataLbl.textColor = UIColor(MY_RED)
        signupDataLbl.textColor = UIColor(MY_RED)
        contentDataLbl.textColor = UIColor(MY_RED)
        mainDataLbl.textAlignment = .left
        signupDataLbl.textAlignment = .left
        contentDataLbl.textAlignment = .left
        
    }
    
    func initTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableViewConstraintHeight.constant = 1000
    }
    
    func initSignupTableView() {

        signupTableView.dataSource = self
        signupTableView.delegate = self
        signupTableView.rowHeight = UITableView.automaticDimension
        //signupTableView.estimatedRowHeight = 300
        signupTableViewConstraintHeight.constant = 0
    }
    
    func initContentView() {
        
        scrollContainerView.addSubview(contentView!)
        var c1: NSLayoutConstraint, c2: NSLayoutConstraint, c3: NSLayoutConstraint
        
        c1 = NSLayoutConstraint(item: contentView!, attribute: .leading, relatedBy: .equal, toItem: contentView!.superview, attribute: .leading, multiplier: 1, constant: 8)
        c2 = NSLayoutConstraint(item: contentView!, attribute: .top, relatedBy: .equal, toItem: contentDataLbl, attribute: .bottom, multiplier: 1, constant: 8)
        c3 = NSLayoutConstraint(item: contentView!, attribute: .trailing, relatedBy: .equal, toItem: contentView!.superview, attribute: .trailing, multiplier: 1, constant: 8)
        contentViewConstraintHeight = NSLayoutConstraint(item: contentView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        contentView!.translatesAutoresizingMaskIntoConstraints = false
        scrollContainerView.addConstraints([c1,c2,c3,contentViewConstraintHeight!])
        contentView!.uiDelegate = self
        contentView!.navigationDelegate = self
    }
    
    override func refresh() {
        if team_token != nil {
            Global.instance.addSpinner(superView: view)
            //print(Member.instance.token)
            let params: [String: String] = ["token": team_token!, "member_token": Member.instance.token]
            dataService.getOne(t: TeamTable.self, params: params) { (success) in
                if (success) {
                    let table: Table = self.dataService.table!
                    self.myTable = table as? TeamTable
                    
                    if self.myTable != nil {
                        self.myTable!.filterRow()
                        //self.courseTable!.signup_normal_models
                        
                        self.titleLbl.text = self.myTable?.name
                        self.setMainData() // setup course basic data
                        self.setFeatured() // setup featured
                        
                        //if self.myTable!.dateTable != nil { // setup next time course time
                            //self.courseTable!.dateTable?.printRow()
                           // self.setNextTime()
                        //}
                        //self.fromNet = true
                        
                        self.isLike = self.myTable!.like
                        self.likeButton.initStatus(self.isLike, self.myTable!.like_count)
                        
                        self.tableView.reloadData()
                        //self.signupTableView.reloadData()
                    }
                }
                Global.instance.removeSpinner(superView: self.view)
                //self.endRefresh()
            }
        }
    }
    
    func setFeatured() {
        
        if myTable!.featured_path.count > 0 {
            let featured_path = myTable!.featured_path
            if featured_path.count > 0 {
                //print(featured_path)
                featured.downloaded(from: featured_path)
            }
        }
    }
    
    func setMainData() {
        
        let mirror: Mirror = Mirror(reflecting: myTable!)
        let propertys: [[String: Any]] = mirror.toDictionary()
        
        for key in tableRowKeys {
            
            for property in propertys {
                
                if ((property["label"] as! String) == key) {
                    var type: String = property["type"] as! String
                    type = type.getTypeOfProperty()!
                    //print("label=>\(property["label"]):value=>\(property["value"]):type=>\(type)")
                    var content: String = ""
                    if type == "Int" {
                        content = String(property["value"] as! Int)
                    } else if type == "Bool" {
                        content = String(property["value"] as! Bool)
                    } else if type == "String" {
                        content = property["value"] as! String
                    }
                    tableRows[key]!["content"] = content
                    break
                }
            }
        }
        
        let content: String = "<html><HEAD><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no\">"+self.body_css+"</HEAD><body>"+self.myTable!.content+"</body></html>"
        
        contentView!.loadHTMLString(content, baseURL: nil)
    }
    
    func setNextTime() {
//        let dateTable: DateTable = myTable!.dateTable!
//        let date: String = dateTable.date
//        let start_time: String = myTable!.start_time_show
//        let end_time: String = myTable!.end_time_show
//        let next_time = "下次上課時間：\(date) \(start_time) ~ \(end_time)"
//        signupDateLbl.text = next_time
        
        
//        let nextCourseTime: [String: String] = courseTable!.nextCourseTime
//        for key in signupTableRowKeys {
//            signupTableRows[key]!["content"] = nextCourseTime[key]
//        }
    }
    
    override func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        super.webView(webView, decidePolicyFor: navigationAction, decisionHandler: decisionHandler)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.contentView!.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                self.contentView!.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
                    self.contentViewConstraintHeight!.constant = height as! CGFloat
                    self.changeScrollViewContentSize()
                })
            }
            
        })
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
    
    func changeScrollViewContentSize() {
        
        let h1 = featured.bounds.size.height
        let h2 = mainDataLbl.bounds.size.height
        let h3 = tableViewConstraintHeight.constant
        let h6 = contentDataLbl.bounds.size.height
        let h7 = contentViewConstraintHeight!.constant
        let h8 = signupDataLbl.bounds.size.height
        let h9 = signupTableViewConstraintHeight.constant
        //print(contentViewConstraintHeight)
        
        //let h: CGFloat = h1 + h2 + h3 + h4 + h5
        let h: CGFloat = h1 + h2 + h3 + h6 + h7 + h8 + h9 + 300
        scrollView.contentSize = CGSize(width: view.frame.width, height: h)
        ContainerViewConstraintHeight.constant = h
        //print(h1)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return tableRowKeys.count
        }
//        else if tableView == self.signupTableView {
//            if courseTable != nil {
//                //let normal_count: Int = courseTable!.signupNormalTables.count
//                let standby_count: Int = courseTable!.signupStandbyTables.count
//                let people_limit: Int = courseTable!.people_limit
//                let count = people_limit + standby_count + 1
//                //print(count)
//                return count
//            } else {
//                return 0
//            }
//        } else if tableView == self.coachTableView {
//            //print(coachTableRowKeys.count)
//            return coachTableRowKeys.count
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableView {
            let cell: OneLineCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OneLineCell
            
            //填入資料
            let key = tableRowKeys[indexPath.row]
            if tableRows[key] != nil {
                var row = tableRows[key]!
                let icon = row["icon"] ?? ""
                let title = row["title"] ?? ""
                if (key == "arena") {
                    if (myTable != nil && myTable!.arena != nil) {
                        row["content"] = myTable!.arena!.name
                    } else {
                        row["content"] = "未提供"
                    }
                }
                let content = row["content"] ?? ""
                cell.update(icon: icon, title: title, content: content)
            }
            
            //計算高度
            if indexPath.row == tableRowKeys.count - 1 {
                UIView.animate(withDuration: 0, animations: {self.tableView.layoutIfNeeded()}) { (complete) in
                    var heightOfTableView: CGFloat = 0.0
                    let cells = self.tableView.visibleCells
                    for cell in cells {
                        heightOfTableView += cell.frame.height
                    }
                    //print(heightOfTableView)
                    self.tableViewConstraintHeight.constant = heightOfTableView
                    self.changeScrollViewContentSize()
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        if (!Member.instance.isLoggedIn) {
            toLogin()
        } else {
            isLike = !isLike
            likeButton.setLike(isLike)
            dataService.like(token: myTable!.token, able_id: myTable!.id)
        }
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        prev()
    }

}
