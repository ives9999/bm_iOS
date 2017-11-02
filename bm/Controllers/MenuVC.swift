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
    @IBOutlet weak var forgetPasswordBtn: UIButton!
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){}
    @IBOutlet weak var nicknameLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isLoggin { // login
            _loginBlock()
        } else {
            _logoutBolck()
        }
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        if isLoggin { // logout
            MemberService.instance.logout()
            _logoutBolck()
        } else {
            performSegue(withIdentifier: TO_LOGIN, sender: nil)
        }
    }
    
    @IBAction func registerBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_REGISTER, sender: nil)
    }
    
    private func _loginBlock() {
        //nicknameLbl.text = Global.instance.member.nickname
        loginBtn.setTitle("登出", for: .normal)
        registerBtn.isHidden = true
        forgetPasswordBtn.isHidden = true
    }
    private func _logoutBolck() {
        nicknameLbl.text = "未登入"
        loginBtn.setTitle("登入", for: .normal)
        registerBtn.isHidden = false
        forgetPasswordBtn.isHidden = false
    }
}
