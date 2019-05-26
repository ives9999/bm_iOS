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
        
        if superCourses != nil && superCourses!.rows.indices.contains(indexPath.row) {
            let row = superCourses!.rows[indexPath.row]
        }
    }

    @IBAction func prevBtnPressed(_ sender: Any) {
        prev()
    }

}
