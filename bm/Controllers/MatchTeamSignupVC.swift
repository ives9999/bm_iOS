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
        if token != nil {
            Global.instance.addSpinner(superView: self.view)
            var params: [String: String] = ["token": token!, "member_token": Member.instance.token]
            
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
        } else if match_group_token != nil {
            Global.instance.addSpinner(superView: self.view)
            var params: [String: String] = ["match_group_token": match_group_token!, "member_token": Member.instance.token]
            
            dataService.getOne(params: params) { [self] (success) in
                Global.instance.removeSpinner(superView: self.view)
                if (success) {
                    let jsonData: Data = self.dataService.jsonData!
                    //jsonData.prettyPrintedJSONString
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
        let vc1: MatchTeamEditVC = MatchTeamEditVC(idx: 0)
        if table != nil {
            vc1.setValue(team: table!)
        }
        pages.append(vc1)
        
        let playerNumber: Int = table!.matchGroupTable!.number
        for i in 1...playerNumber {
            let vc: MatchPlayerEditVC = MatchPlayerEditVC(idx: i)
            if table!.matchPlayers.count > 0 {
                vc.playerTable = table!.matchPlayers[i-1]
            }
            vc.giftTables = table!.matchGifts
            
            if table!.matchPlayers != nil && i <= table!.matchPlayers.count {
                vc.setValue(player: table!.matchPlayers[i-1])
            }
            pages.append(vc)
        }
        
        self.pageVC.setViewControllers([pages.first!], direction: .forward, animated: true)
    }
    
    override func submit() {
        
        //球隊資訊
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
        
        //球員資訊
        var b: [[String: Any]] = [[String: Any]]()
        for i in 1...pages.count-1 {
            
            if let vc = pages[i] as? MatchPlayerEditVC {
                let res = vc.checkRequire()
                if res.count > 0 {
                    warning(res)
                    return
                }
                
                var c: [String: Any] = [String: Any]()
                for field in vc.fields {
                    if let tmp = field as? MainTextField2 {
                        c["\(tmp.key)"] = tmp.value
                    }
                }
                
                var selected_attributes: [String] = [String]()
                var gift_id: String = "0"
                for giftAttribute in vc.giftAttributes {
                    let value: String = "{name:\(giftAttribute["name"] ?? ""),alias:\(giftAttribute["alias"] ?? ""),value:\(giftAttribute["value"] ?? "")}"
                    selected_attributes.append(value)
                    gift_id = giftAttribute["id"] ?? "0"
                }
                
//                var c1: [[String: String] = [String: String]()
//                for attribute in vc.giftAttributes {
//                    for (key, value) in attribute {
//                        c1[key] = value
//                    }
//                }
                c["gift"] = ["id": gift_id, "attribute": selected_attributes.joined(separator: "|")]
                
                
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
               //print(jsonData.toString())
               //jsonData.prettyPrintedJSONString
               do {
                   let t = try JSONDecoder().decode(SuccessTable.self, from: jsonData)
                   if (!t.success) {
                       self.warning(t.msg)
                   } else {
                       //print(self.table!.product_token)
                       self.info(msg: "已經完成報名，請前往付款", closeButtonTitle: "關閉", buttonTitle: "付款") {
                           self.toOrder(
                            login: { vc in vc.toLogin() },
                            register: { vc in vc.toRegister() },
                            product_token: self.table!.product_token,
                            product_price_id: self.table!.matchGroupTable?.product_price_id
                           )
                       }
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
    
    func setValue(team: MatchTeamTable? = nil) {
        if team != nil {
            teamNameTxt2.setValue(team!.name)
            managerNameTxt2.setValue(team!.manager_name)
            managerMobileTxt2.setValue(team!.manager_mobile)
            managerEmailTxt2.setValue(team!.manager_email)
            managerLineTxt2.setValue(team!.manager_line)
        }
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
    
    let hr: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor(MY_LIGHT_WHITE)
        
        return view
    }()
    
    let giftLbl: SuperLabel = {
        let view: SuperLabel = SuperLabel()
        view.setTextBold()
        view.text = "贈品"
        
        return view
    }()
    
    //填寫的所有欄位
    var fields: [UIView] = [UIView]()
    
    var playerTable: MatchPlayerTable? = nil
    var giftTables: [MatchGiftTable] = [MatchGiftTable]()
    //贈品的屬性
    //var attributes: [ProductAttributeTable] = [ProductAttributeTable]()
    
    //要回傳的贈品屬性
    var giftAttributes: [[String: String]] = [[String: String]]()
    
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
        
        title = "隊員\(idx)"
        lbl.text = title
        
//        if gifts.count > 0 {
//            if let product: ProductTable = gifts[0].productTable {
//                giftLbl.text = product.name
//                self.attributes = product.attributes
//            }
//        }
        
        anchor()
        
        setValue()
    }
    
    func anchor() {
        
        let topPadding: Int = 20
        let leftPadding: Int = 20
        let rightPadding: Int = -20
        
        let scroll = initScrollView(self.view)
        
        scroll.contentView.addSubview(formContainer)
        formContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
            formContainer.addSubview(lbl)
            lbl.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(12)
                make.left.equalToSuperview().offset(leftPadding)
                make.right.equalToSuperview().offset(rightPadding)
            }
        
            formContainer.addSubview(nameTxt2)
            nameTxt2.snp.makeConstraints { make in
                make.top.equalTo(lbl.snp.bottom).offset(topPadding)
                make.left.equalToSuperview().offset(leftPadding)
                make.right.equalToSuperview().offset(rightPadding)
            }
            fields.append(nameTxt2)
            
            formContainer.addSubview(mobileTxt2)
            mobileTxt2.snp.makeConstraints { make in
                make.top.equalTo(nameTxt2.snp.bottom).offset(topPadding)
                make.left.equalToSuperview().offset(leftPadding)
                make.right.equalToSuperview().offset(rightPadding)
            }
            fields.append(mobileTxt2)
            
            formContainer.addSubview(emailTxt2)
            emailTxt2.snp.makeConstraints { make in
                make.top.equalTo(mobileTxt2.snp.bottom).offset(topPadding)
                make.left.equalToSuperview().offset(leftPadding)
                make.right.equalToSuperview().offset(rightPadding)
            }
            fields.append(emailTxt2)
            
            formContainer.addSubview(lineTxt2)
            lineTxt2.snp.makeConstraints { make in
                make.top.equalTo(emailTxt2.snp.bottom).offset(topPadding)
                make.left.equalToSuperview().offset(leftPadding)
                make.right.equalToSuperview().offset(rightPadding)
            }
            fields.append(lineTxt2)
            
            formContainer.addSubview(ageTxt2)
            ageTxt2.snp.makeConstraints { make in
                make.top.equalTo(lineTxt2.snp.bottom).offset(topPadding)
                make.left.equalToSuperview().offset(leftPadding)
                make.right.equalToSuperview().offset(rightPadding)
            }
            fields.append(ageTxt2)
        
            formContainer.addSubview(hr)
            hr.snp.makeConstraints { make in
                make.top.equalTo(ageTxt2.snp.bottom).offset(topPadding)
                make.left.equalToSuperview().offset(leftPadding)
                make.right.equalToSuperview().offset(rightPadding)
                make.height.equalTo(1)
            }
            
            formContainer.addSubview(giftLbl)
            giftLbl.snp.makeConstraints { make in
                make.top.equalTo(hr.snp.bottom).offset(topPadding)
                make.left.equalToSuperview().offset(leftPadding)
            }
        
        //下面回圈中要對齊的最後一個view
        var lastView: UIView = giftLbl
        
        //取得隊員所選的贈品
        var giftTables: [MatchPlayerGiftTable] = [MatchPlayerGiftTable]()
        var attributes: [[String: String]] = [[String: String]]()
        if playerTable != nil {
            giftTables = playerTable!.matchPlayerGiftsTable
            if (giftTables.count > 0) {
                let giftTable: MatchPlayerGiftTable = giftTables[0]
                attributes = giftTable.attributes.productAttributeToArray()
            }
        }
        
        for (i, attribute) in self.giftTables[0].productTable!.attributes.enumerated() {
            
            //setup attribute label
            let attributeLbl: SuperLabel = {
                let view: SuperLabel = SuperLabel()
                view.setTextBold()
                view.text = "屬性："
                
                return view
            }()
            
            formContainer.addSubview(attributeLbl)
            attributeLbl.text = attribute.name
            attributeLbl.snp.makeConstraints { make in
                make.top.equalTo(lastView.snp.bottom).offset(topPadding)
                make.left.equalToSuperview().offset(leftPadding)
                //make.bottom.equalToSuperview().offset(-100)
            }
            
            //產生贈品屬性的tag
            var selected: String = ""
            let isExist: Bool = attributes.indices.contains(i)
            if isExist {
                selected = attributes[i]["value"] ?? ""
            }
            
            let tagContainer: AttributesView = AttributesView(name: attribute.name, alias: attribute.alias, attribute: attribute.attribute, selected: selected)
            //屬性欄的高度，從tagContainer來取得
            let h: Int = tagContainer.getHeight()
            
            formContainer.addSubview(tagContainer)
            //tagContainer.backgroundColor = UIColor.red
            tagContainer.snp.makeConstraints { make in
                make.top.equalTo(attributeLbl.snp.bottom).offset(topPadding)
                make.left.equalToSuperview().offset(leftPadding)
                make.right.equalToSuperview().offset(rightPadding)
                make.height.equalTo(h)
            }
            tagContainer.delegate = self
            tagContainer.setAttributes()
            lastView = tagContainer
            
            let tmp: [String: String] = ["name": attribute.name, "alias": attribute.alias, "value": "", "id": String(giftTables[0].id)]
            giftAttributes.append(tmp)
        }
        //print(giftAttributes)
    }
    
    private func initScrollView(_ container: UIView)-> (scrollView: UIScrollView, contentView: UIView) {
        
        let scrollView: UIScrollView = UIScrollView()
        container.addSubview(scrollView)
        //scrollView.backgroundColor = UIColor.red
        scrollView.snp.makeConstraints { make in
            make.centerX.equalTo(container.snp.centerX)
            make.width.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        let contentView = UIView()
        scrollView.addSubview(contentView)
        //contentView.backgroundColor = UIColor.green
        contentView.snp.makeConstraints { make in
            make.left.right.equalTo(scrollView)
            make.top.bottom.equalTo(scrollView)
            make.width.equalTo(scrollView)
            make.height.equalTo(2000)
        }
        
        return (scrollView, contentView)
    }
    
    func setGiftName(_ giftName: String) {
        giftLbl.text = "贈品：\(giftName)"
    }

    func setValue(player: MatchPlayerTable? = nil) {
        if player != nil {
            nameTxt2.setValue(player!.name)
            mobileTxt2.setValue(player!.mobile)
            emailTxt2.setValue(player!.email)
            lineTxt2.setValue(player!.line)
            ageTxt2.setValue(String(player!.age))
            
//            if let age = Member.instance.dob.clacAge() {
//                ageTxt2.setValue(String(20))
//            }
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
        
        if giftAttributes.count > 0 {
            for giftAttribute in giftAttributes {
                for (key, value) in giftAttribute {
                    if key == "value" && value.count == 0 {
                        let name: String = giftAttribute["name"] ?? ""
                        msgs.append("\(title!) \(name)沒有選擇")
                        break
                    }
                }
            }
        }

        if msgs.count > 0 {
            for msg in msgs {
                res += "\(msg)\n"
            }
        }

        return res
    }
}

extension MatchPlayerEditVC: AttributesViewDelegate {
    
    func tagPressed(name: String, alias: String, value: String, idx: Int) {
        //print("key:\(key) => idx:\(idx) => value:\(value)")
        //let value: String = "{name:\(name),alias:\(alias),value:\(value)}"
        //selected_attributes.append(value)
        for (idx, giftAttriubte) in self.giftAttributes.enumerated() {
            for (key, value1) in giftAttriubte {
                if key == "alias" && value1 == alias {
                    giftAttributes[idx]["value"] = value
                    break
                }
            }
        }
//        print(giftAttributes)
//        let i = 6
    }
}

