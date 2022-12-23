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
        let tableView = MyTable2VC<MemberTeamListCell, TeamMemberTable, MemberTeamListVC>(selectedClosure: tableViewSetSelected(row:), getDataClosure: getDataFromServer(page:), myDelegate: self)
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
        tableView.refresh()
        //getDataStart(page: page, perPage: PERPAGE)
    }
    
    func getDataFromServer(page: Int) {
        Global.instance.addSpinner(superView: self.view)
        
        MemberService.instance.memberTeamList(token: Member.instance.token, page: page, perPage: tableView.perPage) { (success) in
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
    
    func deleteMemberTeam(row: TeamMemberTable) {
        warning(msg: "確定要退出嗎？", closeButtonTitle: "取消", buttonTitle: "退出") {
            Global.instance.addSpinner(superView: self.view)
            
            MemberService.instance.deleteMemberTeam(token: row.token) { success in
                if success {
                    self.refresh()
                } else {
                    self.info("刪除失敗")
                }
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
    
    let toolView: UIView = {
        let view = UIView()
        //view.backgroundColor = UIColor.red
        
        return view
    }()
    
    let deleteIV: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "delete")
        
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
        
        //self.backgroundColor = UIColor.red
        
        let deleteGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(deleteThis))
        //deleteGR.cancelsTouchesInView = false
        deleteIV.isUserInteractionEnabled = true
        deleteIV.addGestureRecognizer(deleteGR)
    }
    
    func setAnchor() {
        
        let containerView: UIView = UIView()
        //containerView.backgroundColor = UIColor.brown
        self.contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
        }

        containerView.addSubview(noLbl)
        noLbl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }

        containerView.addSubview(featuredIV)
        featuredIV.snp.makeConstraints { make in
            make.left.equalTo(noLbl.snp.right).offset(12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(90)
            //make.bottom.equalToSuperview().offset(-12)
        }

        containerView.addSubview(dataContainer)
        //dataContainer.backgroundColor = UIColor.blue
        dataContainer.snp.makeConstraints { make in
            make.left.equalTo(featuredIV.snp.right).offset(12)
            make.right.top.bottom.equalToSuperview()
            //make.edges.equalToSuperview()
            //make.height.equalTo(200)
        }
        //dataContainer.backgroundColor = UIColor.gray

        dataContainer.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(12)
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

        dataContainer.addSubview(weekendLbl)
        weekendLbl.snp.makeConstraints { make in
            make.top.equalTo(cityBtn.snp.bottom).offset(12)
            make.left.equalToSuperview()
        }

        dataContainer.addSubview(intervalLbl)
        intervalLbl.snp.makeConstraints { make in
            make.top.equalTo(weekendLbl.snp.bottom).offset(12)
            make.left.equalToSuperview()
        }

        dataContainer.addSubview(joinLbl)
        joinLbl.snp.makeConstraints { make in
            make.top.equalTo(intervalLbl.snp.bottom).offset(12)
            make.left.equalToSuperview()
        }

        dataContainer.addSubview(joinTimeLbl)
        joinTimeLbl.snp.makeConstraints { make in
            make.left.equalTo(joinLbl.snp.right).offset(12)
            make.centerY.equalTo(joinLbl.snp.centerY)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        self.contentView.addSubview(toolView)
        //toolView.backgroundColor = UIColor.blue
        toolView.snp.makeConstraints { make in
            make.top.equalTo(dataContainer.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
            //make.bottom.equalToSuperview().offset(-12)
        }

        toolView.addSubview(deleteIV)
        deleteIV.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(35)
        }

        //self.contentView.addSubview(line)
        line.snp.makeConstraints { make in
            make.top.equalTo(toolView.snp.bottom)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureSubViews() {
        super.configureSubViews()
        noLbl.text = String(item!.no) + "."
        
        if item != nil && item!.teamTable != nil {
            let teamTable = item!.teamTable!
            featuredIV.downloaded(from: teamTable.featured_path)
            titleLbl.text = teamTable.name
            cityBtn.setTitle(teamTable.city_show)
            if teamTable.arena != nil {
                arenaBtn.setTitle(teamTable.arena!.name)
            }
            weekendLbl.text = teamTable.weekdays_show
            intervalLbl.text = teamTable.interval_show
            joinTimeLbl.text = item!.created_at.noSec()
        } else {
            featuredIV.image = UIImage(named: "nophoto")
        }
        
        //createdAtLbl.text = item?.created_at.noSec()
    }
    
    @objc func deleteThis(_ sender: UIView) {
        myDelegate?.deleteMemberTeam(row: item!)
    }
}












