//
//  ShowTeamVC.swift
//  bm
//
//  Created by ives on 2021/5/2.
//  Copyright © 2021 bm. All rights reserved.
//

import UIKit
import WebKit

class ShowTeamVC: ShowVC {
    
    @IBOutlet weak var signupTableView: SuperTableView!
    
    @IBOutlet weak var signupDataLbl: SuperLabel!
    
    @IBOutlet weak var signupTableViewConstraintHeight: NSLayoutConstraint!
        
    var myTable: TeamTable?

    override func viewDidLoad() {
        
        dataService = TeamService.instance
        
        let cellNib = UINib(nibName: "OneLineCell", bundle: nil)
        signupTableView.register(cellNib, forCellReuseIdentifier: "cell")
        
        initSignupTableView()
        
        super.viewDidLoad()
        
        tableRowKeys = ["arena","interval_show","ball","degree_show","leader","mobile_show","fb","youtube","website","email","pv","created_at_show"]
        tableRows = [
            "arena":["icon":"arena","title":"球館","content":""],
            "interval_show":["icon":"clock","title":"時段","content":""],
            "ball":["icon":"ball","title":"球種","content":""],
            "degree_show":["icon":"degree","title":"程度","content":""],
            "leader":["icon":"member1","title":"隊長","content":""],
            "mobile_show":["icon":"mobile","title":"行動電話","content":""],
            "fb": ["icon":"fb","title":"FB","content":""],
            "youtube":["icon":"youtube","title":"Youtube","content":""],
            "website":["icon":"website","title":"網站","content":""],
            "email":["icon":"email1","title":"EMail","content":""],
            "pv":["icon":"pv","title":"瀏覽數","content":""],
            "created_at_show":["icon":"calendar","title":"建立日期","content":""]
        ]
        //refresh()
        refresh(TeamTable.self)
    }
    
    override func viewWillLayoutSubviews() {
        mainDataLbl.text = "主要資料"
        signupDataLbl.text = "臨打報名"
        //signupDataLbl.isHidden = true
        contentDataLbl.text = "詳細介紹"
        
        mainDataLbl.setTextTitle()
        signupDataLbl.setTextTitle()
        contentDataLbl.setTextTitle()
    }
    
    func initSignupTableView() {

        signupTableView.dataSource = self
        signupTableView.delegate = self
        signupTableView.rowHeight = UITableView.automaticDimension
        signupTableView.estimatedRowHeight = 300
        //signupTableViewConstraintHeight.constant = 0
    }
    
    override func setData() {
        
        if (table != nil) {
            myTable = table as? TeamTable
            if (myTable != nil) {
                //myTable!.filterRow()
                
                setMainData(myTable!)
                
                tableView.reloadData()
                //signupTableView.reloadData()
            }
        }
    }
    
//    override func setMainData() {
//
//        let mirror: Mirror = Mirror(reflecting: myTable!)
//        let propertys: [[String: Any]] = mirror.toDictionary()
//
//        for key in tableRowKeys {
//
//            for property in propertys {
//
//                if ((property["label"] as! String) == key) {
//                    var type: String = property["type"] as! String
//                    type = type.getTypeOfProperty()!
//                    //print("label=>\(property["label"]):value=>\(property["value"]):type=>\(type)")
//                    var content: String = ""
//                    if type == "Int" {
//                        content = String(property["value"] as! Int)
//                    } else if type == "Bool" {
//                        content = String(property["value"] as! Bool)
//                    } else if type == "String" {
//                        content = property["value"] as! String
//                    }
//                    tableRows[key]!["content"] = content
//                    break
//                }
//            }
//        }
//    }
    
    func setNextTime() {
//        let dateTable: DateTable = myTable!.dateTable!
//        let date: String = dateTable.date
//        let start_time: String = myTable!.start_time_show
//        let end_time: String = myTable!.end_time_show
//        let next_time = "下次上課時間：\(date) \(start_time) ~ \(end_time)"
//        signupDateLbl.text = next_time
        
        
//        let nextCourseTime: [String: String] = courseTable!.nextCourseTime
//        for key in signupTableRowKeys {
//            signupTableRows[key]!["content"] = nextCourseTime[key]
//        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableView {
            let cell: OneLineCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OneLineCell
            
            //填入資料
            let key = tableRowKeys[indexPath.row]
            if tableRows[key] != nil {
                var row = tableRows[key]!
                let icon = row["icon"] ?? ""
                let title = row["title"] ?? ""
                if (key == "arena") {
                    if (myTable != nil && myTable!.arena != nil) {
                        row["content"] = myTable!.arena!.name
                    } else {
                        row["content"] = "未提供"
                    }
                }
                let content = row["content"] ?? ""
                cell.update(icon: icon, title: title, content: content)
            }
            
            //計算高度
            if indexPath.row == tableRowKeys.count - 1 {
                UIView.animate(withDuration: 0, animations: {self.tableView.layoutIfNeeded()}) { (complete) in
                    var heightOfTableView: CGFloat = 0.0
                    let cells = self.tableView.visibleCells
                    for cell in cells {
                        heightOfTableView += cell.frame.height
                    }
                    //print(heightOfTableView)
                    self.tableViewConstraintHeight.constant = heightOfTableView
                    self.changeScrollViewContentSize()
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    
    override func changeScrollViewContentSize() {
            
        let h1 = featured.bounds.size.height
        let h2 = mainDataLbl.bounds.size.height
        let h3 = tableViewConstraintHeight.constant
        let h6 = contentDataLbl.bounds.size.height
        let h7 = contentViewConstraintHeight!.constant
        let h8 = signupDataLbl.bounds.size.height
        let h9 = signupTableViewConstraintHeight.constant
        //print(contentViewConstraintHeight)
            
        //let h: CGFloat = h1 + h2 + h3 + h4 + h5
        let h: CGFloat = h1 + h2 + h3 + h6 + h7 + h8 + h9 + 300
        scrollView.contentSize = CGSize(width: view.frame.width, height: h)
        ContainerViewConstraintHeight.constant = h
        //print(h1)
    }
}
