//
//  CartVC.swift
//  bm
//
//  Created by ives on 2021/7/25.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class MemberCartListVC: MyTableVC {
    
    var mysTable: CartsTable? = nil
    
    var myTable: CartTable? = nil
    var cartItemsTable: [CartItemTable] = [CartItemTable]()
    
    @IBOutlet weak var submitButton: SubmitButton!
    
    override func viewDidLoad() {
        myTablView = tableView
//        myTablView.allowsMultipleSelectionDuringEditing = false
//        myTablView.isUserInteractionEnabled = true
        dataService = CartService.instance
//        _type = "order"
//        _titleField = "name"
//        searchRows = _searchRows
        
        super.viewDidLoad()
        
        submitButton.setTitle("結帳")
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
            if mysTable == nil {
                warning("購物車中無商品，或購物車超過一個錯誤，請洽管理員")
            } else {
                if (mysTable!.rows.count != 1) {
                    warning("購物車中無商品，或購物車超過一個錯誤，請洽管理員")
                } else {
                    
                    myTable = mysTable!.rows[0]
                    cartItemsTable = myTable!.items
                    lists1 += cartItemsTable
                    myTablView.reloadData()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists1.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CartListCell", for: indexPath) as? CartListCell {
            
            cell.cellDelegate = self
            let row = lists1[indexPath.row] as! CartItemTable
            row.filterRow()
            //row.printRow()
            
            cell.updateViews(indexPath: indexPath, row: row)
            
            return cell
        } else {
            return ListCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
    
    override func cellEdit(row: Table) {
        
        toAddCart(
            cartItem_token: row.token,
            login: { vc in vc.toLogin() },
            register: { vc in vc.toRegister() }
        )
    }
    
    override func cellDelete(row: Table) {
        
        
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        prev()
    }
}
