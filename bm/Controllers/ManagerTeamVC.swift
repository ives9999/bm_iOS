//
//  ManagerTeamVC.swift
//  bm
//
//  Created by ives on 2021/11/19.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation
import SCLAlertView

class ManagerTeamVC: BaseViewController {
    
    var showTop2: ShowTop2?
    
    var showTab2: ShowTab2 = {
        let view: ShowTab2 = ShowTab2()
        
        return view
    }()
    
    lazy var tableView2: MyTable2VC<ManagerTeamCell, TeamTable, ManagerTeamVC> = {
        let tableView2 = MyTable2VC<ManagerTeamCell, TeamTable, ManagerTeamVC>(selectedClosure: tableViewSetSelected(row:), getDataClosure: getDataFromServer(page:), myDelegate: self)
        
        return tableView2
    }()
    
    var rows: [TeamTable] = [TeamTable]()
    var infoLbl: SuperLabel?
    
    var mysTable: TeamsTable?
    var manager_token: String? = nil
    
    //var isReload: Bool = true

    override func viewDidLoad() {
        
        able_type = "team"
        dataService = TeamService.instance
        
        if (manager_token != nil) {
            params["manager_token"] = manager_token!
        }
        //必須指定status，預設是只會出現上線的
        params["status"] = "online,offline"
        
        super.viewDidLoad()
        
        showTop2 = ShowTop2(delegate: self)
        showTop2!.setAnchor(parent: self.view)
        showTop2!.setTitle(title: "我的球隊")
        
        anchor()
        refresh()
    }
    
    func anchor() {
        
        showTop2 = ShowTop2(delegate: self)
        showTop2!.setAnchor(parent: self.view)
        
        tableView2.anchor(parent: self.view, showTop: showTop2!)
    }
    
    override func refresh() {
        
        page = 1
        tableView2.getDataFromServer(page: page)
        //getDataStart(page: page, perPage: PERPAGE)
    }
    
    func getDataFromServer(page: Int) {
        Global.instance.addSpinner(superView: self.view)
        
        TeamService.instance.getList(token: nil, _filter: params, page: page, perPage: tableView2.perPage) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if (success) {
                //TeamService.instance.jsonData?.prettyPrintedJSONString
                let b: Bool = self.tableView2.parseJSON(jsonData: TeamService.instance.jsonData)
                if !b && self.tableView2.msg.count == 0 {
                    self.infoLbl = self.view.setInfo(info: "目前尚無資料！！", topAnchor: self.showTop2!)
                } else {
                    self.infoLbl?.removeFromSuperview()
                    self.rows = self.tableView2.items
                }
                //self.showTableView(tableView: self.tableView, jsonData: TeamService.instance.jsonData!)
            }
        }
    }
    
//    func refresh<T: Table>(_ t: T.Type) {
//        rows.removeAll()
//
//        Global.instance.addSpinner(superView: self.view)
//        let params: [String: String] = ["token": token!, "member_token": Member.instance.token]
//        dataService.getOne(params: params) { (success) in
//            Global.instance.removeSpinner(superView: self.view)
//            if (success) {
//                let jsonData: Data = self.dataService.jsonData!
//                do {
//                    self.table = try JSONDecoder().decode(t, from: jsonData)
//                    if (self.table != nil) {
//                        if (self.table!.id == 0) {
//                            //token錯誤，所以無法解析
//                            self.warning("token錯誤，所以無法解析")
//                        } else {
//                            self.showTop2!.setTitle(title: self.table!.name)
//                            self.tableView2.reloadData()
//                        }
//                    }
//                } catch {
//                    self.warning(error.localizedDescription)
//                }
//            }
//        }
//    }
    
//    override func genericTable() {
//
//        do {
//            if (jsonData != nil) {
//                mysTable = try JSONDecoder().decode(TeamsTable.self, from: jsonData!)
//            } else {
//                warning("無法從伺服器取得正確的json資料，請洽管理員")
//            }
//        } catch {
//            warning("解析JSON字串時，得到空值，請洽管理員")
//        }
//
//        if (mysTable != nil) {
//            tables = mysTable!
//            if mysTable!.rows.count > 0 {
//                if (page == 1) {
//                    lists1 = [TeamTable]()
//                }
//                lists1 += mysTable!.rows
//            } else {
//                view.setInfo(info: "目前暫無球隊", topAnchor: topView)
//            }
//        }
//    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ManagerTeamCell
//        //cell.blacklistCellDelegate = self
//
//        let row = lists1[indexPath.row] as? TeamTable
//        if (row != nil) {
//            row!.filterRow()
//            cell.cellDelegate = self
//            cell.forRow(row: row!)
//        }
//
//        return cell
//    }
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        let row = lists1[indexPath.row] as? TeamTable
//        if row != nil {
//            toShowTeam(token: row!.token)
//        }
//    }
    
    func tableViewSetSelected(row: TeamTable)-> Bool {
        return false
    }
    
    override func cellEdit(row: Table) {
        toEditTeam(token: row.token, _delegate: self)
    }
    
    override func cellSignup(row: Table) {
        toManagerSignup(able_type: able_type, able_token: row.token, able_title: row.name)
    }
    
    override func cellTeamMember(row: Table) {
        toManagerTeamMember(token: row.token)
    }
    
    override func cellDelete(row: Table) {
        msg = "是否確定要刪除此球隊？"
        warning(msg: msg, closeButtonTitle: "取消", buttonTitle: "刪除") {
            Global.instance.addSpinner(superView: self.view)
            self.dataService.delete(token: row.token, type: self.able_type) { success in
                Global.instance.removeSpinner(superView: self.view)
                if (success) {
                    do {
                        self.jsonData = self.dataService.jsonData
                        if (self.jsonData != nil) {
                            let successTable: SuccessTable = try JSONDecoder().decode(SuccessTable.self, from: self.jsonData!)
                            if (!successTable.success) {
                                self.warning(successTable.msg)
                            } else {
                                self.refresh()
                            }
                        } else {
                            self.warning("無法從伺服器取得正確的json資料，請洽管理員")
                        }
                    } catch {
                        self.msg = "解析JSON字串時，得到空值，請洽管理員"
                        self.warning(self.msg)
                    }
                } else {
                    self.warning("刪除失敗，請洽管理員")
                }
            }
        }
    }
    
    override func addPressed() {
        toEditTeam(token: "", _delegate: self)
    }
    
    override func didSelect<U>(item: U, at indexPath: IndexPath) {
        let _item: TeamTable = item as! TeamTable
        toShowTeam(token: _item.token)
    }
}

class ManagerTeamCell: BaseCell<TeamTable, ManagerTeamVC> {
        
//    @IBOutlet weak var editIcon: SuperButton!
//    @IBOutlet weak var deleteIcon: SuperButton!
//    @IBOutlet weak var signupIcon: SuperButton!
//    @IBOutlet weak var teamMemberIcon: SuperButton!
    
    let noLbl: SuperLabel = {
        let view = SuperLabel()
        view.setTextGeneral()
        view.text = "100."
        
        return view
    }()
    
    let mainContainerView: UIView = UIView()
    
    let featuredIV: Featured = {
        let view = Featured()
        return view
    }()
    
    let nameLbl: SuperLabel = {
        let view = SuperLabel()
        view.setTextTitle()
        
        return view
    }()
    
    let iconContainerView: UIView = UIView()
    
    let editIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "edit1")
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    let deleteIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "delete")
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    let signupIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "signup")
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    let teamMemberIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "member")
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#FFFFFF", alpha: 0.2)
        return view
    }()
    
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
        
        let tapEdit: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(editPressed))
        tapEdit.cancelsTouchesInView = true
        editIcon.addGestureRecognizer(tapEdit)
        
        let tapDelete: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(deletePressed))
        tapDelete.cancelsTouchesInView = true
        deleteIcon.addGestureRecognizer(tapDelete)
        
        let tapSignup: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(signupPressed))
        tapSignup.cancelsTouchesInView = true
        signupIcon.addGestureRecognizer(tapSignup)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(teamMemberPressed))
        tap.cancelsTouchesInView = true
        teamMemberIcon.addGestureRecognizer(tap)
    }
    
    func anchor() {
        
        self.contentView.addSubview(noLbl)
        noLbl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        self.contentView.addSubview(mainContainerView)
        //mainContainerView.backgroundColor = UIColor.blue
        mainContainerView.snp.makeConstraints { make in
            make.left.equalTo(noLbl.snp.right).offset(12)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(12)
            //make.bottom.equalToSuperview().offset(4)
            //make.height .equalTo(130)
        }
        
            mainContainerView.addSubview(featuredIV)
            featuredIV.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(12)
                make.left.equalToSuperview()
                make.width.height.equalTo(120)
                make.centerY.equalToSuperview()
                make.bottom.equalToSuperview().offset(-6)
            }

            mainContainerView.addSubview(nameLbl)
            nameLbl.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalTo(featuredIV.snp.right).offset(12)
            }
        
        self.contentView.addSubview(iconContainerView)
        //iconContainerView.backgroundColor = UIColor.red
        iconContainerView.snp.makeConstraints { make in
            make.left.equalTo(noLbl.snp.right).offset(12)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(mainContainerView.snp.bottom)
            //make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
        
        iconContainerView.addSubview(editIcon)
        editIcon.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.width.equalTo(35)
        }
        
        iconContainerView.addSubview(deleteIcon)
        deleteIcon.snp.makeConstraints { make in
            make.left.equalTo(editIcon.snp.right).offset(12)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(35)
        }
        
        iconContainerView.addSubview(signupIcon)
        signupIcon.snp.makeConstraints { make in
            make.left.equalTo(deleteIcon.snp.right).offset(12)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(35)
        }
        
        iconContainerView.addSubview(teamMemberIcon)
        teamMemberIcon.snp.makeConstraints { make in
            make.left.equalTo(signupIcon.snp.right).offset(12)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(35)
        }
        
        self.contentView.addSubview(separator)
        separator.snp.makeConstraints { make in
            make.top.equalTo(iconContainerView.snp.bottom).offset(12)
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    override func configureSubViews() {
        
        super.configureSubViews()
        noLbl.text = String(item!.no) + "."
        
        if item != nil && item!.featured_path.count > 0 {
            self.featuredIV.path(item!.featured_path)
        }
        
        nameLbl.text = (item != nil) ? item!.name : ""
    }
    
    @objc func editPressed(_ sender: UIGestureRecognizer) {
        myDelegate?.cellEdit(row: item!)
    }
    
    @objc func deletePressed(_ sender: UIGestureRecognizer) {
        myDelegate?.cellDelete(row: item!)
    }
    
    @objc func signupPressed(_ sender: UIGestureRecognizer) {
        myDelegate?.cellSignup(row: item!)
    }
    
    @objc func teamMemberPressed(_ sender: UIGestureRecognizer) {
        myDelegate?.cellTeamMember(row: item!)
    }
}
