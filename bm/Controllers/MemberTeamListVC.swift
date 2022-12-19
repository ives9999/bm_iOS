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
    
    var rows: [TeamMemberTable] = [TeamMemberTable]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        showTop = ShowTop2(delegate: self)
        showTop!.setAnchor(parent: self.view)
        showTop!.setTitle(title: "參加球隊")
        
        view.backgroundColor = UIColor(MY_BLACK)
        
        tableView.anchor(parent: view, showTop: showTop!)
        
        refresh()
    }
    
    func tableViewSetSelected(row: TeamMemberTable)-> Bool {
        return false
    }
    
    override func refresh() {
        
        page = 1
        getDataFromServer()
        //getDataStart(page: page, perPage: PERPAGE)
    }
    
    func getDataFromServer() {
        Global.instance.addSpinner(superView: self.view)
        
        MemberService.instance.memberTeamList(token: Member.instance.token, page: page, perPage: PERPAGE) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if (success) {
                //TeamService.instance.jsonData?.prettyPrintedJSONString
                let b: Bool = self.tableView.parseJSON(jsonData: MemberService.instance.jsonData)
                if !b && self.tableView.msg.count == 0 {
                    self.view.setInfo(info: "目前尚無資料！！", topAnchor: self.showTop!)
                } else {
                    self.rows = self.tableView.items
                }
                //self.showTableView(tableView: self.tableView, jsonData: TeamService.instance.jsonData!)
            }
        }
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
    
    override func setupView() {
        super.setupView()
        setAnchor()
    }
    
    func setAnchor() {
        
        self.contentView.addSubview(noLbl)
        noLbl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        self.contentView.addSubview(featuredIV)
        featuredIV.snp.makeConstraints { make in
            make.left.equalTo(noLbl.snp.right).offset(12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(90)
            make.top.bottom.greaterThanOrEqualToSuperview().offset(2)
        }
        
        self.contentView.addSubview(dataContainer)
        dataContainer.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(featuredIV.snp.right).offset(12)
            make.right.equalToSuperview()
        }
        //dataContainer.backgroundColor = UIColor.gray
        
        dataContainer.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
        }

        dataContainer.addSubview(cityBtn)
        cityBtn.snp.makeConstraints { make in
            make.top.equalTo(titleLbl.snp.bottom).offset(12)
            make.left.equalToSuperview()
        }
        
        dataContainer.addSubview(arenaBtn)
        arenaBtn.snp.makeConstraints { make in
            make.left.equalTo(cityBtn.snp.right).offset(12)
            make.centerY.equalTo(cityBtn.snp.centerY)
        }
    }
    
    override func configureSubViews() {
        noLbl.text = String(item!.no) + "."
        featuredIV.downloaded(from: item!.team_featured)
        //createdAtLbl.text = item?.created_at.noSec()
    }
}












