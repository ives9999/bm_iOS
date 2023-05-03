//
//  MatchPlayerSignup.swift
//  bm
//
//  Created by ives on 2023/4/26.
//  Copyright © 2023 bm. All rights reserved.
//

import Foundation

class MatchPlayerSignupVC: BaseViewController {
    
    var match_group_token: String?
    
    var showTop2: ShowTop2?
    var showBottom: ShowBottom2?
    
    var table: MatchGroupTable?
    
    var pageVC: UIPageViewController!
    var pages: [UIViewController] = [UIViewController]()
    
    var currentIdx: Int = 0
    
    override func viewDidLoad() {
        
        dataService = MatchGroupService.instance
        
        super.viewDidLoad()
        
        initTop()
        initBottom()
        initPage()
        
        //refresh(MatchGroupTable.self)
    }
    
    func initTop() {
        showTop2 = ShowTop2(delegate: self)
        showTop2!.anchor(parent: self.view)
    }
    
    func initBottom() {
        showBottom = ShowBottom2(delegate: self)
        self.view.addSubview(showBottom!)
        showBottom!.showButton(parent: self.view, isShowSubmit: true, isShowLike: false, isShowCancel: true)
        showBottom!.setSubmitBtnTitle("報名")
    }
    
    func initPage() {
        
        let pc = UIPageControl.appearance()
        pc.pageIndicatorTintColor = UIColor(MY_GRAY)
        pc.currentPageIndicatorTintColor = UIColor.white
        //pc.backgroundColor = UIColor.green
        
        self.pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.addChild(self.pageVC)
        
        self.pageVC.dataSource = self
        
        pages.append(MatchTeamEditVC(idx: 0))
        pages.append(MatchTeamEditVC(idx: 1))
        
        self.pageVC.setViewControllers([pages.first!], direction: .forward, animated: true)
        self.pageVC.view.isUserInteractionEnabled = true
        //self.pageVC.view.backgroundColor = UIColor.red
        
        self.view.addSubview(self.pageVC.view)
        
        self.pageVC.view.snp.makeConstraints { make in
            make.top.equalTo(showTop2!.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(showBottom!.snp.top)
        }
        
        self.pageVC.didMove(toParent: self)
    }
    
    func refresh<T: Table>(_ t: T.Type) {
        if match_group_token != nil {
            Global.instance.addSpinner(superView: self.view)
            let params: [String: String] = ["token": match_group_token!, "member_token": Member.instance.token]
            dataService.getOne(params: params) { [self] (success) in
                Global.instance.removeSpinner(superView: self.view)
                if (success) {
                    let jsonData: Data = self.dataService.jsonData!
                    //jsonData.prettyPrintedJSONString
                    do {
                        let t: Table = try JSONDecoder().decode(t, from: jsonData)
                        if (t.id == 0) {
                            //token錯誤，所以無法解析
                            self.warning("token錯誤，所以無法解析")
                        } else {
                            
                            guard let _myTable = t as? MatchGroupTable else { return }
                            self.table = _myTable
                            self.table!.filterRow()
                            
                            self.showTop2!.setTitle(self.table!.name)
                            //self.setIntroduceData()
                            //self.setSignupData()
                            
                            //self._tabPressed(self.focusTabIdx)
                        }
                    } catch {
                        print(error.localizedDescription)
                        //self.warning(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    override func cancel() {
        prev()
    }
    
//    override func submit() {
//        msg = checkRequire()
//        if msg.count > 0 {
//            warning(msg)
//            return
//        }
//
//        if table == nil {
//            warning("沒有取得賽事組別資料錯誤!!")
//            return
//        }
//
//        if table!.matchTable == nil {
//            warning("沒有取得賽事資料錯誤!!")
//            return
//        }
//
//        var params: [String: String] = [String: String]()
//        for field in fields {
//            if let f: MainTextField2 = field as? MainTextField2 {
//                params[f.key] = f.value
//            }
//        }
//
//        params["match_id"] = String(table!.matchTable!.id)
//        params["match_group_id"] = String(table!.id)
//        params["member_token"] = Member.instance.token
//        params["do"] = "update"
//        //print(params)
//
//        Global.instance.addSpinner(superView: self.view)
//        dataService.update(params: params) { success in
//            Global.instance.removeSpinner(superView: self.view)
//            if success {
//                let jsonData: Data = MemberService.instance.jsonData!
//                do {
//                    let table = try JSONDecoder().decode(SuccessTable.self, from: jsonData)
//                    if (!table.success) {
//                        self.warning(table.msg)
//                    } else {
//                        self.info("已經更新您銀行帳戶資料")
//                    }
//                } catch {
//                    //self.warning(error.localizedDescription)
//                    self.warning(self.dataService.msg)
//                }
//            } else {
//                Global.instance.removeSpinner(superView: self.view)
//                self.warning("伺服器錯誤，請稍後再試，或洽管理人員")
//                //SCLAlertView().showWarning("錯誤", subTitle: "註冊失敗，伺服器錯誤，請稍後再試")
//
//            }
//        }
//    }
    
//    private func checkRequire()-> String {
//
//        var res: String = ""
//        var msgs: [String] = [String]()
//
//        if nameTxt2.value.count == 0 {
//            msgs.append("姓名不能為空白")
//        }
//
//        if mobileTxt2.value.count == 0 {
//            msgs.append("手機不能為空白")
//        }
//
//        if emailTxt2.value.count == 0 {
//            msgs.append("Email不能為空白")
//        }
//
//        if msgs.count > 0 {
//            for msg in msgs {
//                res += "\(msg)\n"
//            }
//        }
//
//        return res
//    }
}

extension MatchPlayerSignupVC: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let idx: Int = pages.firstIndex(of: viewController) else { return nil }
        
        let preIdx: Int = idx - 1
        
        guard preIdx >= 0 else { return nil }
        guard pages.count > preIdx else { return nil }
        
        currentIdx = preIdx
        return pages[preIdx]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let idx: Int = pages.firstIndex(of: viewController) else { return nil }
        
        let nextIdx: Int = idx + 1
        
        guard pages.count != nextIdx else { return nil }
        guard pages.count > nextIdx else { return nil }
        
        currentIdx = nextIdx
        return pages[nextIdx]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentIdx
    }
}

class MatchTeamEditVC: BaseViewController {
    
    var idx: Int = 0
    
    let teamNameTxt2: MainTextField2 = {
        let view: MainTextField2 = MainTextField2(key: "team_name", label: "隊名", icon: "member_on_svg", placeholder: "無敵隊", isRequired: true)
        
        return view
    }()
    
    init(idx: Int) {
        self.idx = idx
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        anchor()
    }
    
    func anchor() {
        self.view.addSubview(teamNameTxt2)
        teamNameTxt2.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
    }
}

class MatchPlayerEditVC: BaseViewController {
    
    var idx: Int = 1
    
    var formContainer: UIView = UIView()
    
    let teamNameTxt2: MainTextField2 = {
        let view: MainTextField2 = MainTextField2(key: "team_name", label: "隊名", icon: "member_on_svg", placeholder: "無敵隊", isRequired: true)
        
        return view
    }()
    
    let nameTxt2: MainTextField2 = {
        let view: MainTextField2 = MainTextField2(key: "name", label: "姓名", icon: "member_on_svg", placeholder: "王大明", isRequired: true)
        
        return view
    }()
    
    let mobileTxt2: MainTextField2 = {
        let view: MainTextField2 = MainTextField2(key: "mobile", label: "手機", icon: "mobile_svg", placeholder: "0960283457", isRequired: true, keyboard: KEYBOARD.numberPad)
        
        return view
    }()
    
    let emailTxt2: MainTextField2 = {
        let view: MainTextField2 = MainTextField2(key: "email", label: "Email", icon: "email_svg", placeholder: "davie@gmail.com", isRequired: true, keyboard: KEYBOARD.emailAddress)
        
        return view
    }()
    
    let lineTxt2: MainTextField2 = {
        let view: MainTextField2 = MainTextField2(key: "line", label: "line", icon: "line_svg", placeholder: "badminton")
        
        return view
    }()
    
    let ageTxt2: MainTextField2 = {
        let view: MainTextField2 = MainTextField2(key: "age", label: "年齡", icon: "line_svg", placeholder: "32", unit: "歲")
        
        return view
    }()
    
    var fields: [UIView] = [UIView]()
    
    init(idx: Int) {
        self.idx = idx
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initForm()
        
        setValue()
    }
    
    func initForm() {
        self.view.addSubview(formContainer)
        formContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
            formContainer.addSubview(teamNameTxt2)
            teamNameTxt2.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(12)
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
            }
            fields.append(nameTxt2)
        
            formContainer.addSubview(nameTxt2)
            nameTxt2.snp.makeConstraints { make in
                make.top.equalTo(teamNameTxt2.snp.bottom).offset(20)
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
            }
            fields.append(nameTxt2)
            
            formContainer.addSubview(mobileTxt2)
            mobileTxt2.snp.makeConstraints { make in
                make.top.equalTo(nameTxt2.snp.bottom).offset(20)
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
            }
            fields.append(mobileTxt2)
            
            formContainer.addSubview(emailTxt2)
            emailTxt2.snp.makeConstraints { make in
                make.top.equalTo(mobileTxt2.snp.bottom).offset(20)
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
            }
            fields.append(emailTxt2)
            
            formContainer.addSubview(lineTxt2)
            lineTxt2.snp.makeConstraints { make in
                make.top.equalTo(emailTxt2.snp.bottom).offset(20)
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
            }
            fields.append(lineTxt2)
            
            formContainer.addSubview(ageTxt2)
            ageTxt2.snp.makeConstraints { make in
                make.top.equalTo(lineTxt2.snp.bottom).offset(20)
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
            }
            fields.append(ageTxt2)
    }

    func setValue() {
        nameTxt2.setValue(Member.instance.name)
        mobileTxt2.setValue(Member.instance.mobile)
        emailTxt2.setValue(Member.instance.email)
        lineTxt2.setValue(Member.instance.line)
        
        if let age = Member.instance.dob.clacAge() {
            ageTxt2.setValue(String(age))
        }
    }
}
