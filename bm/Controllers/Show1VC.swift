//
//  Show1VC.swift
//  bm
//
//  Created by ives on 2021/5/5.
//  Copyright © 2021 bm. All rights reserved.
//

import UIKit
import WebKit

class Show1VC: BaseViewController, UITableViewDelegate, UITableViewDataSource, WKUIDelegate,  WKNavigationDelegate {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var contentLbl: SuperLabel!
    
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
    
    var isLike: Bool = false
    var token: String?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let cellNib = UINib(nibName: "OneLineCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "cell")
        
        initTableView()
        beginRefresh()
        scrollView.addSubview(refreshControl)
        //refresh()
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
        c2 = NSLayoutConstraint(item: contentView!, attribute: .top, relatedBy: .equal, toItem: contentLbl, attribute: .bottom, multiplier: 1, constant: 16)
        c3 = NSLayoutConstraint(item: contentView!, attribute: .trailing, relatedBy: .equal, toItem: contentView!.superview, attribute: .trailing, multiplier: 1, constant: 8)
        contentViewConstraintHeight = NSLayoutConstraint(item: contentView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        contentView!.translatesAutoresizingMaskIntoConstraints = false
        scrollContainerView.addConstraints([c1,c2,c3,contentViewConstraintHeight!])
        contentView!.uiDelegate = self
        contentView!.navigationDelegate = self
    }
    
    func refresh1<T: Table>(_ a: T.Type) {
        if token != nil {
            let params: [String: String] = ["token": token!, "member_token": Member.instance.token]
            dataService.getOne(t: a, params: params) { (success) in
                if (success) {
                    let table: Table = self.dataService.table!
                    let my = table as! T
                    my.filterRow()
                    
                }
                
            }
            
        }
    }
    
    func setFeatured() {
        
//        if myTable!.featured_path.count > 0 {
//            let featured_path = myTable!.featured_path
//            if featured_path.count > 0 {
//                //print(featured_path)
//                featured.downloaded(from: featured_path)
//            }
//        }
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
    
    func changeScrollViewContentSize() {
    
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
//        if delegate != nil {
//            delegate!.isReload(false)
//        }
        prev()
    }
}
