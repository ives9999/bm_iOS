//
//  PasswordVC.swift
//  bm
//
//  Created by ives on 2017/12/20.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import SCLAlertView

class PasswordVC: BaseViewController {
    
    var type: String?// forget_password, change_password
    //var emailLbl: SuperLabel!
//    var emailTxt: SuperTextField!
//    var submitBtn: SubmitButton!
//    //var oldPwdLbl: SuperLabel!
//    var oldPwdTxt: SuperTextField!
//    //var newPwdLbl: SuperLabel!
//    var newPwdTxt: SuperTextField!
//    //var rePwdLbl: SuperLabel!
//    var rePwdTxt: SuperTextField!

//    @IBOutlet weak var bkView: UIImageView!
//    @IBOutlet weak var titleLbl: UILabel!
//    @IBOutlet weak var dataContainerView: UIView!
//
//    var delegate: BaseViewController?
    
    var showTop2: ShowTop2?
    
    let emailTxt2: MainTextField2 = {
        let view: MainTextField2 = MainTextField2(label: "Email", icon: "email_svg", placeholder: "davie@gmail.com", keyboard: KEYBOARD.emailAddress)
        
        return view
    }()
    
    let oldPasswordTxt2: MainTextField2 = {
        let view: MainTextField2 = MainTextField2(label: "舊密碼", icon: "password_svg", placeholder: "舊密碼", isPassword: true)
        
        return view
    }()
    
    let newPasswordTxt2: MainTextField2 = {
        let view: MainTextField2 = MainTextField2(label: "新密碼", icon: "password_svg", placeholder: "新密碼", isPassword: true)
        
        return view
    }()
    
    let rePasswordTxt2: MainTextField2 = {
        let view: MainTextField2 = MainTextField2(label: "密碼確認", icon: "password_svg", placeholder: "新密碼確認", isPassword: true)
        
        return view
    }()
    
    let submitButton: SubmitButton = SubmitButton()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showTop2 = ShowTop2(delegate: self)
        showTop2!.anchor(parent: self.view)
        if type == "forget_password" {
            showTop2!.setTitle("忘記密碼")
        } else if type == "change_password" {
                showTop2!.setTitle("更改密碼")
        }
        submitButton.delegate = self
        
        anchor()
        
//        emailTxt = SuperTextField()
//        emailTxt.backgroundColor = UIColor(SEARCH_BACKGROUND)
//        emailTxt.attributedPlaceholder = NSAttributedString(
//            string: "請輸入註冊時的email",
//            attributes: [NSAttributedString.Key.foregroundColor: UIColor(SEARCH_BACKGROUND_PLACEHOLDER)]
//        )
//        emailTxt.keyboardType = UIKeyboardType.emailAddress
//        
//        oldPwdTxt = SuperTextField()
//        oldPwdTxt.backgroundColor = UIColor(SEARCH_BACKGROUND)
//        oldPwdTxt.attributedPlaceholder = NSAttributedString(
//            string: "舊密碼",
//            attributes: [NSAttributedString.Key.foregroundColor: UIColor(SEARCH_BACKGROUND_PLACEHOLDER)]
//        )
//        oldPwdTxt.isSecureTextEntry = true
//        
//        newPwdTxt = SuperTextField()
//        newPwdTxt.backgroundColor = UIColor(SEARCH_BACKGROUND)
//        newPwdTxt.attributedPlaceholder = NSAttributedString(
//            string: "新密碼",
//            attributes: [NSAttributedString.Key.foregroundColor: UIColor(SEARCH_BACKGROUND_PLACEHOLDER)]
//        )
//        newPwdTxt.isSecureTextEntry = true
//        
//        rePwdTxt = SuperTextField()
//        rePwdTxt.backgroundColor = UIColor(SEARCH_BACKGROUND)
//        rePwdTxt.attributedPlaceholder = NSAttributedString(
//            string: "密碼確認",
//            attributes: [NSAttributedString.Key.foregroundColor: UIColor(SEARCH_BACKGROUND_PLACEHOLDER)]
//        )
//        rePwdTxt.isSecureTextEntry = true
//        
//        submitBtn = SubmitButton()
//        submitBtn.addTarget(self, action: #selector(submit(_:)), for: UIControl.Event.touchUpInside)
//        
//        //dataContainerView.addSubview(emailLbl)
//        dataContainerView.addSubview(emailTxt)
//        //dataContainerView.addSubview(oldPwdLbl)
//        dataContainerView.addSubview(oldPwdTxt)
//        //dataContainerView.addSubview(newPwdLbl)
//        dataContainerView.addSubview(newPwdTxt)
//        //dataContainerView.addSubview(rePwdLbl)
//        dataContainerView.addSubview(rePwdTxt)
//        dataContainerView.addSubview(submitBtn)
//        
//        if type == "forget_password" {
//            //emailLbl.isHidden = false
//            emailTxt.isHidden = false
//            //oldPwdLbl.isHidden = true
//            oldPwdTxt.isHidden = true
//            //newPwdLbl.isHidden = true
//            newPwdTxt.isHidden = true
//            //rePwdLbl.isHidden = true
//            rePwdTxt.isHidden = true
//        } else if type == "change_password" {
//            //emailLbl.isHidden = true
//            emailTxt.isHidden = true
//            //oldPwdLbl.isHidden = false
//            oldPwdTxt.isHidden = false
//            //newPwdLbl.isHidden = false
//            newPwdTxt.isHidden = false
//            //rePwdLbl.isHidden = false
//            rePwdTxt.isHidden = false
//        }
//        
//        initLayout()

        //print(type)
    }
    
    private func anchor() {
        
        if (type == "forget_password") {
            self.view.addSubview(emailTxt2)
            emailTxt2.snp.makeConstraints { make in
                make.top.equalTo(showTop2!.snp.bottom).offset(100)
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
            }
            
            self.view.addSubview(submitButton)
            submitButton.snp.makeConstraints { make in
                make.top.equalTo(emailTxt2.snp.bottom).offset(65)
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
                make.centerX.equalToSuperview()
                make.height.equalTo(52)
            }
        } else if (type == "change_password") {
            self.view.addSubview(oldPasswordTxt2)
            oldPasswordTxt2.snp.makeConstraints { make in
                make.top.equalTo(showTop2!.snp.bottom).offset(100)
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
            }
            
            self.view.addSubview(newPasswordTxt2)
            newPasswordTxt2.snp.makeConstraints { make in
                make.top.equalTo(oldPasswordTxt2.snp.bottom).offset(36)
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
            }
            
            self.view.addSubview(rePasswordTxt2)
            rePasswordTxt2.snp.makeConstraints { make in
                make.top.equalTo(newPasswordTxt2.snp.bottom).offset(36)
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
            }
            
            self.view.addSubview(submitButton)
            submitButton.snp.makeConstraints { make in
                make.top.equalTo(rePasswordTxt2.snp.bottom).offset(65)
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
                make.centerX.equalToSuperview()
                make.height.equalTo(52)
            }
        }
    }
    
//    private func initLayout() {
//
//        var c1: NSLayoutConstraint,c2: NSLayoutConstraint,c3: NSLayoutConstraint,c4:NSLayoutConstraint
//
//        let emailTxtWidth: CGFloat = 250
//        let emailTxtHeight: CGFloat = 50
//
//        let emailLblLeading: CGFloat = (screen_width - emailTxtWidth) / 2
//
//        c1 = NSLayoutConstraint(item: emailTxt, attribute: .centerX, relatedBy: .equal, toItem: emailTxt.superview, attribute: .centerX, multiplier: 1, constant: 0)
//        c2 = NSLayoutConstraint(item: emailTxt, attribute: .top, relatedBy: .equal, toItem: emailTxt.superview, attribute: .top, multiplier: 1, constant: 80)
//        c3 = NSLayoutConstraint(item: emailTxt, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: emailTxtWidth)
//        c4 = NSLayoutConstraint(item: emailTxt, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant:emailTxtHeight)
//        emailTxt.translatesAutoresizingMaskIntoConstraints = false
//        dataContainerView.addConstraints([c1, c2, c3, c4])
//
//        c1 = NSLayoutConstraint(item: oldPwdTxt, attribute: .top, relatedBy: .equal, toItem: oldPwdTxt.superview, attribute: .top, multiplier: 1, constant: 120)
//        c2 = NSLayoutConstraint(item: oldPwdTxt, attribute: .centerX, relatedBy: .equal, toItem: oldPwdTxt.superview, attribute: .centerX, multiplier: 1, constant: 0)
//        c3 = NSLayoutConstraint(item: oldPwdTxt, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: emailTxtWidth)
//        c4 = NSLayoutConstraint(item: oldPwdTxt, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: emailTxtHeight)
//        oldPwdTxt.translatesAutoresizingMaskIntoConstraints = false
//        dataContainerView.addConstraints([c1, c2, c3, c4])
//
//        c1 = NSLayoutConstraint(item: newPwdTxt, attribute: .top, relatedBy: .equal, toItem: oldPwdTxt, attribute: .bottom, multiplier: 1, constant: 20)
//        c2 = NSLayoutConstraint(item: newPwdTxt, attribute: .centerX, relatedBy: .equal, toItem: newPwdTxt.superview, attribute: .centerX, multiplier: 1, constant: 0)
//        c3 = NSLayoutConstraint(item: newPwdTxt, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: emailTxtWidth)
//        c4 = NSLayoutConstraint(item: newPwdTxt, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: emailTxtHeight)
//        newPwdTxt.translatesAutoresizingMaskIntoConstraints = false
//        dataContainerView.addConstraints([c1, c2, c3, c4])
//
//        c1 = NSLayoutConstraint(item: rePwdTxt, attribute: .top, relatedBy: .equal, toItem: newPwdTxt, attribute: .bottom, multiplier: 1, constant: 20)
//        c2 = NSLayoutConstraint(item: rePwdTxt, attribute: .centerX, relatedBy: .equal, toItem: rePwdTxt.superview, attribute: .centerX, multiplier: 1, constant: 0)
//        c3 = NSLayoutConstraint(item: rePwdTxt, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: emailTxtWidth)
//        c4 = NSLayoutConstraint(item: rePwdTxt, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: emailTxtHeight)
//        rePwdTxt.translatesAutoresizingMaskIntoConstraints = false
//        dataContainerView.addConstraints([c1, c2, c3, c4])
//
//
//        var lastItem: Any?
//        if type == "forget_password" {
//            lastItem = emailTxt
//        } else if type == "change_password" {
//            lastItem = rePwdTxt
//        }
//        c1 = NSLayoutConstraint(item: submitBtn, attribute: .centerX, relatedBy: .equal, toItem: submitBtn.superview, attribute: .centerX, multiplier: 1, constant: 0)
//        c2 = NSLayoutConstraint(item: submitBtn, attribute: .top, relatedBy: .equal, toItem: lastItem, attribute: .bottom, multiplier: 1, constant: 50)
//        c3 = NSLayoutConstraint(item: submitBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: emailTxtWidth)
//        c4 = NSLayoutConstraint(item: submitBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
//        submitBtn.translatesAutoresizingMaskIntoConstraints = false
//        dataContainerView.addConstraints([c1, c2, c3, c4])
//    }
    
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        emailLbl.sizeToFit()
//        oldPwdLbl.sizeToFit()
//        newPwdLbl.sizeToFit()
//        rePwdLbl.sizeToFit()
//        submitBtn.sizeToFit()
//        view.layoutIfNeeded()
//    }
    
//    @objc func submit(_ sender: Any) {
//        if type == "forget_password" {
//            if emailTxt.text?.count == 0 {
//                SCLAlertView().showWarning("警告", subTitle: "email不能為空白")
//            } else {
//                let email = emailTxt.text
//                Global.instance.addSpinner(superView: self.view)
//                MemberService.instance.forgetPassword(email: email!, completion: { (success) in
//                    Global.instance.removeSpinner(superView: self.view)
//                    if success {
//
//                        self.jsonData = MemberService.instance.jsonData
//                        var s: SuccessTable = SuccessTable()
//                        do {
//                            if (self.jsonData != nil) {
//                                s = try JSONDecoder().decode(SuccessTable.self, from: self.jsonData!)
//                            } else {
//                                self.warning("無法從伺服器取得正確的json資料，請洽管理員")
//                            }
//                        } catch {
//                            self.warning("解析JSON字串時，得到空值，請洽管理員")
//                        }
//
//                        if s.success {
//                            self.info(s.msg)
//                        } else {
//                            self.warning(s.msg)
//                        }
//                    }
//                })
//            }
//
//        } else if type == "change_password" {
//            var bValidate: Bool = true
//            var msg: String = ""
//            if oldPwdTxt.text?.count == 0 {
//                bValidate = false
//                msg = "舊密碼不能為空白"
//            }
//            if newPwdTxt.text?.count == 0 {
//                bValidate = false
//                msg = "新密碼不能為空白"
//            }
//            if newPwdTxt.text != rePwdTxt.text {
//                bValidate = false
//                msg = "新密碼不相符"
//            }
//            if !bValidate {
//                SCLAlertView().showWarning("警告", subTitle: msg)
//            } else {
//                Global.instance.addSpinner(superView: self.view)
//                MemberService.instance.changePassword(oldPassword:oldPwdTxt.text!,password: newPwdTxt.text!,rePassword: rePwdTxt.text!, completion: { (success) in
//                    Global.instance.removeSpinner(superView: self.view)
//                    if success {
//
//                        self.jsonData = MemberService.instance.jsonData
//                        var s: SuccessTable = SuccessTable()
//                        do {
//                            if (self.jsonData != nil) {
//                                s = try JSONDecoder().decode(SuccessTable.self, from: self.jsonData!)
//                            } else {
//                                self.warning("無法從伺服器取得正確的json資料，請洽管理員")
//                            }
//                        } catch {
//                            self.warning("解析JSON字串時，得到空值，請洽管理員")
//                        }
//
//                        if s.success {
//                            self.info("更改密碼成功，請使用新密碼重新登入")
//                        } else {
//                            self.warning(s.msg)
//                        }
//                    }
//                })
//            }
//        }
//    }

//    @IBAction func prevBtnPressed(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
//    }
}
//extension IconTextField {
//    func set(icon: String) {
//        self.leftImage = UIImage(named: icon)
//        self.borderWidth(1)
//        self.borderColor(UIColor.white)
//        self.borderCornerRadius(24)
//        self.align(.left)
//    }
//}

extension PasswordVC: SubmitButtonDelegate {
    func submit2() {
        if type == "forget_password" {
            if emailTxt2.text.count == 0 {
                SCLAlertView().showWarning("警告", subTitle: "email不能為空白")
            } else {
                let email = emailTxt2.text
                Global.instance.addSpinner(superView: self.view)
                MemberService.instance.forgetPassword(email: email, completion: { (success) in
                    Global.instance.removeSpinner(superView: self.view)
                    if success {
                        
                        self.jsonData = MemberService.instance.jsonData
                        var s: SuccessTable = SuccessTable()
                        do {
                            if (self.jsonData != nil) {
                                s = try JSONDecoder().decode(SuccessTable.self, from: self.jsonData!)
                            } else {
                                self.warning("無法從伺服器取得正確的json資料，請洽管理員")
                            }
                        } catch {
                            self.warning("解析JSON字串時，得到空值，請洽管理員")
                        }
                        
                        if s.success {
                            self.info(msg: s.msg, buttonTitle: "關閉") {
                                self.toLogin()
                            }
                        } else {
                            self.warning(s.msg)
                        }
                    }
                })
            }
            
        } else if type == "change_password" {
            var msg: String = ""
            if oldPasswordTxt2.text.count == 0 {
                msg += "舊密碼不能為空白\n"
            }
            if newPasswordTxt2.text.count == 0 {
                msg += "新密碼不能為空白\n"
            }
            if newPasswordTxt2.text != rePasswordTxt2.text {
                msg = "新密碼不相符"
            }
            if msg.count > 0 {
                SCLAlertView().showWarning("警告", subTitle: msg)
            } else {
                Global.instance.addSpinner(superView: self.view)
                MemberService.instance.changePassword(oldPassword:oldPasswordTxt2.text,password: newPasswordTxt2.text,rePassword: rePasswordTxt2.text, completion: { (success) in
                    Global.instance.removeSpinner(superView: self.view)
                    if success {
                        
                        self.jsonData = MemberService.instance.jsonData
                        var s: SuccessTable = SuccessTable()
                        do {
                            if (self.jsonData != nil) {
                                s = try JSONDecoder().decode(SuccessTable.self, from: self.jsonData!)
                            } else {
                                self.warning("無法從伺服器取得正確的json資料，請洽管理員")
                            }
                        } catch {
                            self.warning("解析JSON字串時，得到空值，請洽管理員")
                        }
                        
                        if s.success {
                            self.info(msg: "更改密碼成功，請使用新密碼重新登入", buttonTitle: "關閉") {
                                Member.instance.reset()
                                self.toLogin()
                            }
                        } else {
                            self.warning(s.msg)
                        }
                    } else {
                        self.warning("網路錯誤，請稍後再試或洽管理員")
                    }
                })
            }
        }
    }
}
