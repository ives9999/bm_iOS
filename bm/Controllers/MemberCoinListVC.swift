//
//  MemberCoinList.swift
//  bm
//
//  Created by ives on 2022/6/7.
//  Copyright © 2022 bm. All rights reserved.
//

import Foundation
import UIKit

class MemberCoinListVC: MyTableVC {
    
    @IBOutlet weak var top: Top!
    @IBOutlet weak var bottomThreeView: BottomThreeView!
    var memberCoinTables: [MemberCoinTable] = [MemberCoinTable]()
    
    var popupRows: [OneRow] = [OneRow]()
    
    override func viewDidLoad() {
        
        myTablView = tableView
        super.viewDidLoad()
        
        top.setTitle(title: "解碼點數")
        top.delegate = self
        
        let cellNibName = UINib(nibName: "MemberCoinListCell", bundle: nil)
        tableView.register(cellNibName, forCellReuseIdentifier: "MemberCoinListCell")
        
        bottomThreeView.delegate = self
        bottomThreeView.submitButton.setTitle("購買點數")
        bottomThreeView.cancelButton.setTitle("回上一頁")
        bottomThreeView.threeButton.setTitle("退款")
        bottomThreeView.setBottomButtonPadding(screen_width: screen_width)
        
        panelHeight = 500
        
        refresh()
    }
    
    override func refresh() {
        
        page = 1
        getDataStart(page: page, perPage: PERPAGE)
    }
    
    override func getDataStart(token: String? = nil, page: Int = 1, perPage: Int = PERPAGE) {
        Global.instance.addSpinner(superView: self.view)
        
        MemberService.instance.MemberCoinList(member_token: Member.instance.token, page: page, perPage: perPage) { (success) in
            if (success) {
                self.jsonData = MemberService.instance.jsonData
                self.getDataEnd(success: success)
            }
        }
    }
    
    override func genericTable() {
        
        do {
            if (jsonData != nil) {
                //print(jsonData.map { String(format: "%02x", $0) }.joined())
                let coinResultTable: CoinResultTable = try JSONDecoder().decode(CoinResultTable.self, from: jsonData!)
                if (coinResultTable.success) {
                    
                    if coinResultTable.rows.count > 0 {
                        self.memberCoinTables = coinResultTable.rows
                    } else {
                        view.setInfo(info: "目前暫無資料", topAnchor: top)
                    }
                }
            } else {
                warning("無法從伺服器取得正確的json資料，請洽管理員")
            }
        } catch {
            warning("解析JSON字串時，得到空值，請洽管理員")
        }
        
        if (page == 1) {
            lists1 = [MemberCoinTable]()
        }
        lists1 += memberCoinTables
    }
    
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

extension MemberCoinListVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == popupTableView) {
            if (popupRows.count > 0) {
                let row: OneRow = popupRows[indexPath.row]
                if let cell: PlainCell = tableView.dequeueReusableCell(withIdentifier: "PlainCell", for: indexPath) as? PlainCell {
                    cell.update(row: row)
                    return cell
                }
            }
        } else {
        
            if let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCoinListCell", for: indexPath) as? MemberCoinListCell {
                
                let memberCoinTable: MemberCoinTable = memberCoinTables[indexPath.row]
                memberCoinTable.filterRow()
                cell.delegate = self
                cell.update(_row: memberCoinTable, no: indexPath.row + 1)
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row: MemberCoinTable = memberCoinTables[indexPath.row]
        row.filterRow()
        
        //toPayment(order_token: T##String)
        
        //購買點數，前往查看訂單
        if MEMBER_COIN_IN_TYPE.enumFromString(row.in_type) == MEMBER_COIN_IN_TYPE.buy && row.order_token.count > 0 {
            toPayment(order_token: row.order_token, source: "member")
        }
        
        //使用點數購買商品，前往查看訂單
        if !row.in_out && MEMBER_COIN_OUT_TYPE.enumFromString(row.out_type) == MEMBER_COIN_OUT_TYPE.product && row.able_type == "order" {
            toPayment(order_token: row.able_token, source: "member")
        }
        
        
        
//        if let cell = tableView.cellForRow(at: indexPath) as? MemberCoinListCell {
//
//        }
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
