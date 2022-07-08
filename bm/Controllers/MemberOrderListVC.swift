//
//  MemberOrderList.swift
//  bm
//
//  Created by ives on 2021/2/21.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class MemberOrderListVC: MyTableVC {
    
    var mysTable: OrdersTable? = nil
    
    override func viewDidLoad() {
        myTablView = tableView
//        myTablView.allowsMultipleSelectionDuringEditing = false
//        myTablView.isUserInteractionEnabled = true
        dataService = OrderService.instance
//        _type = "order"
//        _titleField = "name"
//        searchRows = _searchRows
        
        super.viewDidLoad()
        let cellNibName = UINib(nibName: "OrderListCell", bundle: nil)
        tableView.register(cellNibName, forCellReuseIdentifier: "OrderListCell")
        
        refresh()
    }
    
    override func refresh() {
        page = 1
        getDataStart(token: Member.instance.token)
    }
    
    override func genericTable() {
        
        do {
            if (jsonData != nil) {
                mysTable = try JSONDecoder().decode(OrdersTable.self, from: jsonData!)
            } else {
                warning("無法從伺服器取得正確的json資料，請洽管理員")
            }
        } catch {
            msg = "解析JSON字串時，得到空值，請洽管理員"
        }
        if (mysTable != nil) {
            tables = mysTable!
            if mysTable!.rows.count > 0 {
                if (page == 1) {
                    lists1 = [OrderTable]()
                }
                lists1 += mysTable!.rows
            } else {
                view.setInfo(info: "目前暫無訂單", topAnchor: topView)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists1.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderListCell", for: indexPath) as? OrderListCell {
            
            let row = lists1[indexPath.row] as! OrderTable
            row.filterRow()
            //row.printRow()
            
            cell.updateOrderViews(indexPath: indexPath, row: row)
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = lists1[indexPath.row] as! OrderTable
//
//        let gateway_method: String = row.gateway!.method
//        if gateway_method == "credit_card" || gateway_method == "store_cvs" {
//            toPayment(order_token: row.token, source: "member")
//        } else if gateway_method == "coin" {
//            toPayment(order_token: row.token, source: "member")
//        } else if gateway_method == "store_pay_711" || gateway_method == "store_pay_family" {
//            toWebView(token: row.token)
//        }
        
        toPayment(order_token: row.token, source: "member")
    }
}
