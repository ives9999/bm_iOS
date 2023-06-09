//
//  ManagerMatchTeamPlayerVC.swift
//  bm
//
//  Created by ives on 2023/6/5.
//  Copyright © 2023 bm. All rights reserved.
//

import Foundation

class ManagerMatchTeamPlayerVC: BaseViewController {
    
    var match_team_token: String? = nil
    
    lazy var tableView: MyTable2VC<ManagerMatchTeamPlayerCell, MatchPlayerTable, ManagerMatchTeamPlayerVC> = {
        let tableView = MyTable2VC<ManagerMatchTeamPlayerCell, MatchPlayerTable, ManagerMatchTeamPlayerVC>(selectedClosure: tableViewSetSelected(row:), getDataClosure: getDataFromServer(page:), myDelegate: self)
        return tableView
    }()
    
    var showTop: ShowTop2?
    
    var matchPlayerTables: [MatchPlayerTable] = [MatchPlayerTable]()
    
    var rows: [MatchPlayerTable] = [MatchPlayerTable]()
    
    var infoLbl: SuperLabel?
    
    //var items = [MatchPlayerTable]()
    
    override func viewDidLoad() {
        
        dataService = MatchTeamService.instance
        super.viewDidLoad()
        
        showTop = ShowTop2(delegate: self)
        showTop!.anchor(parent: self.view)
        showTop!.setTitle("球隊隊員")
        
        tableView.anchor(parent: view, showTop: showTop!)
        
        refresh()
    }
    
    override func refresh() {
        
        if (match_team_token == nil) {
            self.infoLbl = self.view.setInfo(info: "沒有此隊伍資料！！", topAnchor: self.showTop!)
            return
        }
        page = 1
        tableView.getDataFromServer(page: page)
        //getDataStart(page: page, perPage: PERPAGE)
    }
    
    func getDataFromServer(page: Int) {
        Global.instance.addSpinner(superView: self.view)
        
        //let params: [String: String] = ["token": match_team_token!]
        MatchTeamService.instance.teamPlayerList(token: match_team_token!, page: page, perPage: tableView.perPage) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if (success) {
                //MatchTeamService.instance.jsonData?.prettyPrintedJSONString
                let b: Bool = self.parseJSON(jsonData: MatchTeamService.instance.jsonData)
                if !b && self.tableView.msg.count == 0 {
                    self.infoLbl = self.view.setInfo(info: "目前尚無資料！！", topAnchor: self.showTop!)
                } else {
                    self.infoLbl?.removeFromSuperview()
                    self.rows = self.tableView.items
                }
                //self.showTableView(tableView: self.tableView, jsonData: TeamService.instance.jsonData!)
            }
        }
    }
    
    func parseJSON(jsonData: Data?)-> Bool {
        
        let _rows: [MatchPlayerTable] = genericTable2(jsonData: jsonData)
        if (_rows.count == 0) {
            return false
        } else {
            if (page == 1) {
                tableView.items = [MatchPlayerTable]()
            }
            tableView.items += _rows
            tableView.reloadData()
            tableView.endRefresh()
        }
        
        return true
    }
    
    func genericTable2(jsonData: Data?)-> [MatchPlayerTable] {
        
        var rows: [MatchPlayerTable] = [MatchPlayerTable]()
        do {
            if (jsonData != nil) {
                print(jsonData!.prettyPrintedJSONString)
                let tables2: MatchPlayerTables = try JSONDecoder().decode(MatchPlayerTables.self, from: jsonData!)
                if (tables2.success) {
                    if tables2.rows.count > 0 {
                        
                        for row in tables2.rows {
                            row.filterRow()
                        }
                        
                        if (page == 1) {
                            page = tables2.page
                            perPage = tables2.perPage
                            totalCount = tables2.totalCount
                            let _totalPage: Int = totalCount / perPage
                            totalPage = (totalCount % perPage > 0) ? _totalPage + 1 : _totalPage
                        }
                        
                        rows += tables2.rows
                        if self.showTop != nil && tables2.match_group != nil {
                            self.showTop!.setTitle(tables2.match_group!.name)
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
    
    func tableViewSetSelected(row: MatchPlayerTable)-> Bool {
        return false
    }
}

class ManagerMatchTeamPlayerCell: BaseCell<MatchPlayerTable, ManagerMatchTeamPlayerVC> {
    
    let noLbl: SuperLabel = {
        let view = SuperLabel()
        view.setTextGeneral()
        view.text = "100."
        
        return view
    }()
    
    let dataContainer: UIView = UIView()
    
    let nameLbl: SuperLabel = {
        let view = SuperLabel()
        view.setTextGeneral()
        view.text = "xxx"
        
        return view
    }()
    
    let ageLbl: SuperLabel = {
        let view = SuperLabel()
        view.setTextGeneral()
        view.text = "30歲"
        
        return view
    }()
    
    let mobileLbl: SuperLabel = {
        let view = SuperLabel()
        view.setTextGeneral()
        view.text = "0933454946"
        
        return view
    }()
    
    let emailLbl: SuperLabel = {
        let view = SuperLabel()
        view.setTextGeneral()
        view.text = "hank@gmail.com"
        
        return view
    }()
    
    let createdAtLbl: SuperLabel = {
        let view = SuperLabel()
        view.textColor = UIColor(MY_WHITE)
        view.setTextGeneral()
        view.text = "xxx"
        
        return view
    }()
    
//    let deleteIV: UIImageView = {
//        let view = UIImageView()
//        view.image = UIImage(named: "delete")
//        view.isUserInteractionEnabled = true
//        
//        return view
//    }()
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#FFFFFF", alpha: 0.2)
        return view
    }()
    
    //var thisDelegate: ManagerTeamMemberVC?
    
//    typealias deleteClosure = ((TeamMemberTable) -> Void)?
//    var delete: deleteClosure = nil
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.commonInit()
    }
    
    override func commonInit() {
        super.commonInit()
        anchor()
        
        //let deleteGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(deleteThis))
        //deleteIV.addGestureRecognizer(deleteGR)
    }
    
    func anchor() {
        
        self.contentView.addSubview(noLbl)
        noLbl.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        self.contentView.addSubview(dataContainer)
        //dataContainer.backgroundColor = UIColor.blue
        dataContainer.snp.makeConstraints { make in
            make.left.equalTo(noLbl.snp.right).offset(18)
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
        
        self.dataContainer.addSubview(nameLbl)
        nameLbl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.left.equalToSuperview()
        }
        
        self.dataContainer.addSubview(ageLbl)
        ageLbl.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalTo(nameLbl.snp.centerY)
        }
        
        self.dataContainer.addSubview(mobileLbl)
        mobileLbl.snp.makeConstraints { make in
            make.top.equalTo(nameLbl.snp.bottom).offset(12)
            make.left.equalToSuperview()
        }
        
        self.dataContainer.addSubview(emailLbl)
        emailLbl.snp.makeConstraints { make in
            make.top.equalTo(mobileLbl.snp.bottom).offset(12)
            make.left.equalToSuperview()
        }
        
        self.dataContainer.addSubview(createdAtLbl)
        createdAtLbl.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(emailLbl.snp.bottom).offset(12)
            make.bottom.equalToSuperview().offset(-12)
        }
        
//        self.contentView.addSubview(deleteIV)
//        deleteIV.snp.makeConstraints { make in
//            make.right.equalToSuperview().offset(-20)
//            make.centerY.equalToSuperview()
//            make.width.equalTo(25)
//            make.height.equalTo(25)
//        }
        
        self.contentView.addSubview(separator)
        separator.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    override func configureSubViews() {
        noLbl.text = String(item!.no) + "."
        
//        if item != nil && item!.memberTable != nil {
//            self.avatarIV.path(item!.memberTable!.featured_path)
//        }
        nameLbl.text = (item != nil) ? item!.name : ""
        ageLbl.text = (item != nil) ? "\(item!.age)歲" : ""
        mobileLbl.text = (item != nil) ? item!.mobile : ""
        emailLbl.text = (item != nil) ? item!.email : ""
        createdAtLbl.text = item?.created_at.noSec()
    }
    
//    @objc func deleteThis(_ sender: UIView) {
        //print(item?.token)
//        if thisDelegate != nil {
//            thisDelegate!.deleteTeamMember(row: item!)
//        }
        
//        myDelegate?.deleteTeamMember(row: item!)
//    }
    
    func setDeleteClickListener() {
        
    }
}

class MatchPlayerTables: Codable {
    var success: Bool = false
    var page: Int = -1
    var totalCount: Int = -1
    var perPage: Int = -1
    var match_group: MatchGroupTable? = nil
    var rows: [MatchPlayerTable] = [MatchPlayerTable]()
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decode(Bool.self, forKey: .success)
        page = try container.decode(Int.self, forKey: .page)
        totalCount = try container.decode(Int.self, forKey: .totalCount)
        perPage = try container.decode(Int.self, forKey: .perPage)
        match_group = try container.decodeIfPresent(MatchGroupTable.self, forKey: .match_group) ?? nil
        rows = try container.decode([MatchPlayerTable].self, forKey: .rows)
    }
}
