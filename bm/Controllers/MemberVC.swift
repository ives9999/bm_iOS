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
    
    let _sections: [String] = ["帳戶"]
    let fixedRows: [[Dictionary<String, Any>]] = [
        [
            ["text": "帳戶資料", "icon": "account", "segue": TO_PROFILE],
            ["text": "更改密碼", "icon": "password", "segue": TO_PASSWORD]
        ]
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
            self._loginout()
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func setValidateRow() {
        _rows.removeAll()
        _rows = fixedRows
        if Member.instance.isLoggedIn {// detected validate status
            let validate: Int = Member.instance.getData(key: VALIDATE_KEY) as! Int
            //print(validate)
            if validate & EMAIL_VALIDATE <= 0 {
                let new: Dictionary<String, Any> = ["text": "email認證", "icon": "email1", "segue": TO_VALIDATE, "type": "email"]
                _rows[0].append(new)
            }
            if validate & MOBILE_VALIDATE <= 0 {
                let new: Dictionary<String, Any> = ["text": "手機認證", "icon": "mobile_validate", "segue": TO_VALIDATE, "type": "mobile"]
                _rows[0].append(new)
            }
        }
        if Member.instance.isTeamManager {
            let new: Dictionary<String, Any> = ["text": "黑名單", "icon": "blacklist", "segue": TO_BLACKLIST]
            _rows[0].append(new)
        }
        let new: Dictionary<String, Any> = ["text": "重新整理", "icon": "refresh", "segue": TO_REFRESH]
        _rows[0].append(new)
        //print(_rows)
        setData(sections: _sections, rows: _rows)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
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
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        if Member.instance.isLoggedIn { // logout
            MemberService.instance.logout()
            Member.instance.isLoggedIn = false
            _loginout()
        } else {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "login") as? LoginVC {
                present(vc, animated: true, completion: nil)
            }
            //performSegue(withIdentifier: TO_LOGIN, sender: self)
        }
    }
    
    @IBAction func registerBtnPressed(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "register") as? RegisterVC {
            present(vc, animated: true, completion: nil)
        }
        //performSegue(withIdentifier: TO_REGISTER, sender: self)
    }
    
    @IBAction func passwordBtnPressed(_ sender: Any) {
        let type: String = "forget_password"
        if let vc = storyboard?.instantiateViewController(withIdentifier: "passwo") as? PasswordVC {
            vc.type = type
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
       }
    
}
