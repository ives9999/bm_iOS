//
//  RegisterVC.swift
//  bm
//
//  Created by ives on 2017/10/27.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class RegisterVC: BaseViewController, UITextFieldDelegate {

    // Outlets
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var rePasswordTxt: UITextField!
    
    var sourceVC: MemberVC? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
        emailTxt.delegate = self
        passwordTxt.delegate = self
        rePasswordTxt.delegate = self
        //emailTxt.align(.left)
        //emailTxt.borderWidth(0)
        //emailTxt.layer.borderColor = UIColor.clear.cgColor
        //emailTxt.backgroundColor = UIColor.clear
        //passwordTxt.align(.left)
        //passwordTxt.borderWidth(0)
        //passwordTxt.backgroundColor = UIColor.clear
        //rePasswordTxt.align(.left)
        //rePasswordTxt.borderWidth(0)
        //rePasswordTxt.backgroundColor = UIColor.clear
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
                            self.dismiss(animated: true, completion: {
                                if self.sourceVC != nil {
                                    self.sourceVC!._loginout()
                                }
                            })
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
                //print("login fb success")
                //self._loginFB()
                //Session.shared.loginReset = true
                let playerID: String = self._getPlayerID()
                Global.instance.addSpinner(superView: self.view)
                MemberService.instance.login_fb(playerID: playerID, completion: { (success1) in
                    Global.instance.removeSpinner(superView: self.view)
                    if success1 {
                        if MemberService.instance.success {
                            self.dismiss(animated: true, completion: {
                                if self.sourceVC != nil {
                                    self.sourceVC!._loginout()
                                }
                            })
                        } else {
                            //print("login failed by error email or password")
                            self.warning(MemberService.instance.msg)
                        }
                    } else {
                        self.warning("使用FB註冊，但無法新增至資料庫，請洽管理員")
                        //print("login failed by fb")
                    }
                })
            } else {
                print("login fb failure")
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
        dismiss(animated: true, completion: nil)
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
        } else if segue.identifier == TO_LOGIN {
            //let vc: LoginVC = segue.destination as! LoginVC
            //vc.menuVC = (sender as! MenuVC)
        } else if segue.identifier == TO_REGISTER {
            //let vc: RegisterVC = segue.destination as! RegisterVC
            //vc.menuVC = (sender as! MenuVC)
        }
    }
    
//    func backToMenu() {
//        if self.menuVC != nil {
//            self.menuVC!._loginout()
//        }
//        self.performSegue(withIdentifier: UNWIND, sender: "refresh_team")
//    }
}
