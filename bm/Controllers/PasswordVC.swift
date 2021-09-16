//
//  PasswordVC.swift
//  bm
//
//  Created by ives on 2017/12/20.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import SCLAlertView

class PasswordVC: UIViewController {
    
    var type: String?// forget_password, change_password
    var emailLbl: SuperLabel!
    var emailTxt: IconTextField!
    var submitBtn: SubmitButton!
    var oldPwdLbl: SuperLabel!
    var oldPwdTxt: IconTextField!
    var newPwdLbl: SuperLabel!
    var newPwdTxt: IconTextField!
    var rePwdLbl: SuperLabel!
    var rePwdTxt: IconTextField!

    @IBOutlet weak var bkView: UIImageView!
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    var delegate: MemberVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailLbl = SuperLabel()
        emailLbl.text = "請輸入註冊時的email"
        emailTxt = IconTextField()
        emailTxt.set(icon: "email1")
        emailTxt.keyboardType = UIKeyboardType.emailAddress
        
        oldPwdLbl = SuperLabel()
        oldPwdLbl.text = "舊密碼"
        oldPwdTxt = IconTextField()
        oldPwdTxt.set(icon: "password")
        oldPwdTxt.isSecureTextEntry = true
        
        newPwdLbl = SuperLabel()
        newPwdLbl.text = "新密碼"
        newPwdTxt = IconTextField()
        newPwdTxt.set(icon: "password")
        newPwdTxt.isSecureTextEntry = true
        
        rePwdLbl = SuperLabel()
        rePwdLbl.text = "確認密碼"
        rePwdTxt = IconTextField()
        rePwdTxt.set(icon: "password")
        rePwdTxt.isSecureTextEntry = true
        
        
        submitBtn = SubmitButton()
        submitBtn.addTarget(self, action: #selector(submit(_:)), for: UIControl.Event.touchUpInside)
        
        view.addSubview(emailLbl)
        view.addSubview(emailTxt)
        view.addSubview(oldPwdLbl)
        view.addSubview(oldPwdTxt)
        view.addSubview(newPwdLbl)
        view.addSubview(newPwdTxt)
        view.addSubview(rePwdLbl)
        view.addSubview(rePwdTxt)
        view.addSubview(submitBtn)
        
        if type == "forget_password" {
            emailLbl.isHidden = false
            emailTxt.isHidden = false
            oldPwdLbl.isHidden = true
            oldPwdTxt.isHidden = true
            newPwdLbl.isHidden = true
            newPwdTxt.isHidden = true
            rePwdLbl.isHidden = true
            rePwdTxt.isHidden = true
        } else if type == "change_password" {
            emailLbl.isHidden = true
            emailTxt.isHidden = true
            oldPwdLbl.isHidden = false
            oldPwdTxt.isHidden = false
            newPwdLbl.isHidden = false
            newPwdTxt.isHidden = false
            rePwdLbl.isHidden = false
            rePwdTxt.isHidden = false
        }
        
        if type == "forget_password" {
            titleLbl.text = "忘記密碼"
        } else if type == "change_password" {
            titleLbl.text = "更改密碼"
        }
        Global.instance.addSpinner(superView: view)
        Global.instance.removeSpinner(superView: view)
        
        _layout()

        //print(type)
    }
    
    private func _layout() {
        var c1: NSLayoutConstraint,c2: NSLayoutConstraint,c3: NSLayoutConstraint,c4:NSLayoutConstraint
        
        c1 = NSLayoutConstraint(item: emailLbl, attribute: .centerX, relatedBy: .equal, toItem: emailLbl.superview, attribute: .centerX, multiplier: 1, constant: 0)
        c2 = NSLayoutConstraint(item: emailLbl, attribute: .top, relatedBy: .equal, toItem: logoView, attribute: .bottom, multiplier: 1, constant: 50)
        emailLbl.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([c1, c2])
        
        c1 = NSLayoutConstraint(item: emailTxt, attribute: .centerX, relatedBy: .equal, toItem: emailTxt.superview, attribute: .centerX, multiplier: 1, constant: 0)
        c2 = NSLayoutConstraint(item: emailTxt, attribute: .top, relatedBy: .equal, toItem: emailLbl, attribute: .bottom, multiplier: 1, constant: 12)
        c3 = NSLayoutConstraint(item: emailTxt, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250)
        c4 = NSLayoutConstraint(item: emailTxt, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant:43)
        emailTxt.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([c1, c2, c3, c4])
 
        
        c1 = NSLayoutConstraint(item: oldPwdLbl, attribute: .leading, relatedBy: .equal, toItem: oldPwdLbl.superview, attribute: .leading, multiplier: 1, constant: 16)
        c2 = NSLayoutConstraint(item: oldPwdLbl, attribute: .top, relatedBy: .equal, toItem: logoView, attribute: .bottom, multiplier: 1, constant: 50)
        oldPwdLbl.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([c1, c2])
        c1 = NSLayoutConstraint(item: oldPwdTxt, attribute: .leading, relatedBy: .equal, toItem: oldPwdLbl, attribute: .trailing, multiplier: 1, constant: 8)
        c2 = NSLayoutConstraint(item: oldPwdTxt, attribute: .centerY, relatedBy: .equal, toItem: oldPwdLbl, attribute: .centerY, multiplier: 1, constant: 0)
        c3 = NSLayoutConstraint(item: oldPwdTxt, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250)
        c4 = NSLayoutConstraint(item: oldPwdTxt, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 43)
        oldPwdTxt.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([c1, c2, c3, c4])
        
        c1 = NSLayoutConstraint(item: newPwdLbl, attribute: .leading, relatedBy: .equal, toItem: newPwdLbl.superview, attribute: .leading, multiplier: 1, constant: 16)
        c2 = NSLayoutConstraint(item: newPwdLbl, attribute: .top, relatedBy: .equal, toItem: oldPwdLbl, attribute: .bottom, multiplier: 1, constant: 30)
        newPwdLbl.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([c1, c2])
        c1 = NSLayoutConstraint(item: newPwdTxt, attribute: .leading, relatedBy: .equal, toItem: newPwdLbl, attribute: .trailing, multiplier: 1, constant: 8)
        c2 = NSLayoutConstraint(item: newPwdTxt, attribute: .centerY, relatedBy: .equal, toItem: newPwdLbl, attribute: .centerY, multiplier: 1, constant: 0)
        c3 = NSLayoutConstraint(item: newPwdTxt, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250)
        c4 = NSLayoutConstraint(item: newPwdTxt, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 43)
        newPwdTxt.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([c1, c2, c3, c4])
        
        c1 = NSLayoutConstraint(item: rePwdLbl, attribute: .leading, relatedBy: .equal, toItem: rePwdLbl.superview, attribute: .leading, multiplier: 1, constant: 16)
        c2 = NSLayoutConstraint(item: rePwdLbl, attribute: .top, relatedBy: .equal, toItem: newPwdLbl, attribute: .bottom, multiplier: 1, constant: 30)
        rePwdLbl.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([c1, c2])
        c1 = NSLayoutConstraint(item: rePwdTxt, attribute: .leading, relatedBy: .equal, toItem: rePwdLbl, attribute: .trailing, multiplier: 1, constant: 8)
        c2 = NSLayoutConstraint(item: rePwdTxt, attribute: .centerY, relatedBy: .equal, toItem: rePwdLbl, attribute: .centerY, multiplier: 1, constant: 0)
        c3 = NSLayoutConstraint(item: rePwdTxt, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250)
        c4 = NSLayoutConstraint(item: rePwdTxt, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 43)
        rePwdTxt.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([c1, c2, c3, c4])
        
        
        var lastItem: Any?
        if type == "forget_password" {
            lastItem = emailTxt
        } else if type == "change_password" {
            lastItem = rePwdTxt
        }
        c1 = NSLayoutConstraint(item: submitBtn, attribute: .centerX, relatedBy: .equal, toItem: submitBtn.superview, attribute: .centerX, multiplier: 1, constant: 0)
        c2 = NSLayoutConstraint(item: submitBtn, attribute: .top, relatedBy: .equal, toItem: lastItem, attribute: .bottom, multiplier: 1, constant: 20)
        submitBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([c1, c2])
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        emailLbl.sizeToFit()
        oldPwdLbl.sizeToFit()
        newPwdLbl.sizeToFit()
        rePwdLbl.sizeToFit()
        submitBtn.sizeToFit()
        view.layoutIfNeeded()
    }
    
    @objc func submit(_ sender: Any) {
        if type == "forget_password" {
            if emailTxt.text?.count == 0 {
                SCLAlertView().showWarning("警告", subTitle: "email不能為空白")
            } else {
                let email = emailTxt.text
                Global.instance.addSpinner(superView: self.view)
                MemberService.instance.forgetPassword(email: email!, completion: { (success) in
                    Global.instance.removeSpinner(superView: self.view)
                    if success {
                        if MemberService.instance.success {
                            
                            let appearance = SCLAlertView.SCLAppearance(
                                showCloseButton: false
                            )
                            let alertView = SCLAlertView(appearance: appearance)
                            alertView.addButton("成功") {
                                if self.delegate != nil {
                                    self.delegate?.refresh()
                                }
                                self.dismiss(animated: true, completion: nil)
                            }
                            alertView.showSuccess("成功", subTitle: MemberService.instance.msg)
                            
                            
                            //SCLAlertView().showSuccess("成功", subTitle: MemberService.instance.msg)
                        } else {
                            SCLAlertView().showWarning("警告", subTitle: MemberService.instance.msg)
                        }
                    }
                })
            }
            
        } else if type == "change_password" {
            var bValidate: Bool = true
            var msg: String = ""
            if oldPwdTxt.text?.count == 0 {
                bValidate = false
                msg = "舊密碼不能為空白"
            }
            if newPwdTxt.text?.count == 0 {
                bValidate = false
                msg = "新密碼不能為空白"
            }
            if newPwdTxt.text != rePwdTxt.text {
                bValidate = false
                msg = "新密碼不相符"
            }
            if !bValidate {
                SCLAlertView().showWarning("警告", subTitle: msg)
            } else {
                Global.instance.addSpinner(superView: self.view)
                MemberService.instance.changePassword(oldPassword:oldPwdTxt.text!,password: newPwdTxt.text!,rePassword: rePwdTxt.text!, completion: { (success) in
                    Global.instance.removeSpinner(superView: self.view)
                    if success {
                        if MemberService.instance.success {
                            Member.instance.reset()
                            Member.instance.isLoggedIn = false
                            let appearance = SCLAlertView.SCLAppearance(
                                showCloseButton: false
                            )
                            let alertView = SCLAlertView(appearance: appearance)
                            alertView.addButton("關閉") {
                                if self.delegate != nil {
                                    self.delegate?.refresh()
                                }
                                self.dismiss(animated: true, completion: nil)
                            }
                            alertView.showSuccess("成功", subTitle: "更改密碼成功，請使用新密碼重新登入")
                        } else {
                            SCLAlertView().showWarning("警告", subTitle: MemberService.instance.msg)
                        }
                    }
                })
            }
        }
    }

    @IBAction func prevBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
extension IconTextField {
    func set(icon: String) {
        self.leftImage = UIImage(named: icon)
        self.borderWidth(1)
        self.borderColor(UIColor.white)
        self.borderCornerRadius(24)
        self.align(.left)
    }
}
