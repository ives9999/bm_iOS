//
//  ManagerStoreVC.swift
//  bm
//
//  Created by ives sun on 2020/11/6.
//  Copyright © 2020 bm. All rights reserved.
//

import Foundation
import SCLAlertView

class ManagerStoreVC: MyTableVC {
    
    var token: String?
    var manager_token: String?
    var storesTable: StoresTable?
    
    override func viewDidLoad() {
        myTablView = tableView
        super.viewDidLoad()
        
        
        let cellNib = UINib(nibName: "ManagerCourseCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "cell")
        manager_token = Member.instance.token
        refresh()
    }
    
    override func refresh() {
        var filter: [String: Any] = [String: Any]()
        filter.merge(["status": "online"])
        if manager_token != nil {
            filter.merge(["manager_token": manager_token!])
        }
        
        Global.instance.addSpinner(superView: self.view)
        StoreService.instance.getList(t: StoresTable.self, token: token, _filter: filter, page: 1, perPage: 100) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if (success) {
                self.storesTable = (StoreService.instance.tables as! StoresTable)
                //self.superCourses!.printRows()
                if self.storesTable != nil {
                    if self.storesTable!.totalCount == 0 {
                        let alert = SCLAlertView()
                        alert.showInfo("目前無您管理的體育用品店", subTitle: "")
                    } else {
                        self.tableView.reloadData()
                    }
                } else {
                    let alert = SCLAlertView()
                    alert.showWarning("無法取得體育用品店資料，請洽管理員", subTitle: "")
                }
            } else {
                self.warning(CourseService.instance.msg)
            }
            self.endRefresh()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if storesTable != nil {
            return storesTable!.rows.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ManagerCourseCell
        //cell.blacklistCellDelegate = self
        if storesTable != nil && storesTable!.rows.indices.contains(indexPath.row) {
            let row = storesTable!.rows[indexPath.row]
            //row.printRow()
            cell.forStoreRow(row: row)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var row: StoreTable? = nil
        if storesTable != nil && storesTable!.rows.indices.contains(indexPath.row) {
            row = storesTable!.rows[indexPath.row]
        }
        
        var title = "體育用品店"
        if row != nil {
            title = row!.name
        }
        
        let alert = UIAlertController(title: title, message: "選擇動作", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "檢視", style: .default) { (action) in
            let sender: [String: String] = ["title": title, "token": row!.token]
            self.performSegue(withIdentifier: TO_SHOW_COURSE, sender: sender)
        }
        let action2 = UIAlertAction(title: "編輯", style: .default) { (action) in
            let sender: [String: String] = ["title": title, "token": row!.token]
            self.performSegue(withIdentifier: TO_EDIT_COURSE, sender: sender)
        }
        let action3 = UIAlertAction(title: "刪除", style: .default) { (action) in
            
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let alert = SCLAlertView(appearance: appearance)
            alert.addButton("確定", action: {
                //self._delete(token: self.token!)
                self.prevBtnPressed("")
            })
            alert.addButton("取消", action: {
            })
            alert.showWarning("警告", subTitle: "是否確定要刪除")
        }
        let action4 = UIAlertAction(title: "取消", style: .default) { (action) in
        }
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        alert.addAction(action4)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addStoreBtnPressed(_ sender: Any) {
        if !Member.instance.isLoggedIn {
            SCLAlertView().showError("警告", subTitle: "請先登入為會員")
        } else {
            performSegue(withIdentifier: TO_EDIT_STORE, sender: nil)
        }
    }

    @IBAction func prevBtnPressed(_ sender: Any) {
        prev()
    }
}
