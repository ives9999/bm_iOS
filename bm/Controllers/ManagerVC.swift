//
//  TeamManagerVC.swift
//  bm
//
//  Created by ives on 2018/5/21.
//  Copyright © 2018年 bm. All rights reserved.
//

import UIKit
import SCLAlertView

class ManagerVC: MyTableVC {

    @IBOutlet weak var titleLbl: UILabel!
    
    var name: String? = nil
    var token: String? = nil
    var manager_token: String? = nil
    
    override func viewDidLoad() {
        myTablView = tableView
        if (manager_token != nil) {
            params["manager_token"] = manager_token!
        }
        //必須指定status，預設是只會出現上線的
        params["status"] = "all"
        
        super.viewDidLoad()
        
        addBtn.visibility = .visible
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return lists1.count
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        refresh()
//    }
//
//    override func refresh() {
//        getManagerList()
//    }

//    func getManagerList() {
//        if Member.instance.isLoggedIn {
//            _getManagerList(source: source, titleField: titleField) { (success) in
//                if (success) {
//                    self.tableView.reloadData()
//                    self.refreshControl.endRefreshing()
//                } else {
//                    self.warning(self.msg)
//                    self.refreshControl.endRefreshing()
//                }
//            }
//        }
//    }
    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return managerLists.count
//    }
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        //print("show cell sections: \(indexPath.section), rows: \(indexPath.row)")
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ManagerCourseCell
//        //print(rows)
//        
//        let row: SuperData = managerLists[indexPath.row]
//        //print(row)
//        cell.titleLbl.text = row.title
//        cell.featured.image = row.featured
//        
//        return cell
//    }
//    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let row: SuperData = managerLists[indexPath.row]
//        let name: String = row.title
//        let token: String = row.token
//        let sender:[String: String] = ["name": name, "token": token]
//        performSegue(withIdentifier: TO_MANAGER_FUNCTION, sender: sender)
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == TO_MANAGER_FUNCTION {
//            let vc: ManagerFunctionVC = segue.destination as! ManagerFunctionVC
//            let row: [String: String] = sender as! [String: String]
//            vc.name = row["name"]!
//            vc.token = row["token"]!
//            vc.source = source
//        } else if segue.identifier == TO_EDIT {
//            let vc: EditVC = segue.destination as! EditVC
//            vc.source = source
//        }
    }
    
    override func cellDelete(row: Table) {
        
        warning(msg: "是否確定要刪除此筆資料？", closeButtonTitle: "取消", buttonTitle: "刪除", buttonAction: {
            self._delete(token: row.token)
        })
    }
    
    func _delete(token: String) {
        Global.instance.addSpinner(superView: self.view)
        dataService.delete(token: token, type: able_type) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if success {
//                if (!self.dataService.success) {
//                    self.warning("無法刪除，請稍後再試")
//                }
//                NotificationCenter.default.post(name: NOTIF_TEAM_UPDATE, object: nil)
                self.refresh()
            } else {
                self.warning(self.dataService.msg)
            }
        }
    }
    
    override func cellRefresh() {
        refresh()
    }
}
