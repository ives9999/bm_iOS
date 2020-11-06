//
//  ManagerCourseVC.swift
//  bm
//
//  Created by ives on 2019/5/25.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit

class ManagerCourseVC: MyTableVC, EditCourseDelegate {
    
    @IBOutlet weak var titleLbl: UILabel!
    
    var name: String? = nil
    var token: String? = nil
    var manager_token: String? = nil
    
    var superCourses: SuperCourses? = nil
    
    var isReload: Bool = true

    override func viewDidLoad() {
        myTablView = tableView
        super.viewDidLoad()
        
        
        let cellNib = UINib(nibName: "ManagerCourseCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "cell")
        //refresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isReload {
            refresh()
        }
    }
    
    override func refresh() {
        var filter: [String: Any] = [String: Any]()
        filter.merge(["status": "online"])
        if manager_token != nil {
            filter.merge(["manager_token": manager_token!])
        }
        
        Global.instance.addSpinner(superView: self.view)
        CourseService.instance.getList(t: SuperCourse.self, t1: SuperCourses.self, token: token, _filter: filter, page: 1, perPage: 100) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if (success) {
                self.superCourses = (CourseService.instance.superModel as! SuperCourses)
                //self.superCourses!.printRows()
                if self.superCourses != nil {
                    if self.superCourses!.totalCount == 0 {
                        let alert = SCLAlertView()
                        alert.showInfo("目前無您管理的課程")
                    } else {
                        self.tableView.reloadData()
                    }
                } else {
                    let alert = SCLAlertView()
                    alert.showWarning("無法取得課程資料，請洽管理員")
                }
            } else {
                self.warning(CourseService.instance.msg)
            }
            self.endRefresh()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if superCourses != nil {
            return superCourses!.rows.count
        } else {
            return 0
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 120
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ManagerCourseCell
        //cell.blacklistCellDelegate = self
        if superCourses != nil && superCourses!.rows.indices.contains(indexPath.row) {
            let row = superCourses!.rows[indexPath.row]
            //row.printRow()
            cell.forRow(row: row)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var row: SuperCourse? = nil
        if superCourses != nil && superCourses!.rows.indices.contains(indexPath.row) {
            row = superCourses!.rows[indexPath.row]
        }
        
        var title = "課程"
        if row != nil {
            title = row!.title
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
                self._delete(token: self.token!)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == TO_EDIT_COURSE {
            let vc: EditCourseVC = segue.destination as! EditCourseVC
            if sender != nil { //edit
                let row: [String: String] = sender as! [String: String]
                if row["title"] != nil {
                    vc.title = row["title"]
                }
                if row["token"] != nil {
                    vc.course_token = row["token"]
                }
            } else { //add
                vc.course_token = ""
                vc.title = "新增課程"
            }
            if token != nil {
                vc.coach_token = token
            }
            vc.delegate = self
        } else if segue.identifier == TO_SHOW_COURSE {
            let vc: ShowCourseVC = segue.destination as! ShowCourseVC
            vc.delegate = self
            if sender != nil {
                let row: [String: String] = sender as! [String: String]
                if row["title"] != nil {
                    vc.title = row["title"]
                }
                if row["token"] != nil {
                    vc.course_token = row["token"]
                }
            }
        }
    }
    
    private func _delete(token: String) {
        Global.instance.addSpinner(superView: self.view)
        dataService.delete(token: token, type: "course") { (success) in
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
    
    @IBAction func addCourseBtnPressed(_ sender: Any) {
        if !Member.instance.isLoggedIn {
            SCLAlertView().showError("警告", subTitle: "請先登入為會員")
        } else {
            performSegue(withIdentifier: TO_EDIT_COURSE, sender: nil)
        }
    }

    @IBAction func prevBtnPressed(_ sender: Any) {
        prev()
    }
    
    func isReload(_ yes: Bool) {
        self.isReload = yes
    }
}
