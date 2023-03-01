//
//  ShowCourseVC1.swift
//  bm
//
//  Created by ives on 2019/7/5.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit
import SwiftyJSON
import WebKit
import SCLAlertView

class ShowCourseVC: BaseViewController, WKNavigationDelegate {
    
//    @IBOutlet weak var signupButton: SubmitButton!
//    @IBOutlet weak var signupButtonConstraintLeading: NSLayoutConstraint!
        

    var myTable: CourseTable?
    var coachTable: CoachTable?
    
    //var fromNet: Bool = false
    //var signup_date: JSON = JSON()
    var isSignup: Bool = false
    var isStandby: Bool = false
    var canCancelSignup: Bool = false
    var signup_id: Int = 0
    var course_date: String = ""
    var course_deadline: String = ""
    
    let button_width: CGFloat = 120
    var bottom_button_count: Int = 1
    
    var showTop: ShowTop2?
    var showBottom: ShowBottom2?
    
    var scrollView: BaseScrollView?
    //let contentView: UIView = UIView()
    let featured: UIImageView = UIImageView()
    
    let courseTableView: UITableView = {
        let view = UITableView()
        view.isScrollEnabled = false
        
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = UITableView.automaticDimension

        let cellNib = UINib(nibName: "OneLineCell", bundle: nil)
        view.register(cellNib, forCellReuseIdentifier: "cell")
        return view
    }()
    var signupTableView: UITableView = {
        let view = UITableView()
        view.isScrollEnabled = false
        view.backgroundColor = UIColor(MY_BLACK)
        
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = UITableView.automaticDimension

        view.register(ShowSignupCell.self, forCellReuseIdentifier: "ShowSignupCell")
        
        return view
    }()
    let coachTableView: UITableView = {
        let view = UITableView()
        view.isScrollEnabled = false
        
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = UITableView.automaticDimension

        let cellNib = UINib(nibName: "OneLineCell", bundle: nil)
        view.register(cellNib, forCellReuseIdentifier: "cell")
        return view
    }()
    
    var featured_h: CGFloat = 0
    
    var signupDataLbl: SuperLabel = {
        let view = SuperLabel()
        view.setTextSectionTitle()
        view.text = "報名資料"
        view.textAlignment = .center
        
        return view
    }()
    
    var signupDateLbl: SuperLabel = {
        let view = SuperLabel()
        view.setTextGeneral()
        return view
    }()
    
    var signupDeadlineLbl: SuperLabel = {
        let view = SuperLabel()
        view.setTextGeneral()
        
        return view
    }()
    
    var coachDataLbl: SuperLabel = {
        let view = SuperLabel()
        view.setTextSectionTitle()
        view.text = "教練資料"
        view.textAlignment = .center
        
        return view
    }()
    
    var contentWebView: WKWebView = {
        
        //Create configuration
        let configuration = WKWebViewConfiguration()
        //configuration.userContentController = controller
        
        let webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        webView.backgroundColor = UIColor.clear
        webView.scrollView.isScrollEnabled = false
        return webView
    }()
    //var contentWebViewConstraintHeight: NSLayoutConstraint?
    
    var coachRows: [MemberRow] = [MemberRow]()
    
    var token: String?
    var table: Table?
    var memberRows: [MemberRow] = [MemberRow]()
    
    override func viewDidLoad() {

        dataService = CourseService.instance
        
        //bottom_button_count = 2

        //signupButton.setTitle("報名")
        
        super.viewDidLoad()
        
        showTop = ShowTop2(delegate: self)
        showTop!.anchor(parent: self.view)
        
        showBottom = ShowBottom2(delegate: self)
        self.view.addSubview(showBottom!)
        showBottom!.setAnchor(parent: self.view)
        showBottom!.setSubmitBtnTitle("報名")
        
        initScrollView()
        initFeatured()
        initCourse()
        initSignup()
        initCoach()
        
        scrollView?.stackContentView.addArrangedSubview(contentWebView)
//        contentWebView.translatesAutoresizingMaskIntoConstraints = false
//        contentWebViewConstraintHeight = NSLayoutConstraint(item: contentWebView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
//        scrollView?.stackContentView.addConstraint(contentWebViewConstraintHeight!)
        contentWebView.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
        
        //contentWebView.uiDelegate = self
        contentWebView.navigationDelegate = self
        //self.view.addSubview(scrollView)
        //scrollView.backgroundColor = UIColor.brown
        //scrollView.translatesAutoresizingMaskIntoConstraints = false
        //scrollerView.setAnchor(parent: self.view)
//        scrollView.snp.makeConstraints { make in
//            make.top.equalTo(showTop.snp.bottom)
//            make.right.left.equalToSuperview()
//            make.bottom.equalToSuperview()
//            make.width.equalToSuperview()
//        }
        
        //setupScrollView()
        
        
        //contentView.backgroundColor = UIColor.red
        //scrollView.addSubview(contentView)
        
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.leadingAnchor.constraint(equalTo: contentView.superview!.leftAnchor, constant: 0).isActive = true
//        contentView.trailingAnchor.constraint(equalTo: contentView.superview!.trailingAnchor, constant: 0).isActive = true
//        contentView.topAnchor.constraint(equalTo: contentView.superview!.topAnchor, constant: 0).isActive = true
//        contentView.bottomAnchor.constraint(equalTo: contentView.superview!.bottomAnchor, constant: 0).isActive = true
        //contentView.heightConstraint?.constant = 100
        
        
        
//        contentView.snp.makeConstraints { make in
//            make.top.equalToSuperview()
//            make.leading.trailing.equalToSuperview()
//            //make.left.right.equalToSuperview()
//            //make.edges.width.equalToSuperview()
//            make.height.equalTo(100)
//        }
        
        //scrollerView.setAnchor(parent: self.view)
        
        //scrollerView.contentView.addSubview(featured)
        
        //scrollStackViewContainer.addSubview(featured)
        
//        let v: UIView = UIView()
//        scrollStackViewContainer.addArrangedSubview(v)
//        v.backgroundColor = UIColor.blue
//        v.snp.makeConstraints { make in
//            make.height.equalTo(500)
//        }
        
        refresh(CourseTable.self)
        
        
        
//        let v1: UIView = UIView()
//        contentView.addSubview(v1)
//        v1.backgroundColor = UIColor.red
//        v1.snp.makeConstraints { make in
//            //make.width.equalToSuperview()
//            make.height.equalTo(500)
//            make.top.equalTo(v.snp.bottom).offset(20)
//            make.left.right.equalToSuperview().inset(20)
//        }
        
        
        
        
        //initSignupTableView()
        //initCoachTableView()
        
        //let cellNib = UINib(nibName: "OneLineCell", bundle: nil)
        //signupTableView.register(cellNib, forCellReuseIdentifier: "cell")
        //coachTableView.register(cellNib, forCellReuseIdentifier: "cell")
    }
    
    override func cancel() {
        
        if (!Member.instance.isLoggedIn) {
            toLogin()
        } else {
            if (table != nil) {
                showBottom!.isLike = !showBottom!.isLike
                showBottom!.likeBtn.setLike(showBottom!.isLike)
                
                dataService.like(token: table!.token, able_id: table!.id)
            } else {
                warning("沒有取得內容資料值，請稍後再試或洽管理員")
            }
        }
    }
    
    private func initCoach() {
        scrollView?.stackContentView.addArrangedSubview(coachDataLbl)
        coachDataLbl.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
        
        coachTableView.delegate = self
        coachTableView.dataSource = self
        scrollView?.stackContentView.addArrangedSubview(coachTableView)
        coachTableView.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
    }
    
    private func initCourse() {
        courseTableView.delegate = self
        courseTableView.dataSource = self
//        contentView.addSubview(courseTableView)
        scrollView?.stackContentView.addArrangedSubview(courseTableView)
        courseTableView.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
    }
    
    private func initFeatured() {
        scrollView?.stackContentView.addArrangedSubview(featured)
        featured.snp.makeConstraints { make in
            //make.top.left.right.equalToSuperview()
            make.height.equalTo(200)
        }
        //featured.backgroundColor = UIColor.brown
    }
    
    private func initScrollView() {
        //let margins = view.layoutMarginsGuide
        //view.addSubview(scrollView)
        scrollView = BaseScrollView(parent: self.view, delegate: self)
        scrollView!.setAnchor(top: showTop!.snp.bottom, bottom: showBottom!.snp.top)
        
        
//        scrollView.snp.makeConstraints { make in
//            make.top.equalTo(showTop!.snp.bottom)
//            make.bottom.equalTo(showBottom!.snp.top)
//            make.leading.trailing.equalToSuperview()
//        }

//        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        scrollView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
//        scrollView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        
//        scrollView!.addSubview(scrollStackViewContainer)
//        scrollStackViewContainer.snp.makeConstraints { make in
//            make.top.bottom.leading.trailing.equalToSuperview()
//            make.width.equalToSuperview()
//        }

//        scrollStackViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
//        scrollStackViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
//        scrollStackViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
//        scrollStackViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
//        scrollStackViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        //configureContainerView()
    }
    
    private func initSignup() {
        scrollView?.stackContentView.addArrangedSubview(signupDataLbl)
        signupDataLbl.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
        
        scrollView?.stackContentView.addArrangedSubview(signupDateLbl)
        signupDateLbl.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalToSuperview()
        }
        
        scrollView?.stackContentView.addArrangedSubview(signupDeadlineLbl)
        signupDeadlineLbl.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalToSuperview()
        }
        
        signupTableView.delegate = self
        signupTableView.dataSource = self
        
        scrollView?.stackContentView.addArrangedSubview(signupTableView)
        signupTableView.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
    }
    
//    private func configureContainerView() {
//        scrollStackViewContainer.addArrangedSubview(subView1)
//        scrollStackViewContainer.addArrangedSubview(subview2)
//        scrollStackViewContainer.addArrangedSubview(subview3)
//    }

    
    override func viewWillLayoutSubviews() {
        let a = courseTableView.contentSize.height
        courseTableView.heightConstraint?.constant = a
        
        let b = signupTableView.contentSize.height
        signupTableView.heightConstraint?.constant = b
        
        let c = coachTableView.contentSize.height
        coachTableView.heightConstraint?.constant = c
        
        //let d = contentWebView.content
        
        //contentView.heightConstraint?.constant = 500 + a
    }
    
    func refresh<T: Table>(_ t: T.Type) {
        
        memberRows.removeAll()
        coachRows.removeAll()
        
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
                                self.setData()
                                self.setContentWeb()
                                self.initLike()
                                self.showTop!.setTitle(title: self.table!.title)
                            }
                        }
                    } catch {
                        self.warning(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func setContentWeb() {
        let content: String = "<html><HEAD><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no\">"+self.body_css+"</HEAD><body>"+table!.content+"</body></html>"
        
        contentWebView.loadHTMLString(content, baseURL: nil)
    }
    
    func setData() {

        if myTable == nil {
            myTable = CourseTable()
        }

        myTable = table as? CourseTable
        var row: MemberRow = MemberRow(title: "星期", icon: "date", show: myTable!.weekday_text)
        memberRows.append(row)
        row = MemberRow(title: "時段", icon: "clock", show: myTable!.interval_show)
        memberRows.append(row)
        if myTable!.dateTable != nil {
            row = MemberRow(title: "期間", icon: "date", show: myTable!.dateTable!.date)
            memberRows.append(row)
        }
        row = MemberRow(title: "收費", icon: "money", show: myTable!.price_text_long)
        memberRows.append(row)
        row = MemberRow(title: "限制人數", icon: "group", show: myTable!.people_limit_text)
        memberRows.append(row)
        row = MemberRow(title: "週期", icon: "cycle", show: myTable!.kind_text)
        memberRows.append(row)
        row = MemberRow(title: "瀏覽數", icon: "pv", show: String(myTable!.pv))
        memberRows.append(row)
        row = MemberRow(title: "建立日期", icon: "date", show: myTable!.created_at_show)
        memberRows.append(row)
        
        if myTable!.dateTable != nil { // setup next time course time
            //self.courseTable!.dateTable?.printRow()
            setNextTime()
        }
        
        courseTableView.reloadData()
        courseTableView.invalidateIntrinsicContentSize()
        if (myTable!.people_limit == 0) {
            showBottom!.showButton(parent: self.view, isShowSubmit: false, isShowCancel: false)
        }
        if myTable!.isSignup {
            showBottom!.setSubmitBtnTitle("取消報名")
            //signupButton.setTitle("取消報名")
        } else {
            let count = myTable!.signupNormalTables.count
            if count >= myTable!.people_limit {
                self.showBottom!.setSubmitBtnTitle("候補")
            } else {
                self.showBottom!.setSubmitBtnTitle("報名")
            }
        }
        
        signupTableView.reloadData()
        signupTableView.invalidateIntrinsicContentSize()

        if (myTable!.coachTable != nil) {
            coachTable = myTable!.coachTable
            var coachRow: MemberRow = MemberRow(title: "教練", icon: "coach", show: coachTable!.name )
            coachRows.append(coachRow)
            coachRow = MemberRow(title: "行動電話", icon: "mobile", show: coachTable!.mobile )
            coachRows.append(coachRow)
            coachRow = MemberRow(title: "LINE", icon: "line", show: coachTable!.line )
            coachRows.append(coachRow)
            coachRow = MemberRow(title: "FB", icon: "fb", show: coachTable!.fb )
            coachRows.append(coachRow)
            coachRow = MemberRow(title: "YOUTUBE", icon: "youtube", show: coachTable!.youtube )
            coachRows.append(coachRow)
            coachRow = MemberRow(title: "網站", icon: "website", show: coachTable!.website )
            coachRows.append(coachRow)
            coachRow = MemberRow(title: "EMail", icon: "email1", show: coachTable!.email )
            coachRows.append(coachRow)
            
            coachTableView.reloadData()
            coachTableView.invalidateIntrinsicContentSize()
        }
    }
    
    func setFeatured() {

        if (table != nil && table!.featured_path.count > 0) {
            
            featured.downloaded(from: table!.featured_path)
            
            featured_h = featured.heightForUrl(url: table!.featured_path, width: screen_width)
        } else {
            warning("沒有取得內容資料值，請稍後再試或洽管理員")
        }
    }
    
    func initLike() {
        self.showBottom!.initLike(isLike: table!.like, count: table!.like_count)
    }
    
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
            signupDeadlineLbl.text = "報名截止時間："// + myTable!.signupDate!.deadline.noSec()
        }
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
                            self.warning(successTable.msg)
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
    
    override func submit() {
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

    func getMemberOne(member_token: String) {
        
        MemberService.instance.getOne(params: ["token": member_token]) { success in
            
            Global.instance.removeSpinner(superView: self.view)
            
            if success {
                
                let jsonData: Data = MemberService.instance.jsonData!
                do {
                    let successTable: SuccessTable = try JSONDecoder().decode(SuccessTable.self, from: jsonData)
                    if successTable.success {
                        let memberTable: MemberTable = try JSONDecoder().decode(MemberTable.self, from: jsonData)
                        if memberTable.id > 0 {
                            self.showTempMemberInfo(memberTable)
                        }
                    } else {
                        self.warning(successTable.msg)
                    }
                } catch {
                    self.warning(error.localizedDescription)
                }
            }
        }
    }
    
    func showTempMemberInfo(_ memberTable: MemberTable) {
        
        let apperance = SCLAlertView.SCLAppearance(
            showCloseButton: false,
            showCircularIcon: true
        )
        
        let alertView = SCLAlertView(appearance: apperance)
        let alertViewIcon = UIImage(named: "member1")
        
        // Creat the subview
        let subview = UIView(frame: CGRect(x:0, y:0, width:220, height:100))
        //subview.backgroundColor = UIColor.red
        //let x = (subview.frame.width - 10) / 2

        let a: String = "姓名：" + memberTable.name + "\n"
        + "電話：" + memberTable.mobile.mobileShow() + "\n"
        + "EMail：" + memberTable.email
        
        // Add textfield 1
        let textfield1 = UITextView(frame: CGRect(x:0, y:0, width:subview.frame.width, height:subview.frame.height))
        //textfield1.backgroundColor = UIColor.yellow
        textfield1.text = a
        textfield1.font = UIFont(name: textfield1.font?.fontName ?? FONT_NAME, size: 18)
        subview.addSubview(textfield1)

        // Add the subview to the alert's UI property
        alertView.customSubview = subview
        
//        let a: UITextView = alertView.addTextView()
//        a.frame = CGRect(x: 0, y: 0, width: 216, height: 300)
//

        
        alertView.addButton("打電話") {
            memberTable.mobile.makeCall()
        }
        
        alertView.addButton("關閉", backgroundColor: UIColor(MY_GRAY)) {
            alertView.hideView()
        }
        alertView.showSuccess(memberTable.nickname, subTitle: "", circleIconImage: alertViewIcon)
    }
    
    override func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        super.webView(webView, decidePolicyFor: navigationAction, decisionHandler: decisionHandler)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.contentWebView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                self.contentWebView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
                    self.contentWebView.snp.remakeConstraints { make in
                        make.height.equalTo(height as! CGFloat)
                    }
                    //self.contentWebViewConstraintHeight!.constant = height as! CGFloat
                })
            }

        })
    }
}

extension ShowCourseVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (tableView == self.courseTableView) {
            return memberRows.count
        } else if (tableView == self.signupTableView) {
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
        } else if (tableView == self.coachTableView) {
            return coachRows.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (tableView == self.courseTableView) {
            let cell: OneLineCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OneLineCell
            
            let row: MemberRow = memberRows[indexPath.row]
            cell.update(icon: row.icon, title: row.title, content: row.show)
            cell.backgroundColor = UIColor(MY_BLACK)
            
            //        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
            //        cell.textLabel?.text = memberRows[indexPath.row].title
            
            return cell
        } else if tableView == self.signupTableView {
            let cell: ShowSignupCell = tableView.dequeueReusableCell(withIdentifier: "ShowSignupCell", for: indexPath) as! ShowSignupCell
            
            let people_limit = myTable!.people_limit
            let normal_count = myTable!.signupNormalTables.count
            let standby_count = myTable!.signupStandbyTables.count
            if indexPath.row < people_limit {
                cell.noLbl.text = "\(indexPath.row + 1)."
                cell.nameLbl.text = ""
                if normal_count > 0 {
                    if indexPath.row < normal_count {
                        let signup_normal_model = myTable!.signupNormalTables[indexPath.row]
                        cell.nameLbl.text = signup_normal_model.member_name
                    }
                }
            } else if indexPath.row >= people_limit && indexPath.row < people_limit + standby_count {
                cell.noLbl.text = "候補\(indexPath.row - people_limit + 1)."
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
                cell.noLbl.text = remain_text
            }
            cell.setSelectedBackgroundColor()

            return cell
        } else if tableView == self.coachTableView {
            let cell: OneLineCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OneLineCell
            
            let row: MemberRow = coachRows[indexPath.row]
            cell.update(icon: row.icon, title: row.title, content: row.show)
            cell.backgroundColor = UIColor(MY_BLACK)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(indexPath.row)
        if tableView == signupTableView {
            if coachTable != nil {
                if coachTable!.manager_id == Member.instance.id {
                    let people_limit = myTable!.people_limit
                    if (indexPath.row < people_limit) {
                        let signup_normal_model = myTable!.signupNormalTables[indexPath.row]
                        //print(signup_normal_model.member_token)
                        getMemberOne(member_token: signup_normal_model.member_token)
                        
                    } else {
                        let signup_standby_model = myTable!.signupStandbyTables[indexPath.row]
                        getMemberOne(member_token: signup_standby_model.member_token)
                    }
                } else {
                    warning("只有球隊管理員可以檢視報名者資訊")
                }
            }
        }
    }
}

