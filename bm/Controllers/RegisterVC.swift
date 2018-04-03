//
//  RegisterVC.swift
//  bm
//
//  Created by ives on 2017/10/27.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import SCLAlertView

class RegisterVC: BaseViewController, UITextFieldDelegate {

    // Outlets
    @IBOutlet weak var emailTxt: EMailTextField!
    @IBOutlet weak var passwordTxt: SuperTextField!
    @IBOutlet weak var rePasswordTxt: SuperTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
        emailTxt.delegate = self
        passwordTxt.delegate = self
        rePasswordTxt.delegate = self
        emailTxt.align(.left)
        emailTxt.borderWidth(0)
        emailTxt.backgroundColor = UIColor.clear
        passwordTxt.align(.left)
        passwordTxt.borderWidth(0)
        passwordTxt.backgroundColor = UIColor.clear
        rePasswordTxt.align(.left)
        rePasswordTxt.borderWidth(0)
        rePasswordTxt.backgroundColor = UIColor.clear
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
            Global.instance.addSpinner(superView: self.view)
            MemberService.instance.register(email: email, password: password, repassword: rePassword) { (success) in
                Global.instance.removeSpinner(superView: self.view)
                if success {
                    //print("register ok: \(MemberService.instance.success)")
                    if MemberService.instance.success {
                        let appearance = SCLAlertView.SCLAppearance(
                            showCloseButton: false
                        )
                        let alert = SCLAlertView(appearance: appearance)
                        alert.addButton("確定", action: {
                            self.performSegue(withIdentifier: UNWIND, sender: nil)
                        })
                        alert.showSuccess("成功", subTitle: "註冊成功，請儘速通過email認證，才能使用更多功能！！")
                    } else {
                        //print("login failed by error email or password")
                        SCLAlertView().showError("警告", subTitle: MemberService.instance.msg)
                    }
                }
            }
        }
    }
    @IBAction func registerFBBtnPressed(_ sender: Any) {
        Facebook.instance.login(viewController: self) {
            (success) in
            if success {
                //print(Facebook.instance.uid)
                //print(Facebook.instance.email)
                self._loginFB()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
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
    
    @IBAction func passwordBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_PASSWORD, sender: "forget_password")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == TO_PASSWORD {
            let vc: PasswordVC = segue.destination as! PasswordVC
            vc.type = sender as! String
        }
    }
}
