//
//  LoginVC.swift
//  bm
//
//  Created by ives on 2017/10/26.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import SCLAlertView
import FacebookCore
import FacebookLogin

class LoginVC: BaseViewController, UITextFieldDelegate {

    // outlets
    @IBOutlet weak var emailTxt: EMailTextField!
    @IBOutlet weak var passwordTxt: SuperTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        emailTxt.delegate = self
        passwordTxt.delegate = self
        emailTxt.align(.left)
        emailTxt.borderWidth(0)
        emailTxt.backgroundColor = UIColor.clear
        passwordTxt.align(.left)
        passwordTxt.borderWidth(0)
        passwordTxt.backgroundColor = UIColor.clear

        //emailTxt.text = "ives@housetube.tw"
        //passwordTxt.text = "K5SD23r6"
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
        let playerID: String = _getPlayerID()
        Global.instance.addSpinner(superView: self.view)
        MemberService.instance.login(email: email, password: password, playerID: playerID) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if success {
                if MemberService.instance.success {
                    //print("login success")
                    //print(Global.instance.member.nickname)
                    self.performSegue(withIdentifier: UNWIND, sender: "refresh_team")
                } else {
                    //print("login failed by error email or password")
                    SCLAlertView().showError("錯誤", subTitle: MemberService.instance.msg)
                }
            } else {
                print("login failed by server")
            }
        }
    }
    @IBAction func loginFBBtnPressed(_ sender: Any) {
        Facebook.instance.login(viewController: self) {
            (success) in
            if success {
                self._loginFB()
            }
        }
    }
    
    @IBAction func registerBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_REGISTER, sender: nil)
    }
    @IBAction func passwordBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_PASSWORD, sender: "forget_password")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == TO_PASSWORD {
            let vc: PasswordVC = segue.destination as! PasswordVC
            vc.type = sender as! String
        } else if segue.identifier == UNWIND {
            let vc: MenuVC = segue.destination as! MenuVC
            vc.type = "refresh_team"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
}








