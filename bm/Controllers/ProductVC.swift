//
//  ProductVC.swift
//  bm
//
//  Created by ives on 2020/12/30.
//  Copyright © 2020 bm. All rights reserved.
//

import Foundation

class ProductVC: ListVC {
    
    let _searchRows: [[String: Any]] = [
        ["title":"關鍵字","atype":UITableViewCell.AccessoryType.none,"key":"keyword","show":"","hint":"請輸入商品名稱關鍵字","text_field":true,"value":"","value_type":"String","segue":""],
        ["title":"縣市","atype":UITableViewCell.AccessoryType.disclosureIndicator,"key":CITY_KEY,"show":"全部","segue":TO_MULTI_SELECT,"sender":0,"value":"","value_type":"Array"]
    ]
    
    var mysTable: ProductsTable?
        
    override func viewDidLoad() {
        myTablView = tableView
        dataService = ProductService.instance
        //_type = "product"
        //_titleField = "name"
        searchRows = _searchRows
        
        super.viewDidLoad()
        let cellNibName = UINib(nibName: "ProductListCell", bundle: nil)
        tableView.register(cellNibName, forCellReuseIdentifier: "listCell")
        
        //refresh()
    }
    
    override func refresh() {
        page = 1
        getDataStart(t: ProductsTable.self)
    }
    
    override func getDataEnd(success: Bool) {
        if success {
            
            mysTable = (tables as? ProductsTable)
            if mysTable != nil {
                let tmps: [ProductTable] = mysTable!.rows
                
                if page == 1 {
                    lists1 = [ProductTable]()
                }
                lists1 += tmps
                
                myTablView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return lists1.count
        } else {
            return searchRows.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
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
        } else if tableView == searchTableView {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "search_cell", for: indexPath) as? EditCell {
                cell.editCellDelegate = self
                let searchRow = searchRows[indexPath.row]
                //print(searchRow)
                cell.forRow(indexPath: indexPath, row: searchRow, isClear: true)
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.tableView {
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
            
        } else if tableView == searchTableView {
            
            let row = searchRows[indexPath.row]
            let segue: String = row["segue"] as! String
            
            let key: String = row["key"] as! String
            if segue == TO_MULTI_SELECT {
                toMultiSelect(key: key, _delegate: self)
            } else if segue == TO_SINGLE_SELECT {
                
            }
            //performSegue(withIdentifier: segue, sender: indexPath)
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
