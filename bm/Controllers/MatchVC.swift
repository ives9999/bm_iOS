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
    
    func showMatch(idx: Int) {
        toShowMatch(token: self.rows[idx].token)
    }
    
    func signup(idx: Int) {
        //print(item)
        toShowMatch(token: self.rows[idx].token, idx: 2)
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
    
    let arena_city_name: SuperLabel = {
        let view = SuperLabel()
        view.setTextGeneral()
        view.setTextBold()
        
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
    
    let matchStartITT: IconTextText2 = {
        let view = IconTextText2()
        view.setIcon("calendar_start_svg")
        view.setTitle("比賽開始日期")
        
        return view
    }()
    
    let matchEndITT: IconTextText2 = {
        let view = IconTextText2()
        view.setIcon("calendar_end_svg")
        view.setTitle("比賽結束日期")
        
        return view
    }()
    
    let arenaITT: IconTextText2 = {
        let view = IconTextText2()
        view.setIcon("area_svg")
        view.setTitle("比賽球館")
        
        return view
    }()
    
    let showButton2: ShowButton2 = ShowButton2()
    
    let signupButton2: SignupButton2 = SignupButton2()
    
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
        showButton2.delegate = self
        signupButton2.delegate = self
        
        showButton2.setTitle("內容")
        anchor()
        
//        let deleteGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(deleteThis))
//        deleteIV.addGestureRecognizer(deleteGR)
    }
    
    func anchor() {
        
        let view1: UIView = UIView()
        
        self.contentView.addSubview(view1)
        //view1.backgroundColor = UIColor.brown
        view1.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(0)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            //make.bottom.equalToSuperview().offset(-2)
            //make.height.equalTo(30)
        }
        
            view1.addSubview(noLbl)
            noLbl.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.left.equalToSuperview()
            }
        
            view1.addSubview(arena_city_name)
            arena_city_name.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.right.equalToSuperview()
            }
        
            view1.addSubview(separator)
            separator.snp.makeConstraints { make in
                make.top.equalTo(noLbl.snp.bottom).offset(12)
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.height.equalTo(1)
                make.bottom.equalToSuperview().offset(-12)
            }

        self.contentView.addSubview(mainContainerView)
        //mainContainerView.backgroundColor = UIColor.blue
        mainContainerView.snp.makeConstraints { make in
            make.top.equalTo(view1.snp.bottom).offset(0)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            //make.height .equalTo(180)
        }
        
            mainContainerView.addSubview(nameLbl)
            nameLbl.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(6)
                make.left.equalToSuperview()
            }
        
            mainContainerView.addSubview(matchStartITT)
            matchStartITT.snp.makeConstraints { make in
                make.top.equalTo(nameLbl.snp.bottom).offset(12)
                make.left.equalToSuperview()
            }
        
            mainContainerView.addSubview(matchEndITT)
            matchEndITT.snp.makeConstraints { make in
                make.top.equalTo(matchStartITT.snp.bottom).offset(12)
                make.left.equalToSuperview()
            }
        
            mainContainerView.addSubview(arenaITT)
            arenaITT.snp.makeConstraints { make in
                make.top.equalTo(matchEndITT.snp.bottom).offset(12)
                make.left.equalToSuperview()
                make.bottom.equalToSuperview().offset(-12)
            }
        
        let buttonContainer: UIView = UIView()
        self.contentView.addSubview(buttonContainer)
        buttonContainer.snp.makeConstraints { make in
            make.top.equalTo(mainContainerView.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            //make.height.equalTo(60)
            make.bottom.equalToSuperview().offset(-30)
        }
        
            buttonContainer.addSubview(signupButton2)
            signupButton2.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.left.equalToSuperview()
                //make.centerY.equalToSuperview()
                make.height.equalTo(40)
                make.width.equalTo(240)
                //make.centerY.equalToSuperview()
                make.bottom.equalToSuperview().offset(-3)
            }
        
            buttonContainer.addSubview(showButton2)
            showButton2.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.right.equalToSuperview()
                //make.centerY.equalToSuperview()
                make.height.equalTo(40)
                make.width.equalTo(102)
                //make.centerY.equalToSuperview()
                make.bottom.equalToSuperview().offset(-3)
            }
    }
    
    override func configureSubViews() {
        super.configureSubViews()
        
        if item != nil {
            noLbl.text = item!.no.toTwoString() + "."
            arena_city_name.text = item!.arena_city_name
            
            nameLbl.text = item!.name
            matchStartITT.setShow(item!.match_start_show)
            matchEndITT.setShow(item!.match_end_show)
            arenaITT.setShow(item!.arena_name)
            showButton2.idx = item!.no - 1
            signupButton2.idx = item!.no - 1
            
            signupButton2.setPrice(min: item!.priceMin, max: item!.priceMax)
        }
        
        //createdAtLbl.text = item?.created_at.noSec()
    }
}

extension MatchCell: ShowButton2Delegate {
    
//    func showButtonPressed(idx: Int) {
//        myDelegate?.showMatch(idx: idx)
//    }
    
    func showButtonPressed() {
        guard let superView = self.superview as? UITableView else { return }
        myDelegate?.didSelect(item: item, at: superView.indexPath(for: self)!)
    }
}

extension MatchCell: SignupButton2Delegate {
    
    func signupButtonPressed(idx: Int) {
        myDelegate?.signup(idx: idx)
    }
}
