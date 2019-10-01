//
//  SignupListVC.swift
//  bm
//
//  Created by ives on 2019/9/30.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit

class SignupListVC: MyTableVC {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLbl: SuperLabel!
    @IBOutlet weak var emptyCons: NSLayoutConstraint!
    
    var able: String = "course"//來源是什麼，course
    var able_token: String = ""//來源的token
    var signups: SuperSignups?

    override func viewDidLoad() {
        myTablView = tableView
        super.viewDidLoad()
        //print(able_token)

        if able == "course" {
            dataService = CourseService.instance
        }
        tableView.register(BlackListCell.self, forCellReuseIdentifier: "cell")
        refresh()
    }
    
    override func refresh() {
        Global.instance.addSpinner(superView: self.view)
        
        dataService.signup_list(token: able_token) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if (success) {
                self.signups = self.dataService.superModel as? SuperSignups
                self.tableView.reloadData()
            } else {
                self.warning(self.dataService.msg)
            }
            self.endRefresh()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if signups == nil {
            return 0
        } else {
            return signups!.rows.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BlackListCell
        //cell.blacklistCellDelegate = self
        //let row = blacklists[indexPath.row]
        //cell.setRow(row: row, position: indexPath.row)
        
        return cell
    }

    @IBAction func prevBtnPressed(_ sender: Any) {
        prev()
    }
}
