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
    var showBottom: ShowBottom2?
    
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
        view.isScrollEnabled = true
        view.backgroundColor = UIColor.clear
        
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = UITableView.automaticDimension

        let oneLineCellNib = UINib(nibName: "OneLineCell", bundle: nil)
        view.register(oneLineCellNib, forCellReuseIdentifier: "OneLineCell")
        
        return view
    }()
    
    var token: String?
    var table: MatchTable?
    
    var iconTextRows: [IconTextRow] = [IconTextRow]()
    var focusTabIdx: Int = 0

    override func viewDidLoad() {
        
        dataService = MatchService.instance
        
        super.viewDidLoad()
        
        initTop()
        initBottom()
        initTopTab()
        
        showTab2.delegate = self
        
        introduceTableView.delegate = self
        introduceTableView.dataSource = self
        
        signupTableView.delegate = self
        signupTableView.dataSource = self
        
        refresh(MatchTable.self)
    }
    
    func initTop() {
        showTop2 = ShowTop2(delegate: self)
        showTop2!.anchor(parent: self.view)
    }
    
    func initBottom() {
        showBottom = ShowBottom2(delegate: self)
        self.view.addSubview(showBottom!)
        //showBottom!.showButton(parent: self.view, isShowSubmit: true, isShowLike: false, isShowCancel: false)
        showBottom!.setSubmitBtnTitle("報名")
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
        
        showTab2.tab1Name("說明")
        showTab2.tab2Name("內容")
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
            make.left.right.equalTo(introduceContainer)
            make.width.height.top.bottom.equalTo(scrollView)
        }
        
        return (scrollView, contentView)
    }
    
    private func initIntroduce() {
        
        self.view.addSubview(introduceContainer)
        //introduceContainer.backgroundColor = UIColor.blue
        introduceContainer.snp.makeConstraints { make in
            make.top.equalTo(showTab2.snp.bottom).offset(20)
            make.bottom.equalTo(showBottom!.snp.top)
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
            make.bottom.equalTo(showBottom!.snp.top)
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
        signupContainer.snp.makeConstraints { make in
            make.top.equalTo(showTab2.snp.bottom).offset(20)
            make.bottom.equalTo(showBottom!.snp.top)
            make.left.right.equalToSuperview()
        }
        
        signupContainer.addSubview(signupTableView)
        signupTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setIntroduceData() {
        
        var row: IconTextRow = IconTextRow()
        
        row = IconTextRow(title: "比賽開始日期", icon: "calendar_svg", show: "\(table!.match_start_show)(\(table!.match_start_weekday))")
        iconTextRows.append(row)
        row = IconTextRow(title: "比賽結束日期", icon: "calendar_svg", show: "\(table!.match_end.noSec())(\(table!.match_end_weekday))")
        iconTextRows.append(row)
        row = IconTextRow(title: "報名開始日期", icon: "calendar_svg", show: "\(table!.signup_start.noSec())(\(table!.signup_start_weekday))")
        iconTextRows.append(row)
        row = IconTextRow(title: "報名結束日期", icon: "calendar_svg", show: "\(table!.signup_end.noSec())(\(table!.signup_end_weekday))")
        iconTextRows.append(row)
        row = IconTextRow(title: "比賽地點", icon: "city_svg", show: table!.city_name)
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
        
        self.showTop2!.setTitle(table!.name)
        //introduceNameLbl.text = table!.name
    }
    
    func setContentWeb() {
        let content: String = "<html><HEAD><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no\">"+self.body_css+"</HEAD><body>"+table!.content+"</body></html>"
        
        contentWebView.loadHTMLString(content, baseURL: nil)
    }
    
    func setSignupData() {
        
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
                            self.setSignupData()
                            
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
            contentContainer.removeFromSuperview()
            signupContainer.removeFromSuperview()
            initIntroduce()

            introduceTableView.reloadData()
            showBottom!.showButton(parent: self.view, isShowSubmit: true, isShowLike: false, isShowCancel: false)

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
}

extension ShowMatchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int = 0
        if tableView == introduceTableView {
            count = iconTextRows.count
        } else if (tableView == signupTableView) {
            count = table!.matchGroups.count
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == introduceTableView {
            let cell: OneLineCell = tableView.dequeueReusableCell(withIdentifier: "OneLineCell", for: indexPath) as! OneLineCell
            
            let row: IconTextRow = iconTextRows[indexPath.row]
            cell.update(icon: row.icon, title: row.title, content: row.show)
            cell.setSelectedBackgroundColor()
            
            return cell
        } else if tableView == signupTableView {
            let cell: OneLineCell = tableView.dequeueReusableCell(withIdentifier: "OneLineCell", for: indexPath) as! OneLineCell
            
            let row: IconTextRow = iconTextRows[indexPath.row]
            cell.update(icon: row.icon, title: row.title, content: row.show)
            cell.setSelectedBackgroundColor()
            
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
