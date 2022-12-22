//
//  MemberLevelLogVC.swift
//  bm
//
//  Created by ives on 2022/8/24.
//  Copyright © 2022 bm. All rights reserved.
//

import Foundation

class MemberSubscriptionLogVC: BaseViewController {
    
    lazy var tableView: MyTable2VC<MemberSubscriptionLogCell, MemberSubscriptionLogTable, MemberSubscriptionLogVC> = {
        let tableView = MyTable2VC<MemberSubscriptionLogCell, MemberSubscriptionLogTable, MemberSubscriptionLogVC>(selected: tableViewSetSelected(row:), myDelegate: self)
        return tableView
    }()
    
    var rows: [MemberSubscriptionLogTable] = [MemberSubscriptionLogTable]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        top.setTitle(title: "訂閱會員付款紀錄")
        top.delegate = self
        
        tableView.anchor(parent: view, top: top, bottomThreeView: bottomThreeView)
                
        refresh()
    }
    
    override func setupBottomThreeView() {
        bottomThreeView.delegate = self
        bottomThreeView.submitButton.setTitle("退訂")
        bottomThreeView.cancelButton.setTitle("回上一頁")
        bottomThreeView.threeButton.setTitle("查詢")
        bottomThreeView.setBottomButtonPadding(screen_width: screen_width)
    }
    
    override func refresh() {
        
        page = 1
        getDataFromServer()
    }
    
    func getDataFromServer() {
        Global.instance.addSpinner(superView: self.view)
        
        MemberService.instance.subscriptionLog(member_token: Member.instance.token, page: page, perPage: PERPAGE) { (success) in
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
}

class MemberSubscriptionLogCell: BaseCell<MemberSubscriptionLogTable, MemberSubscriptionLogVC> {
    
    let noLbl: SuperLabel = {
        let view = SuperLabel()
        view.textColor = UIColor(MY_WHITE)
        view.setTextGeneral()
        view.text = "100."
        
        return view
    }()
    
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
        setAnchor()
    }
    
    func setAnchor() {
        
        self.contentView.addSubview(noLbl)
        noLbl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().offset(16)
        }
        
        self.contentView.addSubview(priceLbl)
        priceLbl.snp.makeConstraints { make in
            make.left.equalTo(noLbl.snp.right).offset(12)
            make.centerY.equalToSuperview()
        }
        
        self.contentView.addSubview(dateLbl)
        dateLbl.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
    }
    
    override func configureSubViews() {
        
        super.configureSubViews()
        noLbl.text = String(item!.no)
        priceLbl.text = "NT$: " + String(item!.amount) + " 元"
        dateLbl.text = item?.created_at.noSec()
    }
}
