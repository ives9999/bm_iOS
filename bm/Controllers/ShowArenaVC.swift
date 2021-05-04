//
//  ShowArenaVC.swift
//  bm
//
//  Created by ives sun on 2021/5/4.
//  Copyright © 2021 bm. All rights reserved.
//

import UIKit
import WebKit

class ShowArenaVC: BaseViewController, UITableViewDelegate, UITableViewDataSource, WKUIDelegate,  WKNavigationDelegate {

    var arena_token: String?
    @IBOutlet weak var featured: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var tableView: SuperTableView!
    
    @IBOutlet weak var mainDataLbl: SuperLabel!
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
    
    var myTable: ArenaTable?
    
    var tableRowKeys:[String] = ["tel_show","address","fb","interval_show","block","bathroom","air_condition_show","parking_show","pv","created_at_show"]
    var tableRows: [String: [String:String]] = [
        "tel_show":["icon":"tel","title":"電話","content":""],
        "address":["icon":"map","title":"住址","content":""],
        "fb": ["icon":"fb","title":"FB","content":""],
        "interval_show":["icon":"clock","title":"時段","content":""],
        "block":["icon":"block","title":"場地","content":""],
        "bathroom":["icon":"bathroom","title":"浴室","content":""],
        "air_condition_show":["icon":"air_condition","title":"空調","content":""],
        "parking_show":["icon":"parking","title":"停車場","content":""],
        "pv":["icon":"pv","title":"瀏覽數","content":""],
        "created_at_show":["icon":"calendar","title":"建立日期","content":""]
    ]
    
    var contentViewConstraintHeight: NSLayoutConstraint?
    
    var isLike: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataService = ArenaService.instance
        
        let cellNib = UINib(nibName: "OneLineCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "cell")
        
        initTableView()
        initContentView()

        beginRefresh()
        scrollView.addSubview(refreshControl)
        refresh()
    }

    override func viewWillLayoutSubviews() {
        mainDataLbl.text = "球館資料"
        contentDataLbl.text = "詳細介紹"
        mainDataLbl.textColor = UIColor(MY_RED)
        contentDataLbl.textColor = UIColor(MY_RED)
        mainDataLbl.textAlignment = .left
        contentDataLbl.textAlignment = .left
    }
    
    func initTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableViewConstraintHeight.constant = 1000
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
        if arena_token != nil {
            Global.instance.addSpinner(superView: view)
            //print(Member.instance.token)
            let params: [String: String] = ["token": arena_token!, "member_token": Member.instance.token]
            dataService.getOne(t: ArenaTable.self, params: params) { (success) in
                if (success) {
                    let table: Table = self.dataService.table!
                    self.myTable = table as? ArenaTable
                    
                    if self.myTable != nil {
                        self.myTable!.filterRow()
                        //self.courseTable!.signup_normal_models
                        
                        self.titleLbl.text = self.myTable?.name
                        self.setMainData() // setup course basic data
                        self.setFeatured() // setup featured
                        
                        self.isLike = self.myTable!.like
                        self.likeButton.initStatus(self.isLike, self.myTable!.like_count)
                        
                        self.tableView.reloadData()
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
        //print(contentViewConstraintHeight)
        
        //let h: CGFloat = h1 + h2 + h3 + h4 + h5
        let h: CGFloat = h1 + h2 + h3 + h6 + h7 + 300
        scrollView.contentSize = CGSize(width: view.frame.width, height: h)
        ContainerViewConstraintHeight.constant = h
        //print(h1)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return tableRowKeys.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableView {
            let cell: OneLineCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OneLineCell
            
            //填入資料
            let key = tableRowKeys[indexPath.row]
            if tableRows[key] != nil {
                let row = tableRows[key]!
                let icon = row["icon"] ?? ""
                let title = row["title"] ?? ""
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
