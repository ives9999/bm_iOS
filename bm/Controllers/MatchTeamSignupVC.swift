//
//  ViewController.swift
//  Test
//
//  Created by ives on 2023/2/6.
//

import UIKit
import SnapKit

class MatchTeamSignupVC: BaseViewController {
    
    var match_group_token: String?
    var token: String?
        
    var showTop2: ShowTop2?
    var showBottom: ShowBottom2?
        
    var table: MatchTeamTable?
        
    var pageVC: UIPageViewController!
    var pages: [UIViewController] = [UIViewController]()
        
    var currentIdx: Int = 0

    override func viewDidLoad() {
        
        dataService = MatchTeamService.instance
        super.viewDidLoad()
        
        initTop()
        initBottom()
        initPage()
        
        refresh(MatchTeamTable.self)
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
        self.pageVC.delegate = self
        
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
            var params: [String: String] = ["match_group_token": match_group_token!, "member_token": Member.instance.token]
            
            if let tmp = token {
                params["token"] = tmp
            }
            
            dataService.getOne(params: params) { [self] (success) in
                Global.instance.removeSpinner(superView: self.view)
                if (success) {
                    let jsonData: Data = self.dataService.jsonData!
                    jsonData.prettyPrintedJSONString
                    do {
                        let t: Table = try JSONDecoder().decode(t, from: jsonData)
                        guard let _myTable = t as? MatchTeamTable else { return }
                        self.table = _myTable
                        self.table!.filterRow()
                        
                        self.showTop2!.setTitle(self.table!.name)
                        self.setPage()
                    } catch {
                        print(error.localizedDescription)
                        //self.warning(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func setPage() {
        let playerNumber: Int = table!.number
        pages.append(MatchTeamEditVC(idx: 0))
        for i in 1...1 {
            pages.append(MatchPlayerEditVC(idx: i))
        }
        self.pageVC.setViewControllers([pages.first!], direction: .forward, animated: true)
    }
    
    override func submit() {
        
        var params: [String: Any] = [String: Any]()
        if let vc = pages[0] as? MatchTeamEditVC {
            let res = vc.checkRequire()
            if res.count > 0 {
                warning(res)
                return
            }
            
            var a: [String: String] = [String: String]()
            for field in vc.fields {
                if let tmp = field as? MainTextField2 {
                    a["\(tmp.key)"] = tmp.value
                }
            }
            params["manager"] = a
        }
        
        //print(params)
        
        var b: [[String: String]] = [[String: String]]()
        for i in 1...pages.count-1 {
            
            if let vc = pages[i] as? MatchPlayerEditVC {
                let res = vc.checkRequire()
                if res.count > 0 {
                    warning(res)
                    return
                }
                
                var c: [String: String] = [String: String]()
                for field in vc.fields {
                    if let tmp = field as? MainTextField2 {
                        c["\(tmp.key)"] = tmp.value
                    }
                }
                b.append(c)
            }
        }
        
        if b.count > 0 {
            params["players"] = b
        }
        
        if self.table != nil && self.table!.matchTable != nil {
            params["match_id"] = String(table!.matchTable!.id)
        }
        
        if self.table != nil && self.table!.matchGroupTable != nil {
            params["match_group_id"] = String(table!.matchGroupTable!.id)
        }
        
        params["member_token"] = Member.instance.token
        params["manager_token"] = Member.instance.token
        params["do"] = "update"
//        print(params.toJson())
//        print(params)
        Global.instance.addSpinner(superView: self.view)
        dataService.update(query: params) { success in
           Global.instance.removeSpinner(superView: self.view)
           if success {
               let jsonData: Data = self.dataService.jsonData!
               print(jsonData.toString())
               //jsonData.prettyPrintedJSONString
               do {
                   let table = try JSONDecoder().decode(SuccessTable.self, from: jsonData)
                   if (!table.success) {
                       self.warning(table.msg)
                   } else {
                       self.info("已經完成報名")
                   }
               } catch {
                   //self.warning(error.localizedDescription)
                   self.warning(self.dataService.msg)
               }
           } else {
               Global.instance.removeSpinner(superView: self.view)
               self.warning("伺服器錯誤，請稍後再試，或洽管理人員")
               //SCLAlertView().showWarning("錯誤", subTitle: "註冊失敗，伺服器錯誤，請稍後再試")

           }
       }
    }
    
    override func cancel() {
        prev()
    }
}

extension MatchTeamSignupVC: UIPageViewControllerDataSource {
    
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

extension MatchTeamSignupVC: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed {
            if let currentVC = pageViewController.viewControllers?.first,
               let idx = pages.firstIndex(of: currentVC) {
                self.currentIdx = idx
                //print(idx)
            }
        }
    }
}

class MatchTeamEditVC: BaseViewController {
    var idx: Int = 0
    
    let lbl: SuperLabel = {
        let view: SuperLabel = SuperLabel()
        view.setTextBold()
        view.text = "組隊資料"
        
        return view
    }()
    
    let teamNameTxt2: MainTextField2 = {
        let view: MainTextField2 = MainTextField2(key: "team_name", label: "隊名", icon: "member_on_svg", placeholder: "無敵隊", isRequired: true)
        
        return view
    }()
    
    let managerNameTxt2: MainTextField2 = {
        let view: MainTextField2 = MainTextField2(key: "manager_name", label: "隊長姓名", icon: "member_on_svg", placeholder: "張大中", isRequired: true)
        
        return view
    }()
    
    let managerMobileTxt2: MainTextField2 = {
        let view: MainTextField2 = MainTextField2(key: "manager_mobile", label: "隊長手機", icon: "mobile_svg", placeholder: "0960283457", isRequired: true, keyboard: KEYBOARD.numberPad)
        
        return view
    }()
    
    let managerEmailTxt2: MainTextField2 = {
        let view: MainTextField2 = MainTextField2(key: "manager_email", label: "隊長Email", icon: "email_svg", placeholder: "davie@gmail.com", isRequired: true, keyboard: KEYBOARD.emailAddress)
        
        return view
    }()
    
    let managerLineTxt2: MainTextField2 = {
        let view: MainTextField2 = MainTextField2(key: "manager_line", label: "隊長line", icon: "line_svg", placeholder: "badminton")
        
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
        
        self.view.backgroundColor = UIColor.black
        
        anchor()
        setValue()
    }
    
    func anchor() {
        self.view.addSubview(lbl)
        lbl.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        self.view.addSubview(teamNameTxt2)
        teamNameTxt2.snp.makeConstraints { make in
            make.top.equalTo(lbl.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        fields.append(teamNameTxt2)
        
        self.view.addSubview(managerNameTxt2)
        managerNameTxt2.snp.makeConstraints { make in
            make.top.equalTo(teamNameTxt2.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        fields.append(managerNameTxt2)
        
        self.view.addSubview(managerMobileTxt2)
        managerMobileTxt2.snp.makeConstraints { make in
            make.top.equalTo(managerNameTxt2.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        fields.append(managerMobileTxt2)
        
        self.view.addSubview(managerEmailTxt2)
        managerEmailTxt2.snp.makeConstraints { make in
            make.top.equalTo(managerMobileTxt2.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        fields.append(managerEmailTxt2)
        
        self.view.addSubview(managerLineTxt2)
        managerLineTxt2.snp.makeConstraints { make in
            make.top.equalTo(managerEmailTxt2.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        fields.append(managerLineTxt2)
    }
    
    func setValue() {
        teamNameTxt2.setValue("aaa")
        managerNameTxt2.setValue(Member.instance.name)
        managerMobileTxt2.setValue(Member.instance.mobile)
        managerEmailTxt2.setValue(Member.instance.email)
        managerLineTxt2.setValue(Member.instance.line)
    }
    
    func checkRequire()-> String {

        var res: String = ""
        var msgs: [String] = [String]()

        if teamNameTxt2.value.count == 0 {
            msgs.append("隊名不能為空白")
        }
        
        if managerNameTxt2.value.count == 0 {
            msgs.append("隊長姓名不能為空白")
        }

        if managerMobileTxt2.value.count == 0 {
            msgs.append("隊長手機不能為空白")
        }

        if managerEmailTxt2.value.count == 0 {
            msgs.append("隊長Email不能為空白")
        }

        if msgs.count > 0 {
            for msg in msgs {
                res += "\(msg)\n"
            }
        }

        return res
    }
}

class MatchPlayerEditVC: BaseViewController {
    
    var idx: Int = 1
    
    var formContainer: UIView = UIView()
    
    let lbl: SuperLabel = {
        let view: SuperLabel = SuperLabel()
        view.setTextBold()
        view.text = "隊員"
        
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
        
        self.view.backgroundColor = UIColor.black
        
        lbl.text = "隊員\(idx)"
        anchor()
        
        setValue()
    }
    
    func anchor() {
        self.view.addSubview(formContainer)
        formContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
            formContainer.addSubview(lbl)
            lbl.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(12)
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
            }
        
            formContainer.addSubview(nameTxt2)
            nameTxt2.snp.makeConstraints { make in
                make.top.equalTo(lbl.snp.bottom).offset(20)
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
        nameTxt2.setValue("bbb")
        mobileTxt2.setValue("12334")
        emailTxt2.setValue("email")
        lineTxt2.setValue("line")
        
        if let age = Member.instance.dob.clacAge() {
            ageTxt2.setValue(String(20))
        }
    }
    
    func checkRequire()-> String {

        var res: String = ""
        var msgs: [String] = [String]()

        if nameTxt2.value.count == 0 {
            msgs.append("姓名不能為空白")
        }

        if mobileTxt2.value.count == 0 {
            msgs.append("手機不能為空白")
        }

        if emailTxt2.value.count == 0 {
            msgs.append("Email不能為空白")
        }

        if msgs.count > 0 {
            for msg in msgs {
                res += "\(msg)\n"
            }
        }

        return res
    }
}

extension Dictionary {
    
    func toJson() -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
}

