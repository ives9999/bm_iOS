//
//  ManagerCourseVC.swift
//  bm
//
//  Created by ives on 2019/5/25.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit

class ManagerCourseVC: MyTableVC {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    
    var name: String? = nil
    var token: String? = nil
    
    var superCourses: SuperCourses? = nil

    override func viewDidLoad() {
        myTablView = tableView
        super.viewDidLoad()
        
        
        let cellNib = UINib(nibName: "ManagerCourseCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "cell")
        refresh()
    }
    
    override func refresh() {
        Global.instance.addSpinner(superView: self.view)
        CourseService.instance.getList(token: token, filter: nil, page: 1, perPage: 100) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if (success) {
                self.superCourses = CourseService.instance.superCourses
                self.tableView.reloadData()
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
            if row != nil {
                cell.forRow(row: row)
            }
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
            //self.performSegue(withIdentifier: TO_SHOWTIMETABLE, sender: event.id)
        }
        let action2 = UIAlertAction(title: "編輯", style: .default) { (action) in
            let sender: [String: String] = ["title": title, "token": row!.token]
            self.performSegue(withIdentifier: TO_EDIT_COURSE, sender: sender)
        }
        let action3 = UIAlertAction(title: "刪除", style: .default) { (action) in
            self.layerDelete(view: UIButton())
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
            if sender != nil {
                let row: [String: String] = sender as! [String: String]
                if row["title"] != nil {
                    vc.title = row["title"]
                }
                if row["token"] != nil {
                    vc.token = row["token"]
                }
            }
        }
    }

    @IBAction func prevBtnPressed(_ sender: Any) {
        prev()
    }

}
