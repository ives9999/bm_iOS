//
//  MemberVC.swift
//  bm
//
//  Created by ives on 2020/2/15.
//  Copyright © 2020 bm. All rights reserved.
//

import UIKit

class MemberVC: BaseViewController {
    
    //@IBOutlet weak var nicknameLbl: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var registerIcon: UIImageView!
    @IBOutlet weak var forgetPasswordIcon: UIImageView!
    @IBOutlet weak var forgetPasswordBtn: UIButton!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    let featuredContainer: UIView = {
        let view = UIView()
        
        return view
    }()
    
    let qrcodeIV2: IconView2 = {
        let view: IconView2 = IconView2(icon: "qrcode_svg", frameWidth: 48, frameHeight: 48, iconWidth: 24, iconHeight: 24)
        
        return view
    }()
    
    let logoutIV2: IconView2 = {
        let view: IconView2 = IconView2(icon: "logout_svg", frameWidth: 48, frameHeight: 48, iconWidth: 24, iconHeight: 24)
        
        return view
    }()
    
    let avatarIV: Avatar = {
        let view: Avatar = Avatar()
        view.image = UIImage(named: "noavatar_svg")
        
        return view
    }()
    
    let nicknameLbl: SuperLabel = {
        let view: SuperLabel = SuperLabel()
        view.setTextTitle()
        view.text = "ives"
        
        return view
    }()
    
    let levelContainer: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor(MEMBER_LEVEL_BACKGROUND)
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        
        return view
    }()
    
    let levelDivideWidth: Int = 2
    
    let levelLeftContainer: UIView = UIView()
    let levelDivideView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor(hex: "#FFFFFF", alpha: 0.26)
        
        return view
    }()
    let levelRightContainer: UIView = UIView()
    
    let pointIconText: IconTextVertical2 = IconTextVertical2(icon: "point_svg", text: "611 點")
    let levelIconText: IconTextVertical2 = IconTextVertical2(icon: "level_svg", text: "金牌")
    
    let titleLbl: SuperLabel = {
        let view: SuperLabel = SuperLabel()
        view.setTextTitle()
        view.text = "功能"
        
        return view
    }()
        
    var memberSections: [MemberSection] = [MemberSection]()
    var rows: [MainMemberTable] = [MainMemberTable]()
    
    let heightForSection: CGFloat = 34
    
    lazy var tableView: MyTable2VC<MainMemberCell, MainMemberTable, MemberVC> = {
        let tableView = MyTable2VC<MainMemberCell, MainMemberTable, MemberVC>(selectedClosure: tableViewSetSelected(row:), getDataClosure: getDataFromServer, myDelegate: self, isRefresh: false)
        
        return tableView
    }()
    
    func tableViewSetSelected(row: MainMemberTable)-> Bool {
        return false
    }
    
    func getDataFromServer(page: Int) {
    }
    
    var mainBottom2: MainBottom2 = MainBottom2(able_type: "member")

    override func viewDidLoad() {
        //myTablView = tableView
        able_type = "member"
        
        super.viewDidLoad()
        
        dataService = MemberService.instance
        
        self.view.addSubview(mainBottom2)
        mainBottom2.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(72)
        }
        mainBottom2.delegate = self
        qrcodeIV2.delegate = self
        logoutIV2.delegate = self
        
        for mainMemberEnum in MainMemberEnum.allValues {
            rows.append(MainMemberTable(title: mainMemberEnum.rawValue, icon: mainMemberEnum.getIcon()))
        }
        tableView.items = rows
        
        anchor()
        
        refresh()
    }
    
    func anchor() {
        self.view.addSubview(featuredContainer)
        //featuredContainer.backgroundColor = UIColor.gray
        featuredContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(statusBarHeight)
            make.left.right.equalToSuperview()
            make.height.equalTo(160)
        }
        
            featuredContainer.addSubview(qrcodeIV2)
            qrcodeIV2.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(20)
                make.top.equalToSuperview()
                make.width.height.equalTo(48)
            }
            
            featuredContainer.addSubview(logoutIV2)
            logoutIV2.snp.makeConstraints { make in
                make.right.equalToSuperview().offset(-20)
                make.top.equalToSuperview()
                make.width.height.equalTo(48)
            }
            
            featuredContainer.addSubview(avatarIV)
            avatarIV.snp.makeConstraints { make in
                make.width.height.equalTo(112)
                make.top.equalToSuperview().offset(12)
                make.centerX.equalToSuperview()
            }
            
            featuredContainer.addSubview(nicknameLbl)
            nicknameLbl.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(avatarIV.snp.bottom).offset(12)
            }
        
        self.view.addSubview(levelContainer)
        //levelContainer.backgroundColor = UIColor.red
        levelContainer.snp.makeConstraints { make in
            make.top.equalTo(featuredContainer.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(85)
        }
        
            let levelLeftWidth: Int = Int((Int(screen_width) - 20*2 - levelDivideWidth)/2)
            
            levelContainer.addSubview(levelLeftContainer)
            //levelLeftContainer.backgroundColor = UIColor.red
            levelLeftContainer.snp.makeConstraints { make in
                make.left.top.bottom.equalToSuperview()
                make.width.equalTo(levelLeftWidth)
            }
            
                levelLeftContainer.addSubview(pointIconText)
                pointIconText.snp.makeConstraints { make in
                    make.width.equalTo(87)
                    make.height.equalTo(52)
                    make.centerX.centerY.equalToSuperview()
                }
            
            levelContainer.addSubview(levelRightContainer)
            //levelRightContainer.backgroundColor = UIColor.blue
            levelRightContainer.snp.makeConstraints { make in
                make.right.top.bottom.equalToSuperview()
                make.width.equalTo(levelLeftWidth)
            }
            
                levelRightContainer.addSubview(levelIconText)
                levelIconText.snp.makeConstraints { make in
                    make.width.equalTo(87)
                    make.height.equalTo(52)
                    make.centerX.centerY.equalToSuperview()
                }
            
            levelContainer.addSubview(levelDivideView)
            levelDivideView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(levelLeftWidth)
                make.width.equalTo(2)
                make.top.equalToSuperview().offset(10)
                make.bottom.equalToSuperview().offset(-10)
            }
        
        self.view.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(levelContainer.snp.bottom).offset(20)
        }
        
        self.view.addSubview(tableView)
        //tableView.backgroundColor = UIColor.red
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLbl.snp.bottom).offset(3)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(mainBottom2.snp.top)
        }
    }
    
    override func refresh() {
        Global.instance.addSpinner(superView: self.view)
        MemberService.instance.getOne(params: ["token": Member.instance.token]) { success in
            Global.instance.removeSpinner(superView: self.view)
            
            if success {
                
                let jsonData: Data = MemberService.instance.jsonData!
                do {
                    let table: MemberTable = try JSONDecoder().decode(MemberTable.self, from: jsonData)
                    table.toSession(isLoggedIn: true)
                    self._loginBlock()
                    //self.session.dump()
                    //self.loginout()
                    //self.tableView.reloadData()
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
        
        //memberSections = initSectionRows1()
        //self.tableView.reloadData()
        nicknameLbl.text = Member.instance.nickname
        if Member.instance.avatar.count > 0 {
            avatarIV.downloaded(from: Member.instance.avatar)
        }
//        loginBtn.setTitle("登出", for: .normal)
//        registerBtn.isHidden = true
//        registerIcon.isHidden = true
//        forgetPasswordBtn.isHidden = true
//        forgetPasswordIcon.isHidden = true
//
//        tableView.isHidden = false
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
    
//    @objc override func handleExpandClose(gesture : UITapGestureRecognizer) {
//
//        let headerView = gesture.view!
//        let section = headerView.tag
//        let tmp = headerView.subviews.filter({$0 is UIImageView})
//        var mark: UIImageView?
//        if tmp.count > 0 {
//            mark = tmp[0] as? UIImageView
//        }
//
//        var indexPaths: [IndexPath] = [IndexPath]()
//
//        //let key: String = getSectionKey(idx: section)
//        //let rows: [[String: String]] = getRowRowsFromMyRowsByKey(key: key)
//        let rows: [MemberRow] = memberSections[section].items
//        for (i, _) in rows.enumerated() {
//            let indexPath = IndexPath(row: i, section: section)
//            indexPaths.append(indexPath)
//        }
//
//        var isExpanded = memberSections[section].isExpanded
//        memberSections[section].isExpanded = !isExpanded
//
////        var isExpanded = getSectionExpanded(idx: section)
////        if (mySections[section].keyExist(key: "isExpanded")) {
////            mySections[section]["isExpanded"] = !isExpanded
////            //searchSections[section].isExpanded = !isExpanded
////        }
//
//        if isExpanded {
//            tableView.deleteRows(at: indexPaths, with: .fade)
//        } else {
//            tableView.insertRows(at: indexPaths, with: .fade)
//        }
//
//        isExpanded = !isExpanded
//        if mark != nil {
//            toggleMark(mark: mark!, isExpanded: isExpanded)
//        }
//    }
    
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
    
    override func didSelect<U>(item: U, at indexPath: IndexPath) {
        if let _item: MainMemberTable = item as? MainMemberTable {
            let mainMemberEnum: MainMemberEnum = MainMemberEnum.chineseGetEnum(text: _item.title)
            toMemberItem(mainMemberEnum)
        }
    }
}

extension MemberVC {
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//
//        return memberSections.count
//        //return mySections.count
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        var count: Int = 0
//        if (memberSections[section].isExpanded) {
//            count = memberSections[section].items.count
//        }
//
//        return count
//    }
//
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        let headerView = UIView()
//        headerView.backgroundColor = UIColor.gray
//        headerView.tag = section
//
//        let titleLabel = UILabel()
//        titleLabel.text = memberSections[section].title
//        titleLabel.textColor = UIColor(MY_WHITE)
//        titleLabel.sizeToFit()
//        titleLabel.frame = CGRect(x: 10, y: 0, width: 100, height: heightForSection)
//        headerView.addSubview(titleLabel)
//
//        return headerView
//    }
//
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 34
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        //print("show cell sections: \(indexPath.section), rows: \(indexPath.row)")
//        let cell: MenuCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuCell
//        //cell.delegate = self
//        //print(rows)
//
//        let row: MemberRow = memberSections[indexPath.section].items[indexPath.row]
//        //let row: [String: String] = getRowFromIndexPath(indexPath: indexPath)
//        cell.setRow(row: row)
//
//        if indexPath.section == 1 && indexPath.row == 0 {
//            cell.accessoryType = .none
//        }
//
//        return cell
//    }
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        //print("click cell sections: \(indexPath.section), rows: \(indexPath.row)")
//        let row: MemberRow = memberSections[indexPath.section].items[indexPath.row]
//        let segue: String = row.segue
//        if segue == TO_PROFILE {
//            toRegister()
//        } else if segue == TO_PASSWORD {
//            toPassword(type: "change_password")
//        } else if segue == TO_VALIDATE {
//            toValidate(type: row.validate_type)
//        } else if segue == TO_BLACKLIST {
//            performSegue(withIdentifier: segue, sender: nil)
//        } else if segue == TO_REFRESH {
//            refresh()
//        } else if segue == TO_SIGNUPLIST {
//            performSegue(withIdentifier: "toA", sender: nil)
//        } else if segue == TO_MEMBER_ORDER_LIST {
//            toMemberOrderList()
//        } else if segue == TO_MEMBER_CART_LIST {
//            toMemberCartList(source: "member")
//        } else if segue == TO_MEMBER_SIGNUPLIST {
//            let able_type: String = row.able_type
//            toMemberSignuplist(able_type: able_type)
//        } else if segue == TO_LIKE {
//            let able_type: String = row.able_type
//
//            if (able_type == "team") {
//                toTeam(member_like: true)
//            } else if (able_type == "course") {
//                toCourse(member_like: true, isShowPrev: true)
//            } else if (able_type == "product") {
//                toProduct(member_like: true)
//            } else if (able_type == "coach") {
//                toCoach(member_like: true)
//            } else if (able_type == "arena") {
//                toArena(member_like: true, isShowPrev: true)
//            } else if (able_type == "store") {
//                toStore(member_like: true)
//            } else {
//                warning("沒有這個喜歡的連結")
//            }
//        } else if segue == "toManagerCourse" {
//            toManagerCourse(manager_token: Member.instance.token)
//        } else if segue == "toManagerTeam" {
//            toManagerTeam(manager_token: Member.instance.token)
//        } else if segue == "toRequestManagerTeam" {
//            toRequestManagerTeam()
//        } else if segue == TO_MEMBER_BANK {
//            toMemberBank()
//        } else if segue == "delete" {
//            delete()
//        } else if segue == TO_MEMBER_COIN_LIST {
//            toMemberCoinList()
//        } else if segue == TO_MEMBER_SUPSCRIPTION_KIND {
//            toMemberSubscriptionKind()
//        } else if segue == "qrcode" {
//            let qrcodeIV: UIImageView = makeQrcodeLayer()
//            let qrcode: UIImage = generateQRCode(from: Member.instance.token)!
//            qrcodeIV.image = qrcode
//        } else if segue == "toMemberTeamList" {
//            toMemberTeamList()
//        }
//    }
    
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

class MainMemberCell: BaseCell<MainMemberTable, MemberVC> {
    
    let containerView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor(BOTTOM_VIEW_BACKGROUND)
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        
        return view
    }()
    
    let iconIV: UIImageView = UIImageView()
    let titleLbl: SuperLabel = {
        let view: SuperLabel = SuperLabel()
        view.setTextGeneral()
        
        return view
    }()
    let greaterIV: UIImageView = {
        let view: UIImageView = UIImageView()
        view.image = UIImage(named: "greater_svg")
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    override func commonInit() {
        anchor()
    }
    
    func anchor() {
        //self.containerView.heightConstraint?.constant = 60
        self.contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(60)
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        containerView.addSubview(iconIV)
        iconIV.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        containerView.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.left.equalTo(iconIV.snp.right).offset(50)
            make.centerY.equalToSuperview()
        }
        
        containerView.addSubview(greaterIV)
        greaterIV.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
    }
    
    override func configureSubViews() {
        super.configureSubViews()
        if item != nil {
            iconIV.image = UIImage(named: item!.icon)
            titleLbl.text = item!.title
        }
    }
}

class MainMemberTable: Table {
    var icon: String = "nophoto"
    
    init(title: String, icon: String) {
        super.init()
        
        self.title = title
        self.icon = icon
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}

enum MainMemberEnum: String {
    case info = "會員資料"
    case order = "訂單查詢"
    case like = "喜歡"
    case join = "參加"
    case manager = "管理"
    case bank = "銀行帳號"
    case delete = "刪除帳號"
    
    static let allValues: [MainMemberEnum] = [info, order, like, join, manager, bank, delete]
    static func chineseGetEnum(text: String)-> MainMemberEnum {
        switch text {
        case "會員資料": return .info
        case "訂單查詢": return .order
        case "喜歡": return .like
        case "參加": return .join
        case "管理": return .manager
        case "銀行帳號": return .bank
        case "刪除帳號": return .delete
        default: return .info
        }
    }
    
    func getIcon()-> String {
        switch self {
        case .info: return "info_svg"
        case .order: return "truck_svg"
        case .like: return "like_in_svg"
        case .join: return "join_svg"
        case .manager: return "manager1_svg"
        case .bank: return "bank_account_svg"
        case .delete: return "account_delete_svg"
        }
    }
}

extension MemberVC: MainBottom2Delegate {
    func to(able_type: String) {
        switch able_type {
        case "team": toSearch()
        case "course": toCourse()
        case "member": toMember()
        case "arena": toArena()
        case "more": toMore()
        default:
            toTeam()
        }
    }
}

extension MemberVC: IconView2Delegate {
    func iconPressed(icon: String) {
        if icon == "qrcode_svg" {
            let qrcodeIV: UIImageView = makeQrcodeLayer()
            let qrcode: UIImage = generateQRCode(from: Member.instance.token)!
            qrcodeIV.image = qrcode
        } else if icon == "logout_svg" {
            logout()
        }
    }
}
