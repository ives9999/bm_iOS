//
//  ShowCourseVC1.swift
//  bm
//
//  Created by ives on 2019/7/5.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit
import SwiftyJSON

class ShowCourseVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
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
    
    let showTop = ShowTop2()
    let scrollView = UIScrollView()
    let contentView: UIView = UIView()
    let featured: UIImageView = UIImageView()
    let courseTableView: UITableView = UITableView()
    
    var coachRows: [MemberRow] = [MemberRow]()
    
    var token: String?
    var table: Table?
    var memberRows: [MemberRow] = [MemberRow]()
    
    var info = [
            "陳偉殷","王建民","陳金鋒","林智勝"
        ]
    
    override func viewDidLoad() {

        dataService = CourseService.instance
        
        //bottom_button_count = 2

        //signupButton.setTitle("報名")
        
        super.viewDidLoad()
        
        showTop.setAnchor(parent: self.view)
        
        self.view.addSubview(scrollView)
        scrollView.backgroundColor = UIColor.brown
        //scrollerView.setAnchor(parent: self.view)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(showTop.snp.bottom)
            make.right.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        
        contentView.backgroundColor = UIColor.red
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }
        
        //scrollerView.setAnchor(parent: self.view)
        
        //scrollerView.contentView.addSubview(featured)
        
        contentView.addSubview(featured)
        featured.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(500)
        }
        featured.backgroundColor = UIColor.brown
        
        contentView.addSubview(courseTableView)
        courseTableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(featured.snp.bottom)
            make.height.equalTo(100)
        }
        
        courseTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        courseTableView.delegate = self
        courseTableView.dataSource = self
        
        courseTableView.rowHeight = UITableView.automaticDimension
        courseTableView.estimatedRowHeight = UITableView.automaticDimension
        //courseTableViewHeight.constant = 2000
        
        let cellNib = UINib(nibName: "OneLineCell", bundle: nil)
        courseTableView.register(cellNib, forCellReuseIdentifier: "cell")
        
        refresh(CourseTable.self)
        
        
        
//        let v: UIView = UIView()
//        contentView.addSubview(v)
//        v.backgroundColor = UIColor.blue
//        v.snp.makeConstraints { make in
//            make.width.equalTo(50)
//            make.height.equalTo(50)
//            make.top.equalTo(featured.snp.bottom)
//            make.left.equalTo(contentView)
//        }
        
        
        
        
        //initSignupTableView()
        //initCoachTableView()
        
        //let cellNib = UINib(nibName: "OneLineCell", bundle: nil)
        //signupTableView.register(cellNib, forCellReuseIdentifier: "cell")
        //coachTableView.register(cellNib, forCellReuseIdentifier: "cell")
        
        //refresh(CourseTable.self)
        //refresh()
    }
    
    override func viewWillLayoutSubviews() {
        let a = courseTableView.contentSize.height
        courseTableView.heightConstraint?.constant = a
        contentView.heightConstraint?.constant = 500 + a
    }
    
    func refresh<T: Table>(_ t: T.Type) {
        
        if token != nil {
            Global.instance.addSpinner(superView: self.view)
            let params: [String: String] = ["token": token!, "member_token": Member.instance.token]
            dataService.getOne(params: params) { (success) in
                Global.instance.removeSpinner(superView: self.view)
                if (success) {
                    let jsonData: Data = self.dataService.jsonData!
                    do {
                        self.table = try JSONDecoder().decode(t, from: jsonData)
                        if (self.table != nil) {
                            if (self.table!.id == 0) {
                                //token錯誤，所以無法解析
                                self.warning("token錯誤，所以無法解析")
                            } else {
                                self.table!.filterRow()
                                //self.setFeatured()
                                self.initData()
                                //self.setData()
                                //self.setContent()
                                //self.setLike()
                            }
                        }
                    } catch {
                        self.warning(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func initData() {

        if myTable == nil {
            myTable = CourseTable()
        }

        myTable = table as? CourseTable
        var row: MemberRow = MemberRow(title: "星期", icon: "date", show: myTable!.weekday_text)
        memberRows.append(row)
        row = MemberRow(title: "時段", icon: "clock", show: myTable!.interval_show)
        memberRows.append(row)
        if myTable!.dateTable != nil {
            row = MemberRow(title: "期間", icon: "date", show: myTable!.dateTable!.date)
            memberRows.append(row)
        }
        row = MemberRow(title: "收費", icon: "money", show: myTable!.price_text_long)
        memberRows.append(row)
        row = MemberRow(title: "限制人數", icon: "group", show: myTable!.people_limit_text)
        memberRows.append(row)
        row = MemberRow(title: "週期", icon: "cycle", show: myTable!.kind_text)
        memberRows.append(row)
        row = MemberRow(title: "瀏覽數", icon: "pv", show: String(myTable!.pv))
        memberRows.append(row)
        row = MemberRow(title: "建立日期", icon: "date", show: myTable!.created_at_show)
        memberRows.append(row)
        
        courseTableView.reloadData()
        courseTableView.invalidateIntrinsicContentSize()
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
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return memberRows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: OneLineCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OneLineCell

        let row: MemberRow = memberRows[indexPath.row]
        cell.update(icon: row.icon, title: row.title, content: row.show)
        cell.backgroundColor = UIColor(MY_BLACK)
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
//        cell.textLabel?.text = memberRows[indexPath.row].title
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        return 80
//    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        let t = UITableView.automaticDimension
//
//        return UITableView.automaticDimension
//    }
}

