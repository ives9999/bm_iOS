//
//  MemberLevelLogVC.swift
//  bm
//
//  Created by ives on 2022/8/24.
//  Copyright © 2022 bm. All rights reserved.
//

import Foundation

class MemberSubscriptionLogVC: BaseViewController {
    
    var showTop2: ShowTop2?
    
    lazy var tableView: MyTable2VC<MemberSubscriptionLogCell, MemberSubscriptionLogTable, MemberSubscriptionLogVC> = {
        let tableView = MyTable2VC<MemberSubscriptionLogCell, MemberSubscriptionLogTable, MemberSubscriptionLogVC>(selectedClosure: tableViewSetSelected(row:), getDataClosure: getDataFromServer(page:), myDelegate: self)
        return tableView
    }()
    
    var rows: [MemberSubscriptionLogTable] = [MemberSubscriptionLogTable]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initTop()
        
        tableView.anchor(parent: view, showTop: showTop2!)
                
        refresh()
    }
    
    func initTop() {
        showTop2 = ShowTop2(delegate: self)
        showTop2!.anchor(parent: self.view)
        showTop2!.setTitle("訂閱會員付款紀錄")
    }
    
    override func refresh() {
        
        page = 1
        tableView.getDataFromServer(page: page)
    }
    
    func getDataFromServer(page: Int) {
        Global.instance.addSpinner(superView: self.view)
        
        MemberService.instance.subscriptionLog(member_token: Member.instance.token, page: page, perPage: tableView.perPage) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if (success) {
                self.rows = self.showTableView(tableView: self.tableView, jsonData: MemberService.instance.jsonData!)
            }
        }
    }
    
    func tableViewSetSelected(row: MemberSubscriptionLogTable)-> Bool {
        return false
    }
    
    override func didSelect<U>(item: U, at indexPath: IndexPath) {
        
    }
    
    override func showTableView<T: BaseCell<U, V>, U: Table, V: BaseViewController>(tableView: MyTable2VC<T, U, V>, jsonData: Data)-> [U] {
        
        let b: Bool = tableView.parseJSON(jsonData: jsonData)
        if !b && tableView.msg.count == 0 {
            view.setInfo(info: tableView.msg, topAnchor: showTop2!)
        }
        
        return tableView.items
    }
}

class MemberSubscriptionLogCell: BaseCell<MemberSubscriptionLogTable, MemberSubscriptionLogVC> {
    
    let noLbl: SuperLabel = {
        let view = SuperLabel()
        //view.setTextGeneral()
        view.setTextColor(UIColor(MY_GREEN))
        view.setTextBold()
        view.text = "100."
        
        return view
    }()
    
    let playTimeLbl: SuperLabel = {
        let view = SuperLabel()
        view.textColor = UIColor(hex: MY_WHITE, alpha: 0.7)
        view.text = "19:00~21:00"
        
        return view
    }()
    
    let playWeekLbl: SuperLabel = {
        let view = SuperLabel()
        view.textColor = UIColor(hex: MY_WHITE, alpha: 0.7)
        view.text = "19:00~21:00"
        
        return view
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#FFFFFF", alpha: 0.3)
        return view
    }()
    
    let mainContainerView: UIView = UIView()
    
    let priceLbl: SuperLabel = {
        let view = SuperLabel()
        view.textColor = UIColor(MY_WHITE)
        view.setTextGeneral()
        view.text = "200"
        
        return view
    }()
    
    let dateLbl: SuperLabel = {
        let view = SuperLabel()
        view.textColor = UIColor(MY_WHITE)
        view.setTextGeneral()
        view.text = "2022-01-05 22:00"
        
        return view
    }()
    
//    @IBOutlet weak var noLbl: SuperLabel!
//    @IBOutlet weak var priceLbl: SuperLabel!
//    @IBOutlet weak var dateLbl: SuperLabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    override func commonInit() {
        anchor()
    }
    
    func anchor() {
        
        let view1: UIView = UIView()
        
        self.contentView.addSubview(view1)
        //view1.backgroundColor = UIColor.brown
        view1.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(30)
        }
        
            view1.addSubview(noLbl)
            noLbl.snp.makeConstraints { make in
            
                make.left.equalToSuperview()
                make.centerY.equalToSuperview()
            }
            
            view1.addSubview(playTimeLbl)
            playTimeLbl.snp.makeConstraints { make in
                make.right.equalToSuperview()
                make.centerY.equalToSuperview()
            }
        
            view1.addSubview(playWeekLbl)
            playWeekLbl.snp.makeConstraints { make in
                make.right.equalTo(playTimeLbl.snp.left).offset(-6)
                make.centerY.equalToSuperview()
            }
        
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
            //make.bottom.equalToSuperview().offset(4)
            //make.height .equalTo(130)
        }
        
        mainContainerView.addSubview(priceLbl)
        priceLbl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview()
        }
        
        mainContainerView.addSubview(dateLbl)
        dateLbl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-20)
        }
    }
    
    override func configureSubViews() {
        
        super.configureSubViews()
        noLbl.text = String(item!.no)
        priceLbl.text = "NT$: " + String(item!.amount) + " 元"
        dateLbl.text = item?.created_at.noSec()
    }
}
