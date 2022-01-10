//
//  ManagerTeamVC.swift
//  bm
//
//  Created by ives on 2021/11/19.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation
import SCLAlertView

class ManagerTeamVC: ManagerVC {
    
    var mysTable: TeamsTable?
    
    var isReload: Bool = true

    override func viewDidLoad() {
        
        myTablView = tableView
        able_type = "team"
        dataService = TeamService.instance
        
        super.viewDidLoad()
        
        let cellNib = UINib(nibName: "ManagerTeamCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "cell")
        
        refresh()
    }
    
    override func genericTable() {
        
        do {
            if (jsonData != nil) {
                mysTable = try JSONDecoder().decode(TeamsTable.self, from: jsonData!)
            } else {
                warning("無法從伺服器取得正確的json資料，請洽管理員")
            }
        } catch {
            warning("解析JSON字串時，得到空值，請洽管理員")
        }
        
        if (mysTable != nil) {
            tables = mysTable!
            if (page == 1) {
                lists1 = [TeamTable]()
            }
            lists1 += mysTable!.rows
        }
    }
    
//    override func refresh() {
//        var filter: [String: Any] = [String: Any]()
//        filter.merge(["status": "online"])
//        if manager_token != nil {
//            filter.merge(["manager_token": manager_token!])
//        }
//
//        Global.instance.addSpinner(superView: self.view)
//        CourseService.instance.getList(token: token, _filter: filter, page: 1, perPage: PERPAGE) { (success) in
//            Global.instance.removeSpinner(superView: self.view)
//            if (success) {
//
//                do {
//                    if (self.dataService.jsonData != nil) {
//                        try self.coursesTable = JSONDecoder().decode(CoursesTable.self, from: CourseService.instance.jsonData!)
//                        if (self.coursesTable != nil) {
//                            //self.coursesTable!.printRows()
//                            self.tableView.reloadData()
//                        }
//                    } else {
//                        self.warning("無法從伺服器取得正確的json資料，請洽管理員")
//                    }
//                } catch {
//                    self.msg = "解析JSON字串時，得到空值，請洽管理員"
//                }
//
//            } else {
//                self.warning(CourseService.instance.msg)
//            }
//            self.endRefresh()
//        }
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ManagerTeamCell
        //cell.blacklistCellDelegate = self
        
        let row = lists1[indexPath.row] as? TeamTable
        if (row != nil) {
            row!.filterRow()
            cell.cellDelegate = self
            cell.forRow(row: row!)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = lists1[indexPath.row] as? TeamTable
        if row != nil {
            toShowTeam(token: row!.token)
        }
        
//        if mysTable != nil {
//            let myTable = mysTable!.rows[indexPath.row]
//
//            let title = myTable.title
//
//            let alert = UIAlertController(title: title, message: "選擇動作", preferredStyle: .alert)
//            let action1 = UIAlertAction(title: "檢視", style: .default) { (action) in
//                self.toShowTeam(token: myTable.token)
//                //let sender: [String: String] = ["title": title, "token": myTable.token]
//                //self.performSegue(withIdentifier: TO_SHOW_COURSE, sender: sender)
//            }
//            let action2 = UIAlertAction(title: "編輯", style: .default) { (action) in
//                self.toEditTeam(token: myTable.token)
//            }
//            let action3 = UIAlertAction(title: "刪除", style: .default) { (action) in
//
//                let appearance = SCLAlertView.SCLAppearance(
//                    showCloseButton: false
//                )
//                let alert = SCLAlertView(appearance: appearance)
//                alert.addButton("確定", action: {
//                    self._delete(token: self.token!)
//                    self.prevBtnPressed("")
//                })
//                alert.addButton("取消", action: {
//                })
//                alert.showWarning("警告", subTitle: "是否確定要刪除")
//            }
//            let action4 = UIAlertAction(title: "取消", style: .default) { (action) in
//            }
//            alert.addAction(action1)
//            alert.addAction(action2)
//            alert.addAction(action3)
//            alert.addAction(action4)
//            present(alert, animated: true, completion: nil)
//        }
    }
    
    override func cellEdit(row: Table) {
        toEditTeam(token: row.token, _delegate: self)
    }
    
    override func cellSignup(row: Table) {
        toManagerSignup(able_type: able_type, able_token: row.token, able_title: row.name)
    }
    
    override func cellDelete(row: Table) {
        msg = "是否確定要刪除此球隊？"
        warning(msg: msg, closeButtonTitle: "取消", buttonTitle: "刪除") {
            Global.instance.addSpinner(superView: self.view)
            self.dataService.delete(token: row.token, type: self.able_type) { success in
                Global.instance.removeSpinner(superView: self.view)
                if (success) {
                    do {
                        self.jsonData = self.dataService.jsonData
                        if (self.jsonData != nil) {
                            let successTable: SuccessTable = try JSONDecoder().decode(SuccessTable.self, from: self.jsonData!)
                            if (!successTable.success) {
                                self.warning(successTable.msg)
                            } else {
                                self.refresh()
                            }
                        } else {
                            self.warning("無法從伺服器取得正確的json資料，請洽管理員")
                        }
                    } catch {
                        self.msg = "解析JSON字串時，得到空值，請洽管理員"
                        self.warning(self.msg)
                    }
                } else {
                    self.warning("刪除失敗，請洽管理員")
                }
            }
        }
    }
    
    override func addPressed() {
        toEditTeam(token: "", _delegate: self)
    }
    
//    @IBAction func addCourseBtnPressed(_ sender: Any) {
//        if !Member.instance.isLoggedIn {
//            warning("請先登入為會員")
//        } else {
//            performSegue(withIdentifier: TO_EDIT_COURSE, sender: nil)
//        }
//    }
    
    func isReload(_ yes: Bool) {
        self.isReload = yes
        if self.isReload {
            refresh()
        }
    }
}
