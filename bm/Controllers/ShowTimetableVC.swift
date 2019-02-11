//
//  ShowTimeTableVC.swift
//  bm
//
//  Created by ives on 2019/1/22.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit
import WebKit

class ShowTimetableVC: BaseViewController, UITableViewDelegate, UITableViewDataSource, WKUIDelegate,  WKNavigationDelegate {
    
    @IBOutlet weak var tableView: SuperTableView!
    @IBOutlet weak var coachTableView: SuperTableView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var timetableTitle: SuperLabel!
    @IBOutlet weak var contentLbl: SuperLabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var timetableDataLbl: SuperLabel!
    @IBOutlet weak var coachDataLbl: SuperLabel!
    lazy var contentView: WKWebView = {
        
        //Create configuration
        let configuration = WKWebViewConfiguration()
        //configuration.userContentController = controller
        
        let webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        webView.backgroundColor = UIColor.clear
        webView.scrollView.isScrollEnabled = false
        return webView
    }()
    var contentViewHeight: NSLayoutConstraint?
    //var shouldListenToResizeNotification: Bool = false
    //var contentViewHeight: CGFloat = 100
    //var lastView: UIView!
    
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
    let coachTableRowKeys:[String] = [NAME_KEY,MOBILE_KEY,LINE_KEY,FB_KEY,YOUTUBE_KEY,WEBSITE_KEY,EMAIL_KEY]
    var coachTableRows: [String: [String:String]] = [
        NAME_KEY:["icon":"coach","title":"教練","content":"","isPressed":"true"],
        MOBILE_KEY:["icon":"mobile","title":"行動電話","content":"","isPressed":"true"],
        LINE_KEY:["icon":"line","title":"line id","content":"","isPressed":"true"],
        FB_KEY:["icon":"fb","title":"fb","content":"","isPressed":"true"],
        YOUTUBE_KEY:["icon":"youtube","title":"youtube","content":"","isPressed":"true"],
        WEBSITE_KEY:["icon":"website","title":"網站","content":"","isPressed":"true"],
        EMAIL_KEY:["icon":"email1","title":"email","content":"","isPressed":"true"]
    ]
    var timetable: Timetable?
    var superCoach: SuperCoach?

    override func viewDidLoad() {
        super.viewDidLoad()
//        print(tt_id)
//        print(source)
//        print(token)
        
        tableView.dataSource = self
        tableView.delegate = self
        coachTableView.dataSource = self
        coachTableView.delegate = self
        let cellNib = UINib(nibName: "IconCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "cell")
        coachTableView.register(cellNib, forCellReuseIdentifier: "coachCell")
        
        scrollView.backgroundColor = UIColor.black
        
        //let webConfiguation = WKWebViewConfiguration()
        //contentView = WKWebView(frame: CGRect.zero, configuration: webConfiguation)
//        contentView.backgroundColor = UIColor.clear
//        contentView.scrollView.isScrollEnabled = false
        self.scrollView.addSubview(contentView)
        var c1: NSLayoutConstraint, c2: NSLayoutConstraint, c3: NSLayoutConstraint
        
        c1 = NSLayoutConstraint(item: contentView, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leading, multiplier: 1, constant: 0)
        c2 = NSLayoutConstraint(item: contentView, attribute: .top, relatedBy: .equal, toItem: contentLbl, attribute: .bottom, multiplier: 1, constant: 0)
        c3 = NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: view.frame.width)
        //contentViewHeight = 1000
        contentViewHeight = NSLayoutConstraint(item: contentView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addConstraints([c1,c2,c3,contentViewHeight!])
        contentView.uiDelegate = self
        contentView.navigationDelegate = self
        
        /*
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 10)
        lastView = UIView(frame: CGRect.zero)
        lastView.backgroundColor = UIColor.red
        scrollView.addSubview(lastView)
        let c5 = NSLayoutConstraint(item: lastView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 12)
        let c6 = NSLayoutConstraint(item: lastView, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leading, multiplier: 1, constant: 0)
        let c7 = NSLayoutConstraint(item: lastView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: view.frame.width)
        let c8 = NSLayoutConstraint(item: lastView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 10)
        lastView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addConstraints([c5, c6, c7, c8])
 */
        
        beginRefresh()
        scrollView.addSubview(refreshControl)

        refresh()
    }
    
    override func viewWillLayoutSubviews() {
        changeScrollViewContentSize()
        timetableDataLbl.textColor = UIColor(MY_RED)
        coachDataLbl.textColor = UIColor(MY_RED)
        contentLbl.textColor = UIColor(MY_RED)
    }
    
    override func refresh() {
        if tt_id != nil {
            Global.instance.addSpinner(superView: view)
            TimetableService.instance.getOne(id: tt_id!, source: source!, token: token!) { (success) in
                if (success) {
                    Global.instance.removeSpinner(superView: self.view)
                    self.endRefresh()
                    self.timetable = TimetableService.instance.timetable
                    self.superCoach = TimetableService.instance.superCoach
                    //let mirror: Mirror? = Mirror(reflecting: self.timetable!)
                    for key in self.tableRowKeys {
                        if (self.timetable!.responds(to: Selector(key))) {
                            let content: String = String(describing:(self.timetable!.value(forKey: key))!)
                            self.tableRows[key]!["content"] = content
                        }
                    }
                    self.timetableTitle.text = self.timetable!.title
                    let content: String = "<html><HEAD><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no\">"+self.body_css+"</HEAD><body>"+self.timetable!.content+"</body></html>"
                    
                    self.contentView.loadHTMLString(content, baseURL: nil)
                    let date = self.timetable!.start_date + " ~ " + self.timetable!.end_date
                    self.tableRows["date"]!["content"] = date
                    let interval = self.timetable!.start_time_text + " ~ " + self.timetable!.end_time_text
                    self.tableRows["interval"]!["content"] = interval
                    self.tableRows["signup_count"]!["content"] = String(self.timetable!.signup_count)+"人"
                    //print(self.tableRows)
                    self.tableView.reloadData()
                    
                    self.contentViewHeight!.constant = 1000
                    
                    for key in self.coachTableRowKeys {
                        if (self.superCoach!.responds(to: Selector(key))) {
                            let content: String = String(describing:(self.superCoach!.value(forKey: key))!)
                            self.coachTableRows[key]!["content"] = content
                        }
                    }
                    //print(self.coachTableRows)
                    self.coachTableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return tableRowKeys.count
        } else {
            return coachTableRowKeys.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: IconCell?
        if tableView == self.tableView {
            cell = (tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! IconCell)
            let key = tableRowKeys[indexPath.row]
            if tableRows[key] != nil {
                let row = tableRows[key]!
                let icon = row["icon"] ?? ""
                let title = row["title"] ?? ""
                let content = row["content"] ?? ""
                cell!.update(icon: icon, title: title, content: content)
            }
        } else {
            cell = (tableView.dequeueReusableCell(withIdentifier: "coachCell", for: indexPath) as! IconCell)
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
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.coachTableView {
            let key = coachTableRowKeys[indexPath.row]
            if key == NAME_KEY {
                let sender: Show_IN = Show_IN(type: source!,id:superCoach!.id,token:superCoach!.token,title:superCoach!.name)
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
    
    override func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        super.webView(webView, decidePolicyFor: navigationAction, decisionHandler: decisionHandler)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.contentView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                self.contentView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
                    self.contentViewHeight!.constant = height as! CGFloat
                    self.changeScrollViewContentSize()
                })
            }
            
        })
    }
    
    func changeScrollViewContentSize() {
        
        //print(lastView.frame)
        //let absFrame = lastView.convert(lastView.bounds, to: scrollView)
        //print(absFrame)
        //scrollView.contentSize = CGSize(width: view.frame.width, height: lastView.frame.origin.y)
        
        
        let height = contentViewHeight!.constant + 800
        //print(height)
        //let height:CGFloat = 10000
        scrollView.contentSize = CGSize(width: view.frame.width, height: height)
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        prev()
    }
}
