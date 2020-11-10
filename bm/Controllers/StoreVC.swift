//
//  StoreVC.swift
//  bm
//
//  Created by ives sun on 2020/10/23.
//  Copyright © 2020 bm. All rights reserved.
//

import Foundation

class StoreVC: ListVC {
    
    let _searchRows: [[String: Any]] = [
        ["title":"關鍵字","atype":UITableViewCellAccessoryType.none,"key":"keyword","show":"","hint":"請輸入課程名稱關鍵字","text_field":true,"value":"","value_type":"String"],
        ["title":"縣市","atype":UITableViewCellAccessoryType.disclosureIndicator,"key":CITY_KEY,"show":"全部","segue":TO_MULTI_SELECT,"sender":0,"value":"","value_type":"Array"],
        ["title":"日期","atype":UITableViewCellAccessoryType.disclosureIndicator,"key":WEEKDAY_KEY,"show":"全部","segue":TO_MULTI_SELECT,"sender":[Int](),"value":"","value_type":"Array"],
        ["title":"開始時間之後","atype":UITableViewCellAccessoryType.disclosureIndicator,"key":START_TIME_KEY,"show":"不限","segue":TO_SINGLE_SELECT,"sender":[String: Any](),"value":"","value_type":"String"],
        ["title":"結束時間之前","atype":UITableViewCellAccessoryType.disclosureIndicator,"key":END_TIME_KEY,"show":"不限","segue":TO_SINGLE_SELECT,"sender":[String: Any](),"value":"","value_type":"String"]
    ]
    var params1: [String: Any]?
    var superStores: SuperStores? = nil
    internal(set) public var lists1: [SuperModel] = [SuperModel]()
    
    override func viewDidLoad() {
        myTablView = tableView
        myTablView.allowsMultipleSelectionDuringEditing = false
        myTablView.isUserInteractionEnabled = true
        dataService = StoreService.instance
        _type = "store"
        _titleField = "name"
        searchRows = _searchRows
        
        let cellNibName = UINib(nibName: "List1Cell", bundle: nil)
        myTablView.register(cellNibName, forCellReuseIdentifier: "list1cell")
        tableView.estimatedRowHeight = 180
        tableView.rowHeight = UITableViewAutomaticDimension
        
        super.viewDidLoad()
    }
    
    override func getDataStart(page: Int=1, perPage: Int=PERPAGE) {
        //print(page)
        Global.instance.addSpinner(superView: self.view)
        
        dataService.getList(t: SuperStore.self, t1: SuperStores.self, token: nil, _filter: params1, page: page, perPage: perPage) { (success) in
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
            superStores = (superModel as! SuperStores)
            //superCourses = CourseService.instance.superCourses
            let tmps: [SuperStore] = superStores!.rows
            
            //print(tmps)
            //print("===============")
            if page == 1 {
                lists1 = [SuperStores]()
            }
            lists1 += tmps
            //print(self.lists)
            page = superStores!.page
            if page == 1 {
                totalCount = superStores!.totalCount
                perPage = superStores!.perPage
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
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        return UITableViewAutomaticDimension
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "list1cell", for: indexPath) as? List1Cell {
                
                //cell.cellDelegate = self
                let row = lists1[indexPath.row] as! SuperStore
                //row.printRow()
                
                cell.updateStoreViews(indexPath: indexPath, data: row)
                
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
            if superStores != nil {
                let superStore = superStores!.rows[indexPath.row]
                performSegue(withIdentifier: TO_SHOW_STORE, sender: superStore)
            }
            
        } else if tableView == searchTableView {
            let row = searchRows[indexPath.row]
            let segue: String = row["segue"] as! String
            performSegue(withIdentifier: segue, sender: indexPath)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let showVC: ShowStoreVC = segue.destination as? ShowStoreVC {
            assert(sender as? SuperStore != nil)
            let superStore: SuperStore = sender as! SuperStore
            showVC.superStore = superStore
            showVC.store_token = superStore.token
        }
    }
    
    @IBAction func manager(_ sender: Any) {
        if !Member.instance.isLoggedIn {
            SCLAlertView().showError("警告", subTitle: "請先登入為會員")
        } else {
            performSegue(withIdentifier: TO_MANAGER_STORE, sender: nil)
        }
    }
    
    @IBAction func searchBtnPressed(_ sender: Any) {
        if searchPanelisHidden {
            showSearchPanel()
        } else {
            searchPanelisHidden = true
            unmask()
        }
    }
}
