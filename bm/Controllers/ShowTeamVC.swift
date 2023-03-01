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
    
    var showTop2: ShowTop2?
    
    var showTab2: ShowTab2 = {
        let view: ShowTab2 = ShowTab2()
        
        return view
    }()
    
    let button_width: CGFloat = 120
    var bottom_button_count: Int = 1
    var showBottom: ShowBottom2?
    
    //var spacer: UIView = UIView()
    
    var scrollView: UIScrollView = UIScrollView()
    var introduceContentView: UIView = UIView()
    var teamMemberContentView: UIView = UIView()
    
//    var introduceStackView: UIStackView = {
//        let view = UIStackView()
//        view.axis = .vertical
//        view.spacing = 0
//        return view
//    }()
    
    let featured: Featured = {
        let view = Featured()
        
        return view
    }()
    //var featured_h: CGFloat = 0
    let introduceTableView: UITableView = {
        let view = UITableView()
        view.isScrollEnabled = false
        view.backgroundColor = UIColor.clear
//        view.separatorStyle = .singleLine
//        view.separatorColor = UIColor.gray
        
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
    let teamMemberStackView: UIStackView = {
        let view = UIStackView()
        //view.backgroundColor = UIColor.red
        //view.layer.cornerRadius = 26.0
        //view.clipsToBounds = true
        view.axis = .vertical
        view.spacing = 12
        return view
    }()
    
    let teamMemberAllContainer: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let teamMemberLeftContainer: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let teamMemberDataLbl: SuperLabel = {
        let view: SuperLabel = SuperLabel()
        view.setTextTitle()
        view.text = "打球人數統計："
        view.visibility = .invisible
        
        return view
    }()
    
    let teamMemberSummaryContainer: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let teamMemberTotalLbl: TapLabel2 = {
        let view: TapLabel2 = TapLabel2()
        view.tag = 0
        view.text = "16位"
        view.visibility = .invisible
        
        return view
    }()
    
    let teamMemberPlayLbl: TapLabel2 = {
        let view: TapLabel2 = TapLabel2()
        view.tag = 1
        view.text = "16位"
        view.visibility = .invisible
        
        return view
    }()
    
    let teamMemberLeaveLbl: TapLabel2 = {
        let view: TapLabel2 = TapLabel2()
        view.tag = 2
        view.text = "16位"
        
        view.visibility = .invisible
        
        return view
    }()
    
    let showLike2: ShowLike2 = {
        let view = ShowLike2()
        return view
    }()
    
    let nextDateContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    let nextDateIV: UIImageView = {
        let view: UIImageView = UIImageView()
        view.image = UIImage(named: "calendar_svg")
        
        return view
    }()
    
    let nextDateLbl: SuperLabel = {
        let view: SuperLabel = SuperLabel()
        //view.setTextGeneralV2()
        view.text = "下次打球時間"
        view.visibility = .invisible
        
        return view
    }()
    
    let nextTimeContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    let nextTimeIV: UIImageView = {
        let view: UIImageView = UIImageView()
        view.image = UIImage(named: "clock_svg")
        
        return view
    }()
    
    let nextTimeLbl: SuperLabel = {
        let view: SuperLabel = SuperLabel()
        //view.setTextGeneralV2()
        view.weight(10)
        view.text = "下次打球時間"
        view.visibility = .invisible
        
        return view
    }()
    
    var teamMemberListLbl: SuperLabel = {
        let view: SuperLabel = SuperLabel()
        view.setTextTitle()
        view.text = "隊員："
        view.visibility = .invisible
        
        return view
    }()

    var isTeamMemberLoaded: Bool = false
    
    var table: Table?
    var myTable: TeamTable?
    
    var isLike: Bool = false
    
    var focusTabIdx: Int = 0
    
    //team member
    var items1: [TeamMemberTable] = [TeamMemberTable]()
    var filterItems: [TeamMemberTable] = [TeamMemberTable]()
    var teamMemberPage: Int = 1
    var teamMemberPerPage: Int = PERPAGE
    var teamMemberTotalCount: Int = 0
    var teamMemberTotalPage: Int = 0
    var leaveCount: Int = 0
    var teamMemberToken: String? = nil
    var countTaps: [TapLabel2] = [TapLabel2]()
    
    var nextDate: String = ""
    var nextDateWeek: String = ""
    var play_start: String = ""
    var play_end: String = ""
    
    //會員是否為球隊隊友
    var isTeamMember: Bool = false
    //會員為隊友，會員是否已經請假
    var isTeamMemberLeave: Bool = false
    //顯示尚無資料的view
    var noTeamMemberDataView: UIView? = nil
    
    //temp play
    //是否開放臨打
    var isTempPlay: Bool = true
    //會員是否已經加入臨打
    var isAddTempPlay: Bool = false
    //臨打列表資料是否已輸入
    var isTempplayLoaded: Bool = false
    var tempPlayPage: Int = 1
    var tempPlayPerPage: Int = PERPAGE
    var tempPlayTotalCount: Int = 0
    var tempPlayTotalPage: Int = 0
    
    var items2: [TeamTempPlayTable] = [TeamTempPlayTable]()
    var memberRows: [MemberRow] = [MemberRow]()
    var tempPlayCount: Int = 0
    //var standbyCount: Int = 0
    
    var token: String?

    override func viewDidLoad() {
        
        dataService = TeamService.instance
        
        super.viewDidLoad()
        
        initTop()
        initBottom()
        initTopTab()
        initScrollView()
        
        introduceTableView.snp.makeConstraints { make in
            make.height.equalTo(0)
        }
        introduceTableView.delegate = self
        introduceTableView.dataSource = self
        
        showTab2.delegate = self
        
        showLike2.delegate = self
        teamMemberTotalLbl.delegate = self
        teamMemberPlayLbl.delegate = self
        teamMemberLeaveLbl.delegate = self
        
        //initIntroduce()
        //initTeamMember()
        
        countTaps.append(contentsOf: [teamMemberTotalLbl, teamMemberPlayLbl, teamMemberLeaveLbl])

        refresh(TeamTable.self)
    }
    
    func initTop() {
        showTop2 = ShowTop2(delegate: self)
        showTop2!.setAnchor(parent: self.view)
    }
    
    func initBottom() {
        showBottom = ShowBottom2(delegate: self)
        self.view.addSubview(showBottom!)
        //showBottom!.justShowLike(parent: self.view)
        showBottom!.showButton(parent: self.view, isShowSubmit: false, isShowCancel: false)
    }
    
    func initTopTab() {
        
        self.view.addSubview(showTab2)
        showTab2.snp.makeConstraints { make in
            make.top.equalTo(showTop2!.snp.bottom).offset(12)
            make.height.equalTo(40)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            //make.horizontalEdges.equalToSuperview()
        }
    }
    
    private func initScrollView() {
        
        self.view.addSubview(scrollView)
        //scrollView.backgroundColor = UIColor.red
        scrollView.snp.makeConstraints { make in
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalToSuperview()
            make.top.equalTo(showTab2.snp.bottom).offset(20)
            make.bottom.equalTo(showBottom!.snp.top)
            
            
//            make.top.equalTo(showTab2.snp.bottom).offset(20)
//            make.left.equalToSuperview()
//            make.right.equalToSuperview()
//            make.bottom.equalTo(showBottom!.snp.top)
        }
    }
    
    private func initIntroduce() {
        
        scrollView.addSubview(introduceContentView)
        introduceContentView.snp.makeConstraints { make in
            make.centerX.equalTo(introduceContentView.superview!.snp.centerX)
            make.width.equalTo(introduceContentView.superview!.snp.width)
            make.top.bottom.equalToSuperview()
        }
        
//        scrollView.addSubview(introduceStackView)
//        introduceStackView.snp.makeConstraints { make in
//            make.top.bottom.equalToSuperview()
//            make.left.right.equalToSuperview()
//            make.width.equalToSuperview()
//        }
        
        introduceContentView.addSubview(featured)
        //introduceStackView.addArrangedSubview(featured)
        //featured.backgroundColor = UIColor.green
        featured.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(200)
        }
        
        introduceContentView.addSubview(introduceTableView)
        //introduceTableView.backgroundColor = UIColor.red
        //introduceStackView.addArrangedSubview(introduceTableView)
        introduceTableView.snp.makeConstraints { make in
            make.top.equalTo(featured.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
        }

//        introduceStackView.addArrangedSubview(spacer)
//        spacer.snp.makeConstraints { make in
//            make.height.equalTo(130)
//        }
        introduceContentView.addSubview(contentLbl)
        contentLbl.snp.makeConstraints { make in
            make.top.equalTo(introduceTableView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
        }
//        introduceStackView.addArrangedSubview(contentLbl)
//        introduceStackView.addArrangedSubview(spacer)
//        spacer.snp.makeConstraints { make in
//            make.height.equalTo(30)
//        }
//
//        introduceStackView.addArrangedSubview(contentWebView)
//
        introduceContentView.addSubview(contentWebView)
        contentWebView.snp.makeConstraints { make in
            make.top.equalTo(contentLbl.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(500)
            make.bottom.equalToSuperview().offset(-50)
        }
    }
    
    private func initTeamMember() {
        
        scrollView.addSubview(teamMemberContentView)
        teamMemberContentView.snp.makeConstraints { make in
            make.centerX.equalTo(teamMemberContentView.superview!.snp.centerX)
            make.width.equalTo(teamMemberContentView.superview!.snp.width)
            make.top.bottom.equalToSuperview()
        }
        
//        scrollView.addSubview(teamMemberStackView)
//        //teamMemberStackView.backgroundColor = UIColor.cyan
//        teamMemberStackView.snp.makeConstraints { make in
//            make.top.bottom.equalToSuperview()
//            make.width.equalToSuperview()
//        }
        
        //teamMemberAllContainer.backgroundColor = UIColor.blue
        //teamMemberStackView.addArrangedSubview(teamMemberAllContainer)
        teamMemberContentView.addSubview(teamMemberAllContainer)
        teamMemberAllContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            //make.height.equalTo(80)
        }

            //teamMemberLeftContainer.backgroundColor = UIColor.red
            teamMemberAllContainer.addSubview(teamMemberLeftContainer)
            teamMemberLeftContainer.snp.makeConstraints { make in
                make.top.left.equalToSuperview()
                make.right.equalToSuperview().offset(-100)
                //make.height.equalTo(50)
                make.bottom.equalToSuperview()
            }

                //teamMemberDataLbl.backgroundColor = UIColor.brown
                teamMemberLeftContainer.addSubview(teamMemberDataLbl)
                teamMemberDataLbl.snp.makeConstraints { make in
                    make.top.left.right.equalToSuperview()
                    make.height.equalTo(20)
                    //make.bottom.equalToSuperview()
                }

                //teamMemberSummaryContainer.backgroundColor = UIColor.red
                teamMemberLeftContainer.addSubview(teamMemberSummaryContainer)
                teamMemberSummaryContainer.snp.makeConstraints { make in
                    make.top.equalTo(teamMemberDataLbl.snp.bottom).offset(20)
                    make.left.right.equalToSuperview()
                    make.height.equalTo(20)
                    make.bottom.equalToSuperview()
                }

                    //teamMemberTotalLbl.backgroundColor = UIColor.cyan
                    teamMemberSummaryContainer.addSubview(teamMemberTotalLbl)
                    teamMemberTotalLbl.snp.makeConstraints { make in
                        make.top.equalToSuperview()
                        make.left.equalToSuperview()
                        make.centerY.equalToSuperview()
                    }

                    teamMemberSummaryContainer.addSubview(teamMemberPlayLbl)
                    teamMemberPlayLbl.snp.makeConstraints { make in
                        make.left.equalTo(teamMemberTotalLbl.snp.right)
                        make.top.equalToSuperview()
                        make.centerY.equalToSuperview()
                    }

                    teamMemberSummaryContainer.addSubview(teamMemberLeaveLbl)
                    teamMemberLeaveLbl.snp.makeConstraints { make in
                        make.left.equalTo(teamMemberPlayLbl.snp.right)
                        make.top.equalToSuperview()
                        make.centerY.equalToSuperview()
                    }



            teamMemberAllContainer.addSubview(showLike2)
            showLike2.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.right.equalToSuperview()
                make.width.equalTo(48)
                make.height.equalTo(50)
            }


//        let spacer1: UIView = UIView()
//        //spacer1.backgroundColor = UIColor.gray
//        teamMemberStackView.addArrangedSubview(spacer1)
//        spacer1.snp.makeConstraints { make in
//            make.left.equalToSuperview()
//            make.height.equalTo(4)
//        }
//
        teamMemberContentView.addSubview(nextDateContainer)
//        teamMemberStackView.addArrangedSubview(nextDateContainer)
        nextDateContainer.snp.makeConstraints { make in
            make.top.equalTo(teamMemberAllContainer.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(30)
        }

            nextDateContainer.addSubview(nextDateIV)
            nextDateIV.snp.makeConstraints { make in
                make.left.equalToSuperview()
                make.width.height.equalTo(24)
                make.centerY.equalToSuperview()
            }

            nextDateContainer.addSubview(nextDateLbl)
            nextDateLbl.snp.makeConstraints { make in
                make.left.equalTo(nextDateIV.snp.right).offset(24)
                make.centerY.equalToSuperview()
            }

        teamMemberContentView.addSubview(nextTimeContainer)
//        teamMemberStackView.addArrangedSubview(nextTimeContainer)
        nextTimeContainer.snp.makeConstraints { make in
            make.top.equalTo(nextDateContainer.snp.bottom).offset(4)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(30)
        }

            nextTimeContainer.addSubview(nextTimeIV)
            nextTimeIV.snp.makeConstraints { make in
                make.left.equalToSuperview()
                make.width.height.equalTo(24)
                make.centerY.equalToSuperview()
            }

            nextTimeContainer.addSubview(nextTimeLbl)
            nextTimeLbl.snp.makeConstraints { make in
                make.left.equalTo(nextTimeIV.snp.right).offset(24)
                make.centerY.equalToSuperview()
            }

//        let spacer2: UIView = UIView()
//        teamMemberStackView.addArrangedSubview(spacer2)
//        spacer2.snp.makeConstraints { make in
//            make.left.equalToSuperview()
//            make.height.equalTo(10)
//        }

        teamMemberContentView.addSubview(teamMemberListLbl)
//        teamMemberStackView.addArrangedSubview(teamMemberListLbl)
        teamMemberListLbl.snp.makeConstraints { make in
            make.top.equalTo(nextTimeContainer.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(20)
        }

        teamMemberContentView.addSubview(introduceTableView)
//        teamMemberStackView.addArrangedSubview(introduceTableView)
        introduceTableView.snp.makeConstraints { make in
            make.top.equalTo(teamMemberListLbl.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.showLike2.backgroundCircle()
//        self.featured.layer.cornerRadius = 20
//        self.featured.clipsToBounds = true
    }
    
    func refresh<T: Table>(_ t: T.Type) {
        memberRows.removeAll()
        
        if token != nil {
            Global.instance.addSpinner(superView: self.view)
            let params: [String: String] = ["token": token!, "member_token": Member.instance.token]
            dataService.getOne(params: params) { [self] (success) in
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
                                
                                guard let _myTable = self.table as? TeamTable else { return }
                                self.myTable = _myTable
                                self.initIntroduce()
                                self.myTable!.filterRow()
                                self.setFeatured()
                                self.setIntroduceData()
                                self.setContentWeb()
                                self.setLike()
                                self.showTop2!.setTitle(title: self.table!.name)
                                self.tempPlayCount = myTable!.people_limit + myTable!.leaveCount
                                
                                if let nextDate = myTable?.nextDate, !nextDate.isEmpty, let nextDateWeek = myTable?.nextDateWeek, !nextDateWeek.isEmpty {
                                    self.nextDateLbl.text = "\(nextDate) ( \(nextDateWeek) )"
                                }
                                
                                if let playStart = myTable?.play_start, let playEnd = myTable?.play_end {
                                    self.nextTimeLbl.text = "\(playStart) ~ \(playEnd)"
                                }
                                
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
    
//    func initTopTap() {
//
//        let count: Int = 3
//        let tab_width: Int = 80
//
//        let padding: Int = (Int(screen_width) - count * tab_width) / (count+1)
//
//        for (idx, topTab) in topTabs.enumerated() {
//            let x: Int = idx * tab_width + (idx + 1)*padding
//            let rect: CGRect = CGRect(x: x, y: 0, width: 80, height: 50)
//
//            let tab = TabTop(frame: rect)
//            if let tmp: Int = topTab["tag"] as? Int {
//                tab.tag = tmp
//            }
//
//            var icon: String = "like"
//            if let tmp: String = topTab["icon"] as? String {
//                icon = tmp
//            }
//
//            var text: String = "喜歡"
//            if let tmp: String = topTab["text"] as? String {
//                text = tmp
//            }
//
//            tab.setData(iconStr: icon, text: text)
//
//            var isSelected: Bool = false
//            if let tmp: Bool = topTab["focus"] as? Bool {
//                isSelected = tmp
//            }
//            tab.isFocus(isSelected)
//
//            let tabTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tabPressed))
//            tab.addGestureRecognizer(tabTap)
//
//            topTabs[idx]["class"] = tab
//
//            //topTagStackView.addArrangedSubview(tab)
//        }
//    }
    
    override func like() {
        if (!Member.instance.isLoggedIn) {
            toLogin()
        } else {
            if (table != nil) {
                isLike = !isLike
                if (focusTabIdx == 1) {
                    showLike2.setLike(isLike)
                } else {
                    showBottom?.setLike(isLike)
                }
                dataService.like(token: table!.token, able_id: table!.id)
            } else {
                warning("沒有取得內容資料值，請稍後再試或洽管理員")
            }
        }
    }
    
    func setFeatured() {

        if (table != nil && table!.featured_path.count > 0) {
            
            featured.path(table!.featured_path, isCircle: false, rounded: 100)
            
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
        
        var row: MemberRow = MemberRow()
        
        if myTable != nil && myTable!.arena != nil {
        
            row = MemberRow(title: "球館", icon: "arena_svg", show: myTable!.arena!.name)
            memberRows.append(row)
            row = MemberRow(title: "縣市", icon: "city_svg", show: myTable!.arena!.city_show)
            memberRows.append(row)
            row = MemberRow(title: "區域", icon: "area_svg", show: myTable!.arena!.area_show)
            memberRows.append(row)
        }
        row = MemberRow(title: "星期", icon: "calendar_svg", show: myTable!.weekdays_show)
        memberRows.append(row)
        row = MemberRow(title: "時段", icon: "clock_svg", show: myTable!.interval_show)
        memberRows.append(row)
        row = MemberRow(title: "球種", icon: "ball_svg", show: myTable!.ball)
        memberRows.append(row)
        row = MemberRow(title: "程度", icon: "degree_svg", show: myTable!.degree_show)
        memberRows.append(row)
        row = MemberRow(title: "場地", icon: "block_svg", show: myTable!.block_show)
        memberRows.append(row)
        row = MemberRow(title: "費用-男", icon: "fee_svg", show: myTable!.temp_fee_M_show)
        memberRows.append(row)
        row = MemberRow(title: "費用-女", icon: "fee_svg", show: myTable!.temp_fee_F_show)
        memberRows.append(row)
        row = MemberRow(title: "管理者", icon: "manager_svg", show: myTable!.manager_nickname)
        memberRows.append(row)
        row = MemberRow(title: "行動電話", icon: "mobile_svg", show: myTable!.mobile_show)
        memberRows.append(row)
        row = MemberRow(title: "line", icon: "line_svg", show: myTable!.line)
        memberRows.append(row)
        row = MemberRow(title: "FB", icon: "fb_svg", show: myTable!.fb)
        memberRows.append(row)
        row = MemberRow(title: "Youtube", icon: "youtube_svg", show: myTable!.youtube)
        memberRows.append(row)
//        row = MemberRow(title: "網站", icon: "website", show: myTable!.website)
//        memberRows.append(row)
        row = MemberRow(title: "EMail", icon: "email_svg", show: myTable!.email)
        memberRows.append(row)
        row = MemberRow(title: "瀏覽數", icon: "pv_svg", show: String(myTable!.pv))
        memberRows.append(row)
        row = MemberRow(title: "建立日期", icon: "createdAt_svg", show: myTable!.created_at_show)
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
            showLike2.initStatus(table!.like, table!.like_count)
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
            self.submitLeave()
        }
        else if (focusTabIdx == 2) {
            self.submitTempPlay()
            
//            if myTable != nil && myTable!.signupDate != nil {
//
//                //print(myTable!.signupDate!.deadline)
//                if let deadline_time: Date = myTable!.signupDate!.deadline.toDateTime(format: "yyyy-MM-dd HH:mm:ss", locale: false) {
//                    let now: Date = Date().myNow()
//                    if now > deadline_time {
//
//                        var msg: String = "已經超過報名截止時間，請下次再報名"
//                        if myTable!.isSignup {
//                            msg = "已經超過取消報名截止時間，無法取消報名"
//                        }
//                        warning(msg)
//                        return
//                    }
//                }
//
//                Global.instance.addSpinner(superView: view)
//                dataService.signup(token: myTable!.token, member_token: Member.instance.token, date_token: myTable!.signupDate!.token) { (success) in
//
//                    Global.instance.removeSpinner(superView: self.view)
//
//                    do {
//                        if (self.dataService.jsonData != nil) {
//                            let successTable: SuccessTable = try JSONDecoder().decode(SuccessTable.self, from: self.dataService.jsonData!)
//                            if (successTable.success) {
//                                self.info(msg: successTable.msg, buttonTitle: "關閉") {
//                                    self.refresh(TeamTable.self)
//                                }
//                            } else {
//                                self.warning(successTable.msg)
//                            }
//                        }
//                    } catch {
//                        self.msg = "解析JSON字串時，得到空值，請洽管理員"
//                    }
//                }
//            }
        }
    }

//    @objc func tabPressed(sender: UITapGestureRecognizer) {
//
//        if let idx: Int = sender.view?.tag {
//            //self._tabPressed(idx)
//            let selectedTag: [String: Any] = topTabs[idx]
//            if let focus: Bool = selectedTag["focus"] as? Bool {
//                //按了其他頁面的按鈕
//                if (!focus) {
//                    updateTabSelected(idx: idx)
//                    focusTabIdx = idx
//                    _tabPressed(idx)
//                }
//            }
//        }
//    }
    
    private func _tabPressed(_ idx: Int) {
        
        focusTabIdx = idx
        switch idx {
        case 0:
            removeTeamMember()
            
            initIntroduce()
            //setIntroduceData()
            introduceTableView.reloadData()
            showBottom!.showButton(parent: self.view, isShowSubmit: false, isShowCancel: false)
            
        case 1:
            removeIntroduce()
            
            initTeamMember()
            self.teamMemberVisible(.visible)
            
            teamMemberDataLbl.text = "球隊人數統計："
            teamMemberListLbl.text = "正式隊員："
            
            if (!isTeamMemberLoaded) {
                teamMemberPage = 1
                getTeamMemberList(page: teamMemberPage, perPage: teamMemberPerPage)
                isTeamMemberLoaded = true
            } else {
                setTeamMemberSummary()
            }
            
            introduceTableView.reloadData()
            
            setTeamMemberBottom()
            
        case 2:
            removeIntroduce()
            
            initTeamMember()
            self.teamMemberVisible(.visible)
            
            //teamMemberVisible(.visible)
            teamMemberDataLbl.text = "臨打人數統計："
            teamMemberListLbl.text = "臨打隊員："
            
            if (!isTempplayLoaded) {
                tempPlayPage = 1
                getTempPlayList(page: tempPlayPage, perPage: tempPlayPerPage)
                isTempplayLoaded = true
            } else {
                setTempPlaySummary()
            }
            
            introduceTableView.reloadData()
            
            //setSignupData()
            
            setTempPlayBottom()
            
        default:
            refresh()
        }
    }
    
    private func removeIntroduce() {
        //introduceStackView.removeFromSuperview()
        introduceContentView.removeFromSuperview()
    }
    
//    private func removeTempPlay() {
//        tempPlayStackView.removeFromSuperview()
//    }
    
    private func removeTeamMember() {
        //teamMemberStackView.removeFromSuperview()
        teamMemberContentView.removeFromSuperview()
    }
    
//    private func updateTabSelected(idx: Int) {
//
//        // set user click which tag, set tag selected is true
//        for (i, var topTab) in topTabs.enumerated() {
//
//            if (i == idx) {
//                topTab["focus"] = true
//            } else {
//                topTab["focus"] = false
//            }
//            topTabs[i] = topTab
//        }
//        setTabSelectedStyle()
//    }
//
//    private func setTabSelectedStyle() {
//
//        for topTab in topTabs {
//
//            if (topTab.keyExist(key: "class")) {
//
//                let tab: TabTop = (topTab["class"] as? TabTop)!
//
//                var isFocus: Bool = false
//                if let tmp: Bool = topTab["focus"] as? Bool {
//                    isFocus = tmp
//                }
//
//                tab.isFocus(isFocus)
//            }
//        }
//    }
    
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
        if (_rows.count > 0) {
            
            if (teamMemberPage == 1) {
                items1 = [TeamMemberTable]()
            }
            items1 += _rows
            filterItems = items1
            introduceTableView.reloadData()
            
            for item in items1 {
                if item.memberTable != nil {
                    if item.memberTable!.token == Member.instance.token {
                        self.teamMemberToken = item.token
                        self.isTeamMember = true
                        self.isTeamMemberLeave = item.isLeave
                        break
                    }
                }
            }
            
            setTeamMemberBottom()
        }
        
        self.setTeamMemberSummary()
        teamMemberTotalLbl.on()
    }
    
    func jsonToTable2(jsonData: Data?)-> [TeamMemberTable] {
            
        var rows: [TeamMemberTable] = [TeamMemberTable]()
        do {
            if (jsonData != nil) {
                //jsonData!.prettyPrintedJSONString
                let tables2: TeamMemberTables2 = try JSONDecoder().decode(TeamMemberTables2<TeamMemberTable>.self, from: jsonData!)
                if (tables2.success) {
                    
                    tables2.filterRow()
                    if tables2.rows.count > 0 {
                        
                        for row in tables2.rows {
                            row.filterRow()
                        }
                        rows += tables2.rows
                        
                        if (teamMemberPage == 1) {
                            teamMemberPage = tables2.page
                            teamMemberPerPage = tables2.perPage
                            teamMemberTotalCount = tables2.totalCount
                            let _totalPage: Int = teamMemberTotalCount / teamMemberPerPage
                            teamMemberTotalPage = (teamMemberTotalCount % teamMemberPerPage > 0) ? _totalPage + 1 : _totalPage
                            
//                            nextDate = tables2.nextDate
//                            nextDateWeek = tables2.nextDateWeek
//                            play_start = tables2.play_start_show
//                            play_end = tables2.play_end_show
                            self.leaveCount = tables2.leaveCount
                        }
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
    
//    func memberCountFocus(view: SuperLabel) {
//        view.backgroundColor = UIColor(MY_GREEN)
//        view.textColor = UIColor(MY_BLACK)
//        view.corner(3)
//    }
//
//    func memberCountUnFocus(view: SuperLabel) {
//        view.backgroundColor = UIColor.clear
//        view.textColor = UIColor(MY_WHITE)
//    }
    
    func teamMemberVisible(_ visible: UIView.Visibility) {
        self.teamMemberDataLbl.visibility = visible
        
        self.teamMemberSummaryContainer.visibility = visible
        self.teamMemberTotalLbl.visibility = visible
        self.teamMemberPlayLbl.visibility = visible
        self.teamMemberLeaveLbl.visibility = visible
        
        self.nextDateContainer.visibility = visible
        self.nextDateIV.visibility = visible
        self.nextDateLbl.visibility = visible
        
        self.nextTimeContainer.visibility = visible
        self.nextTimeIV.visibility = visible
        self.nextTimeLbl.visibility = visible
        
        self.teamMemberListLbl.visibility = visible
    }
    
    func setTeamMemberBottom() {
        if self.isTeamMember && !self.isTeamMemberLeave {
            showBottom!.showButton(parent: self.view, isShowSubmit: true, isShowLike: false, isShowCancel: false)
            showBottom!.submitBtn.setTitle("請假")
            showBottom!.changeSubmitToNormalBtn()
        } else if self.isTeamMember && self.isTeamMember {
            showBottom!.showButton(parent: self.view, isShowSubmit: true, isShowLike: false, isShowCancel: false)
            showBottom!.submitBtn.setTitle("取消")
            showBottom!.changeSubmitToCancelBtn()
        } else {
            showBottom!.showButton(parent: self.view, isShowSubmit: false, isShowLike: false, isShowCancel: false)
        }
    }
    
    func setTeamMemberSummary() {
        self.teamMemberTotalLbl.text = "全部：\(teamMemberTotalCount)位"
        self.teamMemberLeaveLbl.text = "請假：\(leaveCount)位"
        self.teamMemberPlayLbl.text = "打球：\(teamMemberTotalCount-leaveCount)位"
    }
    
    func teamMemberLeave(doLeave: Bool) {
        
        let doLeaveWarning: String = (doLeave) ? "已經請假了" : "已經取消請假了"
        Global.instance.addSpinner(superView: self.view)
        //team member token
        //play date
        TeamService.instance.leave(team_member_token: self.teamMemberToken!, play_date: myTable!.nextDate) { success in
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
    
    private func submitLeave() {
        //如果要請假
        if !isTeamMemberLeave {
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
}

///////////////////// temp play /////////////////////////////
extension ShowTeamVC {
    
    func tempPlayAdd(doAdd: Bool) {
        
        let doAddWarning: String = (doAdd) ? "報名臨打成功" : "取消臨打成功"
        Global.instance.addSpinner(superView: self.view)
        //team member token
        //play date
        TeamService.instance.tempPlayAdd(token: token!, member_token: Member.instance.token, play_date: myTable!.nextDate) { success in
            Global.instance.removeSpinner(superView: self.view)
            
            do {
                if (self.dataService.jsonData != nil) {
                    let successTable: SuccessTable = try JSONDecoder().decode(SuccessTable.self, from: self.dataService.jsonData!)
                    if (successTable.success) {
                        self.info(msg: doAddWarning, buttonTitle: "關閉") {
                            self.getTempPlayList(page: 1, perPage: PERPAGE)
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
    
    func getTempPlayList(page: Int = 1, perPage: Int = 20) {
        Global.instance.addSpinner(superView: self.view)
        
        TeamService.instance.tempPlayList(token: token!, playDate: myTable!.nextDate, page: page, perPage: perPage) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if (success) {
                var rows: [TeamTempPlayTable] = [TeamTempPlayTable]()
                self.jsonData = TeamService.instance.jsonData
                //self.jsonData?.prettyPrintedJSONString
                do {
                    if (self.jsonData != nil) {
                        //jsonData!.prettyPrintedJSONString
                        let tables2: TempPlayTables2 = try JSONDecoder().decode(TempPlayTables2<TeamTempPlayTable>.self, from: self.jsonData!)
                        if (tables2.success) {
                            
                            tables2.filterRow()
                            if tables2.rows.count > 0 {
                                
                                for row in tables2.rows {
                                    row.filterRow()
                                }
                                rows += tables2.rows
                                
                                if (self.tempPlayPage == 1) {
                                    
                                    self.tempPlayPage = tables2.page
                                    self.tempPlayPerPage = tables2.perPage
                                    self.tempPlayTotalCount = tables2.totalCount
                                    let _totalPage: Int = self.tempPlayTotalCount / self.tempPlayPerPage
                                    self.tempPlayTotalPage = (self.tempPlayTotalCount % self.tempPlayPerPage > 0) ? _totalPage + 1 : _totalPage
                                }
                                
                                if (self.tempPlayPage == 1) {
                                    self.items2.removeAll()
                                }
                                self.items2 += rows
                                //filterItems = items
                                
                                self.isAddTempPlay = false
                                for item in self.items2 {
                                    if item.memberTable != nil {
                                        if item.memberTable!.token == Member.instance.token {
                                            //self.tempPlayToken = item.token
                                            self.isAddTempPlay = true
                                            break
                                        }
                                    }
                                }
                                
                                self.setTempPlaySummary()
                                self.teamMemberTotalLbl.on()
                            } else {
                                self.items2.removeAll()
                                self.isAddTempPlay = false
                            }
                            self.introduceTableView.reloadData()
                            self.setTempPlayBottom()
                        } else {
                            self.msg = "解析JSON字串時，沒有成功，系統傳回值錯誤，請洽管理員"
                        }
                    } else {
                        self.msg = "無法從伺服器取得正確的json資料，請洽管理員"
                    }
                } catch {
                    self.msg = "解析JSON字串時，得到空值，請洽管理員"
                }
            } else {
                self.warning("取得資料錯誤，請洽管理員！！")
            }
        }
    }
    
    func setTempPlayBottom() {
        
        if self.tempPlayCount == 0 {
            showBottom!.showButton(parent: self.view, isShowSubmit: false, isShowLike: false, isShowCancel: false)
        } else {
            if self.isAddTempPlay {
                
                showBottom!.showButton(parent: self.view, isShowSubmit: true, isShowLike: false, isShowCancel: false)
                showBottom!.submitBtn.setTitle("取消")
                showBottom!.changeSubmitToCancelBtn()
            } else {
                showBottom!.showButton(parent: self.view, isShowSubmit: true, isShowLike: false, isShowCancel: false)
                showBottom!.submitBtn.setTitle("報名")
                showBottom!.changeSubmitToNormalBtn()
            }
        }
    }
    
    func setTempPlaySummary() {
        self.teamMemberTotalLbl.text = "全部：\(self.tempPlayCount)位"
        self.teamMemberPlayLbl.text = "報名：\(self.items2.count)位"
        self.teamMemberLeaveLbl.text = "候補：0位"
    }

    func setSignupData() {

        isTempPlayOnline()
        if !isTempPlay {
            //tempPlayDataLbl.text = "目前球隊不開放臨打"
            //signupButtonContainer.visibility = .invisible
            //tempPlayTimeLbl.visibility = .invisible
            //tempPlayDeadlineLbl.visibility = .invisible
            showBottom!.showButton(parent: self.view, isShowSubmit: false, isShowCancel: false)
        } else {
            
            self.teamMemberTotalLbl.text = "全部：\(teamMemberTotalCount)位"
            self.teamMemberLeaveLbl.text = "請假：\(leaveCount)位"
            self.teamMemberPlayLbl.text = "打球：\(teamMemberTotalCount-leaveCount)位"
            teamMemberTotalLbl.on()
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
//        if myTable!.signupDate != nil {
//            let temp_date_string: String = myTable!.signupDate!.date
//
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy-MM-dd"
//            let now_string: String = formatter.string(from: Date())
//
//            //3.如果臨打日期超過現在的日期，關閉臨打
//            if let temp_date: Date = temp_date_string.toDateTime(format: "yyyy-MM-dd", locale: false) {
//
//                var now: Date = Date()
//                if let tmp: Date = now_string.toDateTime(format: "yyyy-MM-dd", locale: false) {
//                    now = tmp
//                }
//
//                //(1)如果報名日期剛好也是臨打日期則可以報名
//                if (temp_date.isEqualTo(now)) {
//                    isTempPlay = true
//                } else {
//                    //(2)如果報名日期已經過了臨打日期則無法報名
//                    if (temp_date.isSmallerThan(now)) {
//                        isTempPlay = false
//                    //(3)如果報名日期還沒過了臨打日期則無法報名
//                    } else {
//                        isTempPlay = true
//                    }
//                }
//            }
//        } else {
//            isTempPlay = false
//        }

        //3.如果管理者設定報名臨打名額是0，關閉臨打
        if myTable!.people_limit == 0 {
            isTempPlay = false
        }
    }
    
    private func submitTempPlay() {
        //如果要請假
        if !isAddTempPlay {
            warning(msg: "是否確定要加入臨打？", closeButtonTitle: "關閉", buttonTitle: "是") {
                self.tempPlayAdd(doAdd: true)
            }
        }
        // 如果要取消請假
        else {
            warning(msg: "是否確定要取消臨打？", closeButtonTitle: "關閉", buttonTitle: "取消請假") {
                self.tempPlayAdd(doAdd: false)
            }
        }
    }
}

extension ShowTeamVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (focusTabIdx == 0) {
            return 40
        } else {
            return 72
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (focusTabIdx == 0) {
            return memberRows.count
            //return tableRowKeys.count
        } else if (focusTabIdx == 1) {
            return filterItems.count
            
        } else if (focusTabIdx == 2) {
            
            return tempPlayCount
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

            return cell
        }
        else if focusTabIdx == 1 && items1.count > 0 {
            let cell: ShowTeamMemberCell = tableView.dequeueReusableCell(withIdentifier: "ShowTeamMemberCell", for: indexPath) as! ShowTeamMemberCell
            
            //cell.delegate = self
            
            let row: TeamMemberTable = filterItems[indexPath.row]
            
            let no: Int = (teamMemberPage - 1) * teamMemberPerPage + (indexPath.row + 1)
            cell.configureTeamMember(row: row, no: no)
            
            cell.setSelectedBackgroundColor()
            return cell
        }
        else if focusTabIdx == 2 {
//            let cell: ShowSignupCell = tableView.dequeueReusableCell(withIdentifier: "ShowSignupCell", for: indexPath) as! ShowSignupCell
            
//            cell.noLbl.text = "\(indexPath.row + 1)."
//
//            if items2.count > indexPath.row {
//                cell.nameLbl.text = String(items2[indexPath.row].memberTable!.nickname)
//            } else {
//                cell.nameLbl.text = ""
//            }
            
            let cell: ShowTeamMemberCell = tableView.dequeueReusableCell(withIdentifier: "ShowTeamMemberCell", for: indexPath) as! ShowTeamMemberCell
            
            let no: Int = (tempPlayPage - 1) * tempPlayPerPage + (indexPath.row + 1)
            
            var row: TeamTempPlayTable? = nil
            if (indexPath.row < items2.count) {
                row = items2[indexPath.row]
            }
            cell.configureTempPlay(row: row, no: no)
            
            cell.setSelectedBackgroundColor()

//            let people_limit = myTable!.people_limit + myTable!.leaveCount
//            let normal_count = myTable!.signupNormalTables.count
//            let standby_count = myTable!.signupStandbyTables.count
//            if indexPath.row < people_limit {
//                cell.noLbl.text = "\(indexPath.row + 1)."
//                cell.nameLbl.text = ""
//                if normal_count > 0 {
//                    if indexPath.row < normal_count {
//                        let signup_normal_model = myTable!.signupNormalTables[indexPath.row]
//                        cell.nameLbl.text = signup_normal_model.member_name
//                    }
//                }
//            } else if indexPath.row >= people_limit && indexPath.row < people_limit + standby_count {
//                cell.noLbl.text = "候補\(indexPath.row - people_limit + 1)."
//                let signup_standby_model = myTable!.signupStandbyTables[indexPath.row - people_limit]
//                cell.nameLbl.text = signup_standby_model.member_name
//            } else {
//                let remain: Int = people_limit - myTable!.signupNormalTables.count
//                var remain_text = ""
//                if (remain > 0) {
//                    remain_text = "還有\(remain)個名額"
//                } else {
//                    remain_text = "已經額滿，請排候補"
//                }
//                cell.noLbl.text = remain_text
//            }

            //cell.setSelectedBackgroundColor()
            return cell
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if focusTabIdx == 1 {
            if myTable != nil {
                if myTable!.manager_token == Member.instance.token {
                    let row: TeamMemberTable = items1[indexPath.row]
                    
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
                    
                    let row: TeamTempPlayTable = items2[indexPath.row]
                    if let memberTable: MemberTable = row.memberTable {
                        getMemberOne(member_token: memberTable.token)
                    }
                    
//                    let signupNormalCount: Int = myTable!.signupNormalTables.count
//                    let peopleLimit: Int = myTable!.people_limit
//                    let idx: Int = indexPath.row
//
//                    if (idx < signupNormalCount) {
//                        let signup_normal_model = myTable!.signupNormalTables[idx]
//                        getMemberOne(member_token: signup_normal_model.member_token)
//                    }
//
//                    if (idx >= peopleLimit) {
//                        let signup_standby_model = myTable!.signupStandbyTables[idx]
//                        getMemberOne(member_token: signup_standby_model.member_token)
//                    }
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

//extension ShowTeamVC: ShowTeamMemberCellDelegate {
//
//    func leavePressed(cell: ShowTeamMemberCell) {
//
//        guard let idx: Int = introduceTableView.indexPath(for: cell)?.row else { return }
//
//        let row: TeamMemberTable = items[idx]
//
//        TeamService.instance.leave(team_member_token: row.token, play_date: self.nextDate) { success in
//
//            Global.instance.removeSpinner(superView: self.view)
//
//            if success {
//
//                let jsonData: Data = TeamService.instance.jsonData!
//                //jsonData.prettyPrintedJSONString
//                do {
//                    let successTable: SuccessTable2<TeamMemberLeaveTable> = try JSONDecoder().decode(SuccessTable2.self, from: jsonData)
//                    if successTable.success {
//                        let teamMemberLeaveTable: TeamMemberLeaveTable = try JSONDecoder().decode(TeamMemberLeaveTable.self, from: jsonData)
//                        self.info(msg: "請假成功", buttonTitle: "關閉") {
//                            self.refresh()
//                        }
//
//                    } else {
//                        self.warning(successTable.parseMsgs())
//                    }
//                } catch {
//                    self.warning(error.localizedDescription)
//                }
//            }
//        }
//    }
//}

class TeamMemberTables2<T: Codable>: Codable {
    var success: Bool = false
    var page: Int = -1
    var totalCount: Int = -1
    var leaveCount: Int = -1
    var perPage: Int = -1
    var rows: [T] = [T]()
    
    //var play_start_show: String = ""
    //var play_end_show: String = ""
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decode(Bool.self, forKey: .success)
        page = try container.decode(Int.self, forKey: .page)
        totalCount = try container.decode(Int.self, forKey: .totalCount)
        leaveCount = try container.decode(Int.self, forKey: .leaveCount)
        perPage = try container.decode(Int.self, forKey: .perPage)

        rows = try container.decode([T].self, forKey: .rows)
    }
    
    func filterRow() {
    }
}

class TempPlayTables2<T: Codable>: Codable {
    var success: Bool = false
    var page: Int = -1
    var totalCount: Int = -1
    var perPage: Int = -1
    var rows: [T] = [T]()
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decode(Bool.self, forKey: .success)
        page = try container.decode(Int.self, forKey: .page)
        totalCount = try container.decode(Int.self, forKey: .totalCount)
        perPage = try container.decode(Int.self, forKey: .perPage)

        rows = try container.decode([T].self, forKey: .rows)
    }
    
    func filterRow() {
    }
}

extension ShowTeamVC: ShowLike2Delegate {
    func likePressed(_ isLike: Bool) {
        
        //print(isLike)
        self.like()
    }
}

extension ShowTeamVC: TapLabel2Delegate {
    func tapPressed(_ idx: Int) {
        for (i, tap) in countTaps.enumerated() {
            (i == idx) ? tap.on() : tap.off()
        }
        
        filterItems.removeAll()
        if (idx == 0) {
            filterItems = items1
        } else if (idx == 1) {
            
            filterItems = items1.filter { !$0.isLeave }
        } else if (idx == 2) {
            filterItems = items1.filter { $0.isLeave }
        }
        
        introduceTableView.reloadData()
        
    }
}

extension ShowTeamVC: ShowTab2Delegate {
    func tabPressed(_ idx: Int) {
        _tabPressed(idx)
    }
}
