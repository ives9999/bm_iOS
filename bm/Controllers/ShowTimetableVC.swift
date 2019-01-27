//
//  ShowTimeTableVC.swift
//  bm
//
//  Created by ives on 2019/1/22.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit
import WebKit

class ShowTimetableVC: BaseViewController, UITableViewDelegate, UITableViewDataSource, WKUIDelegate, WKScriptMessageHandler {
    
    @IBOutlet weak var tableView: SuperTableView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var timetableTitle: SuperLabel!
    @IBOutlet weak var contentLbl: SuperLabel!
    @IBOutlet weak var scrollView: UIScrollView!
    lazy var contentView: WKWebView = {
        //Javascript string
        let source = "window.onload=function () {window.webkit.messageHandlers.sizeNotification.postMessage({justLoaded:true,height: document.body.scrollHeight});};"
        let source2 = "document.body.addEventListener( 'resize', incrementCounter); function incrementCounter() {window.webkit.messageHandlers.sizeNotification.postMessage({height: document.body.scrollHeight});};"
        
        //UserScript object
        let script = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        
        let script2 = WKUserScript(source: source2, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        
        //Content Controller object
        let controller = WKUserContentController()
        
        //Add script to controller
        controller.addUserScript(script)
        controller.addUserScript(script2)
        
        //Add message handler reference
        controller.add(self, name: "sizeNotification")
        
        //Create configuration
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = controller
        
        let webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        webView.backgroundColor = UIColor.clear
        webView.scrollView.isScrollEnabled = false
        return webView
    }()
    var contentViewHeight: NSLayoutConstraint?
    var shouldListenToResizeNotification: Bool = false
    //var contentViewHeight: CGFloat = 100
    
    var tt_id: Int?
    var source: String?  //coach or arena
    var token: String?     // coach token or arena token
    let tableRowKeys:[String] = ["weekday_text","date","interval","charge_text","limit_text","signup_count"]
    var tableRows: [String: [String:String]] = [
        "weekday_text":["icon":"calendar","title":"日期","content":""],
        "date":["icon":"calendar","title":"期間","content":""],
        "interval":["icon":"clock","title":"時段","content":""],
        "charge_text":["icon":"money","title":"收費","content":""],
        "limit_text":["icon":"group","title":"接受報名人數","content":""],
        "signup_count":["icon":"group","title":"已報名人數","content":""]
    ]
    var timetable: Timetable?
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let responseDict = message.body as? [String:Any],
            let height = responseDict["height"] as? Float else {return}
        if self.contentViewHeight!.constant != CGFloat(height) {
            if let _ = responseDict["justLoaded"] {
                print("just loaded")
                shouldListenToResizeNotification = true
                self.contentViewHeight!.constant = CGFloat(height)
            }
            else if shouldListenToResizeNotification {
                print("height is \(height)")
                self.contentViewHeight!.constant = CGFloat(height)
            }
            changeScrollViewContentSize()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        print(tt_id)
//        print(source)
//        print(token)
        
        tableView.dataSource = self
        tableView.delegate = self
        //tableView.isScrollEnabled = false
        let cellNib = UINib(nibName: "IconCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "cell")
        
        scrollView.backgroundColor = UIColor.black
        
        //let webConfiguation = WKWebViewConfiguration()
        //contentView = WKWebView(frame: CGRect.zero, configuration: webConfiguation)
//        contentView.backgroundColor = UIColor.clear
//        contentView.scrollView.isScrollEnabled = false
        self.scrollView.addSubview(contentView)
        var c1: NSLayoutConstraint, c2: NSLayoutConstraint, c3: NSLayoutConstraint
        
        c1 = NSLayoutConstraint(item: contentView, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leading, multiplier: 1, constant: 0)
        c2 = NSLayoutConstraint(item: contentView, attribute: .top, relatedBy: .equal, toItem: contentLbl, attribute: .bottom, multiplier: 1, constant: 12)
        c3 = NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: view.frame.width)
        //contentViewHeight = 1000
        contentViewHeight = NSLayoutConstraint(item: contentView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addConstraints([c1,c2,c3,contentViewHeight!])
        contentView.uiDelegate = self
        
        beginRefresh()
        scrollView.addSubview(refreshControl)

        refresh()
    }
    
    override func viewWillLayoutSubviews() {
        changeScrollViewContentSize()
    }
    func changeScrollViewContentSize() {
        let height = 300 + contentViewHeight!.constant
        scrollView.contentSize = CGSize(width: view.frame.width, height: height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
    
    override func refresh() {
        if tt_id != nil {
            Global.instance.addSpinner(superView: view)
            TimetableService.instance.getOne(id: tt_id!, source: source!, token: token!) { (success) in
                if (success) {
                    Global.instance.removeSpinner(superView: self.view)
                    self.endRefresh()
                    self.timetable = TimetableService.instance.timetable
                    //let mirror: Mirror? = Mirror(reflecting: self.timetable!)
                    for key in self.tableRowKeys {
                        if (self.timetable!.responds(to: Selector(key))) {
                            let content: String = String(describing:(self.timetable!.value(forKey: key))!)
                            self.tableRows[key]!["content"] = content
                        }
//                        for property in mirror!.children {
//                            if key == property.label {
//                                var content: String = String(describing:(event.value(forKey: name))!)
//                                self.tableRows[key]!["content"] = content
//                            }
//                        }
                    }
                    self.timetableTitle.text = self.timetable!.title
                    let content: String = "<div class=\"content\">"+self.timetable!.content+"</div>"+self.timetable!.content_style
                    
                    self.contentView.loadHTMLString(content, baseURL: nil)
                    let date = self.timetable!.start_date + " ~ " + self.timetable!.end_date
                    self.tableRows["date"]!["content"] = date
                    let interval = self.timetable!.start_time_text + " ~ " + self.timetable!.end_time_text
                    self.tableRows["interval"]!["content"] = interval
                    self.tableRows["signup_count"]!["content"] = String(self.timetable!.signup_count)+"人"
                    //print(self.tableRows)
                    self.tableView.reloadData()
                    
                    self.contentViewHeight!.constant = 1000
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableRowKeys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! IconCell
        let key = tableRowKeys[indexPath.row]
        if tableRows[key] != nil {
            let row = tableRows[key]!
            let icon = row["icon"] ?? ""
            let title = row["title"] ?? ""
            let content = row["content"] ?? ""
            cell.update(icon: icon, title: title, content: content)
        }
        
        return cell
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        prev()
    }
}
