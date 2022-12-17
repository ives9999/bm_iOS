//
//  MemberVC.swift
//  bm
//
//  Created by ives on 2020/2/15.
//  Copyright © 2020 bm. All rights reserved.
//

import UIKit

class MemberVC: MyTableVC {
    
    @IBOutlet weak var nicknameLbl: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var registerIcon: UIImageView!
    @IBOutlet weak var forgetPasswordIcon: UIImageView!
    @IBOutlet weak var forgetPasswordBtn: UIButton!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    //let _sections: [String] = ["會員資料", "訂單", "喜歡", "管理"]
    
    //let _sections: [String] = ["會員資料", "報名"]
//    let fixedRows: [Dictionary<String, String>] = [
//        ["text": "帳戶資料", "icon": "account", "segue": TO_PROFILE],
//        ["text": "更改密碼", "icon": "password", "segue": TO_PASSWORD]
//    ]
//    var memberRows: [Dictionary<String, String>] = [Dictionary<String, String>]()
//
//    var orderRows: [Dictionary<String, String>] = [
//        ["text": "購物車", "icon": "cart", "segue": TO_MEMBER_CART_LIST],
//        ["text": "訂單查詢", "icon": "order", "segue": TO_MEMBER_ORDER_LIST]
//    ]
//
//    let likeRows: [Dictionary<String, String>] = [
//        ["text": "球隊","icon":"team","segue":TO_LIKE,"able_type":"team"],
//        ["text": "球館","icon":"arena","segue":TO_LIKE,"able_type":"arena"],
//        ["text": "教練","icon":"coach","segue":TO_LIKE,"able_type":"coach"],
//        ["text": "課程","icon":"course","segue":TO_LIKE,"able_type":"course"],
//        ["text": "商品","icon":"product","segue":TO_LIKE,"able_type":"product"],
//        ["text": "體育用品店","icon":"store","segue":TO_LIKE,"able_type":"store"]
//    ]
//
//    let courseRows: [Dictionary<String, String>] = [
//        ["text": "課程","icon":"course","segue":"toManagerCourse","able_type":"course"]
//    ]
    
    var memberSections: [MemberSection] = [MemberSection]()
    
    let heightForSection: CGFloat = 34
    
//    var searchSections: [ExpandableItems] = [
//        ExpandableItems(isExpanded: true, items: []),
//        ExpandableItems(isExpanded: true, items: []),
//        ExpandableItems(isExpanded: false, items: []),
//        ExpandableItems(isExpanded: true, items: [])
//    ]
    
    
//    let signupRows: [Dictionary<String, String>] = [
//        ["text": "課程報名", "icon": "account", "segue": TO_SIGNUP_LIST]
//    ]
//    var _rows: [[Dictionary<String, Any>]] = [[Dictionary<String, Any>]]()

    override func viewDidLoad() {
        myTablView = tableView
        able_type = "member"
        
        super.viewDidLoad()
        
        dataService = MemberService.instance
        
//        mySections = [
//            ["name": "會員資料", "isExpanded": true, "key": "data"],
//            ["name": "訂單", "isExpanded": true, "key": "order"],
//            ["name": "喜歡", "isExpanded": false, "key": "like"],
//            ["name": "管理", "isExpanded": true, "key": "manager"]
//        ]
//
//        myRows = [
//            ["key":"data", "rows": memberRows],
//            ["key":"order", "rows": orderRows],
//            ["key":"like", "rows": likeRows],
//            ["key":"manager", "rows": courseRows],
//        ]

        tableView.register(MenuCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //refresh()
        loginout()
    }
    
    func initSectionRows1() -> [MemberSection] {
        
//        if (memberSections.count > 0) {
//            return memberSections
//        }
        
        var sections: [MemberSection] = [MemberSection]()
        
        sections.append(makeSection0Row())
        sections.append(makeSection1Row())
        sections.append(makeSection2Row(isEpanded: true))
        sections.append(makeSection3Row())
        sections.append(makeSection4Row())
        sections.append(makeSectionBankRow())
        sections.append(makeSectionXRow())
        
        return sections
    }
    
    func makeSection0Row(isEpanded: Bool = true)-> MemberSection {
        
        var rows: [MemberRow] = [MemberRow]()
        
        let fixedRows = makeSection0FixRow()
        rows.append(contentsOf: fixedRows)
        
        let validateRows = makeSection0ValidateRow()
        rows.append(contentsOf: validateRows)
        
        let refreshRows = makeSection0RefreshRow()
        rows.append(contentsOf: refreshRows)
        
        let s: MemberSection = MemberSection(title: "會員資料", isExpanded: isEpanded, items: rows)
        
        return s
    }
    
    func makeSection0FixRow()-> [MemberRow] {
        
        var rows: [MemberRow] = [MemberRow]()
        
        var r: MemberRow = MemberRow(title: "解碼點數", icon: "coin", segue: TO_MEMBER_COIN_LIST)
        r.show = Member.instance.coin.formattedWithSeparator + " 點"
        rows.append(r)
        r = MemberRow(title: "訂閱會員", icon: "member_level_up", segue: TO_MEMBER_SUPSCRIPTION_KIND)
        let levelEnum: MEMBER_SUBSCRIPTION_KIND = MEMBER_SUBSCRIPTION_KIND.stringToEnum(Member.instance.subscription)
        r.show = levelEnum.rawValue
        rows.append(r)
        r = MemberRow(title: "帳戶資料", icon: "member", segue: TO_PROFILE)
        rows.append(r)
        r = MemberRow(title: "QRCode", icon: "qrcode", segue: "qrcode")
        rows.append(r)
        r = MemberRow(title: "更改密碼", icon: "password", segue: TO_PASSWORD)
        rows.append(r)
        
        return rows
    }
    
    func makeSection0RefreshRow()-> [MemberRow] {
        
        var rows: [MemberRow] = [MemberRow]()
        
        let r1: MemberRow = MemberRow(title: "重新整理", icon: "refresh", segue: TO_REFRESH)
        rows.append(r1)
        
        return rows
    }
    
    func makeSection0ValidateRow() -> [MemberRow] {
        
        var rows: [MemberRow] = [MemberRow]()
        
        let validate: Int = Member.instance.validate
        
        if (validate & EMAIL_VALIDATE <= 0) {
            let r: MemberRow = MemberRow(title: "email認證", icon: "email1", segue: TO_VALIDATE)
            r.validate_type = "email"
            rows.append(r)
        }
        
        if (validate & MOBILE_VALIDATE <= 0) {
            let r: MemberRow = MemberRow(title: "手機認證", icon: "mobile", segue: TO_VALIDATE)
            r.validate_type = "mobile"
            rows.append(r)
        }
        
        return rows
    }
    
    func makeSection1Row(isEpanded: Bool = true)-> MemberSection {
        
        var rows: [MemberRow] = [MemberRow]()
        
        let r1: MemberRow = MemberRow(title: "購物車", icon: "cart", segue: TO_MEMBER_CART_LIST)
        rows.append(r1)
        
        let r2: MemberRow = MemberRow(title: "訂單查詢", icon: "order", segue: TO_MEMBER_ORDER_LIST)
        rows.append(r2)
        
        let s: MemberSection = MemberSection(title: "訂單查詢", isExpanded: isEpanded, items: rows)
        
        return s
    }
    
    func makeSection2Row(isEpanded: Bool = true)-> MemberSection {
        
        var rows: [MemberRow] = [MemberRow]()
        
        let r1: MemberRow = MemberRow(title: "球隊", icon: "team", segue: TO_LIKE, able_type: "team")
        rows.append(r1)
        let r2: MemberRow = MemberRow(title: "球館", icon: "arena", segue: TO_LIKE, able_type: "arena")
        rows.append(r2)
        let r3: MemberRow = MemberRow(title: "教學", icon: "teach", segue: TO_LIKE, able_type: "teach")
        rows.append(r3)
        let r4: MemberRow = MemberRow(title: "教練", icon: "coach", segue: TO_LIKE, able_type: "coach")
        rows.append(r4)
        let r5: MemberRow = MemberRow(title: "課程", icon: "course", segue: TO_LIKE, able_type: "course")
        rows.append(r5)
        let r6: MemberRow = MemberRow(title: "商品", icon: "product", segue: TO_LIKE, able_type: "product")
        rows.append(r6)
        let r7: MemberRow = MemberRow(title: "體育用品店", icon: "store", segue: TO_LIKE, able_type: "store")
        rows.append(r7)
        
        let s: MemberSection = MemberSection(title: "喜歡", isExpanded: isEpanded, items: rows)
        
        return s
    }
    
    func makeSection3Row(isEpanded: Bool = true)-> MemberSection {

        var rows: [MemberRow] = [MemberRow]()
        
        let r1: MemberRow = MemberRow(title: "球隊", icon: "team", segue: TO_MEMBER_SIGNUPLIST, able_type: "team")
        rows.append(r1)
        let r2: MemberRow = MemberRow(title: "臨打", icon: "tempPlay", segue: TO_MEMBER_SIGNUPLIST, able_type: "tempPlay")
        rows.append(r2)
        let r3: MemberRow = MemberRow(title: "課程", icon: "course", segue: TO_MEMBER_SIGNUPLIST, able_type: "course")
        rows.append(r3)

        let s: MemberSection = MemberSection(title: "參加", isExpanded: isEpanded, items: rows)

        return s
    }
    
    func makeSection4Row(isEpanded: Bool = true)-> MemberSection {

        var rows: [MemberRow] = [MemberRow]()
        
        let r1: MemberRow = MemberRow(title: "球隊", icon: "team", segue: "toManagerTeam")
        rows.append(r1)
        let r2: MemberRow = MemberRow(title: "球隊申請管理權", icon: "team", segue: "toRequestManagerTeam")
        rows.append(r2)
        let r3: MemberRow = MemberRow(title: "課程", icon: "course", segue: "toManagerCourse")
        rows.append(r3)

        let s: MemberSection = MemberSection(title: "管理", isExpanded: isEpanded, items: rows)

        return s
    }
    
    func makeSectionBankRow(isEpanded: Bool = true)-> MemberSection {

        var rows: [MemberRow] = [MemberRow]()
        
        let r1: MemberRow = MemberRow(title: "銀行帳號", icon: "bank", segue: TO_MEMBER_BANK)
        rows.append(r1)

        let s: MemberSection = MemberSection(title: "銀行帳號", isExpanded: isEpanded, items: rows)

        return s
    }
    
    func makeSectionXRow(isEpanded: Bool = true)-> MemberSection {

        var rows: [MemberRow] = [MemberRow]()
        
        let r1: MemberRow = MemberRow(title: "刪除會員", icon: "delete", segue: "delete")
        rows.append(r1)

        let s: MemberSection = MemberSection(title: "刪除", isExpanded: isEpanded, items: rows)

        return s
    }
    
    override func refresh() {
        Global.instance.addSpinner(superView: self.view)
        MemberService.instance.getOne(params: ["token": Member.instance.token]) { success in
            
            Global.instance.removeSpinner(superView: self.view)
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            if success {
                
                let jsonData: Data = MemberService.instance.jsonData!
                do {
                    let table: MemberTable = try JSONDecoder().decode(MemberTable.self, from: jsonData)
                    table.toSession(isLoggedIn: true)
                    //self.session.dump()
                    self.loginout()
                    self.tableView.reloadData()
                } catch {
                    self.warning(error.localizedDescription)
                }
            } else {
                self.warning("取得會員資訊錯誤")
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if sender != nil {
            if segue.identifier == TO_VALIDATE {
                let vc: ValidateVC = segue.destination as! ValidateVC
                vc.type = sender as! String
            } else if segue.identifier == TO_LOGIN {
                //let vc: LoginVC = segue.destination as! LoginVC
                //vc.menuVC = (sender as! MenuVC)
            } else if segue.identifier == TO_REGISTER {
                //let vc: RegisterVC = segue.destination as! RegisterVC
                //vc.menuVC = (sender as! MenuVC)
            } else {
         }
        }
    }
    
    func login() {
        toLogin(memberVC: self)
//            if let vc = storyboard?.instantiateViewController(withIdentifier: "login") as? LoginVC {
//                vc.memberVC = self
//                present(vc, animated: true, completion: nil)
//            }
        //performSegue(withIdentifier: TO_LOGIN, sender: self)
    }
    
    func logout() {
        //1.清空session資料
        Member.instance.reset()
        //2.設定登出
        Member.instance.isLoggedIn = false
        loginout()
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        if Member.instance.isLoggedIn { // logout
            logout()
        } else {
            login()
        }
    }
    
    @IBAction func registerBtnPressed(_ sender: Any) {
//        if let vc = storyboard?.instantiateViewController(withIdentifier: "register") as? RegisterVC {
//            vc.sourceVC = self
//            present(vc, animated: true, completion: nil)
//        }
        //performSegue(withIdentifier: TO_REGISTER, sender: self)
        toRegister()
    }
    
    @IBAction func passwordBtnPressed(_ sender: Any) {
        toPassword(type: "forget_password")
//        let type: String = "forget_password"
//        if let vc = storyboard?.instantiateViewController(withIdentifier: "passwo") as? PasswordVC {
//            vc.type = type
//            vc.delegate = self
//            present(vc, animated: true, completion: nil)
//        }
        //performSegue(withIdentifier: TO_PASSWORD, sender: type)
    }
    
    public func loginout() {
        //print(Member.instance.isLoggedIn)
        if Member.instance.isLoggedIn   { // login
           _loginBlock()
        } else {
           _logoutBlock()
       }
    }
       
    public func _loginBlock() {
        
        memberSections = initSectionRows1()
        self.tableView.reloadData()
        nicknameLbl.text = Member.instance.nickname
        if Member.instance.avatar.count > 0 {
            avatarImageView.downloaded(from: Member.instance.avatar)
        }
        loginBtn.setTitle("登出", for: .normal)
        registerBtn.isHidden = true
        registerIcon.isHidden = true
        forgetPasswordBtn.isHidden = true
        forgetPasswordIcon.isHidden = true
    
        tableView.isHidden = false
    }
    
    public func _logoutBlock() {
        nicknameLbl.text = "未登入"
        loginBtn.setTitle("登入", for: .normal)
        registerBtn.isHidden = false
        registerIcon.isHidden = false
        forgetPasswordBtn.isHidden = false
        forgetPasswordIcon.isHidden = false
        tableView.isHidden = true
        avatarImageView.image = UIImage(named: "menuProfileIcon")
    }
    
    @objc override func handleExpandClose(gesture : UITapGestureRecognizer) {
        
        let headerView = gesture.view!
        let section = headerView.tag
        let tmp = headerView.subviews.filter({$0 is UIImageView})
        var mark: UIImageView?
        if tmp.count > 0 {
            mark = tmp[0] as? UIImageView
        }
        
        var indexPaths: [IndexPath] = [IndexPath]()
        
        //let key: String = getSectionKey(idx: section)
        //let rows: [[String: String]] = getRowRowsFromMyRowsByKey(key: key)
        let rows: [MemberRow] = memberSections[section].items
        for (i, _) in rows.enumerated() {
            let indexPath = IndexPath(row: i, section: section)
            indexPaths.append(indexPath)
        }
        
        var isExpanded = memberSections[section].isExpanded
        memberSections[section].isExpanded = !isExpanded
        
//        var isExpanded = getSectionExpanded(idx: section)
//        if (mySections[section].keyExist(key: "isExpanded")) {
//            mySections[section]["isExpanded"] = !isExpanded
//            //searchSections[section].isExpanded = !isExpanded
//        }
        
        if isExpanded {
            tableView.deleteRows(at: indexPaths, with: .fade)
        } else {
            tableView.insertRows(at: indexPaths, with: .fade)
        }
        
        isExpanded = !isExpanded
        if mark != nil {
            toggleMark(mark: mark!, isExpanded: isExpanded)
        }
    }
    
    func delete() {
        msg = "是否確定要刪除自己的會員資料？"
        warning(msg: msg, closeButtonTitle: "取消", buttonTitle: "刪除") {
            Global.instance.addSpinner(superView: self.view)
            self.dataService.delete(token: Member.instance.token, type: self.able_type) { success in
                Global.instance.removeSpinner(superView: self.view)
                if (success) {
                    do {
                        self.jsonData = self.dataService.jsonData
                        if (self.jsonData != nil) {
                            let successTable: SuccessTable = try JSONDecoder().decode(SuccessTable.self, from: self.jsonData!)
                            if (!successTable.success) {
                                self.warning(successTable.msg)
                            } else {
                                self.deleteEnd()
                            }
                        } else {
                            self.warning("無法從伺服器取得正確的json資料，請洽管理員")
                        }
                    } catch {
                        self.msg = "解析JSON字串時，得到空值，請洽管理員"
                        self.warning(self.msg)
                    }
                } else {
                    self.warning("刪除失敗，請洽管理員")
                }
            }
        }
    }
    
    func deleteEnd() {
        
        info(msg: "您的帳號已經被刪除，羽球密碼感謝您的支持", buttonTitle: "關閉") {
            self.logout()
        }
    }
}

extension MemberVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return memberSections.count
        //return mySections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count: Int = 0
        if (memberSections[section].isExpanded) {
            count = memberSections[section].items.count
        }
//        let mySection: [String: Any] = mySections[section]
//        if (mySection.keyExist(key: "isExpanded")) {
//            let isExpanded: Bool = mySection["isExpanded"] as? Bool ?? true
//            if (isExpanded) {
//                if let key: String = mySection["key"] as? String {
//                    let rows: [[String: String]] = getRowRowsFromMyRowsByKey(key: key)
//                    count = rows.count
//                }
//            }
//        }
        
        return count
        
//        if !searchSections[section].isExpanded {
//            return 0
//        }
//
//        if (section == 0) {
//            //searchSections[0].items = [String]()
//            return memberRows.count
//        } else if (section == 1) {
//            return orderRows.count
//        } else if (section == 2) {
//            return likeRows.count
//        } else if (section == 3) {
//            return courseRows.count
//        } else {
//            return 0
//        }
        //return searchSections[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView = UIView()
        headerView.backgroundColor = UIColor.gray
        headerView.tag = section

        let titleLabel = UILabel()
        titleLabel.text = memberSections[section].title
        titleLabel.textColor = UIColor(MY_WHITE)
        titleLabel.sizeToFit()
        titleLabel.frame = CGRect(x: 10, y: 0, width: 100, height: heightForSection)
        headerView.addSubview(titleLabel)
        
//        var expanded_image: String = "to_right_w"
//        if memberSections[section].isExpanded {
//            expanded_image = "to_down_w"
//        }
//        let mark = UIImageView(image: UIImage(named: expanded_image))
//
//        //mark.frame = CGRect(x: view.frame.width-10-20, y: (34-20)/2, width: 20, height: 20)
//        headerView.addSubview(mark)
//
//        mark.translatesAutoresizingMaskIntoConstraints = false
//
//        mark.centerYAnchor.constraint(equalTo: mark.superview!.centerYAnchor).isActive = true
//        mark.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        mark.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        mark.trailingAnchor.constraint(equalTo: mark.superview!.trailingAnchor, constant: -16).isActive = true
//
//        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleExpandClose))
//        headerView.addGestureRecognizer(gesture)

        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("show cell sections: \(indexPath.section), rows: \(indexPath.row)")
        let cell: MenuCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuCell
        //cell.delegate = self
        //print(rows)
                
        let row: MemberRow = memberSections[indexPath.section].items[indexPath.row]
        //let row: [String: String] = getRowFromIndexPath(indexPath: indexPath)
        cell.setRow(row: row)
        
        if indexPath.section == 1 && indexPath.row == 0 {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("click cell sections: \(indexPath.section), rows: \(indexPath.row)")
        let row: MemberRow = memberSections[indexPath.section].items[indexPath.row]
        let segue: String = row.segue
        if segue == TO_PROFILE {
            toRegister()
        } else if segue == TO_PASSWORD {
            toPassword(type: "change_password")
        } else if segue == TO_VALIDATE {
            toValidate(type: row.validate_type)
        } else if segue == TO_BLACKLIST {
            performSegue(withIdentifier: segue, sender: nil)
        } else if segue == TO_REFRESH {
            refresh()
        } else if segue == TO_SIGNUPLIST {
            performSegue(withIdentifier: "toA", sender: nil)
        } else if segue == TO_MEMBER_ORDER_LIST {
            toMemberOrderList()
        } else if segue == TO_MEMBER_CART_LIST {
            toMemberCartList(source: "member")
        } else if segue == TO_MEMBER_SIGNUPLIST {
            let able_type: String = row.able_type
            toMemberSignuplist(able_type: able_type)
        } else if segue == TO_LIKE {
            let able_type: String = row.able_type
            
            if (able_type == "team") {
                toTeam(member_like: true)
            } else if (able_type == "course") {
                toCourse(member_like: true, isShowPrev: true)
            } else if (able_type == "product") {
                toProduct(member_like: true)
            } else if (able_type == "coach") {
                toCoach(member_like: true)
            } else if (able_type == "arena") {
                toArena(member_like: true, isShowPrev: true)
            } else if (able_type == "store") {
                toStore(member_like: true)
            } else {
                warning("沒有這個喜歡的連結")
            }
        } else if segue == "toManagerCourse" {
            toManagerCourse(manager_token: Member.instance.token)
        } else if segue == "toManagerTeam" {
            toManagerTeam(manager_token: Member.instance.token)
        } else if segue == "toRequestManagerTeam" {
            toRequestManagerTeam()
        } else if segue == TO_MEMBER_BANK {
            toMemberBank()
        } else if segue == "delete" {
            delete()
        } else if segue == TO_MEMBER_COIN_LIST {
            toMemberCoinList()
        } else if segue == TO_MEMBER_SUPSCRIPTION_KIND {
            toMemberSubscriptionKind()
        } else if segue == "qrcode" {
            let qrcodeIV: UIImageView = makeQrcodeLayer()
            let qrcode: UIImage = generateQRCode(from: Member.instance.token)!
            qrcodeIV.image = qrcode
        }
    }
    
    func makeQrcodeLayer()-> UIImageView {
        
        maskView = self.view.mask()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        maskView.addGestureRecognizer(gestureRecognizer)
        
        let blackViewHeight: CGFloat = 500
        let blackViewPaddingLeft: CGFloat = 20
        
        let blackView: UIView = maskView.blackView(left: blackViewPaddingLeft, top: (maskView.frame.height-blackViewHeight)/2, width: maskView.frame.width-(2*blackViewPaddingLeft), height: blackViewHeight)
        
        
        let qrcodeIV: UIImageView = UIImageView()
        
        blackView.addSubview(qrcodeIV)
        
        qrcodeIV.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        return qrcodeIV
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 10, y: 10)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
    
    @objc func handleTap(sender: UIView) {
        maskView.unmask()
    }
}

