//
//  Show1VC.swift
//  bm
//
//  Created by ives on 2021/5/5.
//  Copyright © 2021 bm. All rights reserved.
//

import UIKit
import WebKit

class ShowVC: BaseViewController, UITableViewDelegate, UITableViewDataSource, WKUIDelegate,  WKNavigationDelegate {
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var mainDataLbl: SuperLabel!
    @IBOutlet weak var contentDataLbl: SuperLabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContainerView: UIView!
    
    @IBOutlet weak var ContainerViewConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var tableViewConstraintHeight: NSLayoutConstraint!
    
    @IBOutlet weak var featured: UIImageView!
    
    @IBOutlet weak var tableView: SuperTableView!
    
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
    var contentViewConstraintHeight: NSLayoutConstraint?
    
    var cellHeight: CGFloat = 40
    
    var tableRowKeys:[String] = [String]()
    var tableRows: [String: [String:String]] = [String: [String: String]]()
    
    var isLike: Bool = false
    var token: String?
    var table: Table?
    var memberRows: [MemberRow] = [MemberRow]()

    override func viewDidLoad() {
        super.viewDidLoad()

        if (tableView != nil) {
            let cellNib = UINib(nibName: "OneLineCell", bundle: nil)
            tableView.register(cellNib, forCellReuseIdentifier: "cell")
            initTableView()
        }
        
        if (scrollView != nil) {
            initContentView()
            scrollView.backgroundColor = UIColor.clear
            beginRefresh()
            scrollView.addSubview(refreshControl)
        }
        
        //refresh()
    }
    
    func initData() {}
    
//    func initShowVC(sin: Show_IN) {
//        self.show_in = sin
//    }

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
        
        c1 = NSLayoutConstraint(item: contentView!, attribute: .leading, relatedBy: .equal, toItem: contentView!.superview, attribute: .leading, multiplier: 1, constant: 0)
        c2 = NSLayoutConstraint(item: contentView!, attribute: .top, relatedBy: .equal, toItem: contentDataLbl, attribute: .bottom, multiplier: 1, constant: 16)
        c3 = NSLayoutConstraint(item: contentView!, attribute: .trailing, relatedBy: .equal, toItem: contentView!.superview, attribute: .trailing, multiplier: 1, constant: 8)
        contentViewConstraintHeight = NSLayoutConstraint(item: contentView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        contentView!.translatesAutoresizingMaskIntoConstraints = false
        scrollContainerView.addConstraints([c1,c2,c3,contentViewConstraintHeight!])
        contentView!.uiDelegate = self
        contentView!.navigationDelegate = self
    }
    
//    override func beginRefresh() {
//        refreshControl = UIRefreshControl()
//        refreshControl.attributedTitle = NSAttributedString(string: "更新資料")
//        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
//    }
    
    func refresh<T: Table>(_ t: T.Type) {
        
        if token != nil {
            Global.instance.addSpinner(superView: self.view)
            let params: [String: String] = ["token": token!, "member_token": Member.instance.token]
            dataService.getOne(params: params) { (success) in
                Global.instance.removeSpinner(superView: self.view)
                if (success) {
                    let jsonData: Data = self.dataService.jsonData!
                    do {
                        self.table = try JSONDecoder().decode(t, from: jsonData)
                        if (self.table != nil) {
                            self.table!.filterRow()
                            
                            if (self.table!.name.count > 0) {
                                self.titleLbl.text = self.table!.name
                            } else {
                                self.titleLbl.text = self.table!.title
                            }
                            
                            self.initData()
                            self.setData()
                            self.setFeatured()
                            self.setContent()
                            self.setLike()
                        }
                    } catch {
                        self.warning(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func setData() {}
    
    func setFeatured() {

        if (table != nil && table!.featured_path.count > 0) {
            featured.downloaded(from: table!.featured_path)
        } else {
            warning("沒有取得內容資料值，請稍後再試或洽管理員")
        }
    }
    
    func setContent() {
        let content: String = "<html><HEAD><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no\">"+self.body_css+"</HEAD><body>"+table!.content+"</body></html>"
        
        contentView!.loadHTMLString(content, baseURL: nil)
    }
    
    func setLike() {
        isLike = table!.like
        likeButton.initStatus(isLike, table!.like_count)
    }
    
//    func setFeatured<T: Table>(t: T) {
//
//        if t.featured_path.count > 0 {
//            if t.featured_path.count > 0 {
//                print(t.featured_path)
//                featured.downloaded(from: t.featured_path)
//            }
//        }
//    }
    
    func setMainData<T: Table>(_ t: T) {
        
        let mirror: Mirror = Mirror(reflecting: t)
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
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
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
    
//    func beginRefresh<T: Table>(_ t: T.Type) {
//        refreshControl = UIRefreshControl()
//        refreshControl.attributedTitle = NSAttributedString(string: "更新資料")
//        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
//    }
    
    func changeScrollViewContentSize() {}
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        if (!Member.instance.isLoggedIn) {
            toLogin()
        } else {
            if (table != nil) {
                isLike = !isLike
                likeButton.setLike(isLike)
                dataService.like(token: table!.token, able_id: table!.id)
            } else {
                warning("沒有取得內容資料值，請稍後再試或洽管理員")
            }
        }
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        prev()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
}
