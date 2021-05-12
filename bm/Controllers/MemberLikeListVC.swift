//
//  MemberLikeListVC.swift
//  bm
//
//  Created by ives sun on 2021/5/11.
//  Copyright © 2021 bm. All rights reserved.
//

import UIKit

class MemberLikeListVC: ListVC {
    
    var able_type: String = "team"

    override func viewDidLoad() {
        
        myTablView = tableView
        dataService = MemberService.instance
        
        super.viewDidLoad()
        
        let cellNibName = UINib(nibName: "OrderListCell", bundle: nil)
        tableView.register(cellNibName, forCellReuseIdentifier: "OrderListCell")
        
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.lightGray
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func refresh() {
        page = 1
        getDataStart(t: OrdersTable.self)
    }
    
    override func getDataStart<T: Tables>(t: T.Type, page: Int = 1, perPage: Int = PERPAGE) {
        
        Global.instance.addSpinner(superView: self.view)

        dataService.getList(t: t, token: Member.instance.token, _filter: params1, page: page, perPage: perPage) { (success) in
            if (success) {
                self.tables = self.dataService.tables!
                self.page = self.tables!.page
                if self.page == 1 {
                    self.totalCount = self.tables!.totalCount
                    self.perPage = self.tables!.perPage
                    let _pageCount: Int = self.totalCount / self.perPage
                    self.totalPage = (self.totalCount % self.perPage > 0) ? _pageCount + 1 : _pageCount
                    //print(self.totalPage)
                    if self.refreshControl.isRefreshing {
                        self.refreshControl.endRefreshing()
                    }
                }
                self.getDataEnd(success: success)
                Global.instance.removeSpinner(superView: self.view)
            } else {
                Global.instance.removeSpinner(superView: self.view)
                self.warning(self.dataService.msg)
            }
        }
    }
    
    override func getDataEnd(success: Bool) {
        if success {
            
            mysTable = (tables as? OrdersTable)
            if mysTable != nil {
                let tmps: [OrderTable] = mysTable!.rows
                
                if page == 1 {
                    lists1 = [OrderTable]()
                }
                lists1 += tmps
                myTablView.reloadData()
            } else {
                warning("轉換Table出錯，請洽管理員")
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
            return ListCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if mysTable != nil {
            let orderTable = mysTable!.rows[indexPath.row]
            //toShowProduct(token: superProduct.token)
            let token = orderTable.token
            toPayment(order_token: token)
        }
    }
}
