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
    
    let _sections: [String] = ["會員資料", "訂單", "喜歡", "管理"]
    
    let heightForSection: CGFloat = 34
    var searchSections: [ExpandableItems] = [
        ExpandableItems(isExpanded: true, items: []),
        ExpandableItems(isExpanded: true, items: []),
        ExpandableItems(isExpanded: false, items: []),
        ExpandableItems(isExpanded: true, items: [])
    ]
    
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
    
    let signupRows: [Dictionary<String, String>] = [
        ["text": "課程報名", "icon": "account", "segue": TO_SIGNUP_LIST]
    ]
    
    var _rows: [[Dictionary<String, Any>]] = [[Dictionary<String, Any>]]()

    override func viewDidLoad() {
        myTablView = tableView
        super.viewDidLoad()

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
        _rows.removeAll()
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
        
        _rows.append(memberRows)
        _rows.append(orderRows)
        _rows.append(likeRows)
        _rows.append(courseRows)
        _rows.append(signupRows)
        //print(_rows)
        setData(sections: _sections, rows: _rows)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !searchSections[section].isExpanded {
            return 0
        }
        
        if (section == 0) {
            //searchSections[0].items = [String]()
            return memberRows.count
        } else if (section == 1) {
            return orderRows.count
        } else if (section == 2) {
            return likeRows.count
        } else if (section == 3) {
            return courseRows.count
        } else {
            return 0
        }
        //return searchSections[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.white
        headerView.tag = section
        
        let titleLabel = UILabel()
        titleLabel.text = sections?[section]
        titleLabel.textColor = UIColor.black
        titleLabel.sizeToFit()
        titleLabel.frame = CGRect(x: 10, y: 0, width: 100, height: heightForSection)
        headerView.addSubview(titleLabel)
        
        let mark = UIImageView(image: UIImage(named: "to_right"))
        mark.frame = CGRect(x: view.frame.width-10-20, y: (heightForSection-20)/2, width: 20, height: 20)
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
                
        let row: [String: Any] = rows![indexPath.section][indexPath.row]
        cell.setRow(row: row)
        
        if indexPath.section == 1 && indexPath.row == 0 {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("click cell sections: \(indexPath.section), rows: \(indexPath.row)")
        let row: [String: Any] = _rows[indexPath.section][indexPath.row]
        //print(row)
        if row["segue"] != nil {
            let segue = row["segue"] as! String
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
                    sender = row["type"] as! String
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
                    able_type = row["able_type"] as? String ?? "team"
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
    
    @objc func handleExpandClose(gesture : UITapGestureRecognizer) {
        let headerView = gesture.view!
        let section = headerView.tag
        let tmp = headerView.subviews.filter({$0 is UIImageView})
        var mark: UIImageView?
        if tmp.count > 0 {
            mark = tmp[0] as? UIImageView
        }
        
        var indexPaths: [IndexPath] = [IndexPath]()
        
        if (section == 0) {
            for i in 0...memberRows.count {
                let indexPath = IndexPath(row: i, section: section)
                indexPaths.append(indexPath)
            }
        } else if (section == 1) {
            for i in 0...orderRows.count {
                let indexPath = IndexPath(row: i, section: section)
                indexPaths.append(indexPath)
            }
        } else if (section == 2) {
            for i in 0...likeRows.count {
                let indexPath = IndexPath(row: i, section: section)
                indexPaths.append(indexPath)
            }
        } else if (section == 3) {
            for i in 0...courseRows.count {
                let indexPath = IndexPath(row: i, section: section)
                indexPaths.append(indexPath)
            }
        }
        
        
//        for idx in searchSections[section].items.indices {
//            let indexPath = IndexPath(row: idx, section: section)
//            indexPaths.append(indexPath)
//        }
        
        let isExpanded = searchSections[section].isExpanded
        searchSections[section].isExpanded = !isExpanded
        
        if isExpanded {
            tableView.deleteRows(at: indexPaths, with: .fade)
            if mark != nil {
                mark?.image = UIImage(named: "to_right")
            }
        } else {
            tableView.insertRows(at: indexPaths, with: .fade)
            if mark != nil {
                mark?.image = UIImage(named: "to_down")
            }
        }
    }
}

