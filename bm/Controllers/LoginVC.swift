//
//  LoginVC.swift
//  bm
//
//  Created by ives on 2017/10/26.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import SCLAlertView

class LoginVC: UIViewController, UITextFieldDelegate {

    // outlets
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        emailTxt.delegate = self
        passwordTxt.delegate = self

        // Do any additional setup after loading the view.
    }

    @IBAction func prevBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func closeBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        let email = emailTxt.text!
        let password = passwordTxt.text!
        //print(email)
        if email.count == 0 {
            SCLAlertView().showWarning("警告", subTitle: "請填寫email")
        }
        if password.count == 0 {
            SCLAlertView().showWarning("警告", subTitle: "請填寫密碼")
        }
        MemberService.instance.login(email: email, password: password) { (success) in
            if success {
                if MemberService.instance.success {
                    print("login success")
                } else {
                    print("login failed by error email or password")
                }
            } else {
                print("login failed by server")
            }
        }
    }
    
    @IBAction func registerBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_REGISTER, sender: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}







