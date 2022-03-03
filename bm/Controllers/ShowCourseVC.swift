//
//  ShowCourseVC1.swift
//  bm
//
//  Created by ives on 2019/7/5.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit
import SwiftyJSON

class ShowCourseVC: ShowVC {
    
    @IBOutlet weak var signupTableViewConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var coachTableViewConstraintHeight: NSLayoutConstraint!
    
    @IBOutlet weak var signupTableView: SuperTableView!
    @IBOutlet weak var coachTableView: SuperTableView!
    
    @IBOutlet weak var signupDataLbl: SuperLabel!
    @IBOutlet weak var signupDateLbl: SuperLabel!
    @IBOutlet weak var coachDataLbl: SuperLabel!
    
    @IBOutlet weak var signupButton: SubmitButton!
    
    //@IBOutlet weak var signupListButton: CancelButton!
    
    let signupTableRowKeys:[String] = ["date", "deadline"]
    var signupTableRows: [String: [String:String]] = [
        "date":["icon":"calendar","title":"報名上課日期","content":"","isPressed":"false"],
        "deadline":["icon":"clock","title":"報名截止時間","content":"","isPressed":"false"]
    ]
    
    let coachTableRowKeys:[String] = [NAME_KEY,MOBILE_KEY,LINE_KEY,FB_KEY,YOUTUBE_KEY,WEBSITE_KEY,EMAIL_KEY]
    var coachTableRows: [String: [String:String]] = [
        NAME_KEY:["icon":"coach","title":"教練","content":"","isPressed":"true"],
        MOBILE_KEY:["icon":"mobile","title":"行動電話","content":"","isPressed":"true"],
        LINE_KEY:["icon":"line","title":"line id","content":"","isPressed":"false"],
        FB_KEY:["icon":"fb","title":"fb","content":"","isPressed":"true"],
        YOUTUBE_KEY:["icon":"youtube","title":"youtube","content":"","isPressed":"true"],
        WEBSITE_KEY:["icon":"website","title":"網站","content":"","isPressed":"true"],
        EMAIL_KEY:["icon":"email1","title":"email","content":"","isPressed":"true"]
    ]
    
    //var courseTable: courseTable?
    //var coachTable: coachTable?
    
    var myTable: CourseTable?
    var coachTable: CoachTable?
    
    var fromNet: Bool = false
    var signup_date: JSON = JSON()
    var isSignup: Bool = false
    var isStandby: Bool = false
    var canCancelSignup: Bool = false
    var signup_id: Int = 0
    var course_date: String = ""
    var course_deadline: String = ""
    
    override func viewDidLoad() {

        dataService = CourseService.instance
        
        let cellNib = UINib(nibName: "OneLineCell", bundle: nil)
//        signupTableView.register(cellNib, forCellReuseIdentifier: "cell")
//        coachTableView.register(cellNib, forCellReuseIdentifier: "cell")
//
//        initSignupTableView()
//        initCoachTableView()
//
//        signupButton.setTitle("報名")
        //signupListButton.setTitle("報名列表")
        //containerViewConstraintWidth.constant = screen_width
        
        super.viewDidLoad()
        
        tableRowKeys = ["weekday_text","interval_show","date","price_text_long","people_limit_text","kind_text","pv","created_at_show"]
        tableRows = [
            "weekday_text":["icon":"date","title":"星期","content":""],
            "interval_show":["icon":"clock","title":"時段","content":""],
            "date":["icon":"date","title":"期間","content":""],
            "price_text_long":["icon":"money","title":"收費","content":""],
            "people_limit_text":["icon":"group","title":"限制人數","content":""],
            "kind_text": ["icon":"cycle","title":"週期","content":""],       // "signup_count":["icon":"group","title":"已報名人數","content":""],
            "pv":["icon":"pv","title":"瀏覽數","content":""],
            "created_at_show":["icon":"date","title":"建立日期","content":""]
        ]
        
        containerViewConstraintWidth.constant = screen_width
        containerViewConstraintHeight.constant = 2000
        
//        if (scrollView != nil) {
//            initContentView()
//            scrollView.backgroundColor = UIColor.clear
//            beginRefresh()
//            scrollView.addSubview(refreshControl)
//        }
        
        refresh(CourseTable.self)
        //refresh()
    }
    
    override func refresh() {
        refresh(CourseTable.self)
    }
    
//    override func viewWillLayoutSubviews() {
//        mainDataLbl.text = "課程資料"
//        signupDataLbl.text = "報名資料"
//        coachDataLbl.text = "教練資料"
//        contentDataLbl.text = "詳細介紹"
//        
//        mainDataLbl.setTextTitle()
//        signupDataLbl.setTextTitle()
//        coachDataLbl.setTextTitle()
//        contentDataLbl.setTextTitle()
//    }
    
    func initSignupTableView() {
        
        signupTableView.dataSource = self
        signupTableView.delegate = self
        signupTableView.rowHeight = UITableView.automaticDimension
        signupTableView.estimatedRowHeight = 300
        signupTableViewConstraintHeight.constant = 1000
    }
    
    func initCoachTableView() {
        
        coachTableView.dataSource = self
        coachTableView.delegate = self
        coachTableView.rowHeight = UITableView.automaticDimension
        coachTableView.estimatedRowHeight = 600
        coachTableViewConstraintHeight.constant = 3000
    }
    
    override func setData() {
        
        if table != nil {
            myTable = table as? CourseTable
            if (myTable != nil) {
                //myTable!.filterRow()
                //self.courseTable?.printRow()
                
                setMainData(myTable!)
                
                //coachTable = courseTable!.coach
                //self.courseTable!.signup_normal_models
                
                if myTable!.coachTable != nil { // setup coach for course data
                    coachTable = self.myTable!.coachTable
                    setCoachData()
                }
                
                if myTable!.dateTable != nil { // setup next time course time
                    //self.courseTable!.dateTable?.printRow()
                    setNextTime()
                }
                fromNet = true
                                
                tableView.reloadData()
                signupTableView.reloadData()
                coachTableView.reloadData()
                
                if (myTable!.people_limit == 0) {
                    signupButton.visibility = .invisible
                }
            
                if myTable!.isSignup {
                    signupButton.setTitle("取消報名")
                } else {
                    let count = myTable!.signupNormalTables.count
                    if count >= myTable!.people_limit {
                        self.signupButton.setTitle("候補")
                    } else {
                        self.signupButton.setTitle("報名")
                    }
                }
            }
        }
    }
    
//    override func setMainData() {
//
//        if !myTable!.start_date.isEmpty {
//            let date = myTable!.start_date + " ~ " + myTable!.end_date
//            tableRows["date"]!["content"] = date
//        } else {
//            tableRows.removeValue(forKey: "date");
//            tableRowKeys = tableRowKeys.filter{$0 != "date"}
//        }
//        tableRows["interval_show"]!["content"] = myTable!.interval_show
//    }
    
    func setNextTime() {
        
        if (myTable?.people_limit ?? 0 <= 0) {
            signupDateLbl.text = "暫不開放報名"
        } else {
            let dateTable: DateTable = myTable!.dateTable!
            let date: String = dateTable.date
            let start_time: String = myTable!.start_time_show
            let end_time: String = myTable!.end_time_show
            let next_time = "下次上課時間：\(date) \(start_time) ~ \(end_time)"
            signupDateLbl.text = next_time
        }
        
        
//        let nextCourseTime: [String: String] = courseTable!.nextCourseTime
//        for key in signupTableRowKeys {
//            signupTableRows[key]!["content"] = nextCourseTime[key]
//        }
    }
    
    func setCoachData() {
        //coachTable!.printRow()
        let mirror: Mirror = Mirror(reflecting: coachTable!)
        let propertys: [[String: Any]] = mirror.toDictionary()
        for key in coachTableRowKeys {
            
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
                    coachTableRows[key]!["content"] = content
                    break
                }
            }
        }
        //print(self.coachTableRows)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !fromNet {
            return 0
        } else {
            if tableView == self.tableView {
                return tableRowKeys.count
            } else if tableView == self.signupTableView {
                if myTable != nil && myTable!.people_limit > 0 {
                    //let normal_count: Int = courseTable!.signupNormalTables.count
                    let standby_count: Int = myTable!.signupStandbyTables.count
                    let people_limit: Int = myTable!.people_limit
                    let count = people_limit + standby_count + 1
                    //print(count)
                    return count
                } else {
                    return 0
                }
            } else if tableView == self.coachTableView {
                //print(coachTableRowKeys.count)
                return coachTableRowKeys.count
            } else {
                return 0
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableView {
            let cell: OneLineCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OneLineCell
            
            let key = tableRowKeys[indexPath.row]
            if tableRows[key] != nil {
                let row = tableRows[key]!
                let icon = row["icon"] ?? ""
                let title = row["title"] ?? ""
                let content = row["content"] ?? ""
                cell.update(icon: icon, title: title, content: content)
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
        } else if tableView == self.signupTableView {
            let cell: OlCell = tableView.dequeueReusableCell(withIdentifier: "signupCell", for: indexPath) as! OlCell
            
            let people_limit = myTable!.people_limit
            let normal_count = myTable!.signupNormalTables.count
            let standby_count = myTable!.signupStandbyTables.count
            if indexPath.row < people_limit {
                cell.numberLbl.text = "\(indexPath.row + 1)."
                cell.nameLbl.text = ""
                if normal_count > 0 {
                    if indexPath.row < normal_count {
                        let signup_normal_model = myTable!.signupNormalTables[indexPath.row]
                        cell.nameLbl.text = signup_normal_model.member_name
                    }
                }
            } else if indexPath.row >= people_limit && indexPath.row < people_limit + standby_count {
                cell.numberLbl.text = "候補\(indexPath.row - people_limit + 1)."
                let signup_standby_model = myTable!.signupStandbyTables[indexPath.row - people_limit]
                cell.nameLbl.text = signup_standby_model.member_name
            } else {
                let remain: Int = people_limit - myTable!.signupNormalTables.count
                var remain_text = ""
                if (remain > 0) {
                    remain_text = "還有\(remain)個名額"
                } else {
                    remain_text = "已經額滿，請排候補"
                }
                cell.numberLbl.text = remain_text
            }

            if indexPath.row == people_limit + standby_count - 1 {

                UIView.animate(withDuration: 0, animations: {self.signupTableView.layoutIfNeeded()}) { (complete) in
                    var heightOfTableView: CGFloat = 0.0
                    let cells = self.signupTableView.visibleCells
                    for cell in cells {
                        heightOfTableView += cell.frame.height
                    }
                    //print(heightOfTableView)
                    self.signupTableViewConstraintHeight.constant = heightOfTableView
                    self.changeScrollViewContentSize()
                }
            }
            return cell
//            let key = signupTableRowKeys[indexPath.row]
//            if signupTableRows[key] != nil {
//                let row = signupTableRows[key]!
//                let icon = row["icon"] ?? ""
//                let title = row["title"] ?? ""
//                let content = row["content"] ?? ""
//                let isPressed = NSString(string: row["isPressed"] ?? "false").boolValue
//                cell!.update(icon: icon, title: title, content: content, contentH: cellHeight, isPressed: isPressed)
//            }

        } else if tableView == self.coachTableView {
            let cell: OneLineCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OneLineCell
            
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
                cell.update(icon: icon, title: title, content: content, isPressed: isPressed)
            }
            
            if indexPath.row == coachTableRowKeys.count - 1 {
                
                UIView.animate(withDuration: 0, animations: {self.coachTableView.layoutIfNeeded()}) { (complete) in
                    var heightOfTableView: CGFloat = 0.0
                    let cells = self.coachTableView.visibleCells
                    for cell in cells {
                        heightOfTableView += cell.frame.height
                    }
                    //print(heightOfTableView)
                    self.coachTableViewConstraintHeight.constant = heightOfTableView
                    self.changeScrollViewContentSize()
                }
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.coachTableView {
            let key = coachTableRowKeys[indexPath.row]
            if key == NAME_KEY {
                //let sender: Show_IN = Show_IN(type: source,id:coachTable!.id,token:coachTable!.token,title:coachTable!.name)
                //performSegue(withIdentifier: TO_SHOW, sender: sender)
            } else if key == MOBILE_KEY {
                coachTable!.mobile.makeCall()
            } else if key == LINE_KEY {
                coachTable!.line.line()
            } else if key == FB_KEY {
                coachTable!.fb.fb()
            } else if key == YOUTUBE_KEY {
                coachTable!.youtube.youtube()
            } else if key == WEBSITE_KEY {
                coachTable!.website.website()
            } else if key == EMAIL_KEY {
                coachTable!.email.email()
            }
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == TO_SHOW {
//            let sender = sender as! Show_IN
//            let showVC: ShowVC = segue.destination as! ShowVC
//            showVC.show_in = sender
//        } else if segue.identifier == TO_SIGNUP_LIST {
//            let signupListVC: SignupListVC = segue.destination as! SignupListVC
//            signupListVC.able = "course"
//            signupListVC.able_token = token!
//        }
//    }
    
    override func changeScrollViewContentSize() {
        
        let h1 = featured.bounds.size.height
        let h2 = mainDataLbl.bounds.size.height
        let h3 = tableViewConstraintHeight.constant
        let h4 = coachDataLbl.bounds.size.height
        let h5 = coachTableViewConstraintHeight.constant
        let h6 = contentDataLbl.bounds.size.height
        let h7 = contentViewConstraintHeight!.constant
        let h8 = signupDataLbl.bounds.size.height
        let h9 = signupTableViewConstraintHeight.constant
        //print(contentViewConstraintHeight)
        
        //let h: CGFloat = h1 + h2 + h3 + h4 + h5
        let h: CGFloat = h1 + h2 + h3 + h4 + h5 + h6 + h7 + h8 + h9 + 300
        scrollView.contentSize = CGSize(width: view.frame.width, height: h)
        containerViewConstraintHeight.constant = h
        //print(h1)
    }
    
    func showSignupModal() {
        
        let signup_html = "報名課程日期是：" + course_date + "\r\n" + "報名取消截止時間是：" + course_deadline.noSec()
        let cancel_signup_html = "報名課程日期是：" + course_date + "\r\n" + "報名取消截止時間是：" + course_deadline.noSec()
        let cant_cancel_signup_html = "已經超過取消報名期限，無法取消\r\n" + "報名課程日期是：" + course_date + "\r\n" + "報名取消截止時間是：" + course_deadline.noSec()
        //let standby_html = "此課程報名已經額滿，請排候補" + "\r\n" + signup_html
        
        var title: String = ""
        var msg = signup_html
        
        if isSignup {
            title = "取消報名"
            if canCancelSignup {
                msg = cancel_signup_html
            } else {
                msg = cant_cancel_signup_html
            }
        } else {
            if isStandby {
                title = "候補報名"
            } else {
                title = "報名"
            }
        }
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        if (!isSignup && !canCancelSignup) || (isSignup && canCancelSignup) {
            alert.addAction(UIAlertAction(title: title, style: .default, handler: { (action) in
                self.signup()
            }))
        }
        
        let closeAction = UIAlertAction(title: "取消", style: .default, handler: nil)
        alert.addAction(closeAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func signup() {
        if !Member.instance.isLoggedIn {
            warning("請先登入會員")
            return
        }
        if myTable!.dateTable != nil {
            Global.instance.addSpinner(superView: view)
            dataService.signup(token: token!, member_token: Member.instance.token, date_token: myTable!.dateTable!.token, course_deadline: course_deadline) { (success) in
                
                Global.instance.removeSpinner(superView: self.view)
                
                do {
                    if (self.dataService.jsonData != nil) {
                        let successTable: SuccessTable = try JSONDecoder().decode(SuccessTable.self, from: self.dataService.jsonData!)
                        if (successTable.success) {
                            self.info(msg: successTable.msg, buttonTitle: "關閉") {
                                self.refresh(CourseTable.self)
                            }
                        } else {
                            self.warning("報名沒有成功，請洽管理員")
                        }
                    }
                } catch {
                    self.msg = "解析JSON字串時，得到空值，請洽管理員"
                }
                
                
//                let msg = CourseService.instance.msg
//                var title = "警告"
//                var closeAction: UIAlertAction?
//                if self.dataService.success {
//                    title = "提示"
//                    closeAction = UIAlertAction(title: "取消", style: .default, handler: { (action) in
//                        self.refresh(CourseTable.self)
//                    })
//                } else {
//                    closeAction = UIAlertAction(title: "關閉", style: .default, handler: nil)
//                }
//                let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
//                alert.addAction(closeAction!)
//
//                self.present(alert, animated: true, completion: nil)
            }
        } else {
            warning("無法報名，請通知管理員 - signup")
        }
    }
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        if !Member.instance.isLoggedIn {
            warning("請先登入會員")
            return
        }
        //print(Member.instance.token)
        if myTable!.dateTable != nil {
            Global.instance.addSpinner(superView: view)
            dataService.signup_date(token: token!, member_token: Member.instance.token, date_token: myTable!.dateTable!.token) { (success) in
                Global.instance.removeSpinner(superView: self.view)
                if (success) {
                    
                    do {
                        if self.dataService.jsonData != nil {
                            let signupDateTable: SignupDateTable = try JSONDecoder().decode(SignupDateTable.self, from: self.dataService.jsonData!)
                            self.isSignup = signupDateTable.isSignup
                            self.isStandby = signupDateTable.isStandby
                            self.canCancelSignup = signupDateTable.cancel
                            self.course_date = signupDateTable.date
                            self.course_deadline = signupDateTable.deadline
                            self.showSignupModal()
                        }
                    } catch {
                        self.msg = "解析JSON字串時，得到空值，請洽管理員"
                    }
                    
//                    self.signup_date = self.dataService.signup_date
//                    self.isSignup = self.signup_date["isSignup"].boolValue
//                    self.isStandby = self.signup_date["isStandby"].boolValue
//                    self.canCancelSignup = self.signup_date["cancel"].boolValue
//                    //self.signup_id = self.signup_date["signup_id"].intValue
//                    self.course_date = self.signup_date["date"].stringValue
//                    self.course_deadline = self.signup_date["deadline"].stringValue
//                    self.showSignupModal()
                } else {
                    self.warning(self.dataService.msg)
                }
            }
        } else {
            warning("無法取得日期參數，所以無法報名，請通知管理員 - signupButtonPressed")
        }
    }
    
    @IBAction func signupListButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_SIGNUPLIST, sender: nil)
    }
}

