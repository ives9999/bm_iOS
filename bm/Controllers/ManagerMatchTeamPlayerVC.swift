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
                MatchTeamService.instance.jsonData?.prettyPrintedJSONString
                let b: Bool = self.tableView.parseJSON(jsonData: MatchTeamService.instance.jsonData)
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
    
    let avatarIV: Avatar = {
        let view = Avatar()
        return view
    }()
    
    let dataContainer: UIView = UIView()
    
    let nameLbl: SuperLabel = {
        let view = SuperLabel()
        view.setTextGeneral()
        view.text = "xxx"
        
        return view
    }()
    
    let createdAtLbl: SuperLabel = {
        let view = SuperLabel()
        view.textColor = UIColor(MY_WHITE)
        view.setTextGeneral()
        view.text = "xxx"
        
        return view
    }()
    
    let deleteIV: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "delete")
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
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
        
        self.contentView.addSubview(avatarIV)
        avatarIV.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalTo(noLbl.snp.right).offset(12)
            make.width.height.equalTo(48)
            make.centerY.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12)
        }
        
        self.contentView.addSubview(dataContainer)
        //dataContainer.backgroundColor = UIColor.blue
        dataContainer.snp.makeConstraints { make in
            make.left.equalTo(avatarIV.snp.right).offset(18)
            make.top.equalToSuperview().offset(3)
            make.centerY.equalToSuperview()
        }
        
        self.dataContainer.addSubview(nameLbl)
        nameLbl.snp.makeConstraints { make in
            make.top.equalTo(avatarIV.snp.top).offset(4)
            make.left.equalToSuperview()
        }
        
        self.dataContainer.addSubview(createdAtLbl)
        createdAtLbl.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.bottom.equalTo(avatarIV.snp.bottom).offset(-4)
        }
        
        self.contentView.addSubview(deleteIV)
        deleteIV.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.width.equalTo(25)
            make.height.equalTo(25)
        }
        
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
