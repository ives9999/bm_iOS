//
//  MemberTeamListVC.swift
//  bm
//
//  Created by ives on 2022/12/17.
//  Copyright © 2022 bm. All rights reserved.
//

import Foundation

class MemberTeamListVC: BaseViewController {
    
    var showTop: ShowTop2?
    
    lazy var tableView: MyTable2VC<MemberTeamListCell, TeamMemberTable, MemberTeamListVC> = {
        let tableView = MyTable2VC<MemberTeamListCell, TeamMemberTable, MemberTeamListVC>(selected: tableViewSetSelected(row:), myDelegate: self)
        return tableView
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        showTop = ShowTop2(delegate: self)
        showTop!.setAnchor(parent: self.view)
        showTop!.setTitle(title: "參加球隊")
        
        view.backgroundColor = UIColor(MY_BLACK)
    }
    
    func tableViewSetSelected(row: TeamMemberTable)-> Bool {
        return false
    }
}

class MemberTeamListCell: BaseCell<TeamMemberTable, MemberTeamListVC> {
    
    let noLbl: SuperLabel = {
        let view = SuperLabel()
        view.textColor = UIColor(MY_WHITE)
        view.setTextGeneral()
        view.text = "100."
        
        return view
    }()
    
    let featuredIV: UIImageView = {
        let view = UIImageView()
        
        return view
    }()
    
    let dataContainer: UIView = {
        let view = UIView()
        
        return view
    }()
    
    let titleLbl: SuperLabel = {
        let view = SuperLabel()
        view.textColor = UIColor(MY_WHITE)
        view.setTextTitle()
        view.text = "xxx羽球隊"
        
        return view
    }()
    
    let cityBtn: CityButton = {
        let view = CityButton()
        
        return view
    }()
    
    let arenaBtn: CityButton = {
        let view = CityButton()
        
        return view
    }()
    
    let weekendLbl: SuperLabel = {
        let view = SuperLabel()
        view.textColor = UIColor(MY_WHITE)
        view.setTextGeneral()
        view.text = "星期二"
        
        return view
    }()
    
    let intervalLbl: SuperLabel = {
        let view = SuperLabel()
        view.textColor = UIColor(MY_WHITE)
        view.setTextGeneral()
        view.text = "17:00~19:00"
        
        return view
    }()
    
    let joinLbl: SuperLabel = {
        let view = SuperLabel()
        view.highlight()
        view.text = "加入時間："
        
        return view
    }()
    
    let joinTimeLbl: SuperLabel = {
        let view = SuperLabel()
        view.highlight()
        view.text = "2022-11-09 22:04(五)"
        
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
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().offset(16)
        }
        
        self.contentView.addSubview(featuredIV)
        featuredIV.snp.makeConstraints { make in
            make.left.equalTo(noLbl.snp.right).offset(12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(90)
        }
        
//        self.contentView.addSubview(createdAtLbl)
//        createdAtLbl.snp.makeConstraints { make in
//            make.left.equalTo(nameLbl.snp.right).offset(15)
//            make.centerY.equalToSuperview()
//        }
//
//        self.contentView.addSubview(deleteIV)
//        deleteIV.snp.makeConstraints { make in
//            make.right.equalToSuperview().offset(-20)
//            make.centerY.equalToSuperview()
//            make.width.equalTo(25)
//            make.height.equalTo(25)
//        }
    }
    
    override func configureSubViews() {
        noLbl.text = String(item!.no) + "."
        featuredIV.downloaded(from: item!.featured_path)
        //createdAtLbl.text = item?.created_at.noSec()
    }
}












