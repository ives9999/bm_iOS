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
        
        submitButton.setTitle("成立訂單")
        
        let cellNibName = UINib(nibName: "CartListCell", bundle: nil)
        tableView.register(cellNibName, forCellReuseIdentifier: "CartListCell")
        
        refresh()
    }
    
    override func refresh() {
        page = 1
        lists1.removeAll()
        getDataStart(token: Member.instance.token)
    }
    
    
    override func genericTable() {
        
        do {
            if (jsonData != nil) {
                mysTable = try JSONDecoder().decode(CartsTable.self, from: jsonData!)
            } else {
                warning("無法從伺服器取得正確的json資料，請洽管理員")
            }
        } catch {
            msg = "解析JSON字串時，得到空值，請洽管理員"
        }
        if (mysTable != nil) {
            tables = mysTable!
            myTable = mysTable!.rows[0]
            cartItemsTable = myTable!.items
            lists1 += cartItemsTable
        }
    }
//    override func getDataStart<T: Tables>(t: T.Type, page: Int = 1, perPage: Int = PERPAGE) {
//
//        Global.instance.addSpinner(superView: self.view)
//
//        dataService.getList(token: Member.instance.token, _filter: params, page: page, perPage: perPage) { (success) in
//            if (success) {
//
//                do {
//                    if (self.dataService.jsonData != nil) {
//                        try self.tables = JSONDecoder().decode(t, from: self.dataService.jsonData!)
//                        if (self.tables != nil) {
//                            self.getDataEnd(success: success)
//                        }
//                    } else {
//                        self.warning("無法從伺服器取得正確的json資料，請洽管理員")
//                    }
//                } catch {
//                    self.msg = "解析JSON字串時，得到空值，請洽管理員"
//                }
//
//                Global.instance.removeSpinner(superView: self.view)
//            } else {
//                Global.instance.removeSpinner(superView: self.view)
//                self.warning(self.dataService.msg)
//            }
//        }
//    }
//
//    override func getDataEnd(success: Bool) {
//        if success {
//            mysTable = (tables as? CartsTable)
//            if mysTable == nil {
//                warning("購物車中無商品，或購物車超過一個錯誤，請洽管理員")
//            } else {
//                if (mysTable!.rows.count != 1) {
//                    warning("購物車中無商品，或購物車超過一個錯誤，請洽管理員")
//                } else {
//
//                    myTable = mysTable!.rows[0]
//                    cartItemsTable = myTable!.items
//                    lists1 += cartItemsTable
//                    myTablView.reloadData()
//                }
//            }
//        }
//    }
    
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
        
        warning(msg: "是否確定要刪除呢？", closeButtonTitle: "取消", buttonTitle: "確定") {
            
            Global.instance.addSpinner(superView: self.view)
            self.dataService.delete(token: row.token, type: "cart_item") { (success) in
                if (success) {
                    self.refresh()
                } else {
                    self.warning(self.dataService.msg)
                }
                Global.instance.removeSpinner(superView: self.view)
            }
        }
    }
    
    @IBAction func submitBtnPressed(_ sender: Any) {
        
        //toPayment(order_token: "VZsrHrb0AugnuwhxHKnIwU6QJfbUcfl", ecpay_token: "e2bd42a614344b1d8d4a7895deb37b18", tokenExpireDate: "")
        
        toOrder(
            login: { vc in vc.toLogin() },
            register: { vc in vc.toRegister() }
        )
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        prev()
    }
}
