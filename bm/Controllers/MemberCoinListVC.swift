//
//  MemberCoinList.swift
//  bm
//
//  Created by ives on 2022/6/7.
//  Copyright © 2022 bm. All rights reserved.
//

import Foundation
import UIKit

class MemberCoinListVC: BaseViewController {
        
    lazy var tableView: MyTable2VC<MemberCoinListCell, MemberCoinTable, MemberCoinListVC> = {
        let tableView = MyTable2VC<MemberCoinListCell, MemberCoinTable, MemberCoinListVC>(selectedClosure: tableViewSetSelected(row:), getDataClosure: getDataFromServer(page:), myDelegate: self)
        return tableView
    }()
    
    var memberCoinTables: [MemberCoinTable] = [MemberCoinTable]()
    
    var popupRows: [OneRow] = [OneRow]()
    
    var lists1: [Table] = [Table]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        top.setTitle(title: "解碼點數")
        top.delegate = self
        
        tableView.anchor(parent: view, top: top, bottomThreeView: bottomThreeView)
        
        setupBottomThreeView()
        
//        let cellNibName = UINib(nibName: "MemberCoinListCell", bundle: nil)
//        tableView.register(cellNibName, forCellReuseIdentifier: "MemberCoinListCell")
        
        panelHeight = 500
        
        refresh()
    }
    
    override func refresh() {
        
        page = 1
        tableView.getDataFromServer(page: page)
        //getDataStart(page: page, perPage: PERPAGE)
    }
    
    func getDataFromServer(page: Int) {
        Global.instance.addSpinner(superView: self.view)
        
        MemberService.instance.MemberCoinList(member_token: Member.instance.token, page: page, perPage: PERPAGE) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if (success) {
                self.showTableView(tableView: self.tableView, jsonData: MemberService.instance.jsonData!)
            }
        }
    }
    
    func tableViewSetSelected(row: MemberCoinTable)-> Bool {
        return false
    }
    
    override func setupBottomThreeView() {
        bottomThreeView.delegate = self
        bottomThreeView.submitButton.setTitle("購買點數")
        bottomThreeView.cancelButton.setTitle("回上一頁")
        bottomThreeView.threeButton.setTitle("退款")
        bottomThreeView.setBottomButtonPadding(screen_width: screen_width)
    }
    
//    override func getDataStart(token: String? = nil, page: Int = 1, perPage: Int = PERPAGE) {
//        Global.instance.addSpinner(superView: self.view)
//
//        MemberService.instance.MemberCoinList(member_token: Member.instance.token, page: page, perPage: perPage) { (success) in
//            if (success) {
//                self.jsonData = MemberService.instance.jsonData
//                self.getDataEnd(success: success)
//            }
//        }
//    }
//
//    override func genericTable() {
//
//        do {
//            if (jsonData != nil) {
//                //print(jsonData.map { String(format: "%02x", $0) }.joined())
//                let coinResultTable: CoinResultTable = try JSONDecoder().decode(CoinResultTable.self, from: jsonData!)
//                if (coinResultTable.success) {
//
//                    if coinResultTable.rows.count > 0 {
//                        self.memberCoinTables = coinResultTable.rows
//                    } else {
//                        view.setInfo(info: "目前暫無資料", topAnchor: top)
//                    }
//                }
//            } else {
//                warning("無法從伺服器取得正確的json資料，請洽管理員")
//            }
//        } catch {
//            warning("解析JSON字串時，得到空值，請洽管理員")
//        }
//
//        if (page == 1) {
//            lists1 = [MemberCoinTable]()
//        }
//        lists1 += memberCoinTables
//    }
    
    override func submitBtnPressed() {
        toProduct()
    }
    
    override func addPanelBtn() {
        
        panelSubmitBtn = bottomView1.addSubmitBtn()
        panelSubmitBtn.addTarget(self, action: #selector(panelSubmitAction), for: .touchUpInside)
        
        var configuration = UIButton.Configuration.filled()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 36, bottom: 4, trailing: 36)
        configuration.baseBackgroundColor = UIColor(MY_GREEN)
        panelSubmitBtn.configuration = configuration
        panelSubmitBtn.topAnchor.constraint(equalTo: panelSubmitBtn.superview!.topAnchor, constant: 16).isActive = true

        panelCancelBtn = bottomView1.addCancelBtn()
        panelCancelBtn.addTarget(self, action: #selector(panelCancelAction), for: .touchUpInside)

        configuration.baseBackgroundColor = UIColor(MY_GRAY)
        panelCancelBtn.configuration = configuration
        
        panelCancelBtn.bottomAnchor.constraint(equalTo: panelCancelBtn.superview!.bottomAnchor, constant: -16).isActive = true
    }
    
    override func setButtonLayoutHeight() -> Int {
        let buttonViewHeight: Int = 55

        return buttonViewHeight * 2
    }
    
    override func didSelect<U>(item: U, at indexPath: IndexPath) {
        
        let _item: MemberCoinTable = item as! MemberCoinTable
        if MEMBER_COIN_IN_TYPE.enumFromString(_item.in_type) == MEMBER_COIN_IN_TYPE.buy && _item.order_token.count > 0 {
            toPayment(order_token: _item.order_token, source: "member")
        }

        //使用點數購買商品，前往查看訂單
        if !_item.in_out && MEMBER_COIN_OUT_TYPE.enumFromString(_item.out_type) == MEMBER_COIN_OUT_TYPE.product && _item.able_type == "order" {
            toPayment(order_token: _item.able_token, source: "member")
        }
    }
    
//    func didSelect<T: MemberCoinTable>(item: T, at indexPath: IndexPath) {
//        if MEMBER_COIN_IN_TYPE.enumFromString(item.in_type) == MEMBER_COIN_IN_TYPE.buy && item.order_token.count > 0 {
//            toPayment(order_token: item.order_token, source: "member")
//        }
//
//        //使用點數購買商品，前往查看訂單
//        if !item.in_out && MEMBER_COIN_OUT_TYPE.enumFromString(item.out_type) == MEMBER_COIN_OUT_TYPE.product && item.able_type == "order" {
//            toPayment(order_token: item.able_token, source: "member")
//        }
//    }
    
    @objc func panelSubmitAction() {
        print("aaa")
    }
    
    override func threeBtnPressed() {
        msg = ""
        if (Member.instance.bank.count == 0 || Member.instance.branch.count == 0 || Member.instance.bank_code == 0 || Member.instance.account.count == 0) {
            msg += "請先填寫完整的銀行匯款資料才能進行退款，是否前往填寫"
            warning(msg: msg, showCloseButton: true, buttonTitle: "是") {
                self.toMemberBank()
            }
        }
        
        if (msg.count == 0) {
            MemberService.instance.coinReturn(member_token: Member.instance.token) { success in
                if (success) {
                    self.jsonData = MemberService.instance.jsonData
                    do {
                        if (self.jsonData != nil) {
                            //print(jsonData.map { String(format: "%02x", $0) }.joined())
                            let coinReturnResultTable: CoinReturnResultTable = try JSONDecoder().decode(CoinReturnResultTable.self, from: self.jsonData!)
                            if (coinReturnResultTable.success) {
                                
                                self.popupRows = [
                                    OneRow(title: "購買：", value: String(coinReturnResultTable.grand_price), show: coinReturnResultTable.grand_price.formattedWithSeparator + " 點", key: "grand_price", cell: "text"),
                                    OneRow(title: "贈送：", value: String(coinReturnResultTable.grand_give), show: coinReturnResultTable.grand_give.formattedWithSeparator + " 點", key: "grand_give", cell: "text"),
                                    OneRow(title: "支出：", value: String(coinReturnResultTable.grand_spend), show: coinReturnResultTable.grand_spend.formattedWithSeparator + " 點", key: "grand_spend", cell: "text"),
                                    OneRow(title: "手續費：", value: String(coinReturnResultTable.handle_fee), show: coinReturnResultTable.handle_fee.formattedWithSeparator + " 點", key: "handle_fee", cell: "text"),
                                    OneRow(title: "轉帳費：", value: String(coinReturnResultTable.transfer_fee), show:
                                            coinReturnResultTable.transfer_fee.formattedWithSeparator + " 點", key: "transfer_fee", cell: "text")
                                    ]
                                let row: OneRow = OneRow(title: "退款金額：", value: String(coinReturnResultTable.return_coin), show:
                                                            coinReturnResultTable.return_coin.formattedWithSeparator + " 點", key: "return_coin", cell: "text")
                                row.titleColor = UIColor(MY_RED)
                                row.showColor = UIColor(MY_RED)
                                self.popupRows.append(row)
                                
                                let tableViewHeight: Int = self.rowHeight * self.popupRows.count + 150
                                self.showTableLayer(tableViewHeight: tableViewHeight)
                                self.popupTableView.dataSource = self
                                self.popupTableView.delegate = self
                            }
                        } else {
                            self.warning("無法從伺服器取得正確的json資料，請洽管理員")
                        }
                    } catch {
                        self.warning("解析JSON字串時，得到空值，請洽管理員")
                    }
                }
            }
        }
    }
}

extension MemberCoinListVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == popupTableView) {
            return popupRows.count
        } else {
        
            if (lists1.count > 0) {
                return lists1.count
            }
        }
        
        let count: Int = 0

        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == popupTableView) {
            if (popupRows.count > 0) {
                let row: OneRow = popupRows[indexPath.row]
                if let cell: PlainCell = tableView.dequeueReusableCell(withIdentifier: "PlainCell", for: indexPath) as? PlainCell {
                    cell.update(row: row)
                    return cell
                }
            }
        }
        else {

            if let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCoinListCell", for: indexPath) as? MemberCoinListCell {

                let memberCoinTable: MemberCoinTable = memberCoinTables[indexPath.row]
                //memberCoinTable.filterRow()
                //cell.myDelegate = self
                
                //還未完成
                //cell.item =
                //cell.update(_row: memberCoinTable, no: indexPath.row + 1)
                cell.configureSubViews()

                return cell
            }
        }
        
        return UITableViewCell()
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        let row: MemberCoinTable = memberCoinTables[indexPath.row]
//        row.filterRow()
//
//        //toPayment(order_token: T##String)
//
//        //購買點數，前往查看訂單
//        if MEMBER_COIN_IN_TYPE.enumFromString(row.in_type) == MEMBER_COIN_IN_TYPE.buy && row.order_token.count > 0 {
//            toPayment(order_token: row.order_token, source: "member")
//        }
//
//        //使用點數購買商品，前往查看訂單
//        if !row.in_out && MEMBER_COIN_OUT_TYPE.enumFromString(row.out_type) == MEMBER_COIN_OUT_TYPE.product && row.able_type == "order" {
//            toPayment(order_token: row.able_token, source: "member")
//        }
//    }
}

extension MemberCoinListVC: UITableViewDelegate {
    
}

class MemberCoinListCell: BaseCell<MemberCoinTable, MemberCoinListVC> {
    
    let noLbl: SuperLabel = {
        let view = SuperLabel()
        view.textColor = UIColor(MY_WHITE)
        view.setTextGeneral()
        view.text = "100."
        
        return view
    }()
    
    let typeButton: SuperButton = {
        let view = SuperButton()
        
        return view
    }()
    
    let aView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    let able_typeLbl: SuperLabel = {
        let view = SuperLabel()
        view.textColor = UIColor(MY_WHITE)
        view.setTextGeneral()
        view.text = "商品訂單名稱"
        
        return view
    }()
    
    let dateLbl: SuperLabel = {
        let view = SuperLabel()
        view.textColor = UIColor(MY_WHITE)
        view.setTextGeneral()
        view.text = "2022-05-02 14:00"
        
        return view
    }()
    
    let priceLbl: SuperLabel = {
        let view = SuperLabel()
        view.textColor = UIColor(MY_WHITE)
        view.setTextGeneral()
        view.text = "300"
        
        return view
    }()
    
    let priceSignLbl: SuperLabel = {
        let view = SuperLabel()
        view.textColor = UIColor(MY_WHITE)
        view.setTextGeneral()
        view.setTextSize(10)
        view.text = "點"
        
        return view
    }()
    
    let balanceSignLbl: SuperLabel = {
        let view = SuperLabel()
        view.textColor = UIColor(MY_WHITE)
        view.setTextGeneral()
        view.setTextSize(10)
        view.text = "餘額"
        
        return view
    }()
    
    let balanceLbl: SuperLabel = {
        let view = SuperLabel()
        view.textColor = UIColor(MY_WHITE)
        view.setTextGeneral()
        view.text = "600"
        
        return view
    }()
    
    let balanceUnitLbl: SuperLabel = {
        let view = SuperLabel()
        view.textColor = UIColor(MY_WHITE)
        view.setTextGeneral()
        view.setTextSize(10)
        view.text = "點"
        
        return view
    }()
    
//    @IBOutlet weak var noLbl: SuperLabel!
//    @IBOutlet weak var priceSignLbl: SuperLabel!
//    @IBOutlet weak var priceLbl: SuperLabel!
//    @IBOutlet weak var balanceSignLbl: SuperLabel!
//    @IBOutlet weak var balanceLbl: SuperLabel!
//    @IBOutlet weak var balanceUnitLbl: SuperLabel!
//    @IBOutlet weak var dateLbl: SuperLabel!
//    @IBOutlet weak var able_typeLbl: SuperLabel!
//    @IBOutlet weak var typeButton: SuperButton!
    
    //var row: MemberCoinTable?
    
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

//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//        if (noLbl != nil) {
//            noLbl.setTextSize(15)
//            noLbl.setTextColor(UIColor(CITY_BUTTON))
//        }
//
//        if (priceSignLbl != nil) {
//            priceSignLbl.setTextSize(10)
//            priceSignLbl.setTextColor(UIColor(MY_WHITE))
//        }
//
//        if (priceLbl != nil) {
//            priceLbl.setTextSize(16)
//            priceLbl.setTextColor(UIColor(MY_WHITE))
//        }
//
//        if (balanceSignLbl != nil) {
//            balanceSignLbl.setTextSize(10)
//            balanceSignLbl.setTextColor(UIColor(MY_WHITE))
//        }
//
//        if (balanceLbl != nil) {
//            balanceLbl.setTextSize(16)
//            balanceLbl.setTextColor(UIColor(MY_WHITE))
//        }
//
//        if (balanceUnitLbl != nil) {
//            balanceUnitLbl.setTextSize(10)
//            balanceUnitLbl.setTextColor(UIColor(MY_WHITE))
//        }
//
//        if (able_typeLbl != nil) {
//            able_typeLbl.setTextSize(16)
//            priceLbl.setTextColor(UIColor(TEXT_WHITE))
//        }
//
//        if (dateLbl != nil) {
//            dateLbl.setTextSize(10)
//            dateLbl.setTextColor(UIColor(MY_LIGHT_WHITE))
//        }
//    }
    
    func setAnchor() {
        
        self.contentView.addSubview(noLbl)
        noLbl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().offset(16)
        }
        
        self.contentView.addSubview(typeButton)
        typeButton.snp.makeConstraints { make in
            make.left.equalTo(noLbl.snp.right).offset(12)
            make.centerY.equalToSuperview()
        }
        
        self.contentView.addSubview(aView)
        aView.snp.makeConstraints { make in
            make.left.equalTo(typeButton.snp.right).offset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(40)
            make.top.greaterThanOrEqualToSuperview().offset(16)
            make.bottom.greaterThanOrEqualToSuperview().offset(16)
        }
        
        self.aView.addSubview(able_typeLbl)
        able_typeLbl.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(2)
        }
        
        self.aView.addSubview(dateLbl)
        dateLbl.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.bottom.equalToSuperview().offset(2)
        }

        self.contentView.addSubview(priceLbl)
        priceLbl.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-125)
            make.centerY.equalToSuperview()
        }

        self.contentView.addSubview(priceSignLbl)
        priceSignLbl.snp.makeConstraints { make in
            make.left.equalTo(priceLbl.snp.right).offset(4)
            make.bottom.equalTo(priceLbl.snp.bottom).offset(-2)
        }
        
        self.contentView.addSubview(balanceLbl)
        balanceLbl.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-28)
            make.centerY.equalToSuperview()
        }

        self.contentView.addSubview(balanceSignLbl)
        balanceSignLbl.snp.makeConstraints { make in
            make.right.equalTo(balanceLbl.snp.left).offset(-4)
            make.bottom.equalTo(balanceLbl.snp.bottom).offset(-2)
        }
        
        self.contentView.addSubview(balanceUnitLbl)
        balanceUnitLbl.snp.makeConstraints { make in
            make.left.equalTo(balanceLbl.snp.right).offset(4)
            make.bottom.equalTo(balanceLbl.snp.bottom).offset(-2)
        }
    }
    
    override func configureSubViews() {
        
        super.configureSubViews()
        
        if (item != nil) {
            noLbl.text = String(item!.no) + "."
            
            dateLbl.text = item!.created_at.noSec()
            
            balanceLbl.text = item!.balance.formattedWithSeparator
            
            if (item!.able_type_show.count > 0) {
                able_typeLbl.text = item!.able_type_show
                let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(able_action))
                tap.cancelsTouchesInView = false
                able_typeLbl.addGestureRecognizer(tap)
            }
            
            
            if (item!.in_out) {
                priceLbl.text = "+" + item!.coin.formattedWithSeparator
                typeButton.setTitle(item!.type_in_enum.rawValue)
                if (item!.type_in_enum == MEMBER_COIN_IN_TYPE.buy) {
                    typeButton.setColor(textColor: UIColor(MY_WHITE), bkColor: UIColor(MEMBER_COIN_BUY))
                } else if (item!.type_in_enum == MEMBER_COIN_IN_TYPE.gift) {
                    typeButton.setColor(textColor: UIColor(MY_WHITE), bkColor: UIColor(MEMBER_COIN_GIFT))
                } else {
                    typeButton.isHidden = true
                }
            } else {
                priceLbl.text = "-" + item!.coin.formattedWithSeparator
                priceLbl.setTextColor(UIColor(MY_RED))
                typeButton.setTitle(item!.type_out_enum.rawValue)
                if (item!.type_out_enum == MEMBER_COIN_OUT_TYPE.product) {
                    typeButton.setColor(textColor: UIColor(MY_WHITE), bkColor: UIColor(MEMBER_COIN_PAY))
                } else if (item!.type_out_enum == MEMBER_COIN_OUT_TYPE.course) {
                    typeButton.setColor(textColor: UIColor(MY_WHITE), bkColor: UIColor(MEMBER_COIN_PAY))
                } else {
                    typeButton.isHidden = true
                }
            }
            
            if (item!.name.count > 0) {
                able_typeLbl.text = item!.name
            }
        }
    }
    
    @objc func able_action(_ sender: UITapGestureRecognizer) {
        if (myDelegate != nil && item != nil) {
            myDelegate!.toPayment(order_token: item!.able_token)
        }
    }
    
}

class CoinResultTable: Codable {
    
    var success: Bool = false
    var page: Int = -1
    var totalCount: Int = -1
    var perPage: Int = -1
    var msg: String = ""
    var rows: [MemberCoinTable] = [MemberCoinTable]()
    
    init(){}
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        page = try container.decodeIfPresent(Int.self, forKey: .page) ?? -1
        totalCount = try container.decodeIfPresent(Int.self, forKey: .totalCount) ?? -1
        perPage = try container.decodeIfPresent(Int.self, forKey: .perPage) ?? -1
        msg = try container.decodeIfPresent(String.self, forKey: .msg) ?? ""
        rows = try container.decodeIfPresent([MemberCoinTable].self, forKey: .rows) ?? [MemberCoinTable]()
    }
}

class CoinReturnResultTable: Codable {

    var success: Bool = false
    var grand_price: Int = 0
    var grand_give: Int = 0
    var grand_spend: Int = 0
    var handle_fee: Int = 0
    var transfer_fee: Int = 0
    var return_coin: Int = 0
    
    init() {}
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        grand_price = try container.decodeIfPresent(Int.self, forKey: .grand_price) ?? 0
        grand_give = try container.decodeIfPresent(Int.self, forKey: .grand_give) ?? 0
        grand_spend = try container.decodeIfPresent(Int.self, forKey: .grand_spend) ?? 0
        handle_fee = try container.decodeIfPresent(Int.self, forKey: .handle_fee) ?? 0
        transfer_fee = try container.decodeIfPresent(Int.self, forKey: .transfer_fee) ?? 0
        return_coin = try container.decodeIfPresent(Int.self, forKey: .return_coin) ?? 0
    }
}
