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
    @IBOutlet weak var courseLbl: SuperLabel!
    @IBOutlet weak var timetableLbl: SuperLabel!
    @IBOutlet weak var chargeLbl: SuperLabel!
    @IBOutlet weak var expLbl: SuperLabel!
    @IBOutlet weak var licenseLbl: SuperLabel!
    @IBOutlet weak var featLbl: SuperLabel!
    @IBOutlet weak var detailLbl: SuperLabel!
    
    @IBOutlet weak var featuredView: UIImageView!
    @IBOutlet weak var contactTableView: SuperTableView!
    @IBOutlet weak var courseTableView: SuperTableView!
    @IBOutlet weak var timetableView: UIView!
    @IBOutlet weak var timetableCollectionView: UICollectionView!
    
    @IBOutlet weak var scrollView: SuperScrollView!
    @IBOutlet weak var scrollContainerView: UIView!
    @IBOutlet weak var ContainerViewConstraintHeight: NSLayoutConstraint!
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
    @IBOutlet weak var courseTableViewHeight:
    NSLayoutConstraint!
    @IBOutlet weak var timetableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var timetableConllectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var chargeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var expViewHeight: NSLayoutConstraint!
    @IBOutlet weak var licenseViewHeight: NSLayoutConstraint!
    @IBOutlet weak var featViewHeight: NSLayoutConstraint!
    @IBOutlet weak var detailViewHeight: NSLayoutConstraint!
    @IBOutlet weak var likeButton: LikeButton!
    
    var lastView: UIView!
    
    var h: CGFloat = 0
    var lblHeight: CGFloat = 30
    
    var featuredHeight: CGFloat = 0
    var contactHeight: CGFloat = 0
    var timetableHeight: CGFloat = 0
    var timetableHeaderHeight: CGFloat = 30
    var chargeHeight: CGFloat = 0
    var expHeight: CGFloat = 0
    var licenseHeight: CGFloat = 0
    var featHeight: CGFloat = 0
    var detailHeight: CGFloat = 0
    
    
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
    
    //var show_in: Show_IN?
    var myTable: CoachTable?
    var timetables: Timetables?
    var coursesTable: CoursesTable?
    var featured: UIImage?
    var city_id: Int = 0
    var params: [String: Any] = [String: Any]()
    var backDelegate: BackDelegate?
    
    var coach_token: String?
    
    var fromNet: Bool = false
    
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
    
    var isLike: Bool = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        frameWidth = view.frame.width
        
        dataService = CoachService.instance
        
        h = contactLbl.bounds.height * 7
        
        let cellNib = UINib(nibName: "OneLineCell", bundle: nil)
        contactTableView.register(cellNib, forCellReuseIdentifier: "cell")
        initContactTableView()
        
        let cellNib1 = UINib(nibName: "ManagerCourseCell", bundle: nil)
        courseTableView.register(cellNib1, forCellReuseIdentifier: "courseCell")
        initCourseTableView()
        
        initWebView()
        
        initFeaturedView()
        
        //timetableHeight = CGFloat(endNum - startNum) * timetableCellHeight
        //timetableConllectionViewHeight.constant = timetableHeight
        //timetableViewHeight.constant = timetableHeight + 30
        
        
        
//        let frame = CGRect(x: 0, y: 0, width: frameWidth!, height: 10)
//        lastView = UIView(frame: frame)
//        detailView.addSubview(lastView)
//        let c1 = NSLayoutConstraint(item: lastView, attribute: .top, relatedBy: .equal, toItem: detailWebView, attribute: .bottom, multiplier: 1, constant: 12)
//        lastView.translatesAutoresizingMaskIntoConstraints = false
//        detailView.addConstraints([c1])
        
        beginRefresh()
        scrollView.addSubview(refreshControl)
        refresh()
    }
    
    override func viewWillLayoutSubviews() {
        
        contactLbl.setTextTitle()
        //timetableLbl.setTextColor(UIColor(MY_RED))
        chargeLbl.setTextTitle()
        expLbl.setTextTitle()
        licenseLbl.setTextTitle()
        featLbl.setTextTitle()
        detailLbl.setTextTitle()
        courseLbl.setTextTitle()
        //initCollectionView()
        
        contactLbl.textAlignment = .left
        chargeLbl.textAlignment = .left
        expLbl.textAlignment = .left
        licenseLbl.textAlignment = .left
        featLbl.textAlignment = .left
        detailLbl.textAlignment = .left
        courseLbl.textAlignment = .left
    }
    
    override func refresh() {
        Global.instance.addSpinner(superView: view)
        let params: [String: String] = ["token": coach_token!, "member_token": Member.instance.token]
        dataService.getOne(t: CoachTable.self, params: params){ (success1) in
            if (success1) {
                let table: Table = self.dataService.table!
                self.myTable = table as? CoachTable
                //self.coachTable!.printRow()
                //self.setData() move to getFeatured
                if self.myTable != nil {
                    self.myTable!.filterRow()
                    self.titleLbl.text = self.myTable!.name
                    self.setData()
                    self.fromNet = true
                    //self.getFeatured()
                    self.isLike = self.myTable!.like
                    self.likeButton.initStatus(self.isLike, self.myTable!.like_count)
                    self.contactTableView.reloadData()
                    self.setFeatured()
                }
                
                var filter: [String: Any] = [String: Any]()
                filter.merge(["status": "online"])
                if self.myTable != nil {
                    filter.merge(["coach_id": self.myTable!.id])
                }
                
                CourseService.instance.getList(t: CoursesTable.self, token: self.coach_token!, _filter: filter, page: 1, perPage: 100) { (success2) in
                    Global.instance.removeSpinner(superView: self.view)
                    if (success2) {
                        self.coursesTable = (CourseService.instance.tables as? CoursesTable)
                        if (self.coursesTable != nil) {
                            //self.coursesTable!.printRows()
                            self.courseTableView.reloadData()
                        }
                    } else {
                        self.warning(CourseService.instance.msg)
                    }
                    self.endRefresh()
                }
//                CoachService.instance.getTT(token: self.show_in!.token, type: self.show_in!.type) { (success2) in
//                    self.endRefresh()
//                    if (success2) {
//                        self.timetables = CoachService.instance.timetables
//                        self.setTimetableEvent()
//                    }
//                }
            }
            Global.instance.removeSpinner(superView: self.view)
            self.endRefresh()
        }
    }
    
    func initCourseTableView() {
        courseTableView.rowHeight = UITableView.automaticDimension
        courseTableView.estimatedRowHeight = 600
        courseTableViewHeight.constant = 2000
        courseTableView.delegate = self
        courseTableView.dataSource = self
    }
    
    func initContactTableView() {
        contactTableView.rowHeight = UITableView.automaticDimension
        contactTableView.estimatedRowHeight = 600
        contactTableViewHeight.constant = 2000
        contactTableView.delegate = self
        contactTableView.dataSource = self
    }
    
    func initWebView() {
        _initWebView(webView: chargeWebView, container: chargeView)
        _initWebView(webView: expWebView, container: expView)
        _initWebView(webView: licenseWebView, container: licenseView)
        _initWebView(webView: featWebView, container: featView)
        _initWebView(webView: detailWebView, container: detailView)
    }
    
    func _initWebView(webView: WKWebView, container: UIView) {
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
    
    func initFeaturedView() {
        featuredView.backgroundColor = UIColor.white
        featuredView.contentMode = .scaleAspectFit
    }
    
    func changeScrollViewContentSize() {
        
        let h1 = contactTableViewHeight.constant
        let h2 = chargeViewHeight.constant
        let h3 = expViewHeight.constant
        let h4 = licenseViewHeight.constant
        let h5 = featViewHeight.constant
        let h6 = detailViewHeight.constant
        let h7 = featuredViewHeight.constant
        let h8 = courseTableViewHeight.constant
        //print(contentViewConstraintHeight)
        
        h += h1 + h2 + h3 + h4 + h5 + h6 + h7 + h8 + 100
        scrollView.contentSize = CGSize(width: view.frame.width, height: h)
        ContainerViewConstraintHeight.constant = h
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !fromNet {
            return 0
        } else {
            if tableView == contactTableView {
                return contactTableRowKeys.count
            } else if tableView == courseTableView {
                if coursesTable != nil {
                    if coursesTable!.rows.count == 0 {
                        courseTableViewHeight.constant = 0
                    }
                    return coursesTable!.rows.count
                } else {
                    courseTableViewHeight.constant = 0
                    return 0
                }
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == contactTableView {
            let cell = (tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OneLineCell)
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
                cell.update(icon: icon, title: title, content: content, isPressed: isPressed)
            }
            if indexPath.row == contactTableRows.count - 1 {
                UIView.animate(withDuration: 0, animations: {self.contactTableView.layoutIfNeeded()}) { (complete) in
                    var heightOfTableView: CGFloat = 0.0
                    let cells = self.contactTableView.visibleCells
                    for cell in cells {
                        heightOfTableView += cell.frame.height
                    }
                    //print(heightOfTableView)
                    self.contactTableViewHeight.constant = heightOfTableView
                    self.changeScrollViewContentSize()
                }
            }
            return cell
        } else if tableView == courseTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath) as! ManagerCourseCell
            //cell.blacklistCellDelegate = self
            if coursesTable != nil && coursesTable!.rows.indices.contains(indexPath.row) {
                let row = coursesTable!.rows[indexPath.row]
                row.filterRow()
                //row.printRow()
                cell.forRow(row: row)
            }
            if indexPath.row == coursesTable!.rows.count - 1 {
                UIView.animate(withDuration: 0, animations: {self.courseTableView.layoutIfNeeded()}) { (complete) in
                    var heightOfTableView: CGFloat = 0.0
                    let cells = self.courseTableView.visibleCells
                    for cell in cells {
                        heightOfTableView += cell.frame.height
                    }
                    //print(heightOfTableView)
                    self.courseTableViewHeight.constant = heightOfTableView
                    self.changeScrollViewContentSize()
                }
            }
            return cell
        } else {
            let cell = (UITableViewCell() as! IconCell)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == contactTableView {
            let key = contactTableRowKeys[indexPath.row]
            if key == MOBILE_KEY {
                myTable!.mobile.makeCall()
            } else if key == LINE_KEY {
                myTable!.line.line()
            } else if key == FB_KEY {
                myTable!.fb.fb()
            } else if key == YOUTUBE_KEY {
                myTable!.youtube.youtube()
            } else if key == WEBSITE_KEY {
                myTable!.website.website()
            } else if key == EMAIL_KEY {
                myTable!.email.email()
            }
        } else if tableView == courseTableView {
            if coursesTable != nil {
                let sender = coursesTable!.rows[indexPath.row]
                toShowCourse(token: sender.token)
            }
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == TO_SHOW {
//            let sender = sender as! Show_IN
//            let showVC: ShowVC = segue.destination as! ShowVC
//            showVC.show_in = sender
//        } else if segue.identifier == TO_SHOW_TIMETABLE {
//            let showTimetableVC: ShowTimetableVC = segue.destination as! ShowTimetableVC
//            if let id = sender as? Int {
//                showTimetableVC.tt_id = id
//            }
//            //showTimetableVC.source = show_in!.type
//            showTimetableVC.token = coach_token
//        }
//    }
    
    func setData() {
        if myTable != nil {
            if myTable!.citys.count > 0 {
                for city in myTable!.citys {
                    city_id = city.id
                    params["city_id"] = [city_id]
                    params["city_type"] = "all"
                    cityBtn.setTitle(city.name)
                }
            } else {
                cityBtn.isHidden = true
            }
            //print(BASE_URL + coachTable!.featured_path)
            //featuredView.af_setImage(withURL: URL(string: BASE_URL + coachTable!.featured_path)!)
            //featuredView.image = featured
            
            let mirror: Mirror = Mirror(reflecting: myTable!)
            let propertys: [[String: Any]] = mirror.toDictionary()
            
            for key in contactTableRowKeys {
                
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
                        contactTableRows[key]!["content"] = content
                        break
                    }
                }
            }
            
            setWeb(webView: chargeWebView, content: myTable!.charge)
            setWeb(webView: expWebView, content: myTable!.exp)
            setWeb(webView: licenseWebView, content: myTable!.license)
            setWeb(webView: featWebView, content: myTable!.feat)
            setWeb(webView: detailWebView, content: myTable!.content)
        }
    }
    
    func setFeatured() {
        
        if myTable!.featured_path.count > 0 {
            let featured_path = myTable!.featured_path
            if featured_path.count > 0 {
                //print(featured_path)
                featuredView.downloaded(from: featured_path)
            }
        }
    }
    
    func setWeb(webView: WKWebView, content: String) {
        let html: String = "<html><HEAD><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no\">"+body_css+"</HEAD><body>"+content+"</body></html>"
        //print(content)
        
        webView.loadHTMLString(html, baseURL: nil)
    }
    
//    func getFeatured() {
//        DataService.instance1.getImage(_url: BASE_URL + myTable!.featured_path) { (success) in
//            self.featured = DataService.instance1.image
//            self.featuredLayout()
//        }
//    }
    
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
//        self.chargeWebView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
//            if complete != nil {
//                self.chargeWebView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
//                    self.chargeViewHeight!.constant = height as! CGFloat
//                    self.changeScrollViewContentSize()
//                })
//            }
//
//        })
        
        webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                webView.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (height, error) in
                    //print(height)
                    let _height = height as! CGFloat
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
        changeScrollViewContentSize()
    }
    
    func initShowVC(sin: Show_IN) {
        //self.show_in = sin
    }
    
    @IBAction func cityBtnPressed(_ sender: Any) {
        //performSegue(withIdentifier: TO_HOME, sender: nil)
        backDelegate?.setBack(params: params)
        prev()
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        prev()
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
        performSegue(withIdentifier: TO_SHOW_TIMETABLE, sender: event.id)
    }
    
    func initCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        timetableCellWidth = timetableCollectionView.frame.width/CGFloat(columnNum)
        layout.itemSize = CGSize(width: timetableCellWidth, height: timetableCellHeight)
        timetableCollectionView.collectionViewLayout = layout
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
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        if (!Member.instance.isLoggedIn) {
            toLogin()
        } else {
            isLike = !isLike
            likeButton.setLike(isLike)
            dataService.like(token: myTable!.token, able_id: myTable!.id)
        }
    }
}

