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

class ShowCoachVC: ShowVC {
    
    @IBOutlet weak var cityBtn: CityButton!
    //@IBOutlet weak var contactLbl: SuperLabel!
    @IBOutlet weak var courseLbl: SuperLabel!
    @IBOutlet weak var timetableLbl: SuperLabel!
    @IBOutlet weak var chargeLbl: SuperLabel!
    @IBOutlet weak var expLbl: SuperLabel!
    @IBOutlet weak var licenseLbl: SuperLabel!
    @IBOutlet weak var featLbl: SuperLabel!
    //@IBOutlet weak var detailLbl: SuperLabel!
    
    //@IBOutlet weak var featuredView: UIImageView!
    //@IBOutlet weak var contactTableView: SuperTableView!
    @IBOutlet weak var courseTableView: SuperTableView!
    @IBOutlet weak var timetableView: UIView!
    @IBOutlet weak var timetableCollectionView: UICollectionView!
    
    @IBOutlet weak var chargeView: UIView!
    var chargeWebView: SuperWebView = SuperWebView()
    @IBOutlet weak var expView: UIView!
    var expWebView: SuperWebView = SuperWebView()
    @IBOutlet weak var licenseView: UIView!
    var licenseWebView: SuperWebView = SuperWebView()
    @IBOutlet weak var featView: UIView!
    var featWebView: SuperWebView = SuperWebView()
    //@IBOutlet weak var detailView: UIView!
    //var detailWebView: SuperWebView = SuperWebView()
    
    //@IBOutlet weak var featuredViewHeight: NSLayoutConstraint!
    //@IBOutlet weak var contactTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var courseTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var timetableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var timetableConllectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var chargeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var expViewHeight: NSLayoutConstraint!
    @IBOutlet weak var licenseViewHeight: NSLayoutConstraint!
    @IBOutlet weak var featViewHeight: NSLayoutConstraint!
    //@IBOutlet weak var detailViewHeight: NSLayoutConstraint!
    
    var lastView: UIView!
    
    var lblHeight: CGFloat = 30
    
    //var featuredHeight: CGFloat = 0
    //var contactHeight: CGFloat = 0
    var timetableHeight: CGFloat = 0
    var timetableHeaderHeight: CGFloat = 30
    var chargeHeight: CGFloat = 0
    var expHeight: CGFloat = 0
    var licenseHeight: CGFloat = 0
    var featHeight: CGFloat = 0
    //var detailHeight: CGFloat = 0
    
    //var lblMargin: CGFloat = 12
    //var frameWidth: CGFloat?
    //var contactCellHeight: CGFloat = 45
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
    var city_id: Int = 0
    //var backDelegate: BackDelegate?
        
    //var fromNet: Bool = false
        
    override func viewDidLoad() {
        
        dataService = CoachService.instance
        
//        let cellNib = UINib(nibName: "OneLineCell", bundle: nil)
//        contactTableView.register(cellNib, forCellReuseIdentifier: "cell")
//        initContactTableView()
        
        let cellNib1 = UINib(nibName: "ManagerCourseCell", bundle: nil)
        courseTableView.register(cellNib1, forCellReuseIdentifier: "courseCell")
        
        initCourseTableView()
        initWebView()
        
        super.viewDidLoad()
        
        tableRowKeys = [MOBILE_KEY,LINE_KEY,FB_KEY,YOUTUBE_KEY,WEBSITE_KEY,EMAIL_KEY,COACH_SENIORITY_KEY,CREATED_AT_KEY,PV_KEY]
        tableRows = [
            MOBILE_KEY:["icon":"mobile","title":"行動電話","content":"","isPressed":"true"],
            LINE_KEY:["icon":"line","title":"line id","content":"","isPressed":"false"],
            FB_KEY:["icon":"fb","title":"fb","content":"","isPressed":"true"],
            YOUTUBE_KEY:["icon":"youtube","title":"youtube","content":"","isPressed":"true"],
            WEBSITE_KEY:["icon":"website","title":"網站","content":"","isPressed":"true"],
            EMAIL_KEY:["icon":"email1","title":"email","content":"","isPressed":"true"],
            COACH_SENIORITY_KEY:["icon":"seniority","title":"年資","content":""],
            CREATED_AT_KEY:["icon":"date","title":"建立日期","content":""],
            PV_KEY:["icon":"pv","title":"瀏覽數","content":""]
        ]
        
        //frameWidth = view.frame.width
        
        //timetableHeight = CGFloat(endNum - startNum) * timetableCellHeight
        //timetableConllectionViewHeight.constant = timetableHeight
        //timetableViewHeight.constant = timetableHeight + 30
        
        
        
//        let frame = CGRect(x: 0, y: 0, width: frameWidth!, height: 10)
//        lastView = UIView(frame: frame)
//        detailView.addSubview(lastView)
//        let c1 = NSLayoutConstraint(item: lastView, attribute: .top, relatedBy: .equal, toItem: detailWebView, attribute: .bottom, multiplier: 1, constant: 12)
//        lastView.translatesAutoresizingMaskIntoConstraints = false
//        detailView.addConstraints([c1])
        
        
        refresh(CoachTable.self)
    }
    
    override func viewWillLayoutSubviews() {
        
        mainDataLbl.setTextTitle()
        //timetableLbl.setTextColor(UIColor(MY_RED))
        chargeLbl.setTextTitle()
        expLbl.setTextTitle()
        licenseLbl.setTextTitle()
        featLbl.setTextTitle()
        //detailLbl.setTextTitle()
        courseLbl.setTextTitle()
        //initCollectionView()
    }
    
//    override func refresh() {
//        Global.instance.addSpinner(superView: view)
//        let params: [String: String] = ["token": coach_token!, "member_token": Member.instance.token]
//        dataService.getOne(t: CoachTable.self, params: params){ (success1) in
//            if (success1) {
//                let table: Table = self.dataService.table!
//                self.myTable = table as? CoachTable
//                //self.coachTable!.printRow()
//                //self.setData() move to getFeatured
//                if self.myTable != nil {
//                    self.myTable!.filterRow()
//                    self.titleLbl.text = self.myTable!.name
//                    self.setData()
//                    self.fromNet = true
//                    //self.getFeatured()
//                    self.isLike = self.myTable!.like
//                    self.likeButton.initStatus(self.isLike, self.myTable!.like_count)
//                    self.contactTableView.reloadData()
//                    self.setFeatured()
//                }
//
//                var filter: [String: Any] = [String: Any]()
//                filter.merge(["status": "online"])
//                if self.myTable != nil {
//                    filter.merge(["coach_id": self.myTable!.id])
//                }
//
//                CourseService.instance.getList(t: CoursesTable.self, token: self.coach_token!, _filter: filter, page: 1, perPage: 100) { (success2) in
//                    Global.instance.removeSpinner(superView: self.view)
//                    if (success2) {
//                        self.coursesTable = (CourseService.instance.tables as? CoursesTable)
//                        if (self.coursesTable != nil) {
//                            //self.coursesTable!.printRows()
//                            self.courseTableView.reloadData()
//                        }
//                    } else {
//                        self.warning(CourseService.instance.msg)
//                    }
//                    self.endRefresh()
//                }
////                CoachService.instance.getTT(token: self.show_in!.token, type: self.show_in!.type) { (success2) in
////                    self.endRefresh()
////                    if (success2) {
////                        self.timetables = CoachService.instance.timetables
////                        self.setTimetableEvent()
////                    }
////                }
//            }
//            Global.instance.removeSpinner(superView: self.view)
//            self.endRefresh()
//        }
//    }
    
    func initCourseTableView() {
        
        courseTableView.delegate = self
        courseTableView.dataSource = self
        
        courseTableView.rowHeight = UITableView.automaticDimension
        courseTableView.estimatedRowHeight = 600
        courseTableViewHeight.constant = 2000
    }
    
    func initWebView() {
        _initWebView(webView: chargeWebView, container: chargeView)
        _initWebView(webView: expWebView, container: expView)
        _initWebView(webView: licenseWebView, container: licenseView)
        _initWebView(webView: featWebView, container: featView)
        //_initWebView(webView: detailWebView, container: detailView)
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return tableRowKeys.count
        } else if tableView == courseTableView {
            if coursesTable != nil {
                if coursesTable!.rows.count == 0 {
                    courseTableViewHeight.constant = 0
                    return 0
                } else {
                    print(coursesTable!.rows.count)
                    courseTableViewHeight.constant = 100
                    return coursesTable!.rows.count
                }
            } else {
                courseTableViewHeight.constant = 0
                return 0
            }
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableView {
            let cell: OneLineCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OneLineCell
            
            //填入資料
            let key = tableRowKeys[indexPath.row]
            if tableRows[key] != nil {
                let row = tableRows[key]!
                let icon = row["icon"] ?? ""
                let title = row["title"] ?? ""
                
                let content = row["content"] ?? ""
                cell.update(icon: icon, title: title, content: content)
            }
            
            //計算高度
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
            //let cell = (UITableViewCell() as! IconCell)
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView {
            let key = tableRowKeys[indexPath.row]
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
    
    override func setData() {
        
        if (table != nil) {
            myTable = table as? CoachTable
            if (myTable != nil) {
                if myTable!.citys.count > 0 {
                    for city in myTable!.citys {
                        city_id = city.id
                        params["city_id"] = String(city_id)
                        params["city_type"] = "all"
                        cityBtn.setTitle(city.name)
                    }
                } else {
                    cityBtn.isHidden = true
                }
                
                setMainData(myTable!)
                
                tableView.reloadData()
                //signupTableView.reloadData()
                
                setWeb(webView: chargeWebView, content: myTable!.charge)
                setWeb(webView: expWebView, content: myTable!.exp)
                setWeb(webView: licenseWebView, content: myTable!.license)
                setWeb(webView: featWebView, content: myTable!.feat)
                //setWeb(webView: detailWebView, content: myTable!.content)
            }
        }
        
        getCourseList()
    }
    
    func getCourseList() {
        var filter: [String: String] = [String: String]()
        filter.merge(["status": "online"])
        if myTable != nil {
            filter.merge(["coach_id": String(myTable!.id)])
            
            CourseService.instance.getList(token: token!, _filter: filter, page: 1, perPage: 100) { (success2) in
                Global.instance.removeSpinner(superView: self.view)
                if (success2) {
                    do {
                        if (self.dataService.jsonData != nil) {
                            try self.coursesTable = JSONDecoder().decode(CoursesTable.self, from: CourseService.instance.jsonData!)
                            if (self.coursesTable != nil) {
                                //self.coursesTable!.printRows()
                                self.courseTableView.reloadData()
                            }
                        } else {
                            self.warning("無法從伺服器取得正確的json資料，請洽管理員")
                        }
                    } catch {
                        self.msg = "解析JSON字串時，得到空值，請洽管理員"
                    }
                } else {
                    self.warning(CourseService.instance.msg)
                }
                self.endRefresh()
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
    
    
    
    override func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
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
                    } else if (webView == self.contentView) {
                        //self.contentViewConstraintHeight = _height
                        self.contentViewConstraintHeight!.constant = _height
                    }
                    self.changeScrollViewContentSize()
                })
            }
            
        })
    }
    
//    func featuredLayout() {
//        let img_width: CGFloat = featured!.size.width
//        let img_height: CGFloat = featured!.size.height
//        //print(img_width)
//        //print(img_height)
//        featuredHeight = featuredView.frame.width * (img_height / img_width)
//        featuredViewHeight.constant = featuredHeight
//        changeScrollViewContentSize()
//    }
    
    override func changeScrollViewContentSize() {
        
        let h1 = featured.bounds.size.height
        let h2 = mainDataLbl.bounds.size.height
        let h3 = tableViewConstraintHeight.constant
        let h4 = chargeLbl.bounds.size.height
        let h5 = chargeViewHeight.constant
        let h6 = expLbl.bounds.size.height
        let h7 = expViewHeight.constant
        let h8 = licenseLbl.bounds.size.height
        let h9 = licenseViewHeight.constant
        let h10 = contentDataLbl.bounds.size.height
        let h11 = contentViewConstraintHeight!.constant
        let h12 = courseLbl.bounds.size.height
        let h13 = courseTableViewHeight.constant
        //print(contentViewConstraintHeight)
        
        let h = h1 + h2 + h3 + h4 + h5 + h6 + h7 + h8 + h9 + h10 + h11 + h12 + h13 + 500
        scrollView.contentSize = CGSize(width: view.frame.width, height: h)
        ContainerViewConstraintHeight.constant = h
    }
    
    @IBAction func cityBtnPressed(_ sender: Any) {
        //performSegue(withIdentifier: TO_HOME, sender: nil)
        //backDelegate?.setBack(params: params)
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
                
                var start_time: Date = Date()
                if let tmp = row.start_time.toDateTime(format:"HH:mm:ss") {
                    start_time = tmp
                }
                
                var end_time: Date = Date()
                if let tmp = row.end_time.toDateTime(format:"HH:mm:ss") {
                    end_time = tmp
                }
                
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
}

