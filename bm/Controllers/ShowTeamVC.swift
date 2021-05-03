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
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var tableView: SuperTableView!
    @IBOutlet weak var featured: UIImageView!
    
    @IBOutlet weak var mainDataLbl: SuperLabel!
    @IBOutlet weak var signupDataLbl: SuperLabel!
    @IBOutlet weak var contentDataLbl: SuperLabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContainerView: UIView!
    
    @IBOutlet weak var ContainerViewConstraintHeight: NSLayoutConstraint!
    
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
    
    var tableRowKeys:[String] = ["arena","interval_show","ball","manager","mobile_show","fb","youtube","website","email","pv","created_at_show"]
    var tableRows: [String: [String:String]] = [
        "arena":["icon":"calendar","title":"球館","content":""],
        "interval_show":["icon":"clock","title":"時段","content":""],
        "ball":["icon":"calendar","title":"球種","content":""],
        "manager":["icon":"money","title":"隊長","content":""],
        "mobile_show":["icon":"group","title":"行動電話","content":""],
        "fb": ["icon":"cycle","title":"FB","content":""],
        "youtube":["icon":"group","title":"Youtube","content":""],
        "website":["icon":"group","title":"網站","content":""],
        "email":["icon":"group","title":"EMail","content":""],
        "pv":["icon":"pv","title":"瀏覽數","content":""],
        "created_at_show":["icon":"calendar","title":"建立日期","content":""]
    ]
    
    var contentViewConstraintHeight: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataService = TeamService.instance
        
        let cellNib = UINib(nibName: "OneLineCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "cell")
        
        initTableView()

        refresh()
    }
    
    override func viewWillLayoutSubviews() {
        mainDataLbl.text = "球隊資料"
        signupDataLbl.text = "報名資料"
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
        //tableViewConstraintHeight.constant = 1000
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
                        //self.coachTable = self.courseTable!.coach
                        //self.courseTable!.signup_normal_models
                        
                        self.titleLbl.text = self.myTable?.name
                        self.setMainData() // setup course basic data
                        self.setFeatured() // setup featured
                        
                        //if self.myTable!.dateTable != nil { // setup next time course time
                            //self.courseTable!.dateTable?.printRow()
                           // self.setNextTime()
                        //}
                        //self.fromNet = true
                        
                        //self.isLike = self.myTable!.like
                        //self.likeButton.initStatus(self.isLike, self.courseTable!.like_count)
                        
                        self.tableView.reloadData()
                        //self.signupTableView.reloadData()
                        
//                        if self.coachTable!.isSignup {
//                            self.signupButton.setTitle("取消報名")
//                        } else {
//                            let count = self.coachTable!.signup_normal_models.count
//                            if count >= self.coachTable!.people_limit {
//                                self.signupButton.setTitle("候補")
//                            } else {
//                                self.signupButton.setTitle("報名")
//                            }
//                        }
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
        //featured.image = courseTable!.featured
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
            
            let key = tableRowKeys[indexPath.row]
            if tableRows[key] != nil {
                let row = tableRows[key]!
                let icon = row["icon"] ?? ""
                let title = row["title"] ?? ""
                let content = row["content"] ?? ""
                cell.update(icon: icon, title: title, content: content)
            }
            
            if indexPath.row == tableRowKeys.count - 1 {
                UIView.animate(withDuration: 0, animations: {self.tableView.layoutIfNeeded()}) { (complete) in
                    var heightOfTableView: CGFloat = 0.0
                    let cells = self.tableView.visibleCells
                    for cell in cells {
                        heightOfTableView += cell.frame.height
                    }
                    //print(heightOfTableView)
                    //self.tableViewConstraintHeight.constant = heightOfTableView
                    //self.changeScrollViewContentSize()
                }
            }
            return cell
        }
        return UITableViewCell()
    }

}
