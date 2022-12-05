//
//  MemberLevelUp.swift
//  bm
//
//  Created by ives on 2022/7/28.
//  Copyright © 2022 bm. All rights reserved.
//

import Foundation

class MemberSubscriptionKindVC: BaseViewController {
    
    lazy var tableView: MyTable2VC<MemberSubscriptionKindCell, MemberSubscriptionKindTable, MemberSubscriptionKindVC> = {
        let tableView = MyTable2VC<MemberSubscriptionKindCell, MemberSubscriptionKindTable, MemberSubscriptionKindVC>(selected: tableViewSetSelected(row:), myDelegate: self)
        return tableView
    }()
    
    var rows: [MemberSubscriptionKindTable] = [MemberSubscriptionKindTable]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        top.setTitle(title: "訂閱會員")
        top.delegate = self
        
        tableView.anchor(parent: view, top: top, bottomThreeView: bottomThreeView)
        
        setupBottomThreeView()
        
        refresh()
    }
    
    override func refresh() {
        
        page = 1
        getDataFromServer()
    }
    
    func getDataFromServer() {
        Global.instance.addSpinner(superView: self.view)
        
        MemberService.instance.subscriptionKind(member_token: Member.instance.token, page: page, perPage: PERPAGE) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if (success) {
                self.rows = self.showTableView(tableView: self.tableView, jsonData: MemberService.instance.jsonData!)
            }
        }
    }
    
    func tableViewSetSelected(row: MemberSubscriptionKindTable)-> Bool {
        return row.eng_name == Member.instance.subscription ? true : false
    }
    
    override func didSelect<U>(item: U, at indexPath: IndexPath) {
        
        let _item: MemberSubscriptionKindTable = item as! MemberSubscriptionKindTable
        toMemberScriptionPay(name: _item.name, price: _item.price, kind: _item.eng_name)
    }
    
    override func setupBottomThreeView() {
        bottomThreeView.delegate = self
        bottomThreeView.submitButton.setTitle("查詢")
        bottomThreeView.cancelButton.setTitle("回上一頁")
        bottomThreeView.threeButton.setTitle("退訂")
        bottomThreeView.setBottomButtonPadding(screen_width: screen_width)
    }
    
    override func submitBtnPressed() {
        toMemberSubscriptionLog()
    }
}

class MemberSubscriptionKindCell: BaseCell<MemberSubscriptionKindTable, MemberSubscriptionKindVC> {
    
    let noLbl: SuperLabel = {
        let view = SuperLabel()
        view.textColor = UIColor(MY_WHITE)
        view.setTextGeneral()
        view.text = "100."
        
        return view
    }()
    
    let nameLbl: SuperLabel = {
        let view = SuperLabel()
        view.textColor = UIColor(MY_WHITE)
        view.setTextGeneral()
        view.text = "xxx"
        
        return view
    }()
    
    let priceLbl: SuperLabel = {
        let view = SuperLabel()
        view.textColor = UIColor(MY_WHITE)
        view.setTextGeneral()
        view.text = "300"
        
        return view
    }()
    
//    @IBOutlet weak var titleLbl: SuperLabel!
//    @IBOutlet weak var priceLbl: SuperLabel!
    
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
        
        self.contentView.addSubview(nameLbl)
        nameLbl.snp.makeConstraints { make in
            make.left.equalTo(noLbl.snp.right).offset(12)
            make.centerY.equalToSuperview()
        }
        
        self.contentView.addSubview(priceLbl)
        priceLbl.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
    }
    
    override func configureSubViews() {
        
        super.configureSubViews()
        
        noLbl.text = String(item!.no) + "."
        nameLbl.text = item?.name
        priceLbl.text = "NT$: " + String(item!.price) + " 元/月"
    }
}

