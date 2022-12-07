//
//  ShowTeamVC.swift
//  bm
//
//  Created by ives on 2021/5/2.
//  Copyright © 2021 bm. All rights reserved.
//

import UIKit
import WebKit
import SCLAlertView

class ShowTeamVC: BaseViewController {
    
//    @IBOutlet weak var signupTableView: SuperTableView!
//
//    @IBOutlet weak var signupDataLbl: SuperLabel!
//    @IBOutlet weak var signupTimeLbl: SuperLabel!
//    @IBOutlet weak var signupDeadlineLbl: SuperLabel!
//
//    @IBOutlet weak var signupTableViewConstraintHeight: NSLayoutConstraint!
//    @IBOutlet weak var signupButton: SubmitButton!
//    @IBOutlet weak var signupButtonConstraintLeading: NSLayoutConstraint!
//
//    @IBOutlet weak var topTabContainer: UIStackView!
    
//    var topTabContainer: UIView = {
//        let view: UIView = UIView()
//        view.backgroundColor = UIColor.blue
//        return view
//    }()
    
    var showTop: ShowTop2?
    
    var topTagStackView: UIStackView = {
        let view: UIStackView = UIStackView()
        //view.backgroundColor = UIColor.gray
        view.axis = NSLayoutConstraint.Axis.horizontal
        view.distribution = UIStackView.Distribution.fillEqually
        view.alignment = UIStackView.Alignment.center
        view.spacing = 30
        
        return view
    }()
    
    var tagLine: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor("#616161")
        
        return view
    }()
    
    let button_width: CGFloat = 120
    var bottom_button_count: Int = 1
    var showBottom: ShowBottom2?
    
    var scrollView: BaseScrollView?
    
    let featured: UIImageView = UIImageView()
    var featured_h: CGFloat = 0
    let introduceTableView: UITableView = {
        let view = UITableView()
        view.isScrollEnabled = false
        view.backgroundColor = UIColor.clear
        
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = UITableView.automaticDimension

        let oneLineCellNib = UINib(nibName: "OneLineCell", bundle: nil)
        view.register(oneLineCellNib, forCellReuseIdentifier: "OneLineCell")
        
        view.register(ShowSignupCell.self, forCellReuseIdentifier: "ShowSignupCell")
        
        return view
    }()
    
    
    //tempplay data
    let tempPlayDataLbl: SuperLabel = {
        let view: SuperLabel = SuperLabel()
        view.setTextTitle()
        view.text = "目前球隊不開放臨打"
        
        return view
    }()
    let tempPlayTimeLbl: SuperLabel = {
        let view: SuperLabel = SuperLabel()
        view.setTextGeneral()
        view.text = "下次臨打時間"
        
        return view
    }()
    let tempPlayDeadlineLbl: SuperLabel = {
        let view: SuperLabel = SuperLabel()
        view.setTextGeneral()
        view.text = "臨打報名截止時間"
        
        return view
    }()
        
    
    //team member
    let teamMemberDataLbl: SuperLabel = {
        let view: SuperLabel = SuperLabel()
        view.setTextTitle()
        view.text = "總人數：16位"
        
        return view
    }()
    
    var table: Table?
    var myTable: TeamTable?
    
    var isTempPlay: Bool = true
    
    var topTabs: [[String: Any]] = [
        ["key": "intrduce", "icon": "admin", "text": "介紹", "focus": true, "tag": 0, "class": ""],
        ["key": "member", "icon": "team", "text": "隊員", "focus": false, "tag": 1, "class": ""],
        ["key": "tempplay", "icon": "tempPlay", "text": "臨打", "focus": false, "tag": 2, "class": ""]
    ]
    var focusTabIdx: Int = 0
    
    var memberRows: [MemberRow] = [MemberRow]()
    
    var token: String?

    override func viewDidLoad() {
        
        dataService = TeamService.instance
        
        showTop = ShowTop2(delegate: self)
        showTop!.setAnchor(parent: self.view)
        
        initTopTagStackView()
        initTabTop()
        
        showBottom = ShowBottom2(delegate: self)
        self.view.addSubview(showBottom!)
        showBottom!.setAnchor(parent: self.view)
        showBottom!.setSubmitBtnTitle("報名")
        
        initScrollView()
        introduceTableView.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
        
        initIntroduce()
        
        showIntroduce()
        
        //initSignup()
        
        //let cellNib = UINib(nibName: "OneLineCell", bundle: nil)
        //signupTableView.register(cellNib, forCellReuseIdentifier: "cell")
        
        //initSignupTableView()
        
        //bottom_button_count = 2
        
        super.viewDidLoad()
        
        introduceTableView.delegate = self
        introduceTableView.dataSource = self
        
//        mainDataLbl.text = "主要資料"
        //signupDataLbl.text = "臨打報名"
//        contentDataLbl.text = "詳細介紹"
//
//        mainDataLbl.setTextTitle()
        //signupDataLbl.setTextSectionTitle()
//        contentDataLbl.setTextSectionTitle()
//
        //signupButton.setTitle("報名")

        refresh(TeamTable.self)
    }
    
    func initTopTagStackView() {
        
        self.view.addSubview(tagLine)
        tagLine.snp.makeConstraints { make in
            make.top.equalTo(showTop!.snp.bottom).offset(48)
            make.height.equalTo(2)
            make.horizontalEdges.equalToSuperview()
        }
        
        self.view.addSubview(topTagStackView)
        topTagStackView.snp.makeConstraints { make in
            make.top.equalTo(showTop!.snp.bottom)
            make.height.equalTo(50)
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
            //make.horizontalEdges.equalToSuperview()
        }
    }
    
    private func initScrollView() {
        scrollView = BaseScrollView(parent: self.view, delegate: self)
        scrollView!.setAnchor(top: tagLine.snp.bottom, bottom: showBottom!.snp.top)
        scrollView?.setSpacing(10)
    }
    
    private func initIntroduce() {
        
        scrollView?.stackContentView.addArrangedSubview(featured)
        featured.snp.makeConstraints { make in
            //make.top.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(5)
            make.height.equalTo(200)
        }
        //featured.backgroundColor = UIColor.brown
        scrollView?.stackContentView.addArrangedSubview(introduceTableView)
    }
    
    private func removeIntroduce() {
        scrollView?.stackContentView.removeArrangedSubview(featured)
        scrollView?.stackContentView.removeArrangedSubview(introduceTableView)
    }
    
    private func initTempPlay() {
        
        scrollView?.stackContentView.addArrangedSubview(tempPlayDataLbl)
        tempPlayDataLbl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(12)
        }
        
        scrollView?.stackContentView.addArrangedSubview(tempPlayTimeLbl)
        tempPlayTimeLbl.snp.makeConstraints { make in
            //make.top.equalTo(signupDataLbl.snp.bottom).offset(50)
            make.left.equalToSuperview().offset(12)
        }
        //scrollView?.stackContentView.addArrangedSubview(spacerView)
        
        scrollView?.stackContentView.addArrangedSubview(tempPlayDeadlineLbl)
        tempPlayDeadlineLbl.snp.makeConstraints { make in
            //make.top.equalTo(signupTimeLbl.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(12)
        }
        
        scrollView?.stackContentView.addArrangedSubview(introduceTableView)
    }
    
    private func removeTempPlay() {
        scrollView?.stackContentView.removeArrangedSubview(tempPlayDataLbl)
        scrollView?.stackContentView.removeArrangedSubview(tempPlayTimeLbl)
        scrollView?.stackContentView.removeArrangedSubview(tempPlayDeadlineLbl)
        scrollView?.stackContentView.removeArrangedSubview(introduceTableView)
    }
    
    private func initTeamMember() {
        scrollView?.stackContentView.addArrangedSubview(teamMemberDataLbl)
        teamMemberDataLbl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(12)
        }
    }
    
    private func removeTeamMember() {
        scrollView?.stackContentView.removeArrangedSubview(teamMemberDataLbl)
        scrollView?.stackContentView.removeArrangedSubview(introduceTableView)
    }
    
    func refresh<T: Table>(_ t: T.Type) {
        memberRows.removeAll()
        
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
                                self.setIntroduceData()
                                //self.setSignupData()
//                                self.setContentWeb()
//                                self.setLike()
                                self.showTop!.setTitle(title: self.table!.name)
                                self.introduceTableView.reloadData()
                            }
                        }
                    } catch {
                        self.warning(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func initTabTop() {
        
        let count: Int = 3
        let tab_width: Int = 80
        
        let padding: Int = (Int(screen_width) - count * tab_width) / (count+1)
        
        for (idx, topTab) in topTabs.enumerated() {
            let x: Int = idx * tab_width + (idx + 1)*padding
            let rect: CGRect = CGRect(x: x, y: 0, width: 80, height: 50)
            
            let tab = TabTop(frame: rect)
            if let tmp: Int = topTab["tag"] as? Int {
                tab.tag = tmp
            }
            
            var icon: String = "like"
            if let tmp: String = topTab["icon"] as? String {
                icon = tmp
            }
            
            var text: String = "喜歡"
            if let tmp: String = topTab["text"] as? String {
                text = tmp
            }
            
            tab.setData(iconStr: icon, text: text)
            
            var isSelected: Bool = false
            if let tmp: Bool = topTab["focus"] as? Bool {
                isSelected = tmp
            }
            tab.isFocus(isSelected)
            
            let tabTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tabPressed))
            tab.addGestureRecognizer(tabTap)
            
            topTabs[idx]["class"] = tab
            
            topTagStackView.addArrangedSubview(tab)
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
    
    func setIntroduceData() {

        if myTable == nil {
            myTable = TeamTable()
        }
        
        myTable = table as? TeamTable
        var row: MemberRow = MemberRow(title: "球館", icon: "arena", show: myTable!.arena!.name)
        memberRows.append(row)
        if (myTable!.arena != nil) {
            row = MemberRow(title: "縣市", icon: "map", show: myTable!.arena!.city_show)
            memberRows.append(row)
            row = MemberRow(title: "區域", icon: "map", show: myTable!.arena!.area_show)
            memberRows.append(row)
        }
        row = MemberRow(title: "星期", icon: "date", show: myTable!.weekdays_show)
        memberRows.append(row)
        row = MemberRow(title: "時段", icon: "clock", show: myTable!.interval_show)
        memberRows.append(row)
        row = MemberRow(title: "球種", icon: "ball", show: myTable!.ball)
        memberRows.append(row)
        row = MemberRow(title: "程度", icon: "degree", show: myTable!.degree_show)
        memberRows.append(row)
        row = MemberRow(title: "場地", icon: "arena1", show: myTable!.block_show)
        memberRows.append(row)
        row = MemberRow(title: "費用-男", icon: "money", show: myTable!.temp_fee_M_show)
        memberRows.append(row)
        row = MemberRow(title: "費用-女", icon: "money", show: myTable!.temp_fee_F_show)
        memberRows.append(row)
        row = MemberRow(title: "管理者", icon: "admin", show: myTable!.manager_nickname)
        memberRows.append(row)
        row = MemberRow(title: "行動電話", icon: "mobile", show: myTable!.mobile_show)
        memberRows.append(row)
        row = MemberRow(title: "line", icon: "line", show: myTable!.line)
        memberRows.append(row)
        row = MemberRow(title: "FB", icon: "fb", show: myTable!.fb)
        memberRows.append(row)
        row = MemberRow(title: "Youtube", icon: "youtube", show: myTable!.youtube)
        memberRows.append(row)
//        row = MemberRow(title: "網站", icon: "website", show: myTable!.website)
//        memberRows.append(row)
        row = MemberRow(title: "EMail", icon: "email1", show: myTable!.email)
        memberRows.append(row)
        row = MemberRow(title: "瀏覽數", icon: "pv", show: String(myTable!.pv))
        memberRows.append(row)
        row = MemberRow(title: "建立日期", icon: "date", show: myTable!.created_at_show)
        memberRows.append(row)
    }
    
//    func setBottomButtonPadding() {
//
//        if (signupButton.isHidden) {
//            bottom_button_count -= 1
//        }
//
//        let padding: CGFloat = (screen_width - CGFloat(bottom_button_count) * button_width) / CGFloat((bottom_button_count + 1))
//        likeButtonConstraintLeading.constant = CGFloat(bottom_button_count) * padding + CGFloat(bottom_button_count-1)*button_width
//        signupButtonConstraintLeading.constant = padding
//    }
    
    
    
    func setSignupData() {

        isTempPlayOnline()
        if !isTempPlay {
            tempPlayDataLbl.text = "目前球隊不開放臨打"
            //signupButtonContainer.visibility = .invisible
            tempPlayTimeLbl.visibility = .invisible
            tempPlayDeadlineLbl.visibility = .invisible
            //self.signupTableViewConstraintHeight.constant = 20
            //self.changeScrollViewContentSize()
        } else {
            //signupButtonContainer.visibility = .visible
            //tempPlayDataLbl.visibility = .invisible
            tempPlayDataLbl.text = ""
            //tempPlayTimeLbl.visibility = .visible
            if myTable != nil && myTable!.signupDate != nil {
                tempPlayTimeLbl.text = "下次臨打時間：" + myTable!.signupDate!.date + " " + myTable!.interval_show
                tempPlayDeadlineLbl.text = "報名截止時間：" + myTable!.signupDate!.deadline.noSec()
            }
        }

//        if (myTable!.people_limit == 0) {
//            signupButton.visibility = .invisible
//            setBottomButtonPadding()
//        }
//
//        if myTable!.isSignup {
//            signupButton.setTitle("取消報名")
//        } else {
//            let count = myTable!.signupNormalTables.count
//            if count >= myTable!.people_limit {
//                self.signupButton.setTitle("候補")
//            } else {
//                self.signupButton.setTitle("報名")
//            }
//        }
//
//        signupTableView.reloadData()
    }

    func isTempPlayOnline() {

        //1.如果臨打狀態是關閉，關閉臨打
        if myTable!.temp_status == "offline" {
            isTempPlay = false
        }

        //2.如果沒有設定臨打日期，關閉臨打
        if myTable!.signupDate != nil {
            let temp_date_string: String = myTable!.signupDate!.date

            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let now_string: String = formatter.string(from: Date())

            //3.如果臨打日期超過現在的日期，關閉臨打
            if let temp_date: Date = temp_date_string.toDateTime(format: "yyyy-MM-dd", locale: false) {

                var now: Date = Date()
                if let tmp: Date = now_string.toDateTime(format: "yyyy-MM-dd", locale: false) {
                    now = tmp
                }

                //(1)如果報名日期剛好也是臨打日期則可以報名
                if (temp_date.isEqualTo(now)) {
                    isTempPlay = true
                } else {
                    //(2)如果報名日期已經過了臨打日期則無法報名
                    if (temp_date.isSmallerThan(now)) {
                        isTempPlay = false
                    //(3)如果報名日期還沒過了臨打日期則無法報名
                    } else {
                        isTempPlay = true
                    }
                }
            }
        } else {
            isTempPlay = false
        }

        //3.如果管理者設定報名臨打名額是0，關閉臨打
        if myTable!.people_limit == 0 {
            isTempPlay = false
        }
    }
    
    override func viewWillLayoutSubviews() {
        let a = introduceTableView.contentSize.height
        introduceTableView.heightConstraint?.constant = a
        
//        let b = signupTableView.contentSize.height
//        signupTableView.heightConstraint?.constant = b
//
//        let c = coachTableView.contentSize.height
//        coachTableView.heightConstraint?.constant = c
        
        //let d = contentWebView.content
        
        //contentView.heightConstraint?.constant = 500 + a
    }
    
    func getTeamMemberList() {
        Global.instance.addSpinner(superView: self.view)
        
        TeamService.instance.teamMemberList(token: token!, page: page, perPage: PERPAGE) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if (success) {
                //TeamService.instance.jsonData?.prettyPrintedJSONString
                let b: Bool = self.parseJSON(jsonData: TeamService.instance.jsonData)
                if !b && self.tableView.msg.count == 0 {
                    self.view.setInfo(info: "目前尚無資料！！", topAnchor: self.showTop!)
                } else {
                    self.rows = self.tableView.items
                }
                //self.showTableView(tableView: self.tableView, jsonData: TeamService.instance.jsonData!)
            }
        }
    }
    
    func parseJSON(jsonData: Data?)-> Bool {
        
        let _rows: [U] = genericTable2(jsonData: jsonData)
        if (_rows.count == 0) {
            return false
        } else {
            if (page == 1) {
                items = [U]()
            }
            items += _rows
            reloadData()
        }
        
        return true
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
        + "電話：" + memberTable.mobile_show + "\n"
        + "EMail：" + memberTable.email
        
        // Add textfield 1
        let textfield1 = UITextView(frame: CGRect(x:0, y:0, width:subview.frame.width, height:subview.frame.height))
        //textfield1.backgroundColor = UIColor.yellow
        textfield1.text = a
        textfield1.font = UIFont(name: textfield1.font!.fontName, size: 18)
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
    
//    override func changeScrollViewContentSize() {
//
//        //let h1 = featuredConstraintHeight.constant
//        //let h2 = mainDataLbl.bounds.size.height
//        let h3 = tableViewConstraintHeight.constant
////        let h6 = contentDataLbl.bounds.size.height
////        let h7 = contentViewConstraintHeight!.constant
////        let h8 = signupDataLbl.bounds.size.height
//        let h9 = signupTableViewConstraintHeight.constant
////        let h10 = signupTimeLbl.bounds.size.height
////        let h11 = signupDeadlineLbl.bounds.size.height
//        //print(contentViewConstraintHeight)
//
//        dataConstraintHeight.constant = h3 + h9
//        //print("data height:\(dataConstraintHeight.constant)")
//        //let h: CGFloat = h1 + h2 + h3 + h4 + h5
//        let h: CGFloat = featuredConstraintHeight.constant + dataConstraintHeight.constant + 300
//        //print("scroll height:\(h)")
//
//        //scrollContainerView.heightConstraint?.constant = h
//        //scrollView.frame.height = h
//        //scrollView.contentSize = CGSize(width: view.frame.width, height: h)
//        //ContainerViewConstraintHeight.constant = h
//        //print(h1)
//    }
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        
        if !Member.instance.isLoggedIn {
            warning("請先登入會員")
            return
        }
        
        if !Member.instance.checkEMailValidate() {
            warning("請先通過email認證")
            return
        }
        
        if !Member.instance.checkMobileValidate() {
            warning("請先通過行動電話認證")
            return
        }
        
        if myTable != nil && myTable!.signupDate != nil {
            
            //print(myTable!.signupDate!.deadline)
            if let deadline_time: Date = myTable!.signupDate!.deadline.toDateTime(format: "yyyy-MM-dd HH:mm:ss", locale: false) {
                let now: Date = Date().myNow()
                if now > deadline_time {
                    
                    var msg: String = "已經超過報名截止時間，請下次再報名"
                    if myTable!.isSignup {
                        msg = "已經超過取消報名截止時間，無法取消報名"
                    }
                    warning(msg)
                    return
                }
            }
            
            Global.instance.addSpinner(superView: view)
            dataService.signup(token: myTable!.token, member_token: Member.instance.token, date_token: myTable!.signupDate!.token) { (success) in

                Global.instance.removeSpinner(superView: self.view)

                do {
                    if (self.dataService.jsonData != nil) {
                        let successTable: SuccessTable = try JSONDecoder().decode(SuccessTable.self, from: self.dataService.jsonData!)
                        if (successTable.success) {
                            self.info(msg: successTable.msg, buttonTitle: "關閉") {
                                self.refresh(TeamTable.self)
                            }
                        } else {
                            self.warning(successTable.msg)
                        }
                    }
                } catch {
                    self.msg = "解析JSON字串時，得到空值，請洽管理員"
                }
            }
        }
    }
    
    @objc func tabPressed(sender: UITapGestureRecognizer) {
                
        if let idx: Int = sender.view?.tag {
            
            let selectedTag: [String: Any] = topTabs[idx]
            if let focus: Bool = selectedTag["focus"] as? Bool {

                //按了其他頁面的按鈕
                if (!focus) {
                    updateTabSelected(idx: idx)
                    focusTabIdx = idx
                    switch focusTabIdx {
                    case 0:
                        removeTeamMember()
                        hideTeamMember()
                        removeTempPlay()
                        hideTempPlay()
                        
                        initIntroduce()
                        showIntroduce()
                        introduceTableView.reloadData()
                        
                    case 1:
                        hideIntroduce()
                        removeIntroduce()
                        hideTempPlay()
                        removeIntroduce()
                        
                        initTeamMember()
                        showTeamMember()
                        introduceTableView.reloadData()
                        
                    case 2:
                        hideIntroduce()
                        removeIntroduce()
                        hideTempPlay()
                        removeTempPlay()
                        
                        initTempPlay()
                        showTempPlay()
                        setSignupData()
                        introduceTableView.reloadData()
                        
                    default:
                        refresh()
                    }
                }
            }
        }
    }
    
    private func showIntroduce() {
        featured.visibility = .visible
        introduceTableView.visibility = .visible
    }
    private func hideIntroduce() {
        featured.visibility = .invisible
        introduceTableView.visibility = .invisible
    }
    
    private func showTeamMember() {
        teamMemberDataLbl.visibility = .visible
        introduceTableView.visibility = .visible
    }
    private func hideTeamMember() {
        teamMemberDataLbl.visibility = .invisible
        introduceTableView.visibility = .invisible
    }
    
    private func showTempPlay() {
        tempPlayDataLbl.visibility = .visible
        tempPlayTimeLbl.visibility = .visible
        tempPlayDeadlineLbl.visibility = .visible
        introduceTableView.visibility = .visible
    }
    private func hideTempPlay() {
        tempPlayDataLbl.visibility = .invisible
        tempPlayTimeLbl.visibility = .invisible
        tempPlayDeadlineLbl.visibility = .invisible
        introduceTableView.visibility = .invisible
    }
    
    private func updateTabSelected(idx: Int) {
        
        // set user click which tag, set tag selected is true
        for (i, var topTab) in topTabs.enumerated() {
            
            if (i == idx) {
                topTab["focus"] = true
            } else {
                topTab["focus"] = false
            }
            topTabs[i] = topTab
        }
        setTabSelectedStyle()
    }
    
    private func setTabSelectedStyle() {
        
        for topTab in topTabs {
            
            if (topTab.keyExist(key: "class")) {
                
                let tab: TabTop = (topTab["class"] as? TabTop)!
                
                var isFocus: Bool = false
                if let tmp: Bool = topTab["focus"] as? Bool {
                    isFocus = tmp
                }
                
                tab.isFocus(isFocus)
            }
        }
    }
}

extension ShowTeamVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (focusTabIdx == 0) {
            return memberRows.count
            //return tableRowKeys.count
        } else if (focusTabIdx == 2) {
            
            if myTable != nil && isTempPlay {

                let people_limit: Int = myTable!.people_limit
                //let normal_count: Int = myTable!.signupNormalTables.count
                let standby_count: Int = myTable!.signupStandbyTables.count
                let count = people_limit + standby_count + 1
                //print(count)
                return count
            } else {
                return 0
            }
        }
        
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if focusTabIdx == 0 {
            
            let cell: OneLineCell = tableView.dequeueReusableCell(withIdentifier: "OneLineCell", for: indexPath) as! OneLineCell
            
            //let cell: ShowSignupCell = tableView.dequeueReusableCell(withIdentifier: "ShowSignupCell", for: indexPath) as! ShowSignupCell

            let row: MemberRow = memberRows[indexPath.row]
            cell.update(icon: row.icon, title: row.title, content: row.show)

//            print("memberRow: \(memberRows.count)")
//            print("index path: \(indexPath.row)")

            //計算高度
//            if indexPath.row == memberRows.count - 1 {
//                UIView.animate(withDuration: 0, animations: {self.tableView.layoutIfNeeded()}) { (complete) in
//                    var heightOfTableView: CGFloat = 0.0
//                    let cells = self.tableView.visibleCells
//                    for cell in cells {
//                        heightOfTableView += cell.frame.height
//                    }
//
//                    self.tableViewConstraintHeight.constant = heightOfTableView
//                    self.dataConstraintHeight.constant += heightOfTableView
//
//                    //self.scrollContainerHeight += self.dataConstraintHeight.constant
//                    //self.containerViewConstraintHeight.constant = self.scrollContainerHeight
//                    //print("tableView:\(self.scrollContainerHeight)")
//                    //self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollContainerHeight)
//                }
//            }

            return cell
        }
        else if focusTabIdx == 2 {
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

//            if indexPath.row == people_limit + standby_count - 1 {
//
//                UIView.animate(withDuration: 0, animations: {self.signupTableView.layoutIfNeeded()}) { (complete) in
//                    var heightOfTableView: CGFloat = 0.0
//                    let cells = self.introduceTableView.visibleCells
//                    //print(cells.count)
//                    for cell in cells {
//                        heightOfTableView += cell.frame.height
//                    }
//
//                    self.signupTableViewConstraintHeight.constant = heightOfTableView
//                    self.dataConstraintHeight.constant += heightOfTableView
//
//                    //self.scrollContainerHeight += self.dataConstraintHeight.constant
//                    //self.containerViewConstraintHeight.constant = self.scrollContainerHeight
//
//                    //print("signup:\(self.scrollContainerHeight)")
//                    //self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollContainerHeight)
//                    //self.changeScrollViewContentSize()
//                }
//            }

            return cell
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//        if tableView == signupTableView {
//            if myTable != nil {
//                if myTable!.manager_token == Member.instance.token {
//                    let people_limit = myTable!.people_limit
//                    if (indexPath.row < people_limit) {
//                        let signup_normal_model = myTable!.signupNormalTables[indexPath.row]
//                        //print(signup_normal_model.member_token)
//                        getMemberOne(member_token: signup_normal_model.member_token)
//
//                    } else {
//                        let signup_standby_model = myTable!.signupStandbyTables[indexPath.row]
//                        getMemberOne(member_token: signup_standby_model.member_token)
//                    }
//                } else {
//                    warning("只有球隊管理員可以檢視報名者資訊")
//                }
//            }
//        }
    }
}
