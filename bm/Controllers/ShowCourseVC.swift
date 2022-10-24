//
//  ShowCourseVC1.swift
//  bm
//
//  Created by ives on 2019/7/5.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit
import SwiftyJSON

class ShowCourseVC: BaseViewController {
    
    //@IBOutlet weak var signupTableViewConstraintHeight: NSLayoutConstraint!
    //@IBOutlet weak var coachTableViewConstraintHeight: NSLayoutConstraint!
    
    //@IBOutlet weak var signupTableView: SuperTableView!
    //@IBOutlet weak var coachTableView: SuperTableView!
    
//    @IBOutlet weak var signupDataLbl: SuperLabel!
//    @IBOutlet weak var signupDateLbl: SuperLabel!
//    @IBOutlet weak var signupDeadlineLbl: SuperLabel!
//    @IBOutlet weak var coachDataLbl: SuperLabel!
    
    @IBOutlet weak var signupButton: SubmitButton!
    @IBOutlet weak var signupButtonConstraintLeading: NSLayoutConstraint!
        

    var myTable: CourseTable?
    var coachTable: CoachTable?
    
    var fromNet: Bool = false
    //var signup_date: JSON = JSON()
    var isSignup: Bool = false
    var isStandby: Bool = false
    var canCancelSignup: Bool = false
    var signup_id: Int = 0
//    var course_date: String = ""
//    var course_deadline: String = ""
    
    let showTop = ShowTop()
    
    var coachRows: [MemberRow] = [MemberRow]()
    
    override func viewDidLoad() {

        dataService = CourseService.instance
        
        //bottom_button_count = 2

        //signupButton.setTitle("報名")
        
        super.viewDidLoad()
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        
        self.view.addSubview(showTop)
        showTop.snp.makeConstraints { make in
            make.top.equalTo(showTop.superview!).offset(statusBarHeight)
            make.left.right.equalToSuperview()
            make.height.equalTo(64)
        }
        
        showTop.backgroundColor = UIColor(MY_GREEN)
        
        
        
        
        //initSignupTableView()
        //initCoachTableView()
        
        //let cellNib = UINib(nibName: "OneLineCell", bundle: nil)
        //signupTableView.register(cellNib, forCellReuseIdentifier: "cell")
        //coachTableView.register(cellNib, forCellReuseIdentifier: "cell")
        
        //refresh(CourseTable.self)
        //refresh()
    }
    
//    override func initData() {
//
//        if myTable == nil {
//            myTable = CourseTable()
//        }
//
//        myTable = table as? CourseTable
//        var row: MemberRow = MemberRow(title: "星期", icon: "date", show: myTable!.weekday_text)
//        memberRows.append(row)
//        row = MemberRow(title: "時段", icon: "clock", show: myTable!.interval_show)
//        memberRows.append(row)
//        if myTable!.dateTable != nil {
//            row = MemberRow(title: "期間", icon: "date", show: myTable!.dateTable!.date)
//            memberRows.append(row)
//        }
//        row = MemberRow(title: "收費", icon: "money", show: myTable!.price_text_long)
//        memberRows.append(row)
//        row = MemberRow(title: "限制人數", icon: "group", show: myTable!.people_limit_text)
//        memberRows.append(row)
//        row = MemberRow(title: "週期", icon: "cycle", show: myTable!.kind_text)
//        memberRows.append(row)
//        row = MemberRow(title: "瀏覽數", icon: "pv", show: String(myTable!.pv))
//        memberRows.append(row)
//        row = MemberRow(title: "建立日期", icon: "date", show: myTable!.created_at_show)
//        memberRows.append(row)
//
//        var coachRow: MemberRow = MemberRow(title: "教練", icon: "coach", show: myTable!.coachTable?.name ?? "")
//        coachRows.append(coachRow)
//        coachRow = MemberRow(title: "行動電話", icon: "mobile", show: myTable!.coachTable?.mobile ?? "")
//        coachRows.append(coachRow)
//        coachRow = MemberRow(title: "LINE", icon: "line", show: myTable!.coachTable?.line ?? "")
//        coachRows.append(coachRow)
//        coachRow = MemberRow(title: "FB", icon: "fb", show: myTable!.coachTable?.fb ?? "")
//        coachRows.append(coachRow)
//        coachRow = MemberRow(title: "YOUTUBE", icon: "youtube", show: myTable!.coachTable?.youtube ?? "")
//        coachRows.append(coachRow)
//        coachRow = MemberRow(title: "網站", icon: "website", show: myTable!.coachTable?.website ?? "")
//        coachRows.append(coachRow)
//        coachRow = MemberRow(title: "EMail", icon: "email1", show: myTable!.coachTable?.email ?? "")
//        coachRows.append(coachRow)
//    }
    
    
}

