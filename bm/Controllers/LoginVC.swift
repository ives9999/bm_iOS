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
import OneSignal

class LoginVC: UIViewController, UITextFieldDelegate {

    // outlets
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        emailTxt.delegate = self
        passwordTxt.delegate = self

        emailTxt.text = "ives@housetube.tw"
        passwordTxt.text = "K5SD23r6"
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
        let playerID: String = getPlayerID()
        Global.instance.addSpinner(superView: self.view)
        MemberService.instance.login(email: email, password: password, playerID: playerID) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if success {
                if MemberService.instance.success {
                    //print("login success")
                    //print(Global.instance.member.nickname)
                    self.performSegue(withIdentifier: UNWIND, sender: nil)
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
                //print(Facebook.instance.uid)
                //print(Facebook.instance.email)
                let playerID: String = self.getPlayerID()
                Global.instance.addSpinner(superView: self.view)
                MemberService.instance.login_fb(playerID: playerID, completion: { (success1) in
                    Global.instance.removeSpinner(superView: self.view)
                    if success1 {
                        if MemberService.instance.success {
                            self.performSegue(withIdentifier: UNWIND, sender: nil)
                        } else {
                            //print("login failed by error email or password")
                            SCLAlertView().showError("錯誤", subTitle: MemberService.instance.msg)
                        }
                    } else {
                        print("login failed by fb")
                    }
                })
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
    
    func getPlayerID() -> String {
        let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
        let playerID: String = status.subscriptionStatus.userId
        //print(playerID)
        //if userID != nil {
        //let user = PFUser.cu
        //}
        return playerID
    }
}








