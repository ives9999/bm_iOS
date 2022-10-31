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
        let tableView = MyTable2VC<MemberTeamMemberCell, MemberTeamMemberCell>(didSelect: didSelect(item:at:), selected: tableViewSetSelected(row:))
        return tableView
    }()
    
    var teamMemberTables: [TeamMemberTable] = [TeamMemberTable]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        top.setTitle(title: "球隊隊員")
        top.delegate = self
        
        tableView.anchor(parent: view, top: top, bottomThreeView: bottomThreeView)
        
        setupBottomThreeView()
        
//        let cellNibName = UINib(nibName: "MemberCoinListCell", bundle: nil)
//        tableView.register(cellNibName, forCellReuseIdentifier: "MemberCoinListCell")
        
        panelHeight = 500
        
        refresh()
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

