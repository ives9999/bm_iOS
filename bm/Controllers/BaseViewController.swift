//
//  BaseViewController.swift
//  bm
//
//  Created by ives on 2018/4/3.
//  Copyright © 2018年 bm. All rights reserved.
//

import UIKit
import OneSignal
import Reachability

class BaseViewController: UIViewController {
    
    var msg: String = ""
    var teamManagerLists: [SuperData] = [SuperData]()
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let reachability = Reachability()!
        
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                //print("WiFi")
            } else {
                //print("Cellular")
            }
        }
        reachability.whenUnreachable = { _ in
            self.warning(msg: "沒有連接網路，所以無法使用此app", buttonTitle: "確定", buttonAction: {
                exit(0)
            })
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            warning("無法開啟測試連結網路警告視窗，請稍後再使用!!")
        }
    }
    
    func prev() {
        dismiss(animated: true, completion: nil)
    }
    func beginRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "更新資料")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
    }
    func endRefresh() {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
    
    @objc func memberDidChange(_ notif: Notification) {
        //print("notify")
        refreshMember { (success) in
            
        }
    }
    func _getMemberOne(token: String, completion: @escaping CompletionHandler) {
        MemberService.instance.getOne(token: token, completion: completion)
    }
    func refreshMember(completion: @escaping CompletionHandler) {
        Global.instance.addSpinner(superView: self.view)
        MemberService.instance.getOne(token: Member.instance.token) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if (success) {
                completion(true)
            } else {
                SCLAlertView().showError("錯誤", subTitle: MemberService.instance.msg)
                completion(false)
            }
        }
    }
    func _updatePlayerIDWhenIsNull() {
        let token = Member.instance.token
        //print(token)
        MemberService.instance.getOne(token: token) { (success) in
            if (success) {
                Member.instance.justGetMemberOne = true
                //print(Member.instance.type)
                if Member.instance.player_id.count == 0 {
                    self._updatePlayerID()
                }
            }
        }
    }
    func _updatePlayerID() {
        var player_id = _getPlayerID()
        //print(player_id)
        MemberService.instance.update(id: Member.instance.id, field: PLAYERID_KEY, value: &player_id, completion: { (success) in
            if success {
                Member.instance.player_id = player_id
            }
        })
    }
    func _getPlayerID() -> String {
        let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
        var playerID: String = ""
        if let temp: String = status.subscriptionStatus.userId {
            playerID = temp
        }
        //print(playerID)
        //if userID != nil {
        //let user = PFUser.cu
        //}
        return playerID
    }
    
    func _loginFB() {
        //print(Facebook.instance.uid)
        //print(Facebook.instance.email)
        let playerID: String = self._getPlayerID()
        Global.instance.addSpinner(superView: self.view)
        MemberService.instance.login_fb(playerID: playerID, completion: { (success1) in
            Global.instance.removeSpinner(superView: self.view)
            if success1 {
                if MemberService.instance.success {
                    self.performSegue(withIdentifier: UNWIND, sender: "refresh_team")
                } else {
                    //print("login failed by error email or password")
                    self.warning(MemberService.instance.msg)
                }
            } else {
                self.warning("使用FB登入，但無法新增至資料庫，請洽管理員")
                //print("login failed by fb")
            }
        })
    }
    
    func _getTeamManagerList(completion: @escaping CompletionHandler) {
        Global.instance.addSpinner(superView: self.view)
        let filter: [[Any]] = [
            ["channel", "=", CHANNEL],
            ["manager_id", "=", Member.instance.id]
        ]
        let params: Dictionary<String, Any> = [String: Any]()
        TeamService.instance.getList(type: "team", titleField: "name", params:params, page: 1, perPage: 100, filter: filter) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if success {
                self.teamManagerLists = TeamService.instance.dataLists
                //print(self.myTeamLists)
                //                    for team in self.myTeamLists {
                //                        let row: [String: Any] = ["text": team.title, "id": team.id, "token": team.token, "segue": TO_TEAM_TEMP_PLAY,"detail":"臨打"]
                //                        self._rows[1].append(row)
                //                    }
                //print(self.myTeamLists)
                
                completion(true)
            } else {
                self.msg = TeamService.instance.msg
                completion(false)
            }
        }
    }
    
    func addBlackList(memberName: String, memberToken: String, teamToken: String) {
        warning(msg:"是否真的要將球友"+memberName+"設為黑名單\n之後可以解除", closeButtonTitle: "取消", buttonTitle: "確定", buttonAction: {
            self.reasonBox(memberToken: memberToken, teamToken: teamToken)
        })
    }
    func reasonBox(memberToken: String, teamToken: String) {
        let alert = SCLAlertView()
        let txt = alert.addTextField()
        alert.addButton("加入", action: {
            self._addBlackList(txt.text!, memberToken: memberToken, teamToken: teamToken)
        })
        alert.showEdit("請輸入理由")
    }
    func _addBlackList(_ reason: String, memberToken: String, teamToken: String) {
        Global.instance.addSpinner(superView: self.view)
        TeamService.instance.addBlackList(teamToken: teamToken, playerToken: memberToken,managerToken:Member.instance.token, reason: reason) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if (success) {
                self.info("加入黑名單成功")
            } else {
                self.warning(TeamService.instance.msg)
            }
        }
    }
    
    @objc func refresh() {}
    
    func alertError(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "確定", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func __alert(showCloseButton: Bool=false, buttonTitle: String, buttonAction: @escaping ()->Void) -> SCLAlertView {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: showCloseButton
        )
        let alert = SCLAlertView(appearance: appearance)
        alert.addButton(buttonTitle, action: buttonAction)
        return alert
    }
    func _warning(title: String, msg: String, showCloseButton: Bool=false, buttonTitle: String, buttonAction: @escaping ()->Void) {
        let alert = __alert(showCloseButton: showCloseButton, buttonTitle: buttonTitle, buttonAction: buttonAction)
        alert.showWarning(title, subTitle: msg)
    }
    func _warning(title: String, msg: String, closeButtonTitle: String, buttonTitle: String, buttonAction: @escaping ()->Void) {
        let alert = __alert(showCloseButton: true, buttonTitle: buttonTitle, buttonAction: buttonAction)
        alert.showWarning(title, subTitle: msg, closeButtonTitle: closeButtonTitle)
    }
    
    func warning(_ msg: String) {
        alertError(title: "警告", msg: msg)
    }
    func warning(msg: String, showCloseButton: Bool=false, buttonTitle: String, buttonAction: @escaping ()->Void) {
        _warning(title: "警告", msg: msg, showCloseButton: showCloseButton, buttonTitle: buttonTitle, buttonAction: buttonAction)
    }
    func warning(msg: String, closeButtonTitle: String, buttonTitle: String, buttonAction: @escaping ()->Void) {
        _warning(title: "警告", msg: msg, closeButtonTitle: closeButtonTitle, buttonTitle: buttonTitle, buttonAction: buttonAction)
    }
    
    func _info(title: String, msg: String, showCloseButton: Bool=false, buttonTitle: String, buttonAction: @escaping ()->Void) {
        let alert = __alert(showCloseButton: showCloseButton, buttonTitle: buttonTitle, buttonAction: buttonAction)
        alert.showInfo(title, subTitle: msg)
    }
    func _info(title: String, msg: String, closeButtonTitle: String, buttonTitle: String, buttonAction: @escaping ()->Void) {
        let alert = __alert(showCloseButton: true, buttonTitle: buttonTitle, buttonAction: buttonAction)
        alert.showInfo(title, subTitle: msg, closeButtonTitle: closeButtonTitle)
    }
    func info(msg: String, showCloseButton: Bool=false, buttonTitle: String, buttonAction: @escaping ()->Void) {
        _info(title: "訊息", msg: msg, showCloseButton: showCloseButton, buttonTitle: buttonTitle, buttonAction: buttonAction)
    }
    func info(msg: String, closeButtonTitle: String, buttonTitle: String, buttonAction: @escaping ()->Void) {
        _info(title: "訊息", msg: msg, closeButtonTitle: closeButtonTitle, buttonTitle: buttonTitle, buttonAction: buttonAction)
    }
    func info(_ msg: String) {
        alertError(title: "訊息", msg: msg)
    }
}
