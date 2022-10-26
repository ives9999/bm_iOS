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
    //let courseTableView: UITableView = UITableView()
    
    var featured_h: CGFloat = 0
    
    private let scrollStackViewContainer: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = UIColor.red
        view.axis = .vertical
        view.spacing = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var signupDataLbl: SuperLabel = {
        let view = SuperLabel()
        view.textColor = UIColor(MY_WHITE)
        view.text = "報名資料"
        
        return view
    }()
    
//    private let subView1: UIView = {
//        let view = UIView()
//        view.heightAnchor.constraint(equalToConstant: 200).isActive = true
//        view.backgroundColor = UIColor.blue
//        return view
//    }()
//
//    private let subview2: UIView = {
//        let view = UIView()
//        view.heightAnchor.constraint(equalToConstant: 300).isActive = true
//        view.backgroundColor = UIColor.cyan
//        return view
//    }()
//
//    private let subview3: UIView = {
//        let view = UIView()
//        view.heightAnchor.constraint(equalToConstant: 400).isActive = true
//        view.backgroundColor = UIColor.gray
//        return view
//    }()
    
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
        
        //self.view.addSubview(scrollView)
        scrollView.backgroundColor = UIColor.brown
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        //scrollerView.setAnchor(parent: self.view)
//        scrollView.snp.makeConstraints { make in
//            make.top.equalTo(showTop.snp.bottom)
//            make.right.left.equalToSuperview()
//            make.bottom.equalToSuperview()
//            make.width.equalToSuperview()
//        }
        
        setupScrollView()
        
        
        //contentView.backgroundColor = UIColor.red
        //scrollView.addSubview(contentView)
        
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.leadingAnchor.constraint(equalTo: contentView.superview!.leftAnchor, constant: 0).isActive = true
//        contentView.trailingAnchor.constraint(equalTo: contentView.superview!.trailingAnchor, constant: 0).isActive = true
//        contentView.topAnchor.constraint(equalTo: contentView.superview!.topAnchor, constant: 0).isActive = true
//        contentView.bottomAnchor.constraint(equalTo: contentView.superview!.bottomAnchor, constant: 0).isActive = true
        //contentView.heightConstraint?.constant = 100
        
        
        
//        contentView.snp.makeConstraints { make in
//            make.top.equalToSuperview()
//            make.leading.trailing.equalToSuperview()
//            //make.left.right.equalToSuperview()
//            //make.edges.width.equalToSuperview()
//            make.height.equalTo(100)
//        }
        
        //scrollerView.setAnchor(parent: self.view)
        
        //scrollerView.contentView.addSubview(featured)
        
        //scrollStackViewContainer.addSubview(featured)
        scrollStackViewContainer.addArrangedSubview(featured)
        featured.snp.makeConstraints { make in
            //make.top.left.right.equalToSuperview()
            make.height.equalTo(200)
        }
        featured.backgroundColor = UIColor.brown
//
//        contentView.addSubview(courseTableView)
        scrollStackViewContainer.addArrangedSubview(courseTableView)
        courseTableView.snp.makeConstraints { make in
            make.height.equalTo(100)
        }

        courseTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        courseTableView.delegate = self
        courseTableView.dataSource = self
        courseTableView.isScrollEnabled = false

        courseTableView.rowHeight = UITableView.automaticDimension
        courseTableView.estimatedRowHeight = UITableView.automaticDimension

        let cellNib = UINib(nibName: "OneLineCell", bundle: nil)
        courseTableView.register(cellNib, forCellReuseIdentifier: "cell")

        
        
        scrollStackViewContainer.addArrangedSubview(signupDataLbl)
        
        signupDataLbl.snp.makeConstraints { make in
            make.edges.equalTo(courseTableView.snp.bottom).inset(UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
            //make.bottom.equalToSuperview().offset(12)
        }
        
        
        refresh(CourseTable.self)
        
//        let v: UIView = UIView()
//        scrollStackViewContainer.addArrangedSubview(v)
//        v.backgroundColor = UIColor.blue
//        v.snp.makeConstraints { make in
//            make.height.equalTo(500)
//        }
        
//        let v1: UIView = UIView()
//        contentView.addSubview(v1)
//        v1.backgroundColor = UIColor.red
//        v1.snp.makeConstraints { make in
//            //make.width.equalToSuperview()
//            make.height.equalTo(500)
//            make.top.equalTo(v.snp.bottom).offset(20)
//            make.left.right.equalToSuperview().inset(20)
//        }
        
        
        
        
        //initSignupTableView()
        //initCoachTableView()
        
        //let cellNib = UINib(nibName: "OneLineCell", bundle: nil)
        //signupTableView.register(cellNib, forCellReuseIdentifier: "cell")
        //coachTableView.register(cellNib, forCellReuseIdentifier: "cell")
    }
    
    private func setupScrollView() {
        //let margins = view.layoutMarginsGuide
        view.addSubview(scrollView)
        scrollView.addSubview(scrollStackViewContainer)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(showTop.snp.bottom)
            make.bottom.equalToSuperview().inset(self.view.layoutMargins)
            make.leading.trailing.equalToSuperview()
        }

//        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        scrollView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
//        scrollView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        
        scrollStackViewContainer.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
            make.width.equalToSuperview()
        }

//        scrollStackViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
//        scrollStackViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
//        scrollStackViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
//        scrollStackViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
//        scrollStackViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        //configureContainerView()
    }
    
//    private func configureContainerView() {
//        scrollStackViewContainer.addArrangedSubview(subView1)
//        scrollStackViewContainer.addArrangedSubview(subview2)
//        scrollStackViewContainer.addArrangedSubview(subview3)
//    }

    
    override func viewWillLayoutSubviews() {
        let a = courseTableView.contentSize.height
        courseTableView.heightConstraint?.constant = a
        //contentView.heightConstraint?.constant = 500 + a
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
                                self.setFeatured()
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
    
    func setFeatured() {

        if (table != nil && table!.featured_path.count > 0) {
            
            featured.downloaded(from: table!.featured_path)
            
            featured_h = featured.heightForUrl(url: table!.featured_path, width: screen_width)
            //featuredConstraintHeight.constant = featured_h
            
            //scrollContainerHeight += featuredConstraintHeight.constant
            //containerViewConstraintHeight.constant = scrollContainerHeight
            //print("featured:\(scrollContainerHeight)")
            
            //dataContainerConstraintTop.constant = featured_h - 30
        } else {
            warning("沒有取得內容資料值，請稍後再試或洽管理員")
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

