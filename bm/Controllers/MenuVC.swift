//
//  MenuVC.swift
//  bm
//
//  Created by ives on 2017/10/25.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import SwipeCellKit
import UIColor_Hex_Swift

class MenuVC: MyTableVC, SwipeTableViewCellDelegate {

    // outlets
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var registerIcon: UIImageView!
    @IBOutlet weak var forgetPasswordIcon: UIImageView!
    @IBOutlet weak var forgetPasswordBtn: UIButton!
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){}
    @IBOutlet weak var nicknameLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var myTeamLists: [List] = [List]()
    let _sections: [String] = ["帳戶", "登錄"]
    var _rows: [[Dictionary<String, Any>]] = [
        [
            ["text": "帳戶資料", "icon": "account", "segue": TO_PROFILE],
            ["text": "更改密碼", "icon": "password", "segue": TO_PASSWORD],
            ["text": "手機認證", "icon": "mobile_validate"],
        ],
        [
            ["text": "球隊登錄(往右滑可以編輯)", "icon": "team"],
            ["text": "新增球隊", "segue": TO_TEAM_SUBMIT]
            
        ]
    ]
    
    override func viewDidLoad() {
        myTablView = tableView
        setData(sections: _sections, rows: _rows)
        super.viewDidLoad()
        
        var layoutMargins: UIEdgeInsets = tableView.layoutMargins
        layoutMargins.right = 80
        tableView.layoutMargins = layoutMargins
        tableView.register(MenuCell.self, forCellReuseIdentifier: "cell")

        
        if Member.instance.isLoggedIn {
            Global.instance.addSpinner(superView: self.view)
            let filter: [[Any]] = [
                ["channel", "=", CHANNEL],
                ["manager_id", "=", Member.instance.id]
            ]
            DataService.instance.getList(type: "team", titleField: "name", page: 1, perPage: 100, filter: filter) { (success) in
                if success {
                    self.myTeamLists = DataService.instance.lists
                    //print(self.myTeamLists)
                    for team in self.myTeamLists {
                        let row: [String: Any] = ["text": team.title, "id": team.id, "token": team.token, "segue": TO_TEAM_TEMP_PLAY,"detail":"臨打"]
                        self._rows[1].append(row)
                    }
                    //print(self._rows)
                    self.setData(sections: self._sections, rows: self._rows)
                    self.tableView.reloadData()
                    Global.instance.removeSpinner(superView: self.view)
                }
            }
        }
        
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        NotificationCenter.default.addObserver(self, selector: #selector(MenuVC.memberDidChange(_:)), name: NOTIF_MEMBER_DID_CHANGE, object: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("show cell sections: \(indexPath.section), rows: \(indexPath.row)")
        let cell: MenuCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuCell
        cell.delegate = self
                
        let row: [String: Any] = rows![indexPath.section][indexPath.row]
        cell.setRow(row: row)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("click cell sections: \(indexPath.section), rows: \(indexPath.row)")
        let row: [String: Any] = rows![indexPath.section][indexPath.row]
        if row["segue"] != nil {
            let segue = row["segue"] as! String
            //print("segue: \(segue)")
            if segue == TO_PROFILE {
                performSegue(withIdentifier: segue, sender: row["token"])
            } else if segue == TO_PASSWORD {
                performSegue(withIdentifier: segue, sender: "change_password")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if sender != nil {
            if segue.identifier == TO_TEAM_SUBMIT {
                let vc: TeamSubmitVC = segue.destination as! TeamSubmitVC
                vc.token = sender as! String
            } else if segue.identifier == TO_TEAM_TEMP_PLAY {
                let vc: TeamTempPlayEditVC = segue.destination as! TeamTempPlayEditVC
                vc.token = (sender as! String)
            } else if segue.identifier == TO_PASSWORD {
                let vc: PasswordVC = segue.destination as! PasswordVC
                vc.type = (sender as! String)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if indexPath.section == 1 && indexPath.row > 1 {
            guard orientation == .left else { return nil}
            
            let editAction = SwipeAction(style: .default, title: "編輯") { action, indexPath in
                let segue: String = TO_TEAM_SUBMIT
                let row: [String: Any] = self.rows![indexPath.section][indexPath.row]
                if row["segue"] != nil {
                    self.performSegue(withIdentifier: segue, sender: row["token"])
                }
            }
            editAction.backgroundColor = UIColor(MY_GREEN)
            editAction.textColor = UIColor.black

            editAction.image = UIImage(named: "edit")
            
            let deleteAction = SwipeAction(style: .destructive, title: "刪除") { action, indexPath in
                print("delete")
            }

            deleteAction.image = UIImage(named: "close")
            
            return [editAction, deleteAction]
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        
        //var style = SwipeExpansionStyle(
        options.transitionStyle = .border
        //options.expansionStyle?.target.edgeInset = 20
        return options
    }

    
    override func viewDidAppear(_ animated: Bool) {
        _loginout()
    }
    
    @objc func memberDidChange(_ notif: Notification) {
        //print("notify")
        _loginout()
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        if Member.instance.isLoggedIn { // logout
            MemberService.instance.logout()
        } else {
            performSegue(withIdentifier: TO_LOGIN, sender: nil)
        }
    }
    
    @IBAction func registerBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_REGISTER, sender: nil)
    }
    
    @IBAction func passwordBtnPressed(_ sender: Any) {
        let type: String = "forget_password"
        performSegue(withIdentifier: TO_PASSWORD, sender: type)
    }
    
    private func _loginout() {
        //print(Member.instance.isLoggedIn)
        if Member.instance.isLoggedIn   { // login
            _loginBlock()
        } else {
            _logoutBlock()
        }
    }
    
    private func _loginBlock() {
        nicknameLbl.text = Member.instance.nickname
        loginBtn.setTitle("登出", for: .normal)
        registerBtn.isHidden = true
        registerIcon.isHidden = true
        forgetPasswordBtn.isHidden = true
        forgetPasswordIcon.isHidden = true
        tableView.isHidden = false
    }
    private func _logoutBlock() {
        nicknameLbl.text = "未登入"
        loginBtn.setTitle("登入", for: .normal)
        registerBtn.isHidden = false
        registerIcon.isHidden = false
        forgetPasswordBtn.isHidden = false
        forgetPasswordIcon.isHidden = false
        tableView.isHidden = true
    }
}
