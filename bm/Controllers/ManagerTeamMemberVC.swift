//
//  ManagerTeamMemberVC.swift
//  bm
//
//  Created by ives on 2022/10/30.
//  Copyright © 2022 bm. All rights reserved.
//

import Foundation

class ManagerTeamMemberVC: BaseViewController {
    
    lazy var tableView: MyTable2VC<MemberTeamMemberCell, TeamMemberTable> = {
        let tableView = MyTable2VC<MemberTeamMemberCell, TeamMemberTable>(didSelect: didSelect(item:at:), selected: tableViewSetSelected(row:))
        return tableView
    }()
    
    var showTop: ShowTop2?
    
    var teamMemberTables: [TeamMemberTable] = [TeamMemberTable]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        showTop = ShowTop2(delegate: self)
        showTop!.setAnchor(parent: self.view)
        showTop!.setTitle(title: "球隊隊員")
        
        tableView.anchor(parent: view, showTop: showTop!)
        
        //setupBottomThreeView()
        
//        let cellNibName = UINib(nibName: "MemberCoinListCell", bundle: nil)
//        tableView.register(cellNibName, forCellReuseIdentifier: "MemberCoinListCell")
        
        panelHeight = 500
        
        refresh()
    }
    
    override func refresh() {
        
        page = 1
        getDataFromServer()
        //getDataStart(page: page, perPage: PERPAGE)
    }
    
    func getDataFromServer() {
        Global.instance.addSpinner(superView: self.view)
        
        MemberService.instance.MemberCoinList(member_token: Member.instance.token, page: page, perPage: PERPAGE) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if (success) {
                self.showTableView(tableView: self.tableView, jsonData: MemberService.instance.jsonData!)
            }
        }
    }
    
    func didSelect<T: TeamMemberTable>(item: T, at indexPath: IndexPath) {
        
    }
    
    func tableViewSetSelected(row: TeamMemberTable)-> Bool {
        return false
    }
    
}

class MemberTeamMemberCell: BaseCell<TeamMemberTable> {
    
    let noLbl: SuperLabel = {
        let view = SuperLabel()
        view.setTextGeneral()
        
        return view
    }()
    
    let nameLbl: SuperLabel = {
        let view = SuperLabel()
        view.setTextGeneral()
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView() {
        backgroundColor = UIColor(MY_BLACK)
        setAnchor()
    }
    
    func setAnchor() {
        
        self.contentView.addSubview(noLbl)
        noLbl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
        
        self.contentView.addSubview(nameLbl)
        nameLbl.snp.makeConstraints { make in
            make.left.equalTo(noLbl.snp.right).offset(12)
            make.centerY.equalToSuperview()
        }
    }
    
    override func setSelectedBackgroundColor() {
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(CELL_SELECTED1)
        selectedBackgroundView = bgColorView
    }
}

