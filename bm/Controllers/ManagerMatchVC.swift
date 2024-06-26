//
//  MemberMatchVC.swift
//  bm
//
//  Created by ives on 2023/5/21.
//  Copyright © 2023 bm. All rights reserved.
//

import Foundation

class ManagerMatchVC: BaseViewController {
    
    var manager_token: String? = nil
    
    var showTop2: ShowTop2?
    
    lazy var tableView2: MyTable2VC<ManagerMatchCell, MatchTeamTable, ManagerMatchVC> = {
        let tableView = MyTable2VC<ManagerMatchCell, MatchTeamTable, ManagerMatchVC>(selectedClosure: tableViewSetSelected(row:), getDataClosure: getDataFromServer, myDelegate: self, isRefresh: false)
        
        return tableView
    }()
    
    var rows: [MatchTeamTable] = [MatchTeamTable]()
    
    override func viewDidLoad() {
        
        dataService = MatchTeamService.instance
        super.viewDidLoad()
        
        showTop2 = ShowTop2(delegate: self)
        showTop2!.anchor(parent: self.view)
        showTop2!.setTitle("管理賽事")
        
        if (manager_token != nil) {
            params["manager_token"] = manager_token!
        }
        //必須指定status，預設是只會出現上線的
        params["status"] = "online,offline"
        
        view.backgroundColor = UIColor(MY_BLACK)
        
        tableView2.anchor(parent: view, showTop: showTop2!)
        
        refresh()
    }
    
    override func refresh() {
        
        page = 1
        tableView2.getDataFromServer(page: page)
        //getDataStart(page: page, perPage: PERPAGE)
    }
    
    func getDataFromServer(page: Int) {
        Global.instance.addSpinner(superView: self.view)
        
        dataService.getList(token: nil, _filter: params, page: page, perPage: tableView2.perPage) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if (success) {
                //self.dataService.jsonData?.prettyPrintedJSONString
                let b: Bool = self.tableView2.parseJSON(jsonData: self.dataService.jsonData)
                if !b && self.tableView2.msg.count == 0 {
                    self.view.setInfo(info: "目前尚無資料！！", topAnchor: self.showTop2!)
                } else {
                    self.rows = self.tableView2.items
                }
                //self.showTableView(tableView: self.tableView, jsonData: TeamService.instance.jsonData!)
            }
        }
    }
    
    override func cellEdit(row: Table) {
        if let _row: MatchTeamTable = row as? MatchTeamTable {
            if _row.matchGroupTable != nil {
                toMatchTeamSignup(match_group_token: _row.matchGroupTable!.token, token: row.token)
            }
        }
    }
    
    override func cellDelete(row: Table) {
        //print(row)
        
        //1.超過報名時間無法刪除
        //2.繳費完無法刪除，只能棄賽
        
        var canDelete: Bool = false
        if let _row: MatchTeamTable = row as? MatchTeamTable {
            
            var isPay: Bool = false
            if _row.orderTable != nil && _row.orderTable!.process == "complete" {
                isPay = true
            }
            
            var isInterval: Bool = false
            if let signupStartDate: Date = _row.matchTable!.signup_start.toDateTime(), let signupEndDate: Date = _row.matchTable!.signup_end.toDateTime() {
                let now: Date = Date()
                if now.isGreaterThan(signupStartDate) && now.isSmallerThan(signupEndDate) {
                    isInterval = true
                }
            }
            
            if isPay {
                warning("已經報名且繳費，無法刪除隊伍，只能棄權")
            }
            
            if !isInterval {
                warning("已經超過報名截止時間，無法刪除隊伍")
            }
            
            if isInterval && !isPay {
                canDelete = true
            }
        }
        
        if canDelete {
            warning(msg: "是否確定刪除", closeButtonTitle: "取消", buttonTitle: "刪除") {
                self.dataService.delete(token: row.token, type: "", status: "delete") { success in
                    if success {
                        self.refresh()
                    } else {
                        self.info("刪除失敗")
                    }
                }
            }
        }
    }
    
    func cellPay(row: Table) {
        if let _row: MatchTeamTable = row as? MatchTeamTable {
            
            //已經付款
            if _row.orderTable != nil {
                toPayment(order_token: _row.orderTable!.token, source: "match")
            //如果還沒付款
            } else {
                
                guard let matchTable: MatchTable = _row.matchTable else { return }
                
                var isInterval: Bool = false
                if let signupStartDate: Date = _row.matchTable!.signup_start.toDateTime(), let signupEndDate: Date = _row.matchTable!.signup_end.toDateTime() {
                    let now: Date = Date()
                    if now.isGreaterThan(signupStartDate) && now.isSmallerThan(signupEndDate) {
                        isInterval = true
                    }
                }
                
                if isInterval {
                    if _row.matchGroupTable != nil && _row.matchGroupTable!.productTable != nil && _row.matchGroupTable!.productPriceTable != nil {
                        
                        self.toOrder(
                            login: { vc in vc.toLogin() },
                            register: { vc in vc.toRegister() },
                            product_token: _row.matchGroupTable!.productTable!.token,
                            product_price_id: _row.matchGroupTable!.productPriceTable!.id
                        )
                    }
                } else {
                    warning("已經超過報名期限，無法付款，您的報名沒有成功")
                }
            }
        }
    }
    
    override func cellTeamMember(row: Table) {
        toManagerMatchPlayer(match_team_token: row.token)
    }
    
    override func didSelect<U>(item: U, at indexPath: IndexPath) {
        let _item: MatchTeamTable = item as! MatchTeamTable
        if _item.matchTable != nil {
            toShowMatch(token: _item.matchTable!.token)
        }
    }
    
    func tableViewSetSelected(row: MatchTeamTable)-> Bool {
        return false
    }
}

class ManagerMatchCell: BaseCell<MatchTeamTable, ManagerMatchVC> {
    
    let noLbl: SuperLabel = {
        let view = SuperLabel()
        //view.setTextGeneral()
        view.setTextColor(UIColor(MY_GREEN))
        view.setTextBold()
        view.text = "100."
        
        return view
    }()
    
    var teamNameLbl: SuperLabel = {
        let view = SuperLabel()
        view.textColor = UIColor(hex: MY_WHITE, alpha: 0.7)
        view.text = "金剛隊"
        
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
        view.text = "羽球密碼盃"
        
        return view
    }()
    
    let matchStartITT: IconTextText2 = {
        let view = IconTextText2()
        view.setIcon("calendar_start_svg")
        view.setTitle("比賽開始時間")
        
        return view
    }()
    
    let matchEndITT: IconTextText2 = {
        let view = IconTextText2()
        view.setIcon("calendar_end_svg")
        view.setTitle("比賽結束時間")
        
        return view
    }()
    
    let matchGroupITT: IconTextText2 = {
        let view = IconTextText2()
        view.setIcon("ball_svg")
        view.setTitle("賽事組別")
        
        return view
    }()
    
    let priceITT: IconTextText2 = {
        let view = IconTextText2()
        view.setIcon("money_circle_svg")
        view.setTitle("報名費")
        
        return view
    }()
    
    let groupLimitITT: IconTextText2 = {
        let view = IconTextText2()
        view.setIcon("group_svg")
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
    
    var createdAtITT: IconTextText2 = {
        let view = IconTextText2()
        view.setTitle("報名時間")
        view.setIcon("calendar_svg")
        
        return view
    }()
    
    let iconContainerView: UIView = UIView()
    
    let editIcon: IconView2 = {
        let view = IconView2(icon: "edit_svg")
        
        return view
    }()
    
    let deleteIcon: IconView2 = {
        let view = IconView2(icon: "delete_svg")
        
        return view
    }()
    
    let payIcon: IconView2 = {
        let view = IconView2(icon: "card_svg")
        
        return view
    }()
    
//    let teamMemberIcon: IconView2 = {
//        let view = IconView2(icon: "member_svg")
//
//        return view
//    }()
    
    let showButton2: ShowButton2 = ShowButton2()
    
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
        super.commonInit()
        setAnchor()
        
        editIcon.delegate = self
        deleteIcon.delegate = self
        payIcon.delegate = self
        //teamMemberIcon.delegate = self
        
        showButton2.delegate = self
        
        //self.backgroundColor = UIColor.red
        
        //let deleteGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(deleteThis))
        //deleteGR.cancelsTouchesInView = false
        //deleteIV.isUserInteractionEnabled = true
        //deleteIV.addGestureRecognizer(deleteGR)
    }
    
    func setAnchor() {
        
        let view1: UIView = UIView()
        
        self.contentView.addSubview(view1)
        //view1.backgroundColor = UIColor.brown
        view1.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(30)
        }
        
            view1.addSubview(noLbl)
            noLbl.snp.makeConstraints { make in
            
                make.left.equalToSuperview()
                make.centerY.equalToSuperview()
            }
            
            view1.addSubview(teamNameLbl)
            teamNameLbl.snp.makeConstraints { make in
                make.right.equalToSuperview()
                make.centerY.equalToSuperview()
            }
        
        self.contentView.addSubview(separator)
        separator.snp.makeConstraints { make in
            make.top.equalTo(view1.snp.bottom)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            //make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        self.contentView.addSubview(mainContainerView)
        //mainContainerView.backgroundColor = UIColor.blue
        mainContainerView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(separator.snp.bottom).offset(12)
            //make.bottom.equalToSuperview().offset(4)
            //make.height .equalTo(130)
        }

            mainContainerView.addSubview(nameLbl)
            nameLbl.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.left.equalToSuperview()
            }
        
            mainContainerView.addSubview(matchStartITT)
            matchStartITT.snp.makeConstraints { make in
                make.top.equalTo(nameLbl.snp.bottom).offset(12)
                make.left.equalToSuperview()
            }
        
            mainContainerView.addSubview(matchEndITT)
            matchEndITT.snp.makeConstraints { make in
                make.top.equalTo(matchStartITT.snp.bottom).offset(12)
                make.left.equalToSuperview()
            }
    
            mainContainerView.addSubview(matchGroupITT)
            matchGroupITT.snp.makeConstraints { make in
                make.top.equalTo(matchEndITT.snp.bottom).offset(12)
                make.left.equalToSuperview()
            }
        
            mainContainerView.addSubview(priceITT)
            priceITT.snp.makeConstraints { make in
                make.top.equalTo(matchGroupITT.snp.bottom).offset(12)
                make.left.equalToSuperview()
            }
            
            mainContainerView.addSubview(groupLimitITT)
            groupLimitITT.snp.makeConstraints { make in
                make.top.equalTo(priceITT.snp.bottom).offset(12)
                make.left.equalToSuperview()
            }
        
            mainContainerView.addSubview(signupStartITT)
            signupStartITT.snp.makeConstraints { make in
                make.top.equalTo(groupLimitITT.snp.bottom).offset(12)
                make.left.equalToSuperview()
            }
        
            mainContainerView.addSubview(signupEndITT)
            signupEndITT.snp.makeConstraints { make in
                make.top.equalTo(signupStartITT.snp.bottom).offset(12)
                make.left.equalToSuperview()
            }
        
            mainContainerView.addSubview(createdAtITT)
            createdAtITT.snp.makeConstraints { make in
                make.top.equalTo(signupEndITT.snp.bottom).offset(12)
                make.left.equalToSuperview()
                make.bottom.equalToSuperview().offset(-12)
            }
        
        self.contentView.addSubview(iconContainerView)
        //iconContainerView.backgroundColor = UIColor.red
        iconContainerView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(mainContainerView.snp.bottom).offset(13)
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
        
            iconContainerView.addSubview(editIcon)
            editIcon.snp.makeConstraints { make in
                make.left.equalToSuperview()
                make.centerY.equalToSuperview()
                make.height.width.equalTo(40)
            }
            
            iconContainerView.addSubview(deleteIcon)
            deleteIcon.snp.makeConstraints { make in
                make.left.equalTo(editIcon.snp.right).offset(8)
                make.centerY.equalToSuperview()
                make.height.width.equalTo(40)
            }
            
            iconContainerView.addSubview(payIcon)
            payIcon.snp.makeConstraints { make in
                make.left.equalTo(deleteIcon.snp.right).offset(8)
                make.centerY.equalToSuperview()
                make.height.width.equalTo(40)
            }
            
//            iconContainerView.addSubview(teamMemberIcon)
//            teamMemberIcon.snp.makeConstraints { make in
//                make.left.equalTo(payIcon.snp.right).offset(8)
//                make.centerY.equalToSuperview()
//                make.height.width.equalTo(40)
//            }
        
        iconContainerView.addSubview(showButton2)
        showButton2.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(160)
        }
    }
    
    override func configureSubViews() {
        super.configureSubViews()
        
        if item != nil {
            noLbl.text = item!.no.toTwoString() + "."
            teamNameLbl.text = item!.name
            createdAtITT.setShow(item!.created_at.noSec())
            //showButton2.idx = item!.no - 1
        }
        
        if item != nil && item!.matchTable != nil {
            nameLbl.text = item?.matchTable?.name
            matchStartITT.setShow(item!.matchTable!.match_start_show)
            matchEndITT.setShow(item!.matchTable!.match_end_show)
            signupStartITT.setShow(item!.matchTable!.signup_start_show)
            signupEndITT.setShow(item!.matchTable!.signup_end_show)
        }
        
        if item != nil && item!.matchGroupTable != nil {
            matchGroupITT.setShow(item!.matchGroupTable!.name)
            groupLimitITT.setShow("\(item!.matchGroupTable!.limit)組")
        }
        
        if item != nil && item!.matchGroupTable != nil && item!.matchGroupTable!.productPriceTable != nil {
            priceITT.setShow("NT$\(item!.matchGroupTable!.productPriceTable!.price_member)元")
        }
    }
    
    @objc func deleteThis(_ sender: UIView) {
        //myDelegate?.deleteMemberTeam(row: item!)
    }
}

extension ManagerMatchCell: IconView2Delegate {
    
    func iconPressed(icon: String) {
        switch icon {
        case "edit_svg" :
            myDelegate?.cellEdit(row: item!)
        case "delete_svg":
            myDelegate?.cellDelete(row: item!)
        case "card_svg":
            myDelegate?.cellPay(row: item!)
//        case "member_svg":
//            myDelegate?.cellTeamMember(row: item!)
        default:
            myDelegate?.cellEdit(row: item!)
        }
    }
}

extension ManagerMatchCell: ShowButton2Delegate {
    
    func showButtonPressed() {
        guard let superView = self.superview as? UITableView else { return }
        myDelegate?.didSelect(item: item, at: superView.indexPath(for: self)!)
    }
}
