//
//  ShowCoachVC.swift
//  bm
//
//  Created by ives on 2019/2/3.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit
import WebKit
import SwiftyJSON
import AlamofireImage

class ShowCoachVC: BaseViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate,WKUIDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var cityBtn: CityButton!
    @IBOutlet weak var contactLbl: SuperLabel!
    @IBOutlet weak var timetableLbl: SuperLabel!
    @IBOutlet weak var chargeLbl: SuperLabel!
    @IBOutlet weak var expLbl: SuperLabel!
    @IBOutlet weak var licenseLbl: SuperLabel!
    @IBOutlet weak var featLbl: SuperLabel!
    @IBOutlet weak var detailLbl: SuperLabel!
    
    @IBOutlet weak var featuredView: UIImageView!
    @IBOutlet weak var contactTableView: SuperTableView!
    @IBOutlet weak var timetableView: UIView!
    @IBOutlet weak var timetableCollectionView: UICollectionView!
    
    @IBOutlet weak var scrollView: SuperScrollView!
    @IBOutlet weak var chargeView: UIView!
    var chargeWebView: SuperWebView = SuperWebView()
    @IBOutlet weak var expView: UIView!
    var expWebView: SuperWebView = SuperWebView()
    @IBOutlet weak var licenseView: UIView!
    var licenseWebView: SuperWebView = SuperWebView()
    @IBOutlet weak var featView: UIView!
    var featWebView: SuperWebView = SuperWebView()
    @IBOutlet weak var detailView: UIView!
    var detailWebView: SuperWebView = SuperWebView()
    
    @IBOutlet weak var featuredViewHeight:
    NSLayoutConstraint!
    @IBOutlet weak var contactTableViewHeight:
    NSLayoutConstraint!
    @IBOutlet weak var timetableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var timetableConllectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var chargeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var expViewHeight: NSLayoutConstraint!
    @IBOutlet weak var licenseViewHeight: NSLayoutConstraint!
    @IBOutlet weak var featViewHeight: NSLayoutConstraint!
    @IBOutlet weak var detailViewHeight: NSLayoutConstraint!
    var lastView: UIView!
    
    var featuredHeight: CGFloat = 0
    var contactHeight: CGFloat = 0
    var timetableHeight: CGFloat = 0
    var timetableHeaderHeight: CGFloat = 30
    var chargeHeight: CGFloat = 0
    var expHeight: CGFloat = 0
    var licenseHeight: CGFloat = 0
    var featHeight: CGFloat = 0
    var detailHeight: CGFloat = 0
    var lblHeight: CGFloat = 30
    
    var lblMargin: CGFloat = 12
    var frameWidth: CGFloat?
    var contactCellHeight: CGFloat = 45
    var timetableCellWidth: CGFloat!
    var timetableCellHeight: CGFloat = 50
    let timetableCellBorderWidth: CGFloat = 1
    
    let startNum: Int = 7
    let endNum: Int = 23
    let columnNum: Int = 8
    var eventTag: Int = 0
    
    var show_in: Show_IN?
    var superCoach: SuperCoach?
    var timetables: Timetables?
    var featured: UIImage?
    var city_id: Int = 0
    var params: [String: Any] = [String: Any]()
    var backDelegate: BackDelegate?
    
    let contactTableRowKeys:[String] = [MOBILE_KEY,LINE_KEY,FB_KEY,YOUTUBE_KEY,WEBSITE_KEY,EMAIL_KEY,COACH_SENIORITY_KEY,CREATED_AT_KEY,PV_KEY]
    var contactTableRows: [String: [String:String]] = [
        MOBILE_KEY:["icon":"mobile","title":"行動電話","content":"","isPressed":"true"],
        LINE_KEY:["icon":"line","title":"line id","content":"","isPressed":"false"],
        FB_KEY:["icon":"fb","title":"fb","content":"","isPressed":"true"],
        YOUTUBE_KEY:["icon":"youtube","title":"youtube","content":"","isPressed":"true"],
        WEBSITE_KEY:["icon":"website","title":"網站","content":"","isPressed":"true"],
        EMAIL_KEY:["icon":"email1","title":"email","content":"","isPressed":"true"],
        COACH_SENIORITY_KEY:["icon":"seniority","title":"年資","content":""],
        CREATED_AT_KEY:["icon":"calendar","title":"建立日期","content":""],
        PV_KEY:["icon":"pv","title":"瀏覽數","content":""]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.text = show_in!.title
        frameWidth = view.frame.width
        
        let cellNib = UINib(nibName: "IconCell", bundle: nil)
        contactTableView.register(cellNib, forCellReuseIdentifier: "cell")
        contactHeight = contactCellHeight * CGFloat(contactTableRowKeys.count)
        contactTableViewHeight.constant = contactHeight
        
        featuredView.backgroundColor = UIColor.white
        featuredView.contentMode = .scaleAspectFit
        
        timetableHeight = CGFloat(endNum - startNum) * timetableCellHeight
        timetableConllectionViewHeight.constant = timetableHeight
        timetableViewHeight.constant = timetableHeight + 30
        
        initWebView(webView: chargeWebView, container: chargeView)
        initWebView(webView: expWebView, container: expView)
        initWebView(webView: licenseWebView, container: licenseView)
        initWebView(webView: featWebView, container: featView)
        initWebView(webView: detailWebView, container: detailView)
        
        let frame = CGRect(x: 0, y: 0, width: frameWidth!, height: 10)
        lastView = UIView(frame: frame)
        detailView.addSubview(lastView)
        let c1 = NSLayoutConstraint(item: lastView, attribute: .top, relatedBy: .equal, toItem: detailWebView, attribute: .bottom, multiplier: 1, constant: 12)
        lastView.translatesAutoresizingMaskIntoConstraints = false
        detailView.addConstraints([c1])
        
        beginRefresh()
        scrollView.addSubview(refreshControl)
        refresh()
    }
    
    override func refresh() {
        Global.instance.addSpinner(superView: view)
        CoachService.instance.getOne(type: show_in!.type, token: show_in!.token) { (success1) in
            if (success1) {
                self.superCoach = CoachService.instance.superCoach
                //self.superCoach!.printRow()
                //self.setData() move to getFeatured
                self.getFeatured()
                CoachService.instance.getTT(token: self.show_in!.token, type: self.show_in!.type) { (success2) in
                    Global.instance.removeSpinner(superView: self.view)
                    self.endRefresh()
                    if (success2) {
                        self.timetables = CoachService.instance.timetables
                        self.setTimetableEvent()
                    }
                }
            }
        }
    }
    
    func setTimetableEvent() {
        let width: CGFloat = timetableCellWidth - 2 * timetableCellBorderWidth
        timetableCollectionView.isUserInteractionEnabled = true
        if timetables!.rows.count > 0 {
            for i in 0 ... timetables!.rows.count-1 {
                let row = timetables!.rows[i]
                let x: CGFloat = CGFloat(row.weekday) * timetableCellWidth + timetableCellBorderWidth
                let y1 = (CGFloat(row._start_hour-startNum)+CGFloat(row._start_minute)/60)
                let y: CGFloat = y1 * timetableCellHeight + timetableCellBorderWidth
                
                let start_time = row.start_time.toDateTime(format:"HH:mm:ss")
                let end_time = row.end_time.toDateTime(format:"HH:mm:ss")
                let elapsed = CGFloat(end_time.timeIntervalSince(start_time)/(60*60))
                let height: CGFloat = elapsed * timetableCellHeight - 2 * timetableCellBorderWidth
                
                var frame = CGRect(x: x, y: y, width: width, height: height)
                //print(frame)
                let v: UIView = UIView(frame: frame)
                timetableCollectionView.addSubview(v)
                
                let absFrame = v.convert(v.bounds, to: scrollView)
                v.removeFromSuperview()
                //print(absFrame)
                let absView = UIView(frame: absFrame)
                absView.isUserInteractionEnabled = true
                absView.backgroundColor = row._color.toColor()
                absView.tag = 1000 + i
                
                //print(height)
                frame = CGRect(x: 3, y: 3, width: width-6, height: height-6)
                let titleLbl = UILabel(frame: frame)
                //titleLbl.backgroundColor = UIColor.white
                titleLbl.font = titleLbl.font.withSize(14)
                titleLbl.textAlignment = .center
                titleLbl.text = row.title
                titleLbl.textColor = UIColor.black
                titleLbl.numberOfLines = 0
                //titleLbl.sizeToFit()
                absView.addSubview(titleLbl)

                /*
                let line = DrawLine(frame: CGRect(x: 5, y: 35, width: width-10, height: 1))
                absView.addSubview(line)

                frame = CGRect(x: 3, y: 40, width: width, height: height-20)
                let contentLbl = UILabel(frame: frame)
                contentLbl.text = "人數：\n" + row.limit_text
                contentLbl.font = UIFont(name: contentLbl.font.fontName, size: 12)
                contentLbl.textColor = UIColor.black
                contentLbl.numberOfLines = 0
                contentLbl.sizeToFit()
                absView.addSubview(contentLbl)
 */
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(clickTimetableEvent))
                absView.addGestureRecognizer(tap)
                
                scrollView.addSubview(absView)
            }
        }
    }
    
    @objc func clickTimetableEvent(sender: UITapGestureRecognizer) {
        Global.instance.addSpinner(superView: view)
        Global.instance.removeSpinner(superView: view)
        guard let a = (sender.view) else {return}
        let idx: Int = a.tag - 1000
        //print(idx)
        eventTag = idx + 1000
        //print(eventTag)
        let event = timetables!.rows[idx]
        performSegue(withIdentifier: TO_SHOWTIMETABLE, sender: event.id)
    }
    
    override func viewWillLayoutSubviews() {
        contactLbl.setTextColor(UIColor(MY_RED))
        timetableLbl.setTextColor(UIColor(MY_RED))
        chargeLbl.setTextColor(UIColor(MY_RED))
        expLbl.setTextColor(UIColor(MY_RED))
        licenseLbl.setTextColor(UIColor(MY_RED))
        featLbl.setTextColor(UIColor(MY_RED))
        detailLbl.setTextColor(UIColor(MY_RED))
        initCollectionView()
        changeScrollViewContentSize()
    }
    
    func initCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        timetableCellWidth = timetableCollectionView.frame.width/CGFloat(columnNum)
        layout.itemSize = CGSize(width: timetableCellWidth, height: timetableCellHeight)
        timetableCollectionView.collectionViewLayout = layout
    }
    
    func initWebView(webView: WKWebView, container: UIView) {
        webView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(webView)
        webView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        webView.heightAnchor.constraint(equalTo: container.heightAnchor).isActive = true
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.scrollView.isScrollEnabled = false
    }
    
    func changeScrollViewContentSize() {
        //let height: CGFloat = featuredHeight + contactHeight + timetableHeaderHeight + timetableHeight + chargeHeight + expHeight + licenseHeight + featHeight + detailHeight + (lblMargin+lblHeight)*8 + 100
        //let height: CGFloat = 10000
        //print(height)
        
        let absFrame = lastView.convert(lastView.bounds, to: scrollView)
        //print(absFrame)
        scrollView.contentSize = CGSize(width: frameWidth!, height: absFrame.origin.y)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return contactCellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == contactTableView {
            return contactTableRowKeys.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: IconCell?
        if tableView == contactTableView {
            cell = (tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! IconCell)
            let key = contactTableRowKeys[indexPath.row]
            if contactTableRows[key] != nil {
                let row = contactTableRows[key]!
                let icon = row["icon"] ?? ""
                let title = row["title"] ?? ""
                var content = row["content"] ?? ""
                if key == MOBILE_KEY && content.count > 0 {
                    content = content.mobileShow()
                } else if key == CREATED_AT_KEY {
                    content = content.noTime()
                } else if key == COACH_SENIORITY_KEY {
                    if content.count > 0 {
                        content = content + "年"
                    }
                }
                let isPressed = NSString(string: row["isPressed"] ?? "false").boolValue
                cell!.update(icon: icon, title: title, content: content, isPressed: isPressed)
            }
        } else {
            cell = (UITableViewCell() as! IconCell)
            
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == contactTableView {
            let key = contactTableRowKeys[indexPath.row]
            if key == MOBILE_KEY {
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print((endNum-startNum)*columnNum)
        return (endNum-startNum)*columnNum
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //print(indexPath.row)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimetableCell", for: indexPath)
        
        let startTime: Int = indexPath.row / columnNum + startNum
        let weekday: Int = indexPath.row % columnNum
        
        let contentView = cell.contentView
        contentView.layer.borderWidth = timetableCellBorderWidth
        contentView.layer.borderColor = UIColor.gray.cgColor
        cell.tag = (startTime - startNum)*columnNum + weekday
        
        let timeLabel = cell.contentView.subviews[0] as! SuperLabel
        timeLabel.setTextSize(15.0)
        
        if weekday == 0 {
            timeLabel.text = "\(startTime)-\(startTime+1)"
        } else {
            timeLabel.text = ""
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == TO_SHOW {
            let sender = sender as! Show_IN
            let showVC: ShowVC = segue.destination as! ShowVC
            showVC.show_in = sender
        } else if segue.identifier == TO_SHOWTIMETABLE {
            let showTimetableVC: ShowTimetableVC = segue.destination as! ShowTimetableVC
            if let id = sender as? Int {
                showTimetableVC.tt_id = id
            }
            showTimetableVC.source = show_in!.type
            showTimetableVC.token = show_in!.token
        }
    }
    
    func setData() {
        if superCoach != nil {
            if superCoach!.citys.count > 0 {
                for city in superCoach!.citys {
                    city_id = city.id
                    params["city_id"] = [city_id]
                    params["city_type"] = "all"
                    cityBtn.setTitle(city.name)
                }
            } else {
                cityBtn.isHidden = true
            }
            //print(BASE_URL + superCoach!.featured_path)
            //featuredView.af_setImage(withURL: URL(string: BASE_URL + superCoach!.featured_path)!)
            featuredView.image = featured
            setContact()
            setWeb(webView: chargeWebView, content: superCoach!.charge)
            setWeb(webView: expWebView, content: superCoach!.exp)
            setWeb(webView: licenseWebView, content: superCoach!.license)
            setWeb(webView: featWebView, content: superCoach!.feat)
            setWeb(webView: detailWebView, content: superCoach!.content)
        }
    }
    
    func setContact() {
        for key in contactTableRowKeys {
            if (self.superCoach!.responds(to: Selector(key))) {
                let content: String = String(describing:(self.superCoach!.value(forKey: key))!)
                contactTableRows[key]!["content"] = content
            }
        }
        //print(self.coachTableRows)
        contactTableView.reloadData()
    }
    
    func setWeb(webView: WKWebView, content: String) {
        let html: String = "<html><HEAD><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no\">"+body_css+"</HEAD><body>"+content+"</body></html>"
        //print(content)
        
        webView.loadHTMLString(html, baseURL: nil)
    }
    
    func getFeatured() {
        DataService.instance1.getImage(_url: BASE_URL + superCoach!.featured_path) { (success) in
            self.featured = DataService.instance1.image
            self.featuredLayout()
            self.setData()
        }
    }
    
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                webView.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (height, error) in
                    //print(height)
                    let _height = height as! CGFloat-50
                    if webView == self.chargeWebView {
                        self.chargeHeight = _height
                        self.chargeViewHeight!.constant = _height
                    } else if (webView == self.expWebView) {
                        self.expHeight = _height
                        self.expViewHeight!.constant = _height
                    } else if (webView == self.licenseWebView) {
                        self.licenseHeight = _height
                        self.licenseViewHeight!.constant = _height
                    } else if (webView == self.featWebView) {
                        self.featHeight = _height
                        self.featViewHeight!.constant = _height
                    } else if (webView == self.detailWebView) {
                        self.detailHeight = _height
                        self.detailViewHeight!.constant = _height
                    }
                    self.changeScrollViewContentSize()
                })
            }
            
        })
    }
    
    func featuredLayout() {
        let img_width: CGFloat = featured!.size.width
        let img_height: CGFloat = featured!.size.height
        //print(img_width)
        //print(img_height)
        featuredHeight = featuredView.frame.width * (img_height / img_width)
        featuredViewHeight.constant = featuredHeight
    }
    
    func initShowVC(sin: Show_IN) {
        self.show_in = sin
    }
    
    @IBAction func cityBtnPressed(_ sender: Any) {
        //performSegue(withIdentifier: TO_HOME, sender: nil)
        backDelegate?.setBack(params: params)
        prev()
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        prev()
    }
}

