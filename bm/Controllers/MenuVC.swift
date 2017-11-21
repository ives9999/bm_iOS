//
//  MenuVC.swift
//  bm
//
//  Created by ives on 2017/10/25.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class MenuVC: UIViewController {

    // outlets
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var registerIcon: UIImageView!
    @IBOutlet weak var forgetPasswordIcon: UIImageView!
    @IBOutlet weak var forgetPasswordBtn: UIButton!
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){}
    @IBOutlet weak var nicknameLbl: UILabel!
    @IBOutlet weak var menuTableView: UIView!
    
    var myTeamLists: [List] = [List]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if Member.instance.isLoggedIn {
            let filter: [[Any]] = [
                ["channel", "=", CHANNEL],
                ["manager_id", "=", Member.instance.id]
            ]
            DataService.instance.getList(type: "team", titleField: "name", page: 1, perPage: 100, filter: filter) { (success) in
                if success {
                    self.myTeamLists = DataService.instance.lists
                    //print(self.myTeamLists)
                }
            }
        }
        
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        NotificationCenter.default.addObserver(self, selector: #selector(MenuVC.memberDidChange(_:)), name: NOTIF_MEMBER_DID_CHANGE, object: nil)
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
        menuTableView.isHidden = false
    }
    private func _logoutBlock() {
        nicknameLbl.text = "未登入"
        loginBtn.setTitle("登入", for: .normal)
        registerBtn.isHidden = false
        registerIcon.isHidden = false
        forgetPasswordBtn.isHidden = false
        forgetPasswordIcon.isHidden = false
        menuTableView.isHidden = true
    }
}
