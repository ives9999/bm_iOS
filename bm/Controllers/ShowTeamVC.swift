//
//  ShowTeamVC.swift
//  bm
//
//  Created by ives on 2021/5/2.
//  Copyright © 2021 bm. All rights reserved.
//

import UIKit

class ShowTeamVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var tableView: SuperTableView!
    
    var team_token: String?
    var myTable: TeamTable?
    
    var tableRowKeys:[String] = ["weekday_text","interval_show","date","price_text_long","people_limit_text","kind_text","pv","created_at_show"]
    var tableRows: [String: [String:String]] = [
        "weekday_text":["icon":"calendar","title":"星期","content":""],
        "interval_show":["icon":"clock","title":"時段","content":""],
        "date":["icon":"calendar","title":"期間","content":""],
        "price_text_long":["icon":"money","title":"收費","content":""],
        "people_limit_text":["icon":"group","title":"限制人數","content":""],
        "kind_text": ["icon":"cycle","title":"週期","content":""],       // "signup_count":["icon":"group","title":"已報名人數","content":""],
        "pv":["icon":"pv","title":"瀏覽數","content":""],
        "created_at_show":["icon":"calendar","title":"建立日期","content":""]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataService = TeamService.instance
        
        let cellNib = UINib(nibName: "OneLineCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "cell")

        refresh()
    }
    
    override func refresh() {
        if team_token != nil {
            Global.instance.addSpinner(superView: view)
            //print(Member.instance.token)
            let params: [String: String] = ["token": team_token!, "member_token": Member.instance.token]
            dataService.getOne(t: TeamTable.self, params: params) { (success) in
                if (success) {
                    let table: Table = self.dataService.table!
                    self.myTable = table as? TeamTable
                    
                    if self.myTable != nil {
                        //self.courseTable?.printRow()
                        
                        //self.courseTable!.date_model.printRow()
                        //self.coachTable = self.courseTable!.coach
                        //self.courseTable!.signup_normal_models
                        
                        //self.setMainData() // setup course basic data
                        //self.setFeatured() // setup featured
                        
                        //if self.myTable!.dateTable != nil { // setup next time course time
                            //self.courseTable!.dateTable?.printRow()
                           // self.setNextTime()
                        //}
                        //self.fromNet = true
                        
                        //self.isLike = self.myTable!.like
                        //self.likeButton.initStatus(self.isLike, self.courseTable!.like_count)
                        
                        self.tableView.reloadData()
                        //self.signupTableView.reloadData()
                        
//                        if self.coachTable!.isSignup {
//                            self.signupButton.setTitle("取消報名")
//                        } else {
//                            let count = self.coachTable!.signup_normal_models.count
//                            if count >= self.coachTable!.people_limit {
//                                self.signupButton.setTitle("候補")
//                            } else {
//                                self.signupButton.setTitle("報名")
//                            }
//                        }
                    }
                }
                Global.instance.removeSpinner(superView: self.view)
                self.endRefresh()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return tableRowKeys.count
        }
//        else if tableView == self.signupTableView {
//            if courseTable != nil {
//                //let normal_count: Int = courseTable!.signupNormalTables.count
//                let standby_count: Int = courseTable!.signupStandbyTables.count
//                let people_limit: Int = courseTable!.people_limit
//                let count = people_limit + standby_count + 1
//                //print(count)
//                return count
//            } else {
//                return 0
//            }
//        } else if tableView == self.coachTableView {
//            //print(coachTableRowKeys.count)
//            return coachTableRowKeys.count
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableView {
            let cell: OneLineCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OneLineCell
            
            let key = tableRowKeys[indexPath.row]
            if tableRows[key] != nil {
                let row = tableRows[key]!
                let icon = row["icon"] ?? ""
                let title = row["title"] ?? ""
                let content = row["content"] ?? ""
                cell.update(icon: icon, title: title, content: content)
            }
            
            if indexPath.row == tableRowKeys.count - 1 {
                UIView.animate(withDuration: 0, animations: {self.tableView.layoutIfNeeded()}) { (complete) in
                    var heightOfTableView: CGFloat = 0.0
                    let cells = self.tableView.visibleCells
                    for cell in cells {
                        heightOfTableView += cell.frame.height
                    }
                    //print(heightOfTableView)
                    //self.tableViewConstraintHeight.constant = heightOfTableView
                    //self.changeScrollViewContentSize()
                }
            }
            return cell
        }
        return UITableViewCell()
    }

}
