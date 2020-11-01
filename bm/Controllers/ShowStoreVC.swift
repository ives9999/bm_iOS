//
//  ShowStoreVC.swift
//  bm
//
//  Created by ives sun on 2020/10/27.
//  Copyright © 2020 bm. All rights reserved.
//

import Foundation
import WebKit

class ShowStoreVC: BaseViewController, UITableViewDelegate, UITableViewDataSource, WKUIDelegate,  WKNavigationDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContainerView: UIView!
    
    @IBOutlet weak var featured: UIImageView!
    
    @IBOutlet weak var storeDataLbl: SuperLabel!
    @IBOutlet weak var contentLbl: SuperLabel!
    
    @IBOutlet weak var tableView: SuperTableView!
    
    @IBOutlet weak var tableViewConstraintHeight: NSLayoutConstraint!
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
    var contentViewConstraintHeight: NSLayoutConstraint?
    
    var superStore: SuperStore?
    var store_token: String?
    
    var tableRowKeys:[String] = ["tel_text","mobile_text","address","fb","line","website","email","business_time","pv","created_at_text"]
    var tableRows: [String: [String:String]] = [
        "tel_text":["icon":"tel","title":"市內電話","content":""],
        "mobile_text":["icon":"mobile","title":"行動電話","content":""],
        "address":["icon":"marker","title":"住址","content":""],
        "fb":["icon":"fb","title":"FB","content":""],
        "line":["icon":"line","title":"line","content":""],
        "website":["icon":"website","title":"網站","content":""],
        "email":["icon":"email1","title":"email","content":""],
        "business_time":["icon":"clock","title":"營業時間","content":""],
        "pv":["icon":"pv","title":"瀏覽數","content":""],
        "created_at_text":["icon":"calendar","title":"建立日期","content":""]
    ]
    
    var fromNet: Bool = false
    //var cellHeight: CGFloat = 40
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //print(superStore)
        scrollView.backgroundColor = UIColor.clear
        
        let cellNib = UINib(nibName: "OneLineCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "cell")
        
        initTableView()
        initContentView()
        
        beginRefresh()
        scrollView.addSubview(refreshControl)
        refresh()
    }
    
    override func viewWillLayoutSubviews() {
        storeDataLbl.text = "體育用品店資料"
        contentLbl.text = "詳細介紹"
        
        storeDataLbl.textColor = UIColor(MY_RED)
        storeDataLbl.textAlignment = .left
        contentLbl.textColor = UIColor(MY_RED)
        contentLbl.textAlignment = .left
    }
    
    func initTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        //tableView.estimatedRowHeight = 600
        tableViewConstraintHeight.constant = 600
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
        if store_token != nil {
            Global.instance.addSpinner(superView: view)
            //print(Member.instance.token)
            let params: [String: String] = ["token": store_token!, "member_token": Member.instance.token]
            StoreService.instance.getOne(t: SuperStore.self, params: params) { (success) in
                if (success) {
                    let superModel: SuperModel = StoreService.instance.superModel
                    self.superStore =
                        (superModel as! SuperStore)
                    
                    if self.superStore != nil {
                        self.setMainData()
                        self.setFeatured()
                        self.fromNet = true
                        
                        self.tableView.reloadData()
                    }
                }
                Global.instance.removeSpinner(superView: self.view)
                self.endRefresh()
            }
        }
    }
    
    func setFeatured() {
        
        if superStore != nil {
            if superStore!.featured_path.count > 0 {
                let featured_path = superStore!.featured_path
                if featured_path.count > 0 {
                    //print(featured_path)
                    featured.downloaded(from: featured_path)
                }
            }
            //featured.image = superCourse!.featured
        }
    }
    
    func setMainData() {
        if superStore != nil {
            for key in tableRowKeys {
                if (superStore!.responds(to: Selector(key))) {
                    let content: String = String(describing:(superStore!.value(forKey: key))!)
                    tableRows[key]!["content"] = content
                }
            }
            
            if !superStore!.open_time.isEmpty {
                let business_time = superStore!.open_time_text + " ~ " + superStore!.close_time_text
                tableRows["business_time"]!["content"] = business_time
            } else {
                tableRows.removeValue(forKey: "business_time");
                tableRowKeys = tableRowKeys.filter{$0 != "business_time"}
            }
            
            let content: String = "<html><HEAD><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no\">"+self.body_css+"</HEAD><body>"+self.superStore!.content+"</body></html>"
            
            contentView!.loadHTMLString(content, baseURL: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if fromNet {
            return tableRowKeys.count
        } else {
            return 0
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        
//        if tableView == self.tableView {
//            let key = tableRowKeys[indexPath.row]
//            if tableRows[key] != nil {
//                let row = tableRows[key]!
//                let content = row["content"] ?? ""
//                _caculateCellHeight(content)
//                print("\(key):\(content.count):\(cellHeight)")
//            }
//        }
//        
//        //return 120
//        return cellHeight
//        return UITableViewAutomaticDimension
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableView {
            let cell: OneLineCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OneLineCell
            
            let key = tableRowKeys[indexPath.row]
            if tableRows[key] != nil {
                let row = tableRows[key]!
                let icon = row["icon"] ?? ""
                let title = row["title"] ?? ""
                var content = row["content"] ?? ""
                if key == "fb" && !content.isEmpty {
                    content = "連結請按此"
                }
                if key == "website" && !content.isEmpty {
                    content = "連結請按此"
                }
                cell.update(icon: icon, title: title, content: content)
                    //print("\(key):\(cell.frame.height)")
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
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.tableView {
            let key = tableRowKeys[indexPath.row]
            if key == MOBILE_KEY {
                superStore!.mobile.makeCall()
            } else if key == LINE_KEY {
                superStore!.line.line()
            } else if key == FB_KEY {
                superStore!.fb.fb()
            } else if key == WEBSITE_KEY {
                superStore!.website.website()
            } else if key == EMAIL_KEY {
                superStore!.email.email()
            }
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
    
//    private func _caculateCellHeight(_ content: String) {
//        let base: CGFloat = 40.0
//        let limit: Int = 18
//        let n: CGFloat = CGFloat((content.count / limit) + 1)
//        cellHeight = base * n
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
    
    func changeScrollViewContentSize() {
        
        let h1 = featured.bounds.size.height
        let h2 = storeDataLbl.bounds.size.height
        let h3 = tableViewConstraintHeight.constant
        let h6 = contentLbl.bounds.size.height
        let h7 = contentViewConstraintHeight!.constant

        //print(contentViewConstraintHeight)
        
        let h: CGFloat = h1 + h2 + h3 + h6 + h7 + 300
        scrollView.contentSize = CGSize(width: view.frame.width, height: h)
        ContainerViewConstraintHeight.constant = h
        //print(h1)
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
//        if delegate != nil {
//            delegate!.isReload(false)
//        }
        prev()
    }
}

