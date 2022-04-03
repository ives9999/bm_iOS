//
//  ShowTeamVC.swift
//  bm
//
//  Created by ives on 2021/5/2.
//  Copyright © 2021 bm. All rights reserved.
//

import UIKit
import WebKit
import SCLAlertView

class ShowTeamVC: ShowVC {
    
    @IBOutlet weak var signupTableView: SuperTableView!
    
    @IBOutlet weak var signupDataLbl: SuperLabel!
    @IBOutlet weak var signupTimeLbl: SuperLabel!
    @IBOutlet weak var signupDeadlineLbl: SuperLabel!
    
    @IBOutlet weak var signupTableViewConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var signupButton: SubmitButton!
    @IBOutlet weak var signupButtonConstraintLeading: NSLayoutConstraint!
        
    var myTable: TeamTable?
    
    var isTempPlay: Bool = true

    override func viewDidLoad() {
        
        dataService = TeamService.instance
        
        let cellNib = UINib(nibName: "OneLineCell", bundle: nil)
        signupTableView.register(cellNib, forCellReuseIdentifier: "cell")
        
        initSignupTableView()
        
        bottom_button_count = 2
        
        super.viewDidLoad()
        
//        mainDataLbl.text = "主要資料"
        signupDataLbl.text = "臨打報名"
//        contentDataLbl.text = "詳細介紹"
//
//        mainDataLbl.setTextTitle()
        signupDataLbl.setTextSectionTitle()
//        contentDataLbl.setTextSectionTitle()
//
        signupButton.setTitle("報名")

        refresh(TeamTable.self)
    }
    
    override func refresh() {
        refresh(TeamTable.self)
    }
    
    override func setBottomButtonPadding() {
        
        if (signupButton.isHidden) {
            bottom_button_count -= 1
        }
        
        let padding: CGFloat = (screen_width - CGFloat(bottom_button_count) * button_width) / CGFloat((bottom_button_count + 1))
        likeButtonConstraintLeading.constant = CGFloat(bottom_button_count) * padding + CGFloat(bottom_button_count-1)*button_width
        signupButtonConstraintLeading.constant = padding
    }
    
    override func initData() {
        
        if myTable == nil {
            myTable = TeamTable()
        }
        
        myTable = table as? TeamTable
        var row: MemberRow = MemberRow(title: "球館", icon: "arena", show: myTable!.arena!.name)
        memberRows.append(row)
        if (myTable!.arena != nil) {
            row = MemberRow(title: "縣市", icon: "map", show: myTable!.arena!.city_show)
            memberRows.append(row)
            row = MemberRow(title: "區域", icon: "map", show: myTable!.arena!.area_show)
            memberRows.append(row)
        }
        row = MemberRow(title: "星期", icon: "date", show: myTable!.weekdays_show)
        memberRows.append(row)
        row = MemberRow(title: "時段", icon: "clock", show: myTable!.interval_show)
        memberRows.append(row)
        row = MemberRow(title: "球種", icon: "ball", show: myTable!.ball)
        memberRows.append(row)
        row = MemberRow(title: "程度", icon: "degree", show: myTable!.degree_show)
        memberRows.append(row)
        row = MemberRow(title: "場地", icon: "arena1", show: myTable!.block_show)
        memberRows.append(row)
        row = MemberRow(title: "費用-男", icon: "money", show: myTable!.temp_fee_M_show)
        memberRows.append(row)
        row = MemberRow(title: "費用-女", icon: "money", show: myTable!.temp_fee_F_show)
        memberRows.append(row)
        row = MemberRow(title: "管理者", icon: "admin", show: myTable!.manager_nickname)
        memberRows.append(row)
        row = MemberRow(title: "行動電話", icon: "mobile", show: myTable!.mobile_show)
        memberRows.append(row)
        row = MemberRow(title: "line", icon: "line", show: myTable!.line)
        memberRows.append(row)
        row = MemberRow(title: "FB", icon: "fb", show: myTable!.fb)
        memberRows.append(row)
        row = MemberRow(title: "Youtube", icon: "youtube", show: myTable!.youtube)
        memberRows.append(row)
//        row = MemberRow(title: "網站", icon: "website", show: myTable!.website)
//        memberRows.append(row)
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
        signupTableView.estimatedRowHeight = 40
        signupTableViewConstraintHeight.constant = 400
    }
    
    override func setData() {
        super.setData()
        
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
            //signupButtonContainer.visibility = .invisible
            signupTimeLbl.visibility = .invisible
            signupDeadlineLbl.visibility = .invisible
            self.signupTableViewConstraintHeight.constant = 20
            //self.changeScrollViewContentSize()
        } else {
            //signupButtonContainer.visibility = .visible
            signupTimeLbl.visibility = .visible
            if myTable != nil && myTable!.signupDate != nil {
                signupTimeLbl.text = "下次臨打時間：" + myTable!.signupDate!.date + " " + myTable!.interval_show
                signupDeadlineLbl.text = "報名截止時間：" + myTable!.signupDate!.deadline.noSec()
            }
        }
        
        if (myTable!.people_limit == 0) {
            signupButton.visibility = .invisible
            setBottomButtonPadding()
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
        
        //1.如果臨打狀態是關閉，關閉臨打
        if myTable!.temp_status == "offline" {
            isTempPlay = false
        }
        
        //2.如果沒有設定臨打日期，關閉臨打
        if myTable!.signupDate != nil {
            let temp_date_string: String = myTable!.signupDate!.date
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let now_string: String = formatter.string(from: Date())
            
            //3.如果臨打日期超過現在的日期，關閉臨打
            if let temp_date: Date = temp_date_string.toDateTime(format: "yyyy-MM-dd", locale: false) {
                
                var now: Date = Date()
                if let tmp: Date = now_string.toDateTime(format: "yyyy-MM-dd", locale: false) {
                    now = tmp
                }
                
                //(1)如果報名日期剛好也是臨打日期則可以報名
                if (temp_date.isEqualTo(now)) {
                    isTempPlay = true
                } else {
                    //(2)如果報名日期已經過了臨打日期則無法報名
                    if (temp_date.isSmallerThan(now)) {
                        isTempPlay = false
                    //(3)如果報名日期還沒過了臨打日期則無法報名
                    } else {
                        isTempPlay = true
                    }
                }
            }
        } else {
            isTempPlay = false
        }
        
        //3.如果管理者設定報名臨打名額是0，關閉臨打
        if myTable!.people_limit == 0 {
            isTempPlay = false
        }
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
            
//            print("memberRow: \(memberRows.count)")
//            print("index path: \(indexPath.row)")
            
            //計算高度
            if indexPath.row == memberRows.count - 1 {
                UIView.animate(withDuration: 0, animations: {self.tableView.layoutIfNeeded()}) { (complete) in
                    var heightOfTableView: CGFloat = 0.0
                    let cells = self.tableView.visibleCells
                    for cell in cells {
                        heightOfTableView += cell.frame.height
                    }
                    
                    self.tableViewConstraintHeight.constant = heightOfTableView
                    self.dataConstraintHeight.constant += heightOfTableView
                    
                    //self.scrollContainerHeight += self.dataConstraintHeight.constant
                    //self.containerViewConstraintHeight.constant = self.scrollContainerHeight
                    //print("tableView:\(self.scrollContainerHeight)")
                    //self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollContainerHeight)
                }
            }
            
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
                    //print(cells.count)
                    for cell in cells {
                        heightOfTableView += cell.frame.height
                    }
                    
                    self.signupTableViewConstraintHeight.constant = heightOfTableView
                    self.dataConstraintHeight.constant += heightOfTableView
                    
                    //self.scrollContainerHeight += self.dataConstraintHeight.constant
                    //self.containerViewConstraintHeight.constant = self.scrollContainerHeight
                    
                    //print("signup:\(self.scrollContainerHeight)")
                    //self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollContainerHeight)
                    //self.changeScrollViewContentSize()
                }
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == signupTableView {
            if myTable != nil {
                if myTable!.manager_token == Member.instance.token {
                    let people_limit = myTable!.people_limit
                    if (indexPath.row < people_limit) {
                        let signup_normal_model = myTable!.signupNormalTables[indexPath.row]
                        //print(signup_normal_model.member_token)
                        getMemberOne(member_token: signup_normal_model.member_token)
                        
                    } else {
                        let signup_standby_model = myTable!.signupStandbyTables[indexPath.row]
                        getMemberOne(member_token: signup_standby_model.member_token)
                    }
                } else {
                    warning("只有球隊管理員可以檢視報名者資訊")
                }
            }
        }
    }
    
    func getMemberOne(member_token: String) {
        
        MemberService.instance.getOne(params: ["token": member_token]) { success in
            
            Global.instance.removeSpinner(superView: self.view)
            
            if success {
                
                let jsonData: Data = MemberService.instance.jsonData!
                do {
                    let successTable: SuccessTable = try JSONDecoder().decode(SuccessTable.self, from: jsonData)
                    if successTable.success {
                        let memberTable: MemberTable = try JSONDecoder().decode(MemberTable.self, from: jsonData)
                        if memberTable.id > 0 {
                            self.showTempMemberInfo(memberTable)
                        }
                    } else {
                        self.warning(successTable.msg)
                    }
                } catch {
                    self.warning(error.localizedDescription)
                }
            }
        }
    }
    
    func showTempMemberInfo(_ memberTable: MemberTable) {
        
        let apperance = SCLAlertView.SCLAppearance(
            showCloseButton: false,
            showCircularIcon: true
        )
        
        let alertView = SCLAlertView(appearance: apperance)
        let alertViewIcon = UIImage(named: "member1")
        
        // Creat the subview
        let subview = UIView(frame: CGRect(x:0, y:0, width:220, height:100))
        //subview.backgroundColor = UIColor.red
        //let x = (subview.frame.width - 10) / 2

        let a: String = "姓名：" + memberTable.name + "\n"
        + "電話：" + memberTable.mobile_show + "\n"
        + "EMail：" + memberTable.email
        
        // Add textfield 1
        let textfield1 = UITextView(frame: CGRect(x:0, y:0, width:subview.frame.width, height:subview.frame.height))
        //textfield1.backgroundColor = UIColor.yellow
        textfield1.text = a
        textfield1.font = UIFont(name: textfield1.font!.fontName, size: 18)
        subview.addSubview(textfield1)

        // Add the subview to the alert's UI property
        alertView.customSubview = subview
        
//        let a: UITextView = alertView.addTextView()
//        a.frame = CGRect(x: 0, y: 0, width: 216, height: 300)
//

        
        alertView.addButton("打電話") {
            memberTable.mobile.makeCall()
        }
        
        alertView.addButton("關閉", backgroundColor: UIColor(MY_GRAY)) {
            alertView.hideView()
        }
        alertView.showSuccess(memberTable.nickname, subTitle: "", circleIconImage: alertViewIcon)
    }
    
    override func changeScrollViewContentSize() {
            
        //let h1 = featuredConstraintHeight.constant
        //let h2 = mainDataLbl.bounds.size.height
        let h3 = tableViewConstraintHeight.constant
//        let h6 = contentDataLbl.bounds.size.height
//        let h7 = contentViewConstraintHeight!.constant
//        let h8 = signupDataLbl.bounds.size.height
        let h9 = signupTableViewConstraintHeight.constant
//        let h10 = signupTimeLbl.bounds.size.height
//        let h11 = signupDeadlineLbl.bounds.size.height
        //print(contentViewConstraintHeight)
            
        dataConstraintHeight.constant = h3 + h9
        //print("data height:\(dataConstraintHeight.constant)")
        //let h: CGFloat = h1 + h2 + h3 + h4 + h5
        let h: CGFloat = featuredConstraintHeight.constant + dataConstraintHeight.constant + 300
        //print("scroll height:\(h)")
        
        //scrollContainerView.heightConstraint?.constant = h
        //scrollView.frame.height = h
        //scrollView.contentSize = CGSize(width: view.frame.width, height: h)
        //ContainerViewConstraintHeight.constant = h
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
            
            //print(myTable!.signupDate!.deadline)
            if let deadline_time: Date = myTable!.signupDate!.deadline.toDateTime(format: "yyyy-MM-dd HH:mm:ss", locale: false) {
                let now: Date = Date().myNow()
                if now > deadline_time {
                    
                    var msg: String = "已經超過報名截止時間，請下次再報名"
                    if myTable!.isSignup {
                        msg = "已經超過取消報名截止時間，無法取消報名"
                    }
                    warning(msg)
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
                            self.warning(successTable.msg)
                        }
                    }
                } catch {
                    self.msg = "解析JSON字串時，得到空值，請洽管理員"
                }
            }
        }
    }
}
