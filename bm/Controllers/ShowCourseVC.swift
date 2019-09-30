//
//  ShowCourseVC1.swift
//  bm
//
//  Created by ives on 2019/7/5.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit
import WebKit

class ShowCourseVC: BaseViewController, UITableViewDelegate, UITableViewDataSource, WKUIDelegate,  WKNavigationDelegate {
    
    var course_token: String?
    var source: String = "coach"
    var delegate: EditCourseDelegate?
    
    @IBOutlet weak var tableViewConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var signupTableViewConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var coachTableViewConstraintHeight: NSLayoutConstraint!
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContainerView: UIView!
    @IBOutlet weak var ContainerViewConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var featured: UIImageView!
    @IBOutlet weak var courseDataLbl: SuperLabel!
    @IBOutlet weak var tableView: SuperTableView!
    @IBOutlet weak var signupDataLbl: SuperLabel!
    @IBOutlet weak var signupTableView: SuperTableView!
    @IBOutlet weak var coachDataLbl: SuperLabel!
    @IBOutlet weak var coachTableView: SuperTableView!
    @IBOutlet weak var contentLbl: SuperLabel!
    @IBOutlet weak var signupButton: SubmitButton!
    @IBOutlet weak var signupListButton: CancelButton!
    
    var contentView: WKWebView? = {
        
        //Create configuration
        let configuration = WKWebViewConfiguration()
        //configuration.userContentController = controller
        
        let webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        webView.backgroundColor = UIColor.clear
        webView.scrollView.isScrollEnabled = false
        return webView
    }()
    var contentViewConstraintHeight: NSLayoutConstraint?
    
    let tableRowKeys:[String] = ["weekday_text","interval","date","price_text_long","people_limit_text","kind_text","pv","created_at_text"]
    var tableRows: [String: [String:String]] = [
        "weekday_text":["icon":"calendar","title":"星期","content":""],
        "interval":["icon":"clock","title":"時段","content":""],
        "date":["icon":"calendar","title":"期間","content":""],
        "price_text_long":["icon":"money","title":"收費","content":""],
        "people_limit_text":["icon":"group","title":"限制人數","content":""],
        "kind_text": ["icon":"cycle","title":"週期","content":""],       // "signup_count":["icon":"group","title":"已報名人數","content":""],
        "pv":["icon":"pv","title":"瀏覽數","content":""],
        "created_at_text":["icon":"calendar","title":"建立日期","content":""]
        
    ]
    
    let signupTableRowKeys:[String] = ["date", "deadline"]
    var signupTableRows: [String: [String:String]] = [
        "date":["icon":"calendar","title":"報名上課日期","content":"","isPressed":"false"],
        "deadline":["icon":"clock","title":"報名截止時間","content":"","isPressed":"false"]
    ]
    
    let coachTableRowKeys:[String] = [NAME_KEY,MOBILE_KEY,LINE_KEY,FB_KEY,YOUTUBE_KEY,WEBSITE_KEY,EMAIL_KEY]
    var coachTableRows: [String: [String:String]] = [
        NAME_KEY:["icon":"coach","title":"教練","content":"","isPressed":"true"],
        MOBILE_KEY:["icon":"mobile","title":"行動電話","content":"","isPressed":"true"],
        LINE_KEY:["icon":"line","title":"line id","content":"","isPressed":"false"],
        FB_KEY:["icon":"fb","title":"fb","content":"","isPressed":"true"],
        YOUTUBE_KEY:["icon":"youtube","title":"youtube","content":"","isPressed":"true"],
        WEBSITE_KEY:["icon":"website","title":"網站","content":"","isPressed":"true"],
        EMAIL_KEY:["icon":"email1","title":"email","content":"","isPressed":"true"]
    ]
    
    var superCourse: SuperCourse?
    var superCoach: SuperCoach?
    
    var fromNet: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.backgroundColor = UIColor.clear
        
        let cellNib = UINib(nibName: "IconCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "cell")
        signupTableView.register(cellNib, forCellReuseIdentifier: "cell")
        coachTableView.register(cellNib, forCellReuseIdentifier: "cell")
        initTableView()
        initSignupTableView()
        initCoachTableView()
        initContentView()
        
        signupButton.setTitle("報名")
        signupListButton.setTitle("報名列表")
        
        beginRefresh()
        scrollView.addSubview(refreshControl)
        refresh()
    }
    
    override func viewWillLayoutSubviews() {
        courseDataLbl.text = "課程資料"
        signupDataLbl.text = "報名資料"
        coachDataLbl.text = "教練資料"
        contentLbl.text = "詳細介紹"
        courseDataLbl.textColor = UIColor(MY_RED)
        signupDataLbl.textColor = UIColor(MY_RED)
        coachDataLbl.textColor = UIColor(MY_RED)
        contentLbl.textColor = UIColor(MY_RED)
        courseDataLbl.textAlignment = .left
        signupDataLbl.textAlignment = .left
        coachDataLbl.textAlignment = .left
        contentLbl.textAlignment = .left
        
    }
    
    func initTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 600
        tableViewConstraintHeight.constant = 1000
    }
    
    func initSignupTableView() {
        
        signupTableView.dataSource = self
        signupTableView.delegate = self
        signupTableView.rowHeight = UITableViewAutomaticDimension
        signupTableView.estimatedRowHeight = 300
        signupTableViewConstraintHeight.constant = 1000
    }
    
    func initCoachTableView() {
        
        coachTableView.dataSource = self
        coachTableView.delegate = self
        coachTableView.rowHeight = UITableViewAutomaticDimension
        coachTableView.estimatedRowHeight = 600
        coachTableViewConstraintHeight.constant = 3000
    }
    
    func initContentView() {
        
        scrollContainerView.addSubview(contentView!)
        var c1: NSLayoutConstraint, c2: NSLayoutConstraint, c3: NSLayoutConstraint
        
        c1 = NSLayoutConstraint(item: contentView!, attribute: .leading, relatedBy: .equal, toItem: contentView!.superview, attribute: .leading, multiplier: 1, constant: 8)
        c2 = NSLayoutConstraint(item: contentView!, attribute: .top, relatedBy: .equal, toItem: contentLbl, attribute: .bottom, multiplier: 1, constant: 8)
        c3 = NSLayoutConstraint(item: contentView!, attribute: .trailing, relatedBy: .equal, toItem: contentView!.superview, attribute: .trailing, multiplier: 1, constant: 8)
        contentViewConstraintHeight = NSLayoutConstraint(item: contentView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        contentView!.translatesAutoresizingMaskIntoConstraints = false
        scrollContainerView.addConstraints([c1,c2,c3,contentViewConstraintHeight!])
        contentView!.uiDelegate = self
        contentView!.navigationDelegate = self
    }
    
    override func refresh() {
        if course_token != nil {
            Global.instance.addSpinner(superView: view)
            let params: [String: String] = ["token": course_token!, "member_token": Member.instance.token]
            CourseService.instance.getOne(t: SuperCourse.self, params: params) { (success) in
                if (success) {
                    let superModel: SuperModel = CourseService.instance.superModel
                    self.superCourse =
                        (superModel as! SuperCourse)
                    
                    if self.superCourse != nil {
                        //self.superCourse!.printRow()
                        self.superCoach = self.superCourse!.coach
                        self.setMainData()
                        self.setFeatured()
                        self.setCoachData()
                        self.setSignupData()
                        self.fromNet = true
                        
                        self.tableView.reloadData()
                        self.signupTableView.reloadData()
                        self.coachTableView.reloadData()
                        
                        if self.superCourse!.isSignup {
                            self.signupButton.setTitle("取消報名")
                        }
                    }
                }
                Global.instance.removeSpinner(superView: self.view)
                self.endRefresh()
            }
        }
    }
    
    func setMainData() {
        for key in tableRowKeys {
            if (superCourse!.responds(to: Selector(key))) {
                let content: String = String(describing:(superCourse!.value(forKey: key))!)
                tableRows[key]!["content"] = content
            }
        }
        
        let date = superCourse!.start_date + " ~ " + superCourse!.end_date
        tableRows["date"]!["content"] = date
        let interval = superCourse!.start_time_text + " ~ " + superCourse!.end_time_text
        tableRows["interval"]!["content"] = interval
        
        let content: String = "<html><HEAD><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no\">"+self.body_css+"</HEAD><body>"+self.superCourse!.content+"</body></html>"
        
        contentView!.loadHTMLString(content, baseURL: nil)
    }
    
    func setFeatured() {
        
        if superCourse!.featured_path.count > 0 {
            let featured_path = superCourse!.featured_path
            if featured_path.count > 0 {
                //print(featured_path)
                featured.downloaded(from: featured_path)
            }
        }
        //featured.image = superCourse!.featured
    }
    
    func setSignupData() {
        let nextCourseTime: [String: String] = superCourse!.nextCourseTime
        for key in signupTableRowKeys {
            signupTableRows[key]!["content"] = nextCourseTime[key]
        }
    }
    
    func setCoachData() {
        for key in coachTableRowKeys {
            if (superCoach!.responds(to: Selector(key))) {
                let content: String = String(describing:(self.superCoach!.value(forKey: key))!)
                coachTableRows[key]!["content"] = content
            }
        }
        //print(self.coachTableRows)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !fromNet {
            return 0
        } else {
            if tableView == self.tableView {
                return tableRowKeys.count
            } else if tableView == self.signupTableView {
                return signupTableRowKeys.count
            } else if tableView == self.coachTableView {
                return coachTableRowKeys.count
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: IconCell?
        cell = (tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! IconCell)
        
        if tableView == self.tableView {
            let key = tableRowKeys[indexPath.row]
            if tableRows[key] != nil {
                let row = tableRows[key]!
                let icon = row["icon"] ?? ""
                let title = row["title"] ?? ""
                let content = row["content"] ?? ""
                cell!.update(icon: icon, title: title, content: content)
            }
            
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
        } else if tableView == self.signupTableView {
            let key = signupTableRowKeys[indexPath.row]
            if signupTableRows[key] != nil {
                let row = signupTableRows[key]!
                let icon = row["icon"] ?? ""
                let title = row["title"] ?? ""
                let content = row["content"] ?? ""
                let isPressed = NSString(string: row["isPressed"] ?? "false").boolValue
                cell!.update(icon: icon, title: title, content: content, isPressed: isPressed)
            }
            if indexPath.row == signupTableRowKeys.count - 1 {
                
                UIView.animate(withDuration: 0, animations: {self.signupTableView.layoutIfNeeded()}) { (complete) in
                    var heightOfTableView: CGFloat = 0.0
                    let cells = self.signupTableView.visibleCells
                    for cell in cells {
                        heightOfTableView += cell.frame.height
                    }
                    //print(heightOfTableView)
                    self.signupTableViewConstraintHeight.constant = heightOfTableView
                    self.changeScrollViewContentSize()
                }
            }
        } else if tableView == self.coachTableView {
            
            let key = coachTableRowKeys[indexPath.row]
            if coachTableRows[key] != nil {
                let row = coachTableRows[key]!
                let icon = row["icon"] ?? ""
                let title = row["title"] ?? ""
                var content = row["content"] ?? ""
                if key == MOBILE_KEY && content.count > 0 {
                    content = content.mobileShow()
                }
                let isPressed = NSString(string: row["isPressed"] ?? "false").boolValue
                cell!.update(icon: icon, title: title, content: content, isPressed: isPressed)
            }
            
            if indexPath.row == coachTableRowKeys.count - 1 {
                
                UIView.animate(withDuration: 0, animations: {self.coachTableView.layoutIfNeeded()}) { (complete) in
                    var heightOfTableView: CGFloat = 0.0
                    let cells = self.coachTableView.visibleCells
                    for cell in cells {
                        heightOfTableView += cell.frame.height
                    }
                    //print(heightOfTableView)
                    self.coachTableViewConstraintHeight.constant = heightOfTableView
                    self.changeScrollViewContentSize()
                }
            }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.coachTableView {
            let key = coachTableRowKeys[indexPath.row]
            if key == NAME_KEY {
                let sender: Show_IN = Show_IN(type: source,id:superCoach!.id,token:superCoach!.token,title:superCoach!.name)
                performSegue(withIdentifier: TO_SHOW, sender: sender)
            } else if key == MOBILE_KEY {
                superCoach!.mobile.makeCall()
            } else if key == LINE_KEY {
                superCoach!.line.line()
            } else if key == FB_KEY {
                superCoach!.fb.fb()
            } else if key == YOUTUBE_KEY {
                superCoach!.youtube.youtube()
            } else if key == WEBSITE_KEY {
                superCoach!.website.website()
            } else if key == EMAIL_KEY {
                superCoach!.email.email()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == TO_SHOW {
            let sender = sender as! Show_IN
            let showVC: ShowVC = segue.destination as! ShowVC
            showVC.show_in = sender
        }
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
        let h2 = courseDataLbl.bounds.size.height
        let h3 = tableViewConstraintHeight.constant
        let h4 = coachDataLbl.bounds.size.height
        let h5 = coachTableViewConstraintHeight.constant
        let h6 = contentLbl.bounds.size.height
        let h7 = contentViewConstraintHeight!.constant
        let h8 = signupDataLbl.bounds.size.height
        let h9 = signupTableViewConstraintHeight.constant
        //print(contentViewConstraintHeight)
        
        //let h: CGFloat = h1 + h2 + h3 + h4 + h5
        let h: CGFloat = h1 + h2 + h3 + h4 + h5 + h6 + h7 + h8 + h9 + 100
        scrollView.contentSize = CGSize(width: view.frame.width, height: h)
        ContainerViewConstraintHeight.constant = h
        //print(h1)
    }
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func signupListButtonPressed(_ sender: Any) {
        
    }

    @IBAction func prevBtnPressed(_ sender: Any) {
        if delegate != nil {
            delegate!.isReload(false)
        }
        prev()
    }

}
