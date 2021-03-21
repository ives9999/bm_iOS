//
//  ProductVC.swift
//  bm
//
//  Created by ives on 2020/12/30.
//  Copyright © 2020 bm. All rights reserved.
//

import Foundation

class ProductVC: ListVC, List1CellDelegate {
    
    let _searchRows: [[String: Any]] = [
        ["title":"關鍵字","atype":UITableViewCell.AccessoryType.none,"key":"keyword","show":"","hint":"請輸入商品名稱關鍵字","text_field":true,"value":"","value_type":"String","segue":""],
        ["title":"縣市","atype":UITableViewCell.AccessoryType.disclosureIndicator,"key":CITY_KEY,"show":"全部","segue":TO_MULTI_SELECT,"sender":0,"value":"","value_type":"Array"]
    ]
    
    var mysTable: ProductsTable?
        
    override func viewDidLoad() {
        myTablView = tableView
        myTablView.allowsMultipleSelectionDuringEditing = false
        myTablView.isUserInteractionEnabled = true
        dataService = ProductService.instance
        _type = "product"
        _titleField = "name"
        searchRows = _searchRows
        
        super.viewDidLoad()
        let cellNibName = UINib(nibName: "List1Cell", bundle: nil)
        tableView.register(cellNibName, forCellReuseIdentifier: "listCell")
        
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.lightGray
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        
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
            if let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as? List1Cell {
                
                cell.cellDelegate = self
                let row = lists1[indexPath.row] as! ProductTable
                row.filterRow()
                //row.printRow()
                
                cell.updateProductViews(indexPath: indexPath, row: row)
                
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
                        
                        viewController.product_token = token
                        show(viewController, sender: nil)
                    }
                } else {
                    let viewController = self.storyboard!.instantiateViewController(withIdentifier: TO_SHOW_PRODUCT) as! ShowProductVC
                    viewController.product_token = token
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
    
    func cellShowMap(indexPath: IndexPath?) {}
    
    func cellTel(indexPath: IndexPath?) {}
    
    func cellMobile(indexPath: IndexPath?) {}
    
    func cellRefresh(indexPath: IndexPath?) {}
    
    func cellEdit(indexPath: IndexPath?) {}
    
    func cellDelete(indexPath: IndexPath?) {}
    
    func cellCity(indexPath: IndexPath?) {
        //print(indexPath!.row)
        
        let productTable = mysTable?.rows[indexPath!.row]
        if productTable != nil {
            toOrder(
                product_token: productTable!.token,
                login: { vc in vc.toLogin() },
                register: { vc in vc.toRegister() }
            )
        } else {
            
        }
    }
}
