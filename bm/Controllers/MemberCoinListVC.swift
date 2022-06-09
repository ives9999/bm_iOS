//
//  MemberCoinList.swift
//  bm
//
//  Created by ives on 2022/6/7.
//  Copyright © 2022 bm. All rights reserved.
//

import Foundation

class MemberCoinListVC: MyTableVC {
    
    @IBOutlet weak var top: Top!
    var memberCoinTables: [MemberCoinTable] = [MemberCoinTable]()
    
    override func viewDidLoad() {
        
        myTablView = tableView
        super.viewDidLoad()
        
        top.setTitle(title: "解碼幣")
        top.delegate = self
        
        let cellNibName = UINib(nibName: "MemberCoinListCell", bundle: nil)
        tableView.register(cellNibName, forCellReuseIdentifier: "MemberCoinListCell")
        
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
                    self.memberCoinTables = coinResultTable.rows
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCoinListCell", for: indexPath) as? MemberCoinListCell {
            
            let memberCoinTable: MemberCoinTable = memberCoinTables[indexPath.row]
            memberCoinTable.filterRow()
            cell.delegate = self
            cell.update(_row: memberCoinTable, no: indexPath.row + 1)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row: MemberCoinTable = memberCoinTables[indexPath.row]
        row.filterRow()
        
        toPayment(order_token: row.able_token)
        
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
