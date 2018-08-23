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
    
    var myTeamLists: [SuperData] = [SuperData]()
    let _sections: [String] = ["帳戶"]
    let fixedRows: [[Dictionary<String, Any>]] = [
        [
            ["text": "帳戶資料", "icon": "account", "segue": TO_PROFILE],
            ["text": "更改密碼", "icon": "password", "segue": TO_PASSWORD]
        ]
    ]
    var _rows: [[Dictionary<String, Any>]] = [[Dictionary<String, Any>]]()
//    let _rows10: Dictionary<String, Any> = ["text": "球隊登錄(往右滑可以編輯)", "icon": "team"]
//    let _rows11: Dictionary<String, Any> = ["text": "新增球隊", "segue": TO_TEAM_SUBMIT]
    
    override func viewDidLoad() {
        myTablView = tableView
        super.viewDidLoad()
        
        var layoutMargins: UIEdgeInsets = tableView.layoutMargins
        layoutMargins.right = 80
        tableView.layoutMargins = layoutMargins
        tableView.register(MenuCell.self, forCellReuseIdentifier: "cell")

        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        
//        NotificationCenter.default.addObserver(self, selector: #selector(MenuVC.teamDidChange(_:)), name: NOTIF_TEAM_UPDATE, object: nil) move to TempPlayVC
        
//        refreshControl = UIRefreshControl()
//        refreshControl.attributedTitle = NSAttributedString(string: "更新資料")
//        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
//        view.addSubview(refreshControl)
//        NotificationCenter.default.post(name: NOTIF_MEMBER_DID_CHANGE, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
    
//    override func viewWillAppear(_ animated: Bool) {
//        if type == "refresh_team" {
//            refreshTeam()
//        }
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("show cell sections: \(indexPath.section), rows: \(indexPath.row)")
        let cell: MenuCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuCell
        cell.delegate = self
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
        let row: [String: Any] = rows![indexPath.section][indexPath.row]
        //print(row)
        if row["segue"] != nil {
            let segue = row["segue"] as! String
            //print("segue: \(segue)")
            if segue == TO_PROFILE {
                performSegue(withIdentifier: segue, sender: row["token"])
            } else if segue == TO_PASSWORD {
                performSegue(withIdentifier: segue, sender: "change_password")
            } else if segue == TO_VALIDATE {
                var sender: String = ""
                if row["type"] != nil {
                    sender = row["type"] as! String
                }
                performSegue(withIdentifier: segue, sender: sender)
            } else if segue == TO_BLACKLIST {
                performSegue(withIdentifier: segue, sender: nil)
            } else if segue == TO_REFRESH {
                refresh()
            }
        }
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if sender != nil {
            if segue.identifier == TO_PASSWORD {
                let vc: PasswordVC = segue.destination as! PasswordVC
                vc.type = (sender as! String)
            } else if segue.identifier == TO_VALIDATE {
                let vc: ValidateVC = segue.destination as! ValidateVC
                vc.type = sender as! String
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        /*
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
                let appearance = SCLAlertView.SCLAppearance(
                    showCloseButton: false
                )
                let alert = SCLAlertView(appearance: appearance)
                alert.addButton("確定", action: {
                    let row: [String: Any] = self.rows![indexPath.section][indexPath.row]
                    self._deleteTeam(token: row["token"] as! String)
                })
                alert.addButton("取消", action: {
                })
                alert.showWarning("警告", subTitle: "是否確定要刪除此球隊")
            }

            deleteAction.image = UIImage(named: "close")
            
            return [editAction, deleteAction]
        } else {
            return nil
        }
 */
        return nil
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        
        //var style = SwipeExpansionStyle(
        options.transitionStyle = .border
        //options.expansionStyle?.target.edgeInset = 20
        return options
    }
    
//    @objc func teamDidChange(_ notif: Notification) {
//        refreshTeam()
//    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        if Member.instance.isLoggedIn { // logout
            MemberService.instance.logout()
            Member.instance.isLoggedIn = false
            _loginout()
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
    private func _logoutBlock() {
        nicknameLbl.text = "未登入"
        loginBtn.setTitle("登入", for: .normal)
        registerBtn.isHidden = false
        registerIcon.isHidden = false
        forgetPasswordBtn.isHidden = false
        forgetPasswordIcon.isHidden = false
        tableView.isHidden = true
    }
//    private func _deleteTeam(token: String) {
//        Global.instance.addSpinner(superView: self.view)
//        DataService.instance.delete(token: token, type: "team") { (success) in
//            if success {
//                Global.instance.removeSpinner(superView: self.view)
//                if (!DataService.instance.success) {
//                    SCLAlertView().showError("錯誤", subTitle: "無法刪除球隊，請稍後再試")
//                }
//                NotificationCenter.default.post(name: NOTIF_TEAM_UPDATE, object: nil)
//            } else {
//                SCLAlertView().showError("錯誤", subTitle: "無法刪除球隊，請稍後再試")
//            }
//        }
//    }
//
//    private func refreshTeam() {
//        //print("aaa")
//        if Member.instance.isLoggedIn {
//            Global.instance.addSpinner(superView: self.view)
//            let filter: [[Any]] = [
//                ["channel", "=", CHANNEL],
//                ["manager_id", "=", Member.instance.id]
//            ]
//            DataService.instance.getList(type: "team", titleField: "name", page: 1, perPage: 100, filter: filter) { (success) in
//                if success {
//                    self.myTeamLists = DataService.instance.lists
//                    //print(self.myTeamLists)
//                    self._rows[1] = [Dictionary<String, Any>]()
//                    self._rows[1].append(self._rows10)
//                    self._rows[1].append(self._rows11)
//                    for team in self.myTeamLists {
//                        let row: [String: Any] = ["text": team.title, "id": team.id, "token": team.token, "segue": TO_TEAM_TEMP_PLAY,"detail":"臨打"]
//                        self._rows[1].append(row)
//                    }
//                    //print(self._rows)
//                    self.setData(sections: self._sections, rows: self._rows)// set to rows
//                    self.tableView.reloadData()
//                    Global.instance.removeSpinner(superView: self.view)
//                    self.refreshControl.endRefreshing()
//                }
//                self.type = ""
//
//            }
//        }
//    }
}
