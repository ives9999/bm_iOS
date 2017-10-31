//
//  RegisterVC.swift
//  bm
//
//  Created by ives on 2017/10/27.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import SCLAlertView

class RegisterVC: UIViewController, UITextFieldDelegate {

    // Outlets
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var rePasswordTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
        emailTxt.delegate = self
        passwordTxt.delegate = self
        rePasswordTxt.delegate = self
    }

    @IBAction func registerBtnPressed(_ sender: Any) {
        let email = emailTxt.text!
        let password = passwordTxt.text!
        let rePassword = rePasswordTxt.text!
        var bCheck: Bool = true
        
        if email.count == 0 {
            SCLAlertView().showWarning("警告", subTitle: "請填寫email")
            bCheck = false
        }
        if password.count == 0 {
            SCLAlertView().showWarning("警告", subTitle: "請填寫密碼")
            bCheck = false
        }
        if password != rePassword {
            SCLAlertView().showWarning("警告", subTitle: "密碼不符")
            bCheck = false
        }
        
        if bCheck {
            MemberService.instance.register(email: email, password: password, repassword: rePassword) { (success) in
                if success {
                    //print("register ok")
                    if MemberService.instance.success {
                        SCLAlertView().showInfo("成功", subTitle: "註冊成功，請儘速通過email認證，才能使用更多功能！！")
                    } else {
                        //print("login failed by error email or password")
                        SCLAlertView().showError("警告", subTitle: MemberService.instance.msg)
                    }
                }
            }
        }
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func colseBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_LOGIN, sender: nil)
    }
}
