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

class ShowTeamVC: BaseViewController, WKNavigationDelegate {
    
    var showTop: ShowTop2?
    
    // tab
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
    
    var spacer: UIView = UIView()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        
        return view
    }()
    
    var introduceStackView: UIStackView = {
        let view = UIStackView()
        //view.backgroundColor = UIColor.red
        //view.layer.cornerRadius = 26.0
        //view.clipsToBounds = true
        view.axis = .vertical
        view.spacing = 0
        return view
    }()
    
    let featured: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor(MY_GRAY)
        
        return view
    }()
    //var featured_h: CGFloat = 0
    let introduceTableView: UITableView = {
        let view = UITableView()
        view.isScrollEnabled = false
        view.backgroundColor = UIColor.clear
        
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = UITableView.automaticDimension

        let oneLineCellNib = UINib(nibName: "OneLineCell", bundle: nil)
        view.register(oneLineCellNib, forCellReuseIdentifier: "OneLineCell")
        
        view.register(ShowTeamMemberCell.self, forCellReuseIdentifier: "ShowTeamMemberCell")
        
        view.register(ShowSignupCell.self, forCellReuseIdentifier: "ShowSignupCell")
        
        return view
    }()
    
    var contentLbl: SuperLabel = {
        let view = SuperLabel()
        view.setTextSectionTitle()
        view.text = "更多介紹"
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
    
    //team member
    var teamMemberStackView: UIStackView = {
        let view = UIStackView()
        //view.backgroundColor = UIColor.red
        //view.layer.cornerRadius = 26.0
        //view.clipsToBounds = true
        view.axis = .vertical
        view.spacing = 12
        return view
    }()
    
    let teamMemberDataLbl: SuperLabel = {
        let view: SuperLabel = SuperLabel()
        view.setTextTitle()
        view.text = "總人數：16位"
        view.visibility = .invisible
        
        return view
    }()
    
    let nextDateLbl: SuperLabel = {
        let view: SuperLabel = SuperLabel()
        view.setTextGeneral()
        view.text = "下次打球時間"
        view.visibility = .invisible
        
        return view
    }()
    
    var tempPlayStackView: UIStackView = {
        let view = UIStackView()
        //view.backgroundColor = UIColor.red
        //view.layer.cornerRadius = 26.0
        //view.clipsToBounds = true
        view.axis = .vertical
        view.spacing = 12
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
    
    var isTeamMemberLoaded: Bool = false
    
    var table: Table?
    var myTable: TeamTable?
    
    var isTempPlay: Bool = true
    var isLike: Bool = false
    
    var topTabs: [[String: Any]] = [
        ["key": "intrduce", "icon": "admin", "text": "介紹", "focus": true, "tag": 0, "class": ""],
        ["key": "member", "icon": "team", "text": "隊員", "focus": false, "tag": 1, "class": ""],
        ["key": "tempplay", "icon": "tempPlay", "text": "臨打", "focus": false, "tag": 2, "class": ""]
    ]
    var focusTabIdx: Int = 0
    
    //team member
    var items: [TeamMemberTable] = [TeamMemberTable]()
    var teamMemberPage: Int = 1
    var teamMemberPerPage: Int = PERPAGE
    var teamMemberTotalCount: Int = 0
    var teamMemberTotalPage: Int = 0
    var teamMemberToken: String? = nil
    
    var nextDate: String = ""
    var nextDateWeek: String = ""
    var play_start: String = ""
    var play_end: String = ""
    
    //會員是否為球隊隊友
    var isTeamMember: Bool = false
    //會員為隊友，會員是否已經請假
    var isTeapMemberLeave: Bool = false
    
    //temp play
    var memberRows: [MemberRow] = [MemberRow]()
    
    var token: String?

    override func viewDidLoad() {
        
        dataService = TeamService.instance
        
        //initSignup()
        
        //let cellNib = UINib(nibName: "OneLineCell", bundle: nil)
        //signupTableView.register(cellNib, forCellReuseIdentifier: "cell")
        
        //initSignupTableView()
        
        //bottom_button_count = 2
        
        super.viewDidLoad()
        
        showTop = ShowTop2(delegate: self)
        showTop!.setAnchor(parent: self.view)
        
        initTopTagStackView()
        initTabTop()
        
        showBottom = ShowBottom2(delegate: self)
        self.view.addSubview(showBottom!)
        //showBottom!.justShowLike(parent: self.view)
        showBottom!.showButton(parent: self.view, isShowSubmit: false, isShowCancel: false)

        initScrollView()
        
        introduceTableView.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
        introduceTableView.delegate = self
        introduceTableView.dataSource = self
        
        //initIntroduce()
        //initTeamMember()

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
        
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(tagLine.snp.bottom)
            make.right.left.equalToSuperview()
            make.bottom.equalTo(showBottom!.snp.top)
        }
    }
    
    private func initIntroduce() {
        
        scrollView.addSubview(introduceStackView)
        introduceStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        introduceStackView.addArrangedSubview(featured)
        featured.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.height.equalTo(200)
        }
        //featured.backgroundColor = UIColor.brown
        introduceStackView.addArrangedSubview(introduceTableView)
        
        introduceStackView.addArrangedSubview(spacer)
        spacer.snp.makeConstraints { make in
            make.height.equalTo(130)
        }
        introduceStackView.addArrangedSubview(contentLbl)
        introduceStackView.addArrangedSubview(spacer)
        spacer.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        
        introduceStackView.addArrangedSubview(contentWebView)

        contentWebView.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
    }
    
    private func initTeamMember() {
        scrollView.addSubview(teamMemberStackView)
        teamMemberStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        teamMemberStackView.addArrangedSubview(teamMemberDataLbl)
        teamMemberDataLbl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(12)
        }
        
        teamMemberStackView.addArrangedSubview(nextDateLbl)
        nextDateLbl.snp.makeConstraints { make in
            make.top.equalTo(teamMemberDataLbl.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(12)
        }
        
        teamMemberStackView.addArrangedSubview(introduceTableView)
    }

    private func initTempPlay() {
        
        scrollView.addSubview(tempPlayStackView)
        tempPlayStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        tempPlayStackView.addArrangedSubview(tempPlayDataLbl)
        tempPlayDataLbl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(12)
        }

        tempPlayStackView.addArrangedSubview(tempPlayTimeLbl)
        tempPlayTimeLbl.snp.makeConstraints { make in
            //make.top.equalTo(signupDataLbl.snp.bottom).offset(50)
            make.left.equalToSuperview().offset(12)
        }

        tempPlayStackView.addArrangedSubview(tempPlayDeadlineLbl)
        tempPlayDeadlineLbl.snp.makeConstraints { make in
            //make.top.equalTo(signupTimeLbl.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(12)
        }

        tempPlayStackView.addArrangedSubview(introduceTableView)
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
                                self.initIntroduce()
                                self.table!.filterRow()
                                self.setFeatured()
                                self.setIntroduceData()
                                self.setContentWeb()
                                self.setLike()
                                self.showTop!.setTitle(title: self.table!.name)
                                self.introduceTableView.reloadData()
                                
                                self._tabPressed(self.focusTabIdx)
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
    
    override func like() {
        if (!Member.instance.isLoggedIn) {
            toLogin()
        } else {
            if (table != nil) {
                isLike = !isLike
                showBottom?.setLike(isLike)
                dataService.like(token: table!.token, able_id: table!.id)
            } else {
                warning("沒有取得內容資料值，請稍後再試或洽管理員")
            }
        }
    }
    
    func setFeatured() {

        if (table != nil && table!.featured_path.count > 0) {
            
            featured.downloaded(from: table!.featured_path)
            
            //featured_h = featured.heightForUrl(url: table!.featured_path, width: screen_width)
        } else {
            warning("沒有取得內容資料值，請稍後再試或洽管理員")
        }
    }
    
    func getMemberOne(member_token: String) {
        
        Global.instance.addSpinner(superView: self.view)
        
        MemberService.instance.getOne(params: ["token": member_token]) { success in
            
            Global.instance.removeSpinner(superView: self.view)
            
            if success {
                
                let jsonData: Data = MemberService.instance.jsonData!
                do {
                    let successTable: SuccessTable = try JSONDecoder().decode(SuccessTable.self, from: jsonData)
                    if successTable.success {
                        let memberTable: MemberTable = try JSONDecoder().decode(MemberTable.self, from: jsonData)
                        memberTable.filterRow()
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
    
    func setContentWeb() {
        let content: String = "<html><HEAD><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no\">"+self.body_css+"</HEAD><body>"+table!.content+"</body></html>"
        
        contentWebView.loadHTMLString(content, baseURL: nil)
    }
    
    func setLike() {
        if (table != nil) {
            isLike = table!.like
            showBottom?.initLike(isLike: table!.like, count: table!.like_count)
        }
    }
    
    override func viewWillLayoutSubviews() {
        let a = introduceTableView.contentSize.height
        introduceTableView.heightConstraint?.constant = a
    }

    override func submit() {
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
        
        //請假
        if (focusTabIdx == 1) {
            
            //如果要請假
            if !isTeapMemberLeave {
                warning(msg: "是否確定要請假？", closeButtonTitle: "關閉", buttonTitle: "是") {
                    if self.teamMemberToken != nil {
                        self.teamMemberLeave(doLeave: true)
                    }
                }
            }
            // 如果要取消請假
            else {
                warning(msg: "是否確定要取消請假？", closeButtonTitle: "關閉", buttonTitle: "取消請假") {
                    if self.teamMemberToken != nil {
                        self.teamMemberLeave(doLeave: false)
                    }
                }
            }
        }
        else if (focusTabIdx == 2) {
            
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
    }

    @objc func tabPressed(sender: UITapGestureRecognizer) {
                
        if let idx: Int = sender.view?.tag {
            //self._tabPressed(idx)
            let selectedTag: [String: Any] = topTabs[idx]
            if let focus: Bool = selectedTag["focus"] as? Bool {
                //按了其他頁面的按鈕
                if (!focus) {
                    updateTabSelected(idx: idx)
                    focusTabIdx = idx
                    _tabPressed(idx)
                }
            }
        }
    }
    
    private func _tabPressed(_ idx: Int) {
        switch idx {
        case 0:
            removeTeamMember()
            removeTempPlay()
            
            initIntroduce()
            setIntroduceData()
            introduceTableView.reloadData()
            showBottom!.showButton(parent: self.view, isShowSubmit: false, isShowCancel: false)
            
        case 1:
            removeIntroduce()
            removeTempPlay()
            
            initTeamMember()
            memberRows.removeAll()
            
            if (!isTeamMemberLoaded) {
                teamMemberPage = 1
                getTeamMemberList(page: teamMemberPage, perPage: teamMemberPerPage)
                isTeamMemberLoaded = true
            } else {
                introduceTableView.reloadData()
            }
            
            setTeamMemberBottom()
            
        case 2:
            removeIntroduce()
            removeTeamMember()
            
            initTempPlay()
            memberRows.removeAll()
            setSignupData()
            introduceTableView.reloadData()
            //showBottom!.showButton(parent: self.view, isShowSubmit: true, isShowLike: true, isShowCancel: false)
            
        default:
            refresh()
        }
    }
    
    private func removeIntroduce() {
        introduceStackView.removeFromSuperview()
    }
    
    private func removeTempPlay() {
        tempPlayStackView.removeFromSuperview()
    }
    
    private func removeTeamMember() {
        teamMemberStackView.removeFromSuperview()
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

/////////////////  team member leave start /////////////////////////////
extension ShowTeamVC {
    func getTeamMemberList(page: Int = 1, perPage: Int = 20) {
        Global.instance.addSpinner(superView: self.view)
        
//        TeamService.instance.teamMemberList(of: TeamMemberTables2<TeamMemberTable>.self, token: token!, page: page, perPage: perPage) { (success) in
//            let n = 6
//        }
        
        TeamService.instance.teamMemberList(token: token!, page: page, perPage: perPage) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if (success) {
                self.parseJSON(jsonData: TeamService.instance.jsonData)
            } else {
                self.warning("取得資料錯誤，請洽管理員！！")
            }
        }
    }
    
    func parseJSON(jsonData: Data?) {
        
        let _rows: [TeamMemberTable] = self.jsonToTable2(jsonData: jsonData)
        if (_rows.count == 0) {
            self.teamMemberDataLbl.visibility = .invisible
            self.nextDateLbl.visibility = .invisible
            let v = self.view.setInfo(info: "目前尚無資料！！", topAnchor: self.showTop!)
        } else {
            if (teamMemberPage == 1) {
                items = [TeamMemberTable]()
            }
            items += _rows
            self.teamMemberDataLbl.visibility = .visible
            self.nextDateLbl.visibility = .visible
            
            self.teamMemberDataLbl.text = "總人數：\(teamMemberTotalCount)位"
            
            self.nextDateLbl.text = "下次打球時間：\(nextDate)" + " ( " + nextDateWeek + " )" + "  " + "\(play_start) ~ \(play_end)"
            introduceTableView.reloadData()
            
            for item in items {
                if item.memberTable != nil {
                    if item.memberTable!.token == Member.instance.token {
                        self.teamMemberToken = item.token
                        self.isTeamMember = true
                        self.isTeapMemberLeave = item.isLeave
                        break
                    }
                }
            }
            
            setTeamMemberBottom()
        }
    }
    
    func jsonToTable2(jsonData: Data?)-> [TeamMemberTable] {
            
        var rows: [TeamMemberTable] = [TeamMemberTable]()
        do {
            if (jsonData != nil) {
                //print(jsonData!.prettyPrintedJSONString)
                let tables2: TeamMemberTables2 = try JSONDecoder().decode(TeamMemberTables2<TeamMemberTable>.self, from: jsonData!)
                if (tables2.success) {
                    
                    tables2.filterRow()
                    if tables2.rows.count > 0 {
                        
                        for row in tables2.rows {
                            row.filterRow()
                        }
                        
                        if (teamMemberPage == 1) {
                            teamMemberPage = tables2.page
                            teamMemberPerPage = tables2.perPage
                            teamMemberTotalCount = tables2.totalCount
                            let _totalPage: Int = teamMemberTotalCount / teamMemberPerPage
                            teamMemberTotalPage = (teamMemberTotalCount % teamMemberPerPage > 0) ? _totalPage + 1 : _totalPage
                            
                            nextDate = tables2.nextDate
                            nextDateWeek = tables2.nextDateWeek
                            play_start = tables2.play_start_show
                            play_end = tables2.play_end_show
                        }
                        
                        rows += tables2.rows
                    }
                } else {
                    msg = "解析JSON字串時，沒有成功，系統傳回值錯誤，請洽管理員"
                }
            } else {
                msg = "無法從伺服器取得正確的json資料，請洽管理員"
            }
        } catch {
            msg = "解析JSON字串時，得到空值，請洽管理員"
        }
        
        return rows
    }
    
    func setTeamMemberBottom() {
        if self.isTeamMember && !self.isTeapMemberLeave {
            showBottom!.showButton(parent: self.view, isShowSubmit: true, isShowLike: true, isShowCancel: false)
            showBottom!.submitBtn.setTitle("請假")
        } else if self.isTeamMember && self.isTeamMember {
            showBottom!.showButton(parent: self.view, isShowSubmit: true, isShowLike: true, isShowCancel: false)
            showBottom!.submitBtn.setTitle("取消")
        } else {
            showBottom!.showButton(parent: self.view, isShowSubmit: false, isShowLike: true, isShowCancel: false)
        }
    }
    
    func teamMemberLeave(doLeave: Bool) {
        
        let doLeaveWarning: String = (doLeave) ? "已經請假了" : "已經取消請假了"
        Global.instance.addSpinner(superView: self.view)
        //team member token
        //play date
        TeamService.instance.leave(team_member_token: self.teamMemberToken!, play_date: self.nextDate) { success in
            Global.instance.removeSpinner(superView: self.view)
            
            do {
                if (self.dataService.jsonData != nil) {
                    let successTable: SuccessTable = try JSONDecoder().decode(SuccessTable.self, from: self.dataService.jsonData!)
                    if (successTable.success) {
                        self.info(msg: doLeaveWarning, buttonTitle: "關閉") {
                            self.getTeamMemberList(page: 1, perPage: PERPAGE)
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
        textfield1.font = .systemFont(ofSize: 18)
        //textfield1.font = UIFont(name: textfield1.font!.fontName, size: 18)
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
}

///////////////////// temp play /////////////////////////////
extension ShowTeamVC {

    func setSignupData() {

        isTempPlayOnline()
        if !isTempPlay {
            tempPlayDataLbl.text = "目前球隊不開放臨打"
            //signupButtonContainer.visibility = .invisible
            tempPlayTimeLbl.visibility = .invisible
            tempPlayDeadlineLbl.visibility = .invisible
            showBottom!.showButton(parent: self.view, isShowSubmit: false, isShowCancel: false)
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

        if (myTable!.people_limit == 0) {
            showBottom!.showButton(parent: self.view, isShowSubmit: false, isShowCancel: false)
        }

        if myTable!.isSignup {
            showBottom?.setSubmitBtnTitle("取消報名")
        } else {
            let count = myTable!.signupNormalTables.count
            if count >= myTable!.people_limit {
                showBottom?.setSubmitBtnTitle("候補")
            } else {
                showBottom?.setSubmitBtnTitle("報名")
            }
        }
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
}

extension ShowTeamVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (focusTabIdx == 0) {
            return memberRows.count
            //return tableRowKeys.count
        } else if (focusTabIdx == 1) {
            return items.count
            
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
            cell.setSelectedBackgroundColor()

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
        else if focusTabIdx == 1 && items.count > 0 {
            let cell: ShowTeamMemberCell = tableView.dequeueReusableCell(withIdentifier: "ShowTeamMemberCell", for: indexPath) as! ShowTeamMemberCell
            
            cell.delegate = self
            
            let row: TeamMemberTable = items[indexPath.row]
            cell.noLbl.text = "\(indexPath.row + 1)."
            
            var nickname: String = ""
            if (row.memberTable != nil) {
                nickname = row.memberTable!.nickname
            }
            cell.nameLbl.text = nickname
            
            cell.leaveLbl.visibility = (row.isLeave) ? .visible : .invisible
            if cell.leaveLbl.visibility == .visible {
                cell.leaveLbl.text = "請假(\(row.leaveTime.noSec()))"
            }
            
            cell.setSelectedBackgroundColor()
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

            cell.setSelectedBackgroundColor()
            return cell
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if focusTabIdx == 1 {
            if myTable != nil {
                if myTable!.manager_token == Member.instance.token {
                    let row: TeamMemberTable = items[indexPath.row]
                    
                    if (row.memberTable != nil) {
                        getMemberOne(member_token: row.memberTable!.token)
                    }
                } else {
                    warning("只有球隊管理員可以檢視報名者資訊")
                }
            }
        }
        else if focusTabIdx == 2 {
            if myTable != nil {
                if myTable!.manager_token == Member.instance.token {
                    
                    let signupNormalCount: Int = myTable!.signupNormalTables.count
                    let peopleLimit: Int = myTable!.people_limit
                    let idx: Int = indexPath.row
                    
                    if (idx < signupNormalCount) {
                        let signup_normal_model = myTable!.signupNormalTables[idx]
                        getMemberOne(member_token: signup_normal_model.member_token)
                    }
                    
                    if (idx >= peopleLimit) {
                        let signup_standby_model = myTable!.signupStandbyTables[idx]
                        getMemberOne(member_token: signup_standby_model.member_token)
                    }
                } else {
                    warning("只有球隊管理員可以檢視報名者資訊")
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if focusTabIdx == 1 {
//            print("page:\(teamMemberPage)")
//            print("perPage:\(teamMemberPerPage)")
//            print("index.row:\(indexPath.row)")
            if indexPath.row == teamMemberPage * teamMemberPerPage - 2 {
                teamMemberPage += 1
                //print("current page: \(page)")
                //print(totalPage)
                if teamMemberPage <= teamMemberTotalPage {
                    getTeamMemberList(page: teamMemberPage, perPage: teamMemberPerPage)
                }
            }
        }
    }
}

extension ShowTeamVC: ShowTeamMemberCellDelegate {
    
    func leavePressed(cell: ShowTeamMemberCell) {
        
        guard let idx: Int = introduceTableView.indexPath(for: cell)?.row else { return }
        
        let row: TeamMemberTable = items[idx]
        
        TeamService.instance.leave(team_member_token: row.token, play_date: self.nextDate) { success in
            
            Global.instance.removeSpinner(superView: self.view)
            
            if success {
                
                let jsonData: Data = TeamService.instance.jsonData!
                //jsonData.prettyPrintedJSONString
                do {
                    let successTable: SuccessTable2<TeamMemberLeaveTable> = try JSONDecoder().decode(SuccessTable2.self, from: jsonData)
                    if successTable.success {
                        let teamMemberLeaveTable: TeamMemberLeaveTable = try JSONDecoder().decode(TeamMemberLeaveTable.self, from: jsonData)
                        self.info(msg: "請假成功", buttonTitle: "關閉") {
                            self.refresh()
                        }
                        
                    } else {
                        self.warning(successTable.parseMsgs())
                    }
                } catch {
                    self.warning(error.localizedDescription)
                }
            }
        }
    }
}

class TeamMemberTables2<T: Codable>: Codable {
    var success: Bool = false
    var page: Int = -1
    var totalCount: Int = -1
    var perPage: Int = -1
    var nextDate: String = ""
    var nextDateWeek: String = ""
    var play_start: String = ""
    var play_end: String = ""
    var rows: [T] = [T]()
    
    var play_start_show: String = ""
    var play_end_show: String = ""
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decode(Bool.self, forKey: .success)
        page = try container.decode(Int.self, forKey: .page)
        totalCount = try container.decode(Int.self, forKey: .totalCount)
        perPage = try container.decode(Int.self, forKey: .perPage)
        nextDate = try container.decode(String.self, forKey: .nextDate)
        nextDateWeek = try container.decode(String.self, forKey: .nextDateWeek)
        play_start = try container.decode(String.self, forKey: .play_start)
        play_end = try container.decode(String.self, forKey: .play_end)
        rows = try container.decode([T].self, forKey: .rows)
    }
    
    func filterRow() {
        
        if play_start.count > 0 {
            play_start_show = play_start.noSec()
        }
        
        if play_end.count > 0 {
            play_end_show = play_end.noSec()
        }
    }
}
