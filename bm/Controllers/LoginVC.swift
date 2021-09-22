//
//  LoginVC.swift
//  bm
//
//  Created by ives on 2017/10/26.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import SCLAlertView
//import FBSDKLoginKit

class LoginVC: BaseViewController, UITextFieldDelegate {
//    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
//
//        if result!.isCancelled {
//
//        } else {
//            if result!.grantedPermissions.contains("email") {
//
//            }
//        }
//        fetchProfile()
//    }
//
//    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
//
//    }
//
//    func loginButtonWillLogin(_ loginButton: FBLoginButton) -> Bool {
//        return true
//    }
    
    var memberVC: MemberVC? = nil

    // outlets
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    //@IBOutlet weak var facebookLogin: FBLoginButton!
    
    var table: MemberTable?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        emailTxt.delegate = self
        passwordTxt.delegate = self
        //emailTxt.align(.left)
        //emailTxt.borderWidth(0)
        //emailTxt.backgroundColor = UIColor.clear
        //passwordTxt.align(.left)
        //passwordTxt.borderWidth(0)
        //passwordTxt.backgroundColor = UIColor.clear

        emailTxt.text = "ives@housetube.tw"
        passwordTxt.text = "K5SD23r6"
    }

    @IBAction func prevBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
                
                let jsonData: Data = MemberService.instance.jsonData!
                do {
                    self.table = try JSONDecoder().decode(MemberTable.self, from: jsonData)
                    if (self.table != nil) {                        
                        //self.table?.printRow()
                        self.table!.toSession(isLoggedIn: true)
                    }
                } catch {
                    self.warning(error.localizedDescription)
                }
                
                if MemberService.instance.msg.count > 0 {
                    let appearance = SCLAlertView.SCLAppearance(
                        showCloseButton: false
                    )
                    let alert = SCLAlertView(appearance: appearance)
                    alert.addButton("確定", action: {
                        self.performSegue(withIdentifier: UNWIND, sender: nil)
                    })
                    alert.showWarning("警告", subTitle: MemberService.instance.msg)
                }
                self.dismiss(animated: true, completion: {
                    if self.memberVC != nil {
                        self.memberVC!.loginout()
                    }
                })
            } else {
                //print("login failed by server")
                let appearance = SCLAlertView.SCLAppearance(
                    showCloseButton: false
                )
                let alert = SCLAlertView(appearance: appearance)
                alert.addButton("確定", action: {
                    self.performSegue(withIdentifier: UNWIND, sender: nil)
                })
                alert.showWarning("警告", subTitle: MemberService.instance.msg)
            }
        }
    }
    
//    @IBAction func loginFBBtnPressed(_ sender: Any) {
//
//        Facebook.instance.login(viewController: self) {
//            (success) in
//            if success {
//                //print("login fb success")
//                //self._loginFB()
//                //Session.shared.loginReset = true
//                let playerID: String = self._getPlayerID()
//                Global.instance.addSpinner(superView: self.view)
//                MemberService.instance.login_fb(playerID: playerID, completion: { (success1) in
//                    Global.instance.removeSpinner(superView: self.view)
//                    if success1 {
//                        if MemberService.instance.success {
//                            self.dismiss(animated: true, completion: {
//                                if self.sourceVC != nil {
//                                    self.sourceVC!._loginout()
//                                }
//                            })
//                        } else {
//                            //print("login failed by error email or password")
//                            self.warning(MemberService.instance.msg)
//                        }
//                    } else {
//                        self.warning("使用FB登入，但無法新增至資料庫，請洽管理員")
//                        //print("login failed by fb")
//                    }
//                })
//            } else {
//                print("login fb failure")
//            }
//        }
//    }
    
    @IBAction func registerBtnPressed(_ sender: Any) {
        toRegister()
    }
    @IBAction func passwordBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_PASSWORD, sender: "forget_password")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == TO_PASSWORD {
            let vc: PasswordVC = segue.destination as! PasswordVC
            vc.type = sender as? String
        } else if segue.identifier == UNWIND {
            //let vc: MenuVC = segue.destination as! MenuVC
        } else if segue.identifier == TO_LOGIN {
            //let vc: LoginVC = segue.destination as! LoginVC
            //vc.menuVC = (sender as! MenuVC)
        } else if segue.identifier == TO_REGISTER {
            //let vc: RegisterVC = segue.destination as! RegisterVC
            //vc.menuVC = (sender as! MenuVC)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
//    func backToMenu() {
//        if self.menuVC != nil {
//            self.menuVC!._loginout()
//        }
//        self.performSegue(withIdentifier: UNWIND, sender: "refresh_team")
//    }
}








