//
//  StoreVC.swift
//  bm
//
//  Created by ives sun on 2020/10/23.
//  Copyright © 2020 bm. All rights reserved.
//

import Foundation
import SCLAlertView

class StoreVC: MyTableVC {
    
    var mysTable: StoresTable?
    
    //let session: UserDefaults = UserDefaults.standard
            
    override func viewDidLoad() {
        myTablView = tableView
        able_type = "store"
        dataService = StoreService.instance
//        _type = "store"
//        _titleField = "name"
//        searchRows = [
//            ["title":"店名關鍵字","atype":UITableViewCell.AccessoryType.none,"key":"keyword","show":"","hint":"請輸入店名名稱關鍵字","text_field":true,"value":"","value_type":"String","segue":""],
//            ["title":"縣市","atype":UITableViewCell.AccessoryType.disclosureIndicator,"key":CITY_KEY,"show":"全部","segue":TO_CITY,"sender":0,"value":"","value_type":"Array"]
//        ]
        
        searchSections = initSectionRows()
        
        super.viewDidLoad()
        
        let cellNibName = UINib(nibName: "StoreListCell", bundle: nil)
        tableView.register(cellNibName, forCellReuseIdentifier: "listCell")
        
        // this page show search icon in top
        searchBtn.visibility = .visible
        
        refresh()
    }
    
    override func initSectionRows()-> [SearchSection] {

        var sections: [SearchSection] = [SearchSection]()

        sections.append(makeSection0Row())

        return sections
    }
    
    override func makeSection0Row(_ isExpanded: Bool=true)-> SearchSection {
        var rows: [SearchRow] = [SearchRow]()
        let r1: SearchRow = SearchRow(title: "關鍵字", key: KEYWORD_KEY, cell: "textField")
        rows.append(r1)
        let r2: SearchRow = SearchRow(title: "縣市", show: "全部", key: CITY_KEY, cell: "more", accessory: UITableViewCell.AccessoryType.disclosureIndicator)
        rows.append(r2)

        let s: SearchSection = SearchSection(title: "一般", isExpanded: isExpanded)
        s.items.append(contentsOf: rows)
        return s
    }
    
//    override func refresh() {
//        page = 1
//        getDataStart(page: page, perPage: PERPAGE)
//    }
    
    override func genericTable() {
        
        do {
            if (jsonData != nil) {
                mysTable = try JSONDecoder().decode(StoresTable.self, from: jsonData!)
            } else {
                warning("無法從伺服器取得正確的json資料，請洽管理員")
            }
        } catch {
            msg = "解析JSON字串時，得到空值，請洽管理員"
        }
        if (mysTable != nil) {
            tables = mysTable!
            if (page == 1) {
                lists1 = [StoreTable]()
            }
            lists1 += mysTable!.rows
        }
    }
    
//    override func getDataEnd(success: Bool) {
//        if success {
//            
//            mysTable = (tables as? StoresTable)
//            if mysTable != nil {
//                let tmps: [StoreTable] = mysTable!.rows
//                
//                if page == 1 {
//                    lists1 = [StoreTable]()
//                }
//                lists1 += tmps
//                myTablView.reloadData()
//            } else {
//                warning("轉換Table出錯，請洽管理員")
//            }
//        }
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists1.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as? StoreListCell {
            
            cell.cellDelegate = self
            let row = lists1[indexPath.row] as? StoreTable
            if row != nil {
                row!.filterRow()
                //row!.printRow()
            
                cell.updateViews(row!)
            }
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = lists1[indexPath.row]
        toShowStore(token: row.token)
    }
    
    func cellEdit(indexPath: IndexPath?) {
        if indexPath != nil {
            let row = lists1[indexPath!.row] as! StoreTable
            if #available(iOS 13.0, *) {
                let storyboard = UIStoryboard(name: "More", bundle: nil)
                if let viewController = storyboard.instantiateViewController(identifier: TO_EDIT_STORE) as? EditStoreVC {
                    viewController.title = row.name
                    viewController.store_token = row.token
                    show(viewController, sender: nil)
                }
            } else {
                let viewController = self.storyboard!.instantiateViewController(withIdentifier: TO_EDIT_STORE) as! EditStoreVC
                viewController.title = row.name
                viewController.store_token = row.token
                self.navigationController!.pushViewController(viewController, animated: true)
            }
        } else {
            warning("index path 為空值，請洽管理員")
        }
    }
    
    func cellDelete(indexPath: IndexPath?) {
        if indexPath != nil {
            let row = lists1[indexPath!.row] as! StoreTable
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let alert = SCLAlertView(appearance: appearance)
            alert.addButton("確定", action: {
                self._delete(token: row.token)
                self.prevBtnPressed("")
            })
            alert.addButton("取消", action: {
            })
            alert.showWarning("警告", subTitle: "是否確定要刪除")
        } else {
            warning("index path 為空值，請洽管理員")
        }
    }
    
    private func _delete(token: String) {
        Global.instance.addSpinner(superView: self.view)
        dataService.delete(token: token, type: "store") { (success) in
            if success {
                Global.instance.removeSpinner(superView: self.view)
                if (!self.dataService.success) {
                    SCLAlertView().showError("錯誤", subTitle: "無法刪除，請稍後再試")
                }
                NotificationCenter.default.post(name: NOTIF_TEAM_UPDATE, object: nil)
                self.refresh()
            } else {
                SCLAlertView().showError("錯誤", subTitle: "無法刪除，請稍後再試")
            }
        }
    }
    
//    override func multiSelected(key: String, selecteds: [String]) {
//        var row = getDefinedRow(key)
//        var show = ""
//        if key == WEEKDAY_KEY {
//            var texts: [String] = [String]()
//            for selected in selecteds {
//                let text = WEEKDAY.intToString(Int(selected)!)
//                texts.append(text)
//            }
//            show = texts.joined(separator: ",")
//        } else if key == CITY_KEY {
//            var citys: [[String: String]] = [[String: String]]()
//            if session.array(forKey: "citys") != nil {
//                citys = (session.array(forKey: "citys") as! [[String: String]])
//                //print(citys)
//            }
//            var texts: [String] = [String]()
//            for selected in selecteds {
//                for city in citys {
//                    if city["value"] == selected {
//                        let text = city["title"]!
//                        texts.append(text)
//                        break
//                    }
//                }
//            }
//            show = texts.joined(separator: ",")
//        }
//        row["show"] = show
//        row["value"] = selecteds.joined(separator: ",")
//        replaceRows(key, row)
//        searchTableView.reloadData()
//    }
    
    @IBAction func manager(_ sender: Any) {
        if !Member.instance.isLoggedIn {
            SCLAlertView().showError("警告", subTitle: "請先登入為會員")
        } else {
            performSegue(withIdentifier: TO_MANAGER_STORE, sender: nil)
        }
    }
}

