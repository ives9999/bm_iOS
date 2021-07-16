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
    let fixedRows: [Dictionary<String, String>] = [
        ["text": "帳戶資料", "icon": "account", "segue": TO_PROFILE],
        ["text": "更改密碼", "icon": "password", "segue": TO_PASSWORD]
    ]
    var memberRows: [Dictionary<String, String>] = [Dictionary<String, String>]()
    
    var orderRows: [Dictionary<String, String>] = [
        ["text": "訂單查詢", "icon": "order", "segue": TO_MEMBER_ORDER_LIST]
    ]
    
    let likeRows: [Dictionary<String, String>] = [
        ["text": "球隊","icon":"team","segue":TO_LIKE,"able_type":"team"],
        ["text": "球館","icon":"arena","segue":TO_LIKE,"able_type":"arena"],
        ["text": "教練","icon":"coach","segue":TO_LIKE,"able_type":"coach"],
        ["text": "課程","icon":"course","segue":TO_LIKE,"able_type":"course"],
        ["text": "商品","icon":"product","segue":TO_LIKE,"able_type":"product"],
        ["text": "體育用品店","icon":"store","segue":TO_LIKE,"able_type":"store"]
    ]
    
    let courseRows: [Dictionary<String, String>] = [
        ["text": "課程","icon":"course","segue":"toManagerCourse","able_type":"course"]
    ]
    
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
        
        super.viewDidLoad()
        
        mySections = [
            ["name": "會員資料", "isExpanded": true, "key": "data"],
            ["name": "訂單", "isExpanded": true, "key": "order"],
            ["name": "喜歡", "isExpanded": false, "key": "like"],
            ["name": "管理", "isExpanded": true, "key": "manager"]
        ]
        
        myRows = [
            ["key":"data", "rows": memberRows],
            ["key":"order", "rows": orderRows],
            ["key":"like", "rows": likeRows],
            ["key":"manager", "rows": courseRows],
        ]

        tableView.register(MenuCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //refresh()
        _loginout()
    }
    
    override func refresh() {
        //print("refresh")
        refreshMember { (success) in
            if success {
                self._loginout()
                self.tableView.reloadData()
            }
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func setValidateRow() {
        //_rows.removeAll()
        memberRows.removeAll()
        memberRows = fixedRows
        if Member.instance.isLoggedIn {// detected validate status
            let validate: Int = Member.instance.getData(key: VALIDATE_KEY) as! Int
            //print(validate)
            if validate & EMAIL_VALIDATE <= 0 {
                let new: Dictionary<String, String> = ["text": "email認證", "icon": "email1", "segue": TO_VALIDATE, "type": "email"]
                memberRows.append(new)
            }
            if validate & MOBILE_VALIDATE <= 0 {
                let new: Dictionary<String, String> = ["text": "手機認證", "icon": "mobile_validate", "segue": TO_VALIDATE, "type": "mobile"]
                memberRows.append(new)
            }
        }
//        if Member.instance.isTeamManager {
//            let new: Dictionary<String, String> = ["text": "黑名單", "icon": "blacklist", "segue": TO_BLACKLIST]
//            memberRows.append(new)
//        }
        let new: Dictionary<String, String> = ["text": "重新整理", "icon": "refresh", "segue": TO_REFRESH]
        memberRows.append(new)
        myRows[0]["rows"] = memberRows
        
//        _rows.append(memberRows)
//        _rows.append(orderRows)
//        _rows.append(likeRows)
//        _rows.append(courseRows)
//        _rows.append(signupRows)
        //print(_rows)
        //setData(sections: _sections, rows: _rows)
    }
    
//    var mySections: [[String: Any]] = [
//        ["name": "會員資料", "isExpanded": true, "key": "data"],
//        ["name": "訂單", "isExpanded": true, "key": "order"],
//        ["name": "喜歡", "isExpanded": false, "key": "like"],
//        ["name": "管理", "isExpanded": true, "key": "manager"]
//    ]
    func getSectionName(idx: Int)-> String {
        
        var name: String = ""
        let row: [String: Any] = mySections[idx]
        if (row.keyExist(key: "name")) {
            if let tmp: String = row["name"] as? String {
                name = tmp
            }
        }
        
        return name
    }
    
    func getSectionKey(idx: Int)-> String {
        
        var key: String = ""
        let row: [String: Any] = mySections[idx]
        if (row.keyExist(key: "key")) {
            if let tmp: String = row["key"] as? String {
                key = tmp
            }
        }
        
        return key
    }
    
    func getSectionExpanded(idx: Int)-> Bool {
        
        var b: Bool = true
        let row: [String: Any] = mySections[idx]
        if (row.keyExist(key: "isExpanded")) {
            if let tmp: Bool = row["isExpanded"] as? Bool {
                b = tmp
            }
        }
        
        return b
    }
    
//    myRows = [
//        ["key":"data", "rows": fixedRows],
//        ["key":"order", "rows": orderRows],
//        ["key":"like", "rows": likeRows],
//        ["key":"manager", "rows": courseRows],
//    ]
    
    func getSectionRowFromMyRowsByKey(key: String)-> [String: Any] {
        
        for row in myRows {
            if let key1: String = row["key"] as? String {
                if key == key1 {
                    return row
                }
            }
        }
        
        return [String: Any]()
    }
    
    func getSectionRowFromMyRowsByIdx(idx: Int)-> [String: Any] {
        
        return myRows[idx]
    }
    
//    let fixedRows: [[String: String]] = [
//        ["text": "帳戶資料", "icon": "account", "segue": TO_PROFILE],
//        ["text": "更改密碼", "icon": "password", "segue": TO_PASSWORD]
//    ]
    func getRowRowsFromMyRowsBykey(key: String)-> [[String: String]] {
        
        let sectionRow: [String: Any] = getSectionRowFromMyRowsByKey(key: key)
        if (sectionRow.keyExist(key: "rows")) {
            if let tmp: [[String: String]] = sectionRow["rows"] as? [[String: String]] {
                return tmp
            }
        }
        
        return [[String: String]]()
    }
    
    //["text": "帳戶資料", "icon": "account", "segue": TO_PROFILE],
    func getRowFromIndexPath(indexPath: IndexPath)-> [String: String] {
        
        let section: Int = indexPath.section
        let key: String = getSectionKey(idx: section)
        let rows: [[String: String]] = getRowRowsFromMyRowsBykey(key: key)
        let row: [String: String] = rows[indexPath.row]
        
        return row
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return mySections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count: Int = 0
        let mySection: [String: Any] = mySections[section]
        if (mySection.keyExist(key: "isExpanded")) {
            let isExpanded: Bool = mySection["isExpanded"] as? Bool ?? true
            if (isExpanded) {
                if let key: String = mySection["key"] as? String {
                    let rows: [[String: String]] = getRowRowsFromMyRowsBykey(key: key)
                    count = rows.count
                }
            }
        }
        
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
        headerView.backgroundColor = UIColor.white
        headerView.tag = section
        
        let titleLabel = UILabel()
        titleLabel.text = getSectionName(idx: section)
        titleLabel.textColor = UIColor.black
        titleLabel.sizeToFit()
        titleLabel.frame = CGRect(x: 10, y: 0, width: 100, height: heightForSection)
        headerView.addSubview(titleLabel)
        
        let isExpanded = getSectionExpanded(idx: section)
        let mark = UIImageView(image: UIImage(named: "to_right"))
        mark.frame = CGRect(x: view.frame.width-10-20, y: (heightForSection-20)/2, width: 20, height: 20)
        toggleMark(mark: mark, isExpanded: isExpanded)
        headerView.addSubview(mark)
        
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleExpandClose))
        headerView.addGestureRecognizer(gesture)
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("show cell sections: \(indexPath.section), rows: \(indexPath.row)")
        let cell: MenuCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuCell
        //cell.delegate = self
        //print(rows)
                
        let row: [String: String] = getRowFromIndexPath(indexPath: indexPath)
        cell.setRow(row: row)
        
        if indexPath.section == 1 && indexPath.row == 0 {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("click cell sections: \(indexPath.section), rows: \(indexPath.row)")
        let row: [String: String] = getRowFromIndexPath(indexPath: indexPath)
        //print(row)
        if row.keyExist(key: "segue") && row["segue"] != nil {
            let segue: String = row["segue"]!
            //print("segue: \(segue)")
            if segue == TO_PROFILE {
                toRegister()
//                if #available(iOS 13.0, *) {
//                    let storyboard = UIStoryboard(name: "Member", bundle: nil)
//                    let viewController = storyboard.instantiateViewController(identifier: "UIViewController-vfe-V8-Hfx")
//                    show(viewController, sender: nil)
//                } else {
//                    let viewController = self.storyboard!.instantiateViewController(withIdentifier: "UIViewController-vfe-V8-Hfx") as! ProfileVC
//                    self.navigationController!.pushViewController(viewController, animated: true)
//                }
                //performSegue(withIdentifier: segue, sender: nil)
            } else if segue == TO_PASSWORD {
                if #available(iOS 13.0, *) {
                    let storyboard = UIStoryboard(name: "Member", bundle: nil)
                    if let viewController = storyboard.instantiateViewController(identifier: "passwo") as? PasswordVC {
                        viewController.type = "change_password"
                        viewController.delegate = self
                        show(viewController, sender: nil)
                    }
                } else {
                    let viewController =  self.storyboard!.instantiateViewController(withIdentifier: "passwo") as! PasswordVC
                    viewController.type = "change_password"
                    viewController.delegate = self
                    self.navigationController!.pushViewController(viewController, animated: true)
                }
                //performSegue(withIdentifier: segue, sender: "change_password")
            } else if segue == TO_VALIDATE {
                
                var sender: String = ""
                if row["type"] != nil {
                    sender = row["type"]!
                }
                if #available(iOS 13.0, *) {
                    let storyboard = UIStoryboard(name: "Member", bundle: nil)
                    if let viewController = storyboard.instantiateViewController(identifier: "UIViewController-XsO-Wn-cpI") as? ValidateVC {
                        viewController.type = sender
                        viewController.delegate = self
                        show(viewController, sender: nil)
                    }
                } else {
                    let viewController =  self.storyboard!.instantiateViewController(withIdentifier: "UIViewController-XsO-Wn-cpI") as! ValidateVC
                    viewController.type = sender
                    viewController.delegate = self
                    self.navigationController!.pushViewController(viewController, animated: true)
                }
                
                
                //performSegue(withIdentifier: segue, sender: sender)
            } else if segue == TO_BLACKLIST {
                performSegue(withIdentifier: segue, sender: nil)
            } else if segue == TO_REFRESH {
                refresh()
            } else if segue == TO_SIGNUP_LIST {
             
                 //if let vc = storyboard?.instantiateViewController(withIdentifier: "toS") as? CourseCalendarVC {
                     //present(vc, animated: true, completion: nil)
                 //}
                performSegue(withIdentifier: "toA", sender: nil)
            } else if segue == TO_MEMBER_ORDER_LIST {
                toMemberOrderList()
            } else if segue == TO_LIKE {
                var able_type: String = "team"
                if (row.keyExist(key: "able_type") && row["able_type"] != nil) {
                    able_type = row["able_type"]!
                }
                //toMemberLikeList(able_type)
                if (able_type == "team") {
                    toTeam(member_like: true)
                } else if (able_type == "course") {
                    toCourse(member_like: true)
                } else if (able_type == "product") {
                    toProduct(member_like: true)
                } else if (able_type == "coach") {
                    toCoach(member_like: true)
                } else if (able_type == "arena") {
                    toArena(member_like: true)
                } else if (able_type == "store") {
                    toStore(member_like: true)
                } else {
                    warning("沒有這個喜歡的連結")
                }
            } else if segue == "toManagerCourse" {
                toManagerCourse(manager_token: Member.instance.token)
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
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        if Member.instance.isLoggedIn { // logout
            MemberService.instance.logout()
            Member.instance.isLoggedIn = false
            _loginout()
        } else {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "login") as? LoginVC {
                vc.sourceVC = self
                present(vc, animated: true, completion: nil)
            }
            //performSegue(withIdentifier: TO_LOGIN, sender: self)
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
        let type: String = "forget_password"
        if let vc = storyboard?.instantiateViewController(withIdentifier: "passwo") as? PasswordVC {
            vc.type = type
            vc.delegate = self
            present(vc, animated: true, completion: nil)
        }
        //performSegue(withIdentifier: TO_PASSWORD, sender: type)
    }
    
    public func _loginout() {
           //print(Member.instance.isLoggedIn)
           if Member.instance.isLoggedIn   { // login
               _loginBlock()
           } else {
               _logoutBlock()
           }
       }
       
    public func _loginBlock() {
        self.setValidateRow()
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
}

