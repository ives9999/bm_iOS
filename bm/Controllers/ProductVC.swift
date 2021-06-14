//
//  ProductVC.swift
//  bm
//
//  Created by ives on 2020/12/30.
//  Copyright © 2020 bm. All rights reserved.
//

import Foundation

class ProductVC: MyTableVC {
    
    var mysTable: ProductsTable?
        
    override func viewDidLoad() {
        myTablView = tableView
        able_type = "product"
        dataService = ProductService.instance
        //_type = "product"
        //_titleField = "name"
        searchRows = [
            ["title":"關鍵字","atype":UITableViewCell.AccessoryType.none,"key":"keyword","show":"","hint":"請輸入商品名稱關鍵字","text_field":true,"value":"","value_type":"String","segue":""]
        ]
        
        super.viewDidLoad()
        let cellNibName = UINib(nibName: "ProductListCell", bundle: nil)
        tableView.register(cellNibName, forCellReuseIdentifier: "listCell")
        
        refresh()
    }
    
//    override func refresh() {
//        page = 1
//        getDataStart(page: page, perPage: PERPAGE)
//    }
    
    override func genericTable() {
        
        do {
            if (jsonData != nil) {
                mysTable = try JSONDecoder().decode(ProductsTable.self, from: jsonData!)
            } else {
                warning("無法從伺服器取得正確的json資料，請洽管理員")
            }
        } catch {
            msg = "解析JSON字串時，得到空值，請洽管理員"
        }
        if (mysTable != nil) {
            tables = mysTable!
            if (page == 1) {
                lists1 = [ProductTable]()
            }
            lists1 += mysTable!.rows
        }
    }
    
//    override func getDataEnd(success: Bool) {
//        if success {
//            
//            mysTable = (tables as? ProductsTable)
//            if mysTable != nil {
//                let tmps: [ProductTable] = mysTable!.rows
//                
//                if page == 1 {
//                    lists1 = [ProductTable]()
//                }
//                lists1 += tmps
//                
//                myTablView.reloadData()
//            }
//        }
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists1.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as? ProductListCell {
            
            cell.cellDelegate = self
            let row = lists1[indexPath.row] as? ProductTable
            if row != nil {
                row!.filterRow()
                //row!.printRow()
            
                cell.updateViews(row!)
            }
            return cell
        } else {
            return ListCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if mysTable != nil {
            let productTable = mysTable!.rows[indexPath.row]
            //toShowProduct(token: superProduct.token)
            let token = productTable.token
            if #available(iOS 13.0, *) {
                let storyboard = UIStoryboard(name: "More", bundle: nil)
                if let viewController = storyboard.instantiateViewController(identifier: TO_SHOW_PRODUCT)  as? ShowProductVC {
                    
                    viewController.token = token
                    show(viewController, sender: nil)
                }
            } else {
                let viewController = self.storyboard!.instantiateViewController(withIdentifier: TO_SHOW_PRODUCT) as! ShowProductVC
                viewController.token = token
                self.navigationController!.pushViewController(viewController, animated: true)
            }
        }
    }
    
    override func cellCity(row: Table) {
        //print(indexPath!.row)
        
        toOrder(
            product_token: row.token,
            login: { vc in vc.toLogin() },
            register: { vc in vc.toRegister() }
        )
    }
}
