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
    var chargeWebView: SuperWebView!
    @IBOutlet weak var expView: UIView!
    var expWebView: SuperWebView!
    @IBOutlet weak var licenseView: UIWebView!
    var licenseWebView: SuperWebView!
    @IBOutlet weak var featView: UIWebView!
    var featWebView: SuperWebView!
    @IBOutlet weak var detailView: UIWebView!
    var detailWebView: SuperWebView!
    
    //@IBOutlet weak var featuredViewWidth:
    //NSLayoutConstraint!
    @IBOutlet weak var featuredViewHeight:
    NSLayoutConstraint!
    //@IBOutlet weak var contactTableViewWidth:
    //NSLayoutConstraint!
    @IBOutlet weak var contactTableViewHeight:
    NSLayoutConstraint!
    @IBOutlet weak var timetableConllectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var chargeTop: NSLayoutConstraint!
    @IBOutlet weak var chargeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var expViewHeight: NSLayoutConstraint!
    @IBOutlet weak var licenseViewHeight: NSLayoutConstraint!
    @IBOutlet weak var featViewHeight: NSLayoutConstraint!
    @IBOutlet weak var detailViewHeight: NSLayoutConstraint!
    
    var timetableHeight: CGFloat = 0
    var timetableHeaderHeight: CGFloat = 30
    var lblMargin: CGFloat = 12
    var chargeHeight: CGFloat = 0
    
    var frameWidth: CGFloat?
    var timetableCellWidth: CGFloat!
    var timetableCellHeight: CGFloat = 50
    let timetableCellBorderWidth: CGFloat = 1
    
    let startNum: Int = 6
    let endNum: Int = 23
    let columnNum: Int = 8
    var eventViews: [UIView] = [UIView]()
    var eventTag: Int = 0
    
    var show_in: Show_IN?
    var superCoach: SuperCoach?
    var timetables: Timetables?
    var featured: UIImage?
    
    let style = "<style>body{background-color:#F00;padding-left:8px;padding-right:8px;margin-top:0;padding-top:0;}div.content{color:#888888;font-size:54px;}</style>"
    let contactTableRowKeys:[String] = [MOBILE_KEY,LINE_KEY,FB_KEY,YOUTUBE_KEY,WEBSITE_KEY,EMAIL_KEY,COACH_SENIORITY_KEY,CREATED_AT_KEY,PV_KEY]
    var contactTableRows: [String: [String:String]] = [
        MOBILE_KEY:["icon":"mobile","title":"行動電話","content":"","isPressed":"true"],
        LINE_KEY:["icon":"line","title":"line id","content":"","isPressed":"true"],
        FB_KEY:["icon":"fb","title":"fb","content":"","isPressed":"true"],
        YOUTUBE_KEY:["icon":"youtube","title":"youtube","content":"","isPressed":"true"],
        WEBSITE_KEY:["icon":"website","title":"網站","content":"","isPressed":"true"],
        EMAIL_KEY:["icon":"email1","title":"email","content":"","isPressed":"true"],
        COACH_SENIORITY_KEY:["icon":"seniority","title":"年資","content":"","isPressed":"true"],
        CREATED_AT_KEY:["icon":"calendar","title":"建立日期","content":""],
        PV_KEY:["icon":"pv","title":"瀏覽數","content":""]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.text = show_in!.title
        frameWidth = view.frame.width
        
        let cellNib = UINib(nibName: "IconCell", bundle: nil)
        contactTableView.register(cellNib, forCellReuseIdentifier: "cell")
        featuredView.backgroundColor = UIColor.white
        featuredView.contentMode = .scaleAspectFit
        
        timetableHeight = CGFloat(endNum - startNum) * timetableCellHeight
        timetableConllectionViewHeight.constant = timetableHeight
        chargeTop.constant = timetableHeight+timetableHeaderHeight+lblMargin
        
        initChargeView()
        initExpView()
        //initLicenseView()
        
        refresh()
    }
    
//    override func loadView() {
//        super.loadView()
//        chargeWebView = SuperWebView()
//        chargeWebView.backgroundColor = UIColor.gray
//        chargeWebView.uiDelegate = self
//        chargeView = chargeWebView
//        chargeView.backgroundColor = UIColor.white
//    }
    
    override func refresh() {
        Global.instance.addSpinner(superView: view)
        CoachService.instance.getOne(type: show_in!.type, token: show_in!.token) { (success1) in
            if (success1) {
                self.superCoach = CoachService.instance.superCoach
                //self.superCoach!.printRow()
                //self.setData()
                self.getFeatured()
                CoachService.instance.getTT(token: self.show_in!.token, type: self.show_in!.type) { (success2) in
                    Global.instance.removeSpinner(superView: self.view)
                    if (success2) {
                        self.timetables = CoachService.instance.timetables
                        self.setTimetableEvent()
                        //self.chargeViewHeight.constant = 500
                    }
                }
            }
        }
    }
    
    func setTimetableEvent() {
        //timetables!.printRows()
        for eventView in eventViews {
            eventView.removeFromSuperview()
        }
        eventViews.removeAll()
        let width: CGFloat = timetableCellWidth - 2 * timetableCellBorderWidth
        for i in 0 ... timetables!.rows.count-1 {
            let row = timetables!.rows[i]
            let x: CGFloat = CGFloat(row.weekday) * timetableCellWidth + timetableCellBorderWidth
            let y: CGFloat = CGFloat(row._start_time-startNum) * timetableCellHeight + timetableCellBorderWidth
            let gridNum: CGFloat = CGFloat(row._end_time-row._start_time)
            let height: CGFloat = gridNum * timetableCellHeight - 2 * timetableCellBorderWidth
            
            var frame = CGRect(x: x, y: y, width: width, height: height)
            let v: UIView = UIView(frame: frame)
            v.backgroundColor = row._color.toColor()
            v.tag = 1000 + i
            
            frame = CGRect(x: 3, y: 10, width: width, height: 20)
            let titleLbl = UILabel(frame: frame)
            titleLbl.text = row.title
            titleLbl.textColor = UIColor.black
            titleLbl.numberOfLines = 0
            titleLbl.sizeToFit()
            v.addSubview(titleLbl)
            
            let line = DrawLine(frame: CGRect(x: 5, y: 35, width: width-10, height: 1))
            v.addSubview(line)
            
            frame = CGRect(x: 3, y: 40, width: width, height: height-20)
            let contentLbl = UILabel(frame: frame)
            contentLbl.text = "人數：\n" + row.limit_text
            contentLbl.font = UIFont(name: contentLbl.font.fontName, size: 12)
            contentLbl.textColor = UIColor.black
            contentLbl.numberOfLines = 0
            contentLbl.sizeToFit()
            v.addSubview(contentLbl)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(clickTimetableEvent))
            v.addGestureRecognizer(tap)
            
            timetableCollectionView.addSubview(v)
            eventViews.append(v)
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
        
        //contactTableViewWidth.constant = frameWidth!
        changeScrollViewContentSize()
        initCollectionView()
//        print(view.frame.width)
//        print(timetableCollectionView.frame.width)
//        print(scrollView.frame.width)
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
    
    func initChargeView() {
        chargeWebView = SuperWebView()
        chargeWebView.translatesAutoresizingMaskIntoConstraints = false
        chargeView.addSubview(chargeWebView)
        chargeWebView.topAnchor.constraint(equalTo: chargeView.topAnchor).isActive = true
        chargeWebView.rightAnchor.constraint(equalTo: chargeView.rightAnchor).isActive = true
        chargeWebView.leftAnchor.constraint(equalTo: chargeView.leftAnchor).isActive = true
        chargeWebView.bottomAnchor.constraint(equalTo: chargeView.bottomAnchor).isActive = true
        chargeWebView.heightAnchor.constraint(equalTo: chargeView.heightAnchor).isActive = true
        chargeWebView.uiDelegate = self
        chargeWebView.navigationDelegate = self
    }
    
    func initExpView() {
        expWebView = SuperWebView()
        expWebView.translatesAutoresizingMaskIntoConstraints = false
        expView.addSubview(expWebView)
        expWebView.topAnchor.constraint(equalTo: expView.topAnchor).isActive = true
        expWebView.rightAnchor.constraint(equalTo: expView.rightAnchor).isActive = true
        expWebView.leftAnchor.constraint(equalTo: expView.leftAnchor).isActive = true
        expWebView.bottomAnchor.constraint(equalTo: expView.bottomAnchor).isActive = true
        expWebView.heightAnchor.constraint(equalTo: expView.heightAnchor).isActive = true
        expWebView.uiDelegate = self
        expWebView.navigationDelegate = self
    }
    
    func changeScrollViewContentSize() {
        let height: CGFloat = 10000
        //print(height)
        scrollView.contentSize = CGSize(width: timetableCollectionView.frame.width, height: height)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let startTime: Int = indexPath.row / columnNum + startNum
        let weekday: Int = indexPath.row % columnNum
        //print("\(weekday)-\(startTime)")
        let values: [String: String] = [TT_START_TIME: String(startTime) + ":00", TT_WEEKDAY: String(weekday)]
        //eventTag = (collectionView.cellForItem(at: indexPath)?.tag)!
        //print(eventTag)
        //form = TimeTableForm(values: values)
        //showEditEvent(2)
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
        cityBtn.setTitle(superCoach!.city.name)
        //print(BASE_URL + superCoach!.featured_path)
        //featuredView.af_setImage(withURL: URL(string: BASE_URL + superCoach!.featured_path)!)
        featuredView.image = featured
        setContact()
        setCharge()
        setExp()
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
    
    func setCharge() {
        
        let content: String = "<html><body><div class=\"content\">"+superCoach!.charge+"</div></body></html>"+style
        //print(content)
        
        chargeWebView.loadHTMLString(content, baseURL: nil)
    }
    
    func setExp() {
        
        let content: String = "<html><body><div class=\"content\">"+superCoach!.exp+"</div></body></html>"+style
        //print(content)
        
        expWebView.loadHTMLString(content, baseURL: nil)
    }
    
    func getFeatured() {
        DataService.instance1.getImage(_url: BASE_URL + superCoach!.featured_path) { (success) in
            self.featured = DataService.instance1.image
            self.featuredLayout()
            self.setData()
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        chargeWebView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                self.chargeWebView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
                    print(height)
                    self.chargeViewHeight!.constant = height as! CGFloat
                    //self.changeScrollViewContentSize()
                })
            }
            
        })
        
        expWebView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                self.expWebView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
                    print(height)
                    self.expViewHeight!.constant = height as! CGFloat
                    //self.changeScrollViewContentSize()
                })
            }
            
        })
    }
    
    private func featuredLayout() {
        let img_width: CGFloat = featured!.size.width
        let img_height: CGFloat = featured!.size.height
        //print(img_width)
        //print(img_height)
        let height: CGFloat = featuredView.frame.width * (img_height / img_width)
        //featuredViewWidth.constant = frameWidth!
        featuredViewHeight.constant = height
    }
    
    func initShowVC(sin: Show_IN) {
        self.show_in = sin
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        prev()
    }
}
