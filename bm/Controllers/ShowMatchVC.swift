//
//  ShowMatchVC.swift
//  bm
//
//  Created by ives on 2023/4/20.
//  Copyright © 2023 bm. All rights reserved.
//

import Foundation
import WebKit

class ShowMatchVC: BaseViewController {
    
    var showTop2: ShowTop2?
    
    var showTab2: ShowTab2 = {
        let view: ShowTab2 = ShowTab2()
        
        return view
    }()
    
    let button_width: CGFloat = 120
    var bottom_button_count: Int = 1
    //var showBottom: ShowBottom2?
    
    var introduceContainer: UIView = UIView()
    var contentContainer: UIView = UIView()
    var signupContainer: UIView = UIView()
    
    let introduceTableView: UITableView = {
        let view = UITableView()
        view.isScrollEnabled = true
        view.backgroundColor = UIColor.clear
        
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = UITableView.automaticDimension

        let oneLineCellNib = UINib(nibName: "OneLineCell", bundle: nil)
        view.register(oneLineCellNib, forCellReuseIdentifier: "OneLineCell")
        
        view.register(OneLineCell2.self, forCellReuseIdentifier: "OneLineCell2")
        
        return view
    }()
    
    var contentWebView: WKWebView = {
        
        //Create configuration
        let configuration = WKWebViewConfiguration()
        //configuration.userContentController = controller
        
        let webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        webView.backgroundColor = UIColor.clear
        webView.scrollView.isScrollEnabled = true
        return webView
    }()
    
    let signupTableView: UITableView = {
        let view = UITableView()
        //view.isScrollEnabled = true
        view.isUserInteractionEnabled = true
        view.backgroundColor = UIColor.clear
        
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = UITableView.automaticDimension

        view.register(MatchGroupSignupCell.self, forCellReuseIdentifier: "MatchGroupSignupCell")
        
        return view
    }()
    
    var token: String?
    var table: MatchTable?
    
    var sectionTitles: [String] = [String]()
    var sections: [[IconTextRow]] = [[IconTextRow]]()
    var iconTextRows: [IconTextRow] = [IconTextRow]()
    var focusTabIdx: Int = 0

    override func viewDidLoad() {
        
        dataService = MatchService.instance
        
        super.viewDidLoad()
        
        initTop()
        //initBottom()
        initTopTab()
        
        showTab2.delegate = self
        
        introduceTableView.delegate = self
        introduceTableView.dataSource = self
        
        //introduceTableView.backgroundColor = UIColor.red
        
        signupTableView.delegate = self
        signupTableView.dataSource = self
        
        //signupTableView.backgroundColor = UIColor.red
        
        refresh(MatchTable.self)
    }
    
    func initTop() {
        showTop2 = ShowTop2(delegate: self)
        showTop2!.anchor(parent: self.view)
    }
    
//    func initBottom() {
//        showBottom = ShowBottom2(delegate: self)
//        self.view.addSubview(showBottom!)
//        //showBottom!.showButton(parent: self.view, isShowSubmit: true, isShowLike: false, isShowCancel: false)
//        showBottom!.setSubmitBtnTitle("報名")
//    }
    
    func initTopTab() {
        
        self.view.addSubview(showTab2)
        showTab2.snp.makeConstraints { make in
            make.top.equalTo(showTop2!.snp.bottom).offset(12)
            make.height.equalTo(40)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            //make.horizontalEdges.equalToSuperview()
        }
        
        showTab2.tab1Name("內容")
        showTab2.tab2Name("簡章")
        showTab2.tab3Name("報名")
    }
    
    private func initScrollView(_ container: UIView)-> (scrollView: UIScrollView, contentView: UIView) {
        
        let scrollView: UIScrollView = UIScrollView()
        container.addSubview(scrollView)
        //scrollView.backgroundColor = UIColor.red
        scrollView.snp.makeConstraints { make in
            make.centerX.equalTo(container.snp.centerX)
            make.width.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        let contentView = UIView()
        scrollView.addSubview(contentView)
        //contentView.backgroundColor = UIColor.green
        contentView.snp.makeConstraints { make in
            make.left.right.equalTo(container)
            make.width.height.top.bottom.equalTo(scrollView)
        }
        
        return (scrollView, contentView)
    }
    
    private func initIntroduce() {
        
        self.view.addSubview(introduceContainer)
        //introduceContainer.backgroundColor = UIColor.blue
        introduceContainer.snp.makeConstraints { make in
            make.top.equalTo(showTab2.snp.bottom)
            //make.bottom.equalTo(showBottom!.snp.top)
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        let view = initScrollView(introduceContainer)
        let contentView = view.contentView

        contentView.addSubview(introduceTableView)
        //introduceTableView.backgroundColor = UIColor.gray
        introduceTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func initContent() {
        self.view.addSubview(contentContainer)
        contentContainer.snp.makeConstraints { make in
            make.top.equalTo(showTab2.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
            //make.bottom.equalTo(showBottom!.snp.top)
            make.left.right.equalToSuperview()
        }
        
        contentContainer.addSubview(contentWebView)
        //contentWebView.backgroundColor = UIColor.red
        contentWebView.snp.makeConstraints { make in
            make.top.equalTo(showTab2.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview()
        }
    }
    
    private func initSignup() {
        self.view.addSubview(signupContainer)
        //signupContainer.backgroundColor = UIColor.gray
        signupContainer.snp.makeConstraints { make in
            make.top.equalTo(showTab2.snp.bottom)
            //make.bottom.equalTo(showBottom!.snp.top)
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
//        let view = initScrollView(signupContainer)
//        let contentView = view.contentView
        
        signupContainer.addSubview(signupTableView)
        //signupTableView.backgroundColor = UIColor.red
        signupTableView.snp.makeConstraints { make in
            //make.edges.equalToSuperview()
            make.top.equalTo(showTab2.snp.bottom)
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            //make.height.equalTo(150)
        }
    }
    
    func setIntroduceData() {
        
        var row: IconTextRow = IconTextRow()
        
        row = IconTextRow(title: "比賽開始日期", icon: "calendar_start_svg", show: "\(table!.match_start_show) (\(table!.match_start_weekday))")
        iconTextRows.append(row)
        row = IconTextRow(title: "比賽結束日期", icon: "calendar_end_svg", show: "\(table!.match_end.noSec()) (\(table!.match_end_weekday))")
        iconTextRows.append(row)
        row = IconTextRow(title: "報名開始日期", icon: "member_start_svg", show: "\(table!.signup_start.noSec()) (\(table!.signup_start_weekday))")
        iconTextRows.append(row)
        row = IconTextRow(title: "報名結束日期", icon: "member_end_svg", show: "\(table!.signup_end.noSec()) (\(table!.signup_end_weekday))")
        iconTextRows.append(row)
        sections.append(iconTextRows)
        sectionTitles.append("賽事日期時間")
        
        iconTextRows.removeAll()
        row = IconTextRow(title: "比賽地點", icon: "area_svg", show: table!.city_name)
        iconTextRows.append(row)
        if table!.arenaTable != nil {
            row = IconTextRow(title: "比賽球館", icon: "arena_on_svg 1", show: table!.arenaTable!.name)
            iconTextRows.append(row)
            row = IconTextRow(title: "球館地址", icon: "area_svg", show: table!.address)
            iconTextRows.append(row)
            row = IconTextRow(title: "球館電話", icon: "mobile_svg", show: table!.arenaTable!.tel_show)
            iconTextRows.append(row)
        }
        
        row = IconTextRow(title: "比賽用球", icon: "ball_svg", show: table!.ball)
        iconTextRows.append(row)
        sections.append(iconTextRows)
        sectionTitles.append("賽事地點")
        
        iconTextRows.removeAll()
        if table!.matchContactTable != nil {
            row = IconTextRow(title: "聯絡人", icon: "member_on_svg", show: table!.matchContactTable!.contact_name)
            iconTextRows.append(row)
            row = IconTextRow(title: "聯絡電話", icon: "mobile_svg", show: table!.matchContactTable!.contact_tel)
            iconTextRows.append(row)
            row = IconTextRow(title: "聯絡人Email", icon: "email_svg", show: table!.matchContactTable!.contact_email)
            iconTextRows.append(row)
            row = IconTextRow(title: "聯絡人line", icon: "line_svg", show: table!.matchContactTable!.contact_line)
            iconTextRows.append(row)
        }
        sections.append(iconTextRows)
        sectionTitles.append("賽事聯絡人")
        
        self.showTop2!.setTitle(table!.name)
        //introduceNameLbl.text = table!.name
        //print(section)
    }
    
    func setContentWeb() {
        let content: String = "<html><HEAD><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no\">"+self.body_css+"</HEAD><body>"+table!.content+"</body></html>"
        
        contentWebView.loadHTMLString(content, baseURL: nil)
    }
    
    func refresh<T: Table>(_ t: T.Type) {
        if token != nil {
            Global.instance.addSpinner(superView: self.view)
            let params: [String: String] = ["token": token!, "member_token": Member.instance.token]
            dataService.getOne(params: params) { [self] (success) in
                Global.instance.removeSpinner(superView: self.view)
                if (success) {
                    let jsonData: Data = self.dataService.jsonData!
                    //jsonData.prettyPrintedJSONString
                    do {
                        let t: Table = try JSONDecoder().decode(t, from: jsonData)
                        if (t.id == 0) {
                            //token錯誤，所以無法解析
                            self.warning("token錯誤，所以無法解析")
                        } else {
                            
                            guard let _myTable = t as? MatchTable else { return }
                            self.table = _myTable
                            self.table!.filterRow()
                            
                            self.showTop2!.setTitle(self.table!.name)
                            self.setIntroduceData()
                            //self.setSignupData()
                            
                            showTab2.pressed(self.focusTabIdx)
                            self._tabPressed(self.focusTabIdx)
                        }
                    } catch {
                        print(error.localizedDescription)
                        //self.warning(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    private func _tabPressed(_ idx: Int) {

        focusTabIdx = idx
        switch idx {
        case 0:
//            introduceContainer.removeFromSuperview()
//            contentContainer.removeFromSuperview()
//            initSignup()
//
//            signupTableView.reloadData()
            contentContainer.removeFromSuperview()
            signupContainer.removeFromSuperview()
            signupTableView.removeFromSuperview()
            initIntroduce()

//            introduceTableView.reloadData()
//            //showBottom!.showButton(parent: self.view, isShowSubmit: true, isShowLike: false, isShowCancel: false)

        case 1:
            introduceContainer.removeFromSuperview()
            signupContainer.removeFromSuperview()
            initContent()
            setContentWeb()

        case 2:
            introduceContainer.removeFromSuperview()
            contentContainer.removeFromSuperview()
            initSignup()
            
            signupTableView.reloadData()

        default:
            
            refresh()
        }
    }
    
    func signup(item: MatchGroupTable) {
        
        if !Member.instance.isLoggedIn {
            warning(msg: "請先登入", closeButtonTitle: "取消", buttonTitle: "登入") {
                self.toLogin()
            }
        } else {
            var canSignup: Bool = true
            if table != nil {
                if let signupStartDate: Date = table!.signup_start.toDateTime(), let signupEndDate: Date = table!.signup_end.toDateTime() {
                    let now: Date = Date()
                    if now.isSmallerThan(signupStartDate) {
                        canSignup = false
                        warning("還沒到報名時間，無法報名")
                    }
                    
                    if now.isGreaterThan(signupEndDate) {
                        canSignup = false
                        warning("已超過報名時間，無法報名")
                    }
                }
                
                if item.signup_count >= item.limit {
                    canSignup = false
                    warning("已超過報名組數，無法報名")
                }
            }
            
            if canSignup {
                toMatchTeamSignup(match_group_token: item.token)
            }
        }
    }
}

extension ShowMatchVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == introduceTableView {
            return sections.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int = 0
        if tableView == introduceTableView {
            count = sections[section].count
        } else if (tableView == signupTableView) {
            count = table!.matchGroups.count
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView == introduceTableView {
            return 20
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == introduceTableView {
            return 100
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == introduceTableView {
            let headerView: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 100))
            headerView.backgroundColor = UIColor(MY_BLACK)
            
            let titleLbl: SuperLabel = {
                let view: SuperLabel = SuperLabel()
                view.setTextTitle()
                view.text = sectionTitles[section]
                return view
            }()
            
            headerView.addSubview(titleLbl)
            titleLbl.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(20)
                make.centerY.equalToSuperview()
            }
            return headerView
        }
        
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if tableView == introduceTableView {
            let footerView: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 20))
            footerView.backgroundColor = UIColor(MY_BLACK)
            
            let separator: UIView = {
                let view: UIView = UIView()
                view.backgroundColor = UIColor(hex: "FFFFFF", alpha: 0.25)
                return view
            }()
            
            footerView.addSubview(separator)
            separator.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
                make.height.equalTo(1)
                make.bottom.equalToSuperview()
            }
            
            return footerView
        }
        
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == introduceTableView {
            let cell: OneLineCell2 = tableView.dequeueReusableCell(withIdentifier: "OneLineCell2", for: indexPath) as! OneLineCell2
            
            let row: IconTextRow = sections[indexPath.section][indexPath.row]
            cell.update(icon: row.icon, title: row.title, show: row.show)
            cell.setSelectedBackgroundColor()
            
            return cell
        } else if tableView == signupTableView {
            let cell: MatchGroupSignupCell = tableView.dequeueReusableCell(withIdentifier: "MatchGroupSignupCell", for: indexPath) as! MatchGroupSignupCell
            
            cell.signupStartShow = table!.signup_start_show
            cell.signupEndShow = table!.signup_end_show
            cell.myDelegate = self
            let item: MatchGroupTable = table!.matchGroups[indexPath.row]
            item.no = indexPath.row + 1
            cell.item = item
            
            
            return cell
        }
        
        return UITableViewCell()
    }
}

extension ShowMatchVC: ShowTab2Delegate {
    func tabPressed(_ idx: Int) {
        _tabPressed(idx)
    }
}

class MatchGroupSignupCell: BaseCell<MatchGroupTable, ShowMatchVC> {
    
    var signupStartShow: String = ""
    var signupEndShow: String = ""
    
    let noLbl: SuperLabel = {
        let view = SuperLabel()
        //view.setTextGeneral()
        view.setTextColor(UIColor(MY_GREEN))
        view.setTextBold()
        view.text = "100."
        
        return view
    }()
    
    let priceLbl: SuperLabel = {
        let view = SuperLabel()
        view.setTextGeneralV2()
        view.setTextColor(UIColor(MY_RED))
        view.text = "600"
        
        return view
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#FFFFFF", alpha: 0.3)
        return view
    }()
    
    let mainContainerView: UIView = UIView()
    
    let nameLbl: SuperLabel = {
        let view = SuperLabel()
        view.setTextTitle()
        return view
    }()
    
    let numberITT: IconTextText2 = {
        let view = IconTextText2()
        view.setIcon("member2_svg")
        view.setTitle("人數")
        return view
    }()
    
    let signupNumberITT: IconTextText2 = {
        let view = IconTextText2()
        view.setIcon("member2_svg")
        view.setTitle("報名組數")
        return view
    }()
    
    let limitITT: IconTextText2 = {
        let view = IconTextText2()
        view.setIcon("member2_svg")
        view.setTitle("限制組數")
        return view
    }()
    
    let signupStartITT: IconTextText2 = {
        let view = IconTextText2()
        view.setIcon("calendar_start_svg")
        view.setTitle("報名開始時間")
        
        return view
    }()
    
    let signupEndITT: IconTextText2 = {
        let view = IconTextText2()
        view.setIcon("calendar_end_svg")
        view.setTitle("報明結束時間")
        
        return view
    }()
    
    let showButton2: ShowButton2 = ShowButton2()
    
    //var delegate: ShowButton2Delegate? = nil
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    override func commonInit() {
        //super.commonInit()
        //self.contentView.backgroundColor = UIColor.blue
        showButton2.delegate = self
        setAnchor()
    }
    
    func setAnchor() {
        
        let view1: UIView = UIView()
        
        self.contentView.addSubview(view1)
        //view1.backgroundColor = UIColor.cyan
        view1.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(0)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            //make.bottom.equalToSuperview().offset(-2)
            //make.height.equalTo(30)
        }
        
            view1.addSubview(noLbl)
            noLbl.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.left.equalToSuperview()
            }
        
            view1.addSubview(priceLbl)
            priceLbl.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.right.equalToSuperview()
            }

            view1.addSubview(separator)
            separator.snp.makeConstraints { make in
                make.top.equalTo(noLbl.snp.bottom).offset(12)
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.height.equalTo(1)
                make.bottom.equalToSuperview().offset(-12)
            }

        self.contentView.addSubview(mainContainerView)
        //mainContainerView.backgroundColor = UIColor.brown
        mainContainerView.snp.makeConstraints { make in
            make.top.equalTo(view1.snp.bottom).offset(0)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            //make.bottom.equalToSuperview().offset(-2)
            //make.height .equalTo(180)
        }

            mainContainerView.addSubview(nameLbl)
            nameLbl.snp.makeConstraints { make in
                make.left.equalToSuperview()
                make.top.equalToSuperview().offset(6)
            }

            mainContainerView.addSubview(numberITT)
            numberITT.snp.makeConstraints { make in
                make.top.equalTo(nameLbl.snp.bottom).offset(12)
                make.left.equalToSuperview()
            }

            mainContainerView.addSubview(signupNumberITT)
            signupNumberITT.snp.makeConstraints { make in
                make.top.equalTo(numberITT.snp.bottom).offset(12)
                make.left.equalToSuperview()
            }

            mainContainerView.addSubview(limitITT)
            limitITT.snp.makeConstraints { make in
                make.top.equalTo(signupNumberITT.snp.bottom).offset(12)
                make.left.equalToSuperview()
            }
        
            mainContainerView.addSubview(signupStartITT)
            signupStartITT.snp.makeConstraints { make in
                make.top.equalTo(limitITT.snp.bottom).offset(12)
                make.left.equalToSuperview()
            }
            
            mainContainerView.addSubview(signupEndITT)
            signupEndITT.snp.makeConstraints { make in
                make.top.equalTo(signupStartITT.snp.bottom).offset(12)
                make.left.equalToSuperview()
                make.bottom.equalToSuperview().offset(-12)
            }


        self.contentView.addSubview(showButton2)
        showButton2.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            //make.centerY.equalToSuperview()
            make.height.equalTo(50)
            //make.width.equalTo(160)
            make.top.equalTo(mainContainerView.snp.bottom).offset(12)
            make.bottom.equalToSuperview().offset(-30)
        }
    }
    
    override func configureSubViews() {
        super.configureSubViews()
        
//        if item!.no % 2 == 0 {
//            self.contentView.backgroundColor = UIColor.blue
//        } else {
//            self.contentView.backgroundColor = UIColor.orange
//        }

        if item != nil {
            self.noLbl.text = "\(item!.no.toTwoString())."
            self.priceLbl.text = "NT$ \(item!.price.formattedWithSeparator)元"
            self.nameLbl.text = item!.name
            self.numberITT.setShow("\(item!.number)人")
            self.signupNumberITT.setShow("\(item!.signup_count)組")
            self.limitITT.setShow("\(item!.limit)組")
            self.signupStartITT.setShow(signupStartShow)
            self.signupEndITT.setShow(signupEndShow)
            showButton2.idx = item!.no - 1
        }
        
        showButton2.setTitle("報名")
    }
}

extension MatchGroupSignupCell: ShowButton2Delegate {
    
//    func showButtonPressed(idx: Int) {
//        //guard let superView = self.superview as? UITableView else { return }
//        myDelegate?.signup(idx: idx)
//    }
    
    func showButtonPressed() {
        guard let superView = self.superview as? UITableView else { return }
        //myDelegate?.didSelect(item: item, at: superView.indexPath(for: self)!)
        if item != nil {
            myDelegate?.signup(item: item!)
        }
    }
}
