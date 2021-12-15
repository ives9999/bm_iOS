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
    @IBOutlet weak var signupTimeLbl: SuperLabel!
    @IBOutlet weak var signupDeadlineLbl: SuperLabel!
    
    @IBOutlet weak var signupTableViewConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var signupButton: SubmitButton!
    @IBOutlet weak var signupButtonContainer: UIView!
        
    var myTable: TeamTable?
    
    var isTempPlay: Bool = true

    override func viewDidLoad() {
        
        dataService = TeamService.instance
        
        let cellNib = UINib(nibName: "OneLineCell", bundle: nil)
        signupTableView.register(cellNib, forCellReuseIdentifier: "cell")
        
        initSignupTableView()
        
        super.viewDidLoad()
        
        mainDataLbl.text = "主要資料"
        signupDataLbl.text = "臨打報名"
        //signupDataLbl.isHidden = true
        contentDataLbl.text = "詳細介紹"
        
        mainDataLbl.setTextTitle()
        signupDataLbl.setTextTitle()
        contentDataLbl.setTextTitle()
        
        signupTimeLbl.setTextGeneral()
        signupDeadlineLbl.setTextGeneral()
        
        signupButton.setTitle("報名")
        
//        tableRowKeys = ["arena","interval_show","ball","degree_show","leader","mobile_show","fb","youtube","website","email","pv","created_at_show"]
//        tableRows = [
//            "arena":["icon":"arena","title":"球館","content":""],
//            "interval_show":["icon":"clock","title":"時段","content":""],
//            "ball":["icon":"ball","title":"球種","content":""],
//            "degree_show":["icon":"degree","title":"程度","content":""],
//            "leader":["icon":"member1","title":"隊長","content":""],
//            "mobile_show":["icon":"mobile","title":"行動電話","content":""],
//            "fb": ["icon":"fb","title":"FB","content":""],
//            "youtube":["icon":"youtube","title":"Youtube","content":""],
//            "website":["icon":"website","title":"網站","content":""],
//            "email":["icon":"email1","title":"EMail","content":""],
//            "pv":["icon":"pv","title":"瀏覽數","content":""],
//            "created_at_show":["icon":"calendar","title":"建立日期","content":""]
//        ]
        //refresh()
        refresh(TeamTable.self)
    }
    
    override func initData() {
        
        if myTable == nil {
            myTable = TeamTable()
        }
        
        myTable = table as? TeamTable
        var row: MemberRow = MemberRow(title: "球館", icon: "arena1", show: myTable!.arena!.name)
        memberRows.append(row)
        row = MemberRow(title: "時段", icon: "clock", show: myTable!.interval_show)
        memberRows.append(row)
        row = MemberRow(title: "球種", icon: "ball", show: myTable!.ball)
        memberRows.append(row)
        row = MemberRow(title: "程度", icon: "degree", show: myTable!.degree_show)
        memberRows.append(row)
        row = MemberRow(title: "隊長", icon: "group", show: myTable!.manager_nickname)
        memberRows.append(row)
        row = MemberRow(title: "行動電話", icon: "mobile", show: myTable!.mobile_show)
        memberRows.append(row)
        row = MemberRow(title: "line", icon: "line", show: myTable!.line)
        memberRows.append(row)
        row = MemberRow(title: "FB", icon: "fb", show: myTable!.fb)
        memberRows.append(row)
        row = MemberRow(title: "Youtube", icon: "youtube", show: myTable!.youtube)
        memberRows.append(row)
        row = MemberRow(title: "網站", icon: "website", show: myTable!.website)
        memberRows.append(row)
        row = MemberRow(title: "EMail", icon: "email1", show: myTable!.email)
        memberRows.append(row)
        row = MemberRow(title: "瀏覽數", icon: "pv", show: String(myTable!.pv))
        memberRows.append(row)
        row = MemberRow(title: "建立日期", icon: "date", show: myTable!.created_at_show)
        memberRows.append(row)
    }
    
    func initSignupTableView() {

        signupTableView.dataSource = self
        signupTableView.delegate = self
        signupTableView.rowHeight = UITableView.automaticDimension
        signupTableView.estimatedRowHeight = 300
        signupTableViewConstraintHeight.constant = 1000
    }
    
    override func setData() {
        
        if (table != nil) {
            myTable = table as? TeamTable
            if (myTable != nil) {
                //myTable!.filterRow()
                
                setMainData(myTable!)
                //set signup data
                setSignupData()
                
                tableView.reloadData()
            }
        }
    }
    
    func setSignupData() {
        
        isTempPlayOnline()
        if !isTempPlay {
            signupDataLbl.text = "目前球隊不開放臨打"
            signupButtonContainer.visibility = .invisible
            signupTimeLbl.visibility = .invisible
            signupDeadlineLbl.visibility = .invisible
            self.signupTableViewConstraintHeight.constant = 20
            self.changeScrollViewContentSize()
        } else {
            signupButtonContainer.visibility = .visible
            signupTimeLbl.visibility = .visible
            if myTable != nil && myTable!.signupDate != nil {
                signupTimeLbl.text = "下次臨打時間：" + myTable!.signupDate!.date + " " + myTable!.interval_show
                signupDeadlineLbl.text = "報名截止時間：" + myTable!.signupDate!.deadline.noSec()
            }
        }
        
        if (myTable!.people_limit == 0) {
            signupButton.visibility = .invisible
        }
    
        if myTable!.isSignup {
            signupButton.setTitle("取消報名")
        } else {
            let count = myTable!.signupNormalTables.count
            if count >= myTable!.people_limit {
                self.signupButton.setTitle("候補")
            } else {
                self.signupButton.setTitle("報名")
            }
        }
        
        signupTableView.reloadData()
    }
    
    func isTempPlayOnline() {
        
        if myTable!.temp_status == "offline" {
            isTempPlay = false
        }
        
        if myTable!.signupDate != nil {
            let temp_date_string: String = myTable!.signupDate!.date
            //let temp_date_string = "aaa"
            if let temp_date: Date = temp_date_string.toDate() {
                if temp_date.isSmallerThan(Date()) {
                    isTempPlay = false
                }
            }
        }
        
        if myTable!.people_limit == 0 {
            isTempPlay = false
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
            return memberRows.count
            //return tableRowKeys.count
        } else if tableView == self.signupTableView {
            if myTable != nil && isTempPlay {
                
                let people_limit: Int = myTable!.people_limit
                //let normal_count: Int = myTable!.signupNormalTables.count
                let standby_count: Int = myTable!.signupStandbyTables.count
                let count = people_limit + standby_count + 1
                //print(count)
                return count
            } else {
                return 0
            }
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableView {
            let cell: OneLineCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OneLineCell
            
            let row: MemberRow = memberRows[indexPath.row]
            cell.update(icon: row.icon, title: row.title, content: row.show)
            //填入資料
//            let key = tableRowKeys[indexPath.row]
//            if tableRows[key] != nil {
//                var row = tableRows[key]!
//                let icon = row["icon"] ?? ""
//                let title = row["title"] ?? ""
//                if (key == "arena") {
//                    if (myTable != nil && myTable!.arena != nil) {
//                        row["content"] = myTable!.arena!.name
//                    } else {
//                        row["content"] = "未提供"
//                    }
//                }
//                let content = row["content"] ?? ""
//                cell.update(icon: icon, title: title, content: content)
//            }
            
            //計算高度
            if indexPath.row == memberRows.count - 1 {
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
            
//            if indexPath.row == tableRowKeys.count - 1 {
//                UIView.animate(withDuration: 0, animations: {self.tableView.layoutIfNeeded()}) { (complete) in
//                    var heightOfTableView: CGFloat = 0.0
//                    let cells = self.tableView.visibleCells
//                    for cell in cells {
//                        heightOfTableView += cell.frame.height
//                    }
//                    //print(heightOfTableView)
//                    self.tableViewConstraintHeight.constant = heightOfTableView
//                    self.changeScrollViewContentSize()
//                }
//            }
            return cell
        } else if tableView == signupTableView {
            let cell: OlCell = tableView.dequeueReusableCell(withIdentifier: "signupCell", for: indexPath) as! OlCell
            
            let people_limit = myTable!.people_limit
            let normal_count = myTable!.signupNormalTables.count
            let standby_count = myTable!.signupStandbyTables.count
            if indexPath.row < people_limit {
                cell.numberLbl.text = "\(indexPath.row + 1)."
                cell.nameLbl.text = ""
                if normal_count > 0 {
                    if indexPath.row < normal_count {
                        let signup_normal_model = myTable!.signupNormalTables[indexPath.row]
                        cell.nameLbl.text = signup_normal_model.member_name
                    }
                }
            } else if indexPath.row >= people_limit && indexPath.row < people_limit + standby_count {
                cell.numberLbl.text = "候補\(indexPath.row - people_limit + 1)."
                let signup_standby_model = myTable!.signupStandbyTables[indexPath.row - people_limit]
                cell.nameLbl.text = signup_standby_model.member_name
            } else {
                let remain: Int = people_limit - myTable!.signupNormalTables.count
                var remain_text = ""
                if (remain > 0) {
                    remain_text = "還有\(remain)個名額"
                } else {
                    remain_text = "已經額滿，請排候補"
                }
                cell.numberLbl.text = remain_text
            }

            if indexPath.row == people_limit + standby_count - 1 {

                UIView.animate(withDuration: 0, animations: {self.signupTableView.layoutIfNeeded()}) { (complete) in
                    var heightOfTableView: CGFloat = 0.0
                    let cells = self.signupTableView.visibleCells
                    for cell in cells {
                        heightOfTableView += cell.frame.height
                    }
                    //print(heightOfTableView)
                    self.signupTableViewConstraintHeight.constant = heightOfTableView
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
        let h10 = signupTimeLbl.bounds.size.height
        let h11 = signupDeadlineLbl.bounds.size.height
        //print(contentViewConstraintHeight)
            
        //let h: CGFloat = h1 + h2 + h3 + h4 + h5
        let h: CGFloat = h1 + h2 + h3 + h6 + h7 + h8 + h9 + h10 + h11 + 300
        scrollView.contentSize = CGSize(width: view.frame.width, height: h)
        ContainerViewConstraintHeight.constant = h
        //print(h1)
    }
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        
        if !Member.instance.isLoggedIn {
            warning("請先登入會員")
            return
        }
        
        if !Member.instance.checkEMailValidate() {
            warning("請先通過email認證")
            return
        }
        
        if !Member.instance.checkMobileValidate() {
            warning("請先通過行動電話認證")
            return
        }
        
        if myTable != nil && myTable!.signupDate != nil {
            
            if let deadline_date: Date = myTable!.signupDate!.deadline.toDate() {
                if Date() > deadline_date {
                    warning("已經超過報名截止時間，請下次再報名")
                    return
                }
            }
            
            Global.instance.addSpinner(superView: view)
            dataService.signup(token: myTable!.token, member_token: Member.instance.token, date_token: myTable!.signupDate!.token) { (success) in

                Global.instance.removeSpinner(superView: self.view)

                do {
                    if (self.dataService.jsonData != nil) {
                        let successTable: SuccessTable = try JSONDecoder().decode(SuccessTable.self, from: self.dataService.jsonData!)
                        if (successTable.success) {
                            self.info(msg: successTable.msg, buttonTitle: "關閉") {
                                self.refresh(TeamTable.self)
                            }
                        } else {
                            self.warning("報名沒有成功，請洽管理員")
                        }
                    }
                } catch {
                    self.msg = "解析JSON字串時，得到空值，請洽管理員"
                }
            }
        }
    }
}
