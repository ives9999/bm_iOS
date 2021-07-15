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
    
    //source is team or coach or arena
    var source: String = "team"
    
    override func viewDidLoad() {
        myTablView = tableView 
        super.viewDidLoad()
        
        if source == "team" {
            titleLbl.text = "球隊管理"
        } else if source == "coach" {
            titleLbl.text = "教練管理"
        } else if source == "arena" {
            titleLbl.text = "球館管理"
        }

        let cellNib = UINib(nibName: "ManagerCourseCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "cell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refresh()
    }
    
    override func refresh() {
        getManagerList()
    }
    func getManagerList() {
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
    }
    
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
        if segue.identifier == TO_MANAGER_FUNCTION {
            let vc: ManagerFunctionVC = segue.destination as! ManagerFunctionVC
            let row: [String: String] = sender as! [String: String]
            vc.name = row["name"]!
            vc.token = row["token"]!
            vc.source = source
        } else if segue.identifier == TO_EDIT {
            let vc: EditVC = segue.destination as! EditVC
            vc.source = source
        }
    }

    @IBAction func addTeamBtnPressed(_ sender: Any) {
        if !Member.instance.isLoggedIn {
            SCLAlertView().showError("警告", subTitle: "請先登入為會員")
        } else {
            performSegue(withIdentifier: TO_EDIT, sender: nil)
        }
    }
}
