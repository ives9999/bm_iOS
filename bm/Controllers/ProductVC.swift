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
        ["title":"關鍵字","atype":UITableViewCellAccessoryType.none,"key":"keyword","show":"","hint":"請輸入商品名稱關鍵字","text_field":true,"value":"","value_type":"String","segue":""],
        ["title":"縣市","atype":UITableViewCellAccessoryType.disclosureIndicator,"key":CITY_KEY,"show":"全部","segue":TO_MULTI_SELECT,"sender":0,"value":"","value_type":"Array"]
    ]
    var params1: [String: Any]?
    var superProducts: SuperProducts? = nil
    internal(set) public var lists1: [SuperModel] = [SuperModel]()
    
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
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //refresh()
    }
    
    override func refresh() { //called by ListVC viewWillAppear
        page = 1
        getDataStart()
    }
    
    override func getDataStart(page: Int=1, perPage: Int=PERPAGE) {
        //print(page)
        Global.instance.addSpinner(superView: self.view)

        dataService.getList(t: SuperProduct.self, t1: SuperProducts.self, token: nil, _filter: params1, page: page, perPage: perPage) { (success) in
            if (success) {
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
            let superModel: SuperModel = dataService.superModel
            superProducts = (superModel as! SuperProducts)
            //superCourses = CourseService.instance.superCourses
            let tmps: [SuperProduct] = superProducts!.rows

            //print(tmps)
            //print("===============")
            if page == 1 {
                lists1 = [SuperProducts]()
            }
            lists1 += tmps
            //print(self.lists)
            page = superProducts!.page
            if page == 1 {
                totalCount = superProducts!.totalCount
                perPage = superProducts!.perPage
                let _pageCount: Int = totalCount / perPage
                totalPage = (totalCount % perPage > 0) ? _pageCount + 1 : _pageCount
                //print(self.totalPage)
                if refreshControl.isRefreshing {
                    refreshControl.endRefreshing()
                }
            }
            myTablView.reloadData()
            //self.page = self.page + 1 in CollectionView
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
                
                //cell.cellDelegate = self
                let row = lists1[indexPath.row] as! SuperProduct
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
            if superProducts != nil {
                let superProduct = superProducts!.rows[indexPath.row]
                performSegue(withIdentifier: TO_SHOW_PRODUCT, sender: superProduct)
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
}
