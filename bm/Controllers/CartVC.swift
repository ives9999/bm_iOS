//
//  CartVC.swift
//  bm
//
//  Created by ives on 2021/7/25.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class CartVC: MyTableVC {
    
    var mysTable: CartsTable? = nil
    
    override func viewDidLoad() {
        myTablView = tableView
//        myTablView.allowsMultipleSelectionDuringEditing = false
//        myTablView.isUserInteractionEnabled = true
        dataService = CartService.instance
//        _type = "order"
//        _titleField = "name"
//        searchRows = _searchRows
        
        super.viewDidLoad()
        let cellNibName = UINib(nibName: "CartListCell", bundle: nil)
        tableView.register(cellNibName, forCellReuseIdentifier: "CartListCell")
        
        refresh()
    }
    
    override func refresh() {
        page = 1
        getDataStart(t: CartsTable.self)
    }
    
    override func getDataStart<T: Tables>(t: T.Type, page: Int = 1, perPage: Int = PERPAGE) {
        
        Global.instance.addSpinner(superView: self.view)

        dataService.getList(token: Member.instance.token, _filter: params, page: page, perPage: perPage) { (success) in
            if (success) {
                
                do {
                    if (self.dataService.jsonData != nil) {
                        try self.tables = JSONDecoder().decode(t, from: self.dataService.jsonData!)
                        if (self.tables != nil) {
                            //self.coursesTable!.printRows()
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
                        }
                    } else {
                        self.warning("無法從伺服器取得正確的json資料，請洽管理員")
                    }
                } catch {
                    self.msg = "解析JSON字串時，得到空值，請洽管理員"
                }
                                
                Global.instance.removeSpinner(superView: self.view)
            } else {
                Global.instance.removeSpinner(superView: self.view)
                self.warning(self.dataService.msg)
            }
        }
    }
    
    override func getDataEnd(success: Bool) {
        if success {
            
            mysTable = (tables as? CartsTable)
            if mysTable != nil {
                let tmps: [CartTable] = mysTable!.rows
                
                if page == 1 {
                    lists1 = [CartTable]()
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CartListCell", for: indexPath) as? CartListCell {
            
            let row = lists1[indexPath.row] as! CartTable
            row.filterRow()
            //row.printRow()
            
            cell.updateViews(indexPath: indexPath, row: row)
            
            return cell
        } else {
            return ListCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
}
