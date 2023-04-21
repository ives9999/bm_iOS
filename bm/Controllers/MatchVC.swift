//
//  MatchVC.swift
//  bm
//
//  Created by ives on 2023/4/18.
//  Copyright © 2023 bm. All rights reserved.
//

import Foundation

class MatchVC: BaseViewController {
    
    var showTop2: ShowTop2?
    
    lazy var tableView2: MyTable2VC<MatchCell, MatchTable, MatchVC> = {
        let tableView = MyTable2VC<MatchCell, MatchTable, MatchVC>(selectedClosure: tableViewSetSelected(row:), getDataClosure: getDataFromServer(page:), myDelegate: self)
        return tableView
    }()
    
    var rows: [MatchTable] = [MatchTable]()
    
    var infoLbl: SuperLabel?
    
    override func viewDidLoad() {
        
        dataService = MatchService.instance
        super.viewDidLoad()
        
        showTop2 = ShowTop2(delegate: self)
        showTop2!.anchor(parent: self.view)
        showTop2!.setTitle("賽事列表")
        
        tableView2.anchor(parent: self.view, showTop: showTop2!)
        
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
                    self.infoLbl = self.view.setInfo(info: "目前尚無資料！！", topAnchor: self.showTop2!)
                } else {
                    self.infoLbl?.removeFromSuperview()
                    self.rows = self.tableView2.items
                }
                //self.showTableView(tableView: self.tableView, jsonData: self.dataService.jsonData!)
            }
        }
    }
    
    override func didSelect<U>(item: U, at indexPath: IndexPath) {
        let _item: MatchTable = item as! MatchTable
        toShowMatch(token: _item.token)
    }
    
    func tableViewSetSelected(row: MatchTable)-> Bool {
        return false
    }
}

class MatchCell: BaseCell<MatchTable, MatchVC> {
    
    let noLbl: SuperLabel = {
        let view = SuperLabel()
        //view.setTextGeneral()
        view.setTextColor(UIColor(MY_GREEN))
        view.setTextBold()
        view.text = "100."
        
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
        view.text = "xxx"
        
        return view
    }()
    
    let datetimeLbl: SuperLabel = {
        let view = SuperLabel()
        view.setTextGeneral()
        view.text = "xxx"
        
        return view
    }()
    
    let arenaLbl: SuperLabel = {
        let view = SuperLabel()
        view.setTextGeneral()
        view.text = "xxx"
        
        return view
    }()
    
    let showButton2: ShowButton2 = ShowButton2()
    
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
        
        showButton2.setTitle("報名")
        
//        let deleteGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(deleteThis))
//        deleteIV.addGestureRecognizer(deleteGR)
    }
    
    func anchor() {
        
        let view1: UIView = UIView()
        
        self.contentView.addSubview(view1)
        //view1.backgroundColor = UIColor.brown
        view1.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            //make.bottom.equalToSuperview().offset(-2)
            make.height.equalTo(30)
        }
        
            view1.addSubview(noLbl)
            noLbl.snp.makeConstraints { make in
            
                make.left.equalToSuperview()
                make.centerY.equalToSuperview()
            }
            
//            view1.addSubview(playTimeLbl)
//            playTimeLbl.snp.makeConstraints { make in
//                make.right.equalToSuperview()
//                make.centerY.equalToSuperview()
//            }
//        
//            view1.addSubview(playWeekLbl)
//            playWeekLbl.snp.makeConstraints { make in
//                make.right.equalTo(playTimeLbl.snp.left).offset(-6)
//                make.centerY.equalToSuperview()
//            }
        
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
            make.top.equalTo(separator.snp.bottom).offset(4)
            make.bottom.equalToSuperview().offset(-2)
            //make.height .equalTo(180)
        }
        
            mainContainerView.addSubview(nameLbl)
            nameLbl.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(12)
                make.left.equalToSuperview()
            }
        
            mainContainerView.addSubview(datetimeLbl)
                datetimeLbl.snp.makeConstraints { make in
                make.top.equalTo(nameLbl.snp.bottom).offset(12)
                make.left.equalToSuperview()
            }
        
            mainContainerView.addSubview(arenaLbl)
            arenaLbl.snp.makeConstraints { make in
                make.top.equalTo(datetimeLbl.snp.bottom).offset(12)
                make.left.equalToSuperview()
            }
        
            mainContainerView.addSubview(showButton2)
            showButton2.snp.makeConstraints { make in
                make.top.equalTo(arenaLbl.snp.bottom).offset(12)
                make.right.equalToSuperview()
                //make.centerY.equalToSuperview()
                make.height.equalTo(40)
                make.width.equalTo(160)
                make.bottom.equalToSuperview().offset(-15)
            }
    }
    
    override func configureSubViews() {
        super.configureSubViews()
        
        noLbl.text = String(item!.no) + "."
        
        nameLbl.text = item?.name
        arenaLbl.text = item?.arena_name
        datetimeLbl.text = "\(item!.start_datetime.noSec()) ~ \(item!.end_datetime.noSec())"
        
        //createdAtLbl.text = item?.created_at.noSec()
    }
}