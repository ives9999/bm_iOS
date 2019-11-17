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
    @IBOutlet weak var emptyLbl: SuperLabel!
    @IBOutlet weak var emptyCons: NSLayoutConstraint!
    
    var able: String = "course"//來源是什麼，course
    var able_token: String = ""//來源的token
    var signups: SuperSignups?
    var able_model: SuperCourse = SuperCourse()
    var signupRows: [SuperSignup] = [SuperSignup]()

    override func viewDidLoad() {
        myTablView = tableView
        super.viewDidLoad()
        //print(able_token)

        if able == "course" {
            dataService = CourseService.instance
        }
        
        let cell = UINib(nibName: "SignupListCell", bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: "cell")
        emptyLbl.isHidden = true
        refresh()
    }
    
    override func refresh() {
        page = 1
        getDataStart()
    }
    
    override func getDataStart(page: Int = 1, perPage: Int = PERPAGE) {
        Global.instance.addSpinner(superView: self.view)
        
        dataService.signup_list(token: able_token, page: page, perPage: perPage) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if success {
                self.getDataEnd(success: success)
            } else {
                self.warning(self.dataService.msg)
            }
        }
    }
    
    override func getDataEnd(success: Bool) {
        if success {
            signups = dataService.superModel as? SuperSignups
            
            if page == 1 {
                able_model = dataService.able as! SuperCourse
                titleLbl.text = able_model.title + "報名列表"
                signupRows = [SuperSignup]()
                totalCount = signups!.totalCount
                perPage = signups!.perPage
                let _pageCount: Int = totalCount / perPage
                totalPage = (totalCount % perPage > 0) ? _pageCount + 1 : _pageCount
            }
            signupRows += signups!.rows
            page = signups!.page
            
            if refreshControl.isRefreshing {
                refreshControl.endRefreshing()
            }
            tableView.reloadData()
        }
        self.endRefresh()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if signupRows.count == 0 {
            emptyLbl.isHidden = false
            emptyCons.constant = 20
            return 0
        } else {
            emptyLbl.isHidden = true
            emptyCons.constant = 0
            return signupRows.count + 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SignupListCell
        if indexPath.row == 0 {
            cell.update(no: "序號", signuper: "報名者", signupTime: "報名時間", courseDate: "上課日期")
        } else {
            let row = signupRows[indexPath.row - 1]
            let no = String(indexPath.row)
            cell.update(no: no, signuper: row.member_name, signupTime: row.created_at.noSec().noYear(), courseDate: row.able_date)
        }
        
        return cell
    }

    @IBAction func prevBtnPressed(_ sender: Any) {
        prev()
    }
}
