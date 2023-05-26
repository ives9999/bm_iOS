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
                //TeamService.instance.jsonData?.prettyPrintedJSONString
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
    
    var createdAtLbl: SuperLabel = {
        let view = SuperLabel()
        view.textColor = UIColor(hex: MY_WHITE, alpha: 0.7)
        view.text = "2023-08-01 08:00"
        
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
    
    var matchTimeLbl: SuperLabel = {
        let view = SuperLabel()
        view.textColor = UIColor(hex: MY_WHITE, alpha: 0.7)
        view.text = "2023-08-01 08:00 ~ 2023-08-01 18:00"
        
        return view
    }()
    
    let dot1: UIView = Dot2()
    
    let matchGroupLbl: SuperLabel = {
        let view = SuperLabel()
        view.textColor = UIColor(hex: MY_WHITE, alpha: 0.7)
        view.text = "社會組女雙"
        
        return view
    }()
    
    let dot2: UIView = Dot2()
    
    let priceLbl: SuperLabel = {
        let view = SuperLabel()
        view.textColor = UIColor(hex: MY_WHITE, alpha: 0.7)
        view.text = "1000元"
        
        return view
    }()
    
    let dot3: UIView = Dot2()
    
    let groupLimitLbl: SuperLabel = {
        let view = SuperLabel()
        view.textColor = UIColor(hex: MY_WHITE, alpha: 0.7)
        view.text = "10人"
        
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
    
    let signupIcon: IconView2 = {
        let view = IconView2(icon: "check_svg")
        
        return view
    }()
    
    let teamMemberIcon: IconView2 = {
        let view = IconView2(icon: "member_svg")
        
        return view
    }()
    
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
        signupIcon.delegate = self
        teamMemberIcon.delegate = self
        
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
            
            view1.addSubview(createdAtLbl)
            createdAtLbl.snp.makeConstraints { make in
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
        
            mainContainerView.addSubview(matchTimeLbl)
            matchTimeLbl.snp.makeConstraints { make in
                make.top.equalTo(nameLbl.snp.bottom).offset(12)
                make.left.equalToSuperview()
            }
        
            let partContainer:UIView = UIView()
            //partContainer.backgroundColor = UIColor.red
            mainContainerView.addSubview(partContainer)
            partContainer.snp.makeConstraints { make in
                make.top.equalTo(matchTimeLbl.snp.bottom).offset(12)
                make.left.right.equalToSuperview()
                make.height.equalTo(30)
                make.bottom.equalToSuperview().offset(-12)
            }
        
                partContainer.addSubview(dot1)
                dot1.snp.makeConstraints { make in
                    make.centerY.equalToSuperview()
                    make.left.equalToSuperview()
                }

                partContainer.addSubview(matchGroupLbl)
                matchGroupLbl.snp.makeConstraints { make in
                    make.left.equalTo(dot1.snp.right).offset(6)
                    make.centerY.equalToSuperview()
                }
        
                partContainer.addSubview(dot2)
                dot2.snp.makeConstraints { make in
                    make.left.equalTo(matchGroupLbl.snp.right).offset(16)
                    make.centerY.equalToSuperview()
                }
            
                partContainer.addSubview(priceLbl)
                priceLbl.snp.makeConstraints { make in
                    make.left.equalTo(dot2.snp.right).offset(6)
                    make.centerY.equalToSuperview()
                }
            
                partContainer.addSubview(dot3)
                dot3.snp.makeConstraints { make in
                    make.left.equalTo(priceLbl.snp.right).offset(16)
                    make.centerY.equalToSuperview()
                }
            
                partContainer.addSubview(groupLimitLbl)
                groupLimitLbl.snp.makeConstraints { make in
                    make.left.equalTo(dot3.snp.right).offset(6)
                    make.centerY.equalToSuperview()
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
            
            iconContainerView.addSubview(signupIcon)
            signupIcon.snp.makeConstraints { make in
                make.left.equalTo(deleteIcon.snp.right).offset(8)
                make.centerY.equalToSuperview()
                make.height.width.equalTo(40)
            }
            
            iconContainerView.addSubview(teamMemberIcon)
            teamMemberIcon.snp.makeConstraints { make in
                make.left.equalTo(signupIcon.snp.right).offset(8)
                make.centerY.equalToSuperview()
                make.height.width.equalTo(40)
            }
        
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
            noLbl.text = String(item!.no) + "."
            createdAtLbl.text = item!.created_at.noSec()
        }
        
        if item != nil && item!.matchTable != nil {
            matchTimeLbl.text = item!.matchTable!.match_time_show
            nameLbl.text = item?.matchTable?.name
        }
        
        if item != nil && item!.matchGroupTable != nil {
            matchGroupLbl.text = item!.matchGroupTable!.name
            groupLimitLbl.text = "\(item!.matchGroupTable!.limit)組"
            matchGroupLbl.text = item!.matchGroupTable!.name
        }
        
        if item != nil && item!.matchGroupTable != nil && item!.matchGroupTable!.productPrice != nil {
            priceLbl.text = "NT$\(item!.matchGroupTable!.productPrice!.price_member)元"
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
        case "check_svg":
            myDelegate?.cellSignup(row: item!)
        case "member_svg":
            myDelegate?.cellTeamMember(row: item!)
        default:
            myDelegate?.cellEdit(row: item!)
        }
    }
}

extension ManagerMatchCell: ShowButton2Delegate {
    func pressed() {
        guard let superView = self.superview as? UITableView else { return }
        myDelegate?.didSelect(item: item, at: superView.indexPath(for: self)!)
    }
}
