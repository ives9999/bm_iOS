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
    
    @IBOutlet weak var titleLbl: SuperLabel!
    
    @IBOutlet weak var mainDataLbl: SuperLabel!
    @IBOutlet weak var contentDataLbl: SuperLabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContainerView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var featured: UIImageView!
    @IBOutlet weak var dataContainerView: UIView!
    
    @IBOutlet weak var containerViewConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var containerViewConstraintWidth: NSLayoutConstraint!
    @IBOutlet weak var dataContainerConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var tableViewConstraintHeight: NSLayoutConstraint!
    
    @IBOutlet weak var featuredConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var dataConstraintHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: SuperTableView!
    
    @IBOutlet weak var likeButton: LikeButton!
    @IBOutlet weak var likeButtonConstraintLeading: NSLayoutConstraint!
    
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
    
    var scrollContainerHeight: CGFloat = 0
    
    var tableRowKeys:[String] = [String]()
    var tableRows: [String: [String:String]] = [String: [String: String]]()
    
    var isLike: Bool = false
    var token: String?
    var table: Table?
    var memberRows: [MemberRow] = [MemberRow]()
    let button_width: CGFloat = 120
    var bottom_button_count: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        if (tableView != nil) {
            let cellNib = UINib(nibName: "OneLineCell", bundle: nil)
            tableView.register(cellNib, forCellReuseIdentifier: "cell")
            initTableView()
        }
        
        if (scrollView != nil) {
            initContentView()
            beginRefresh()
            scrollView.addSubview(refreshControl)
        }
        
        if (dataContainerView != nil) {
            dataContainerView.layer.cornerRadius = 26.0
            dataContainerView.clipsToBounds = true
        }
        
        if (bottomView != nil) {
            bottomView.backgroundColor = UIColor(BOTTOM_VIEW_BACKGROUND)
            
            setBottomButtonPaddint()
        }
        
        containerViewConstraintWidth.constant = screen_width
        containerViewConstraintHeight.constant = 2000
        
        //refresh()
    }
    
    func initData() {}

    func initTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        tableViewConstraintHeight.constant = 600
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
    
    func setBottomButtonPaddint() {
        
        let padding: CGFloat = (screen_width - CGFloat(bottom_button_count) * button_width) / CGFloat((bottom_button_count + 1))
        likeButtonConstraintLeading.constant = CGFloat(bottom_button_count) * padding + button_width
    }
    
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
                            if (self.table!.id == 0) {
                                //token錯誤，所以無法解析
                                self.warning("token錯誤，所以無法解析")
                            } else {
                                self.table!.filterRow()
                                self.setFeatured()
                                self.initData()
                                self.setData()
                                self.setContent()
                                self.setLike()
                            }
                        }
                    } catch {
                        self.warning(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func setData() {
        if (self.table!.name.count > 0) {
            self.titleLbl.text = self.table!.name
        } else {
            self.titleLbl.text = self.table!.title
        }
        self.titleLbl.setTextTitle()
    }
    
    func setFeatured() {

        if (table != nil && table!.featured_path.count > 0) {
            let featured_h: CGFloat = featured.heightForUrl(url: table!.featured_path, width: screen_width)
            featuredConstraintHeight.constant = featured_h
            
            featured.downloaded(from: table!.featured_path)
            scrollContainerHeight += featuredConstraintHeight.constant
            containerViewConstraintHeight.constant = scrollContainerHeight
            //print("featured:\(scrollContainerHeight)")
            
            dataContainerConstraintTop.constant = featured_h - 30
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
                    
                    if let tmp = height as? CGFloat {
                        self.contentViewConstraintHeight!.constant = tmp
                        self.dataConstraintHeight.constant += self.contentViewConstraintHeight?.constant ?? 0
                        self.scrollContainerHeight += self.dataConstraintHeight.constant
                        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollContainerHeight)
                    }
                    //self.changeScrollViewContentSize()
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
