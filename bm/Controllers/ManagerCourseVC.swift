//
//  ManagerCourseVC.swift
//  bm
//
//  Created by ives on 2019/5/25.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit
import SCLAlertView

class ManagerCourseVC: ManagerVC {
    
    var mysTable: CoursesTable?
    
    var isReload: Bool = true

    override func viewDidLoad() {
        
        myTablView = tableView
        able_type = "course"
        dataService = CourseService.instance
        
        super.viewDidLoad()
        
        let cellNib = UINib(nibName: "ManagerCourseCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "cell")
    
        refresh()
    }
    
    override func genericTable() {
        
        do {
            if (jsonData != nil) {
                mysTable = try JSONDecoder().decode(CoursesTable.self, from: jsonData!)
            } else {
                warning("無法從伺服器取得正確的json資料，請洽管理員")
            }
        } catch {
            msg = "解析JSON字串時，得到空值，請洽管理員"
        }
        if (mysTable != nil) {
            tables = mysTable!
            if mysTable!.rows.count > 0 {
                if (page == 1) {
                    lists1 = [CourseTable]()
                }
                lists1 += mysTable!.rows
            } else {
                view.setInfo(info: "目前暫無課程", topAnchor: topView)
            }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ManagerCourseCell
        //cell.blacklistCellDelegate = self
        
        let row = lists1[indexPath.row] as? CourseTable
        if (row != nil) {
            row!.filterRow()
            cell.cellDelegate = self
            cell.forRow(row: row!)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = lists1[indexPath.row] as? CourseTable
        if row != nil {
            toShowCourse(token: row!.token)
        }
        
//        if mysTable != nil {
//            let myTable = mysTable!.rows[indexPath.row]
//
//            let title = myTable.title
//
//            let alert = UIAlertController(title: title, message: "選擇動作", preferredStyle: .alert)
//            let action1 = UIAlertAction(title: "檢視", style: .default) { (action) in
//                self.toShowCourse(token: myTable.token)
//                //let sender: [String: String] = ["title": title, "token": myTable.token]
//                //self.performSegue(withIdentifier: TO_SHOW_COURSE, sender: sender)
//            }
//            let action2 = UIAlertAction(title: "編輯", style: .default) { (action) in
//                self.toEditCourse(token: myTable.token)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
//        if sender != nil { //edit
//            let row: [String: String] = sender as! [String: String]
//            if row["title"] != nil {
//                vc.title = row["title"]
//            }
//            if row["token"] != nil {
//                vc.course_token = row["token"]
//            }
//        } else { //add
//            vc.course_token = ""
//            vc.title = "新增課程"
//        }
//
//        if segue.identifier == TO_EDIT_COURSE {
//            let vc: EditCourseVC = segue.destination as! EditCourseVC
//            if token != nil {
//                vc.coach_token = token
//            }
//            vc.delegate = self
//        }
    }
    
    override func cellEdit(row: Table) {
        toEditCourse(token: row.token, _delegate: self)
    }
    
    override func cellSignup(row: Table) {
        toManagerSignup(able_type: able_type, able_token: row.token, able_title: row.title)
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
