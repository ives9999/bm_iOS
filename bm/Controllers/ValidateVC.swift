//
//  ValidateVC.swift
//  bm
//
//  Created by ives on 2018/5/24.
//  Copyright © 2018年 bm. All rights reserved.
//

import UIKit
import SCLAlertView

class ValidateVC: BaseViewController {

//    @IBOutlet weak var titleLbl: UILabel!
//    @IBOutlet weak var codeTxt: SuperTextField!
//    @IBOutlet weak var typeTxt: SuperTextField!
//    @IBOutlet weak var submitBtn: SubmitButton!
//    @IBOutlet weak var reSendBtn: SuperButton!
//
//    @IBOutlet weak var dataContainerView: UIView!
//
//    var delegate: BaseViewController?
    
    var type: String = ""
    var showTop2: ShowTop2?
    
    let emailTxt2: MainTextField2 = {
        let view: MainTextField2 = MainTextField2(label: "Email", icon: "email_svg", placeholder: "davie@gmail.com", isRequired: true, keyboard: KEYBOARD.emailAddress)
        
        return view
    }()
    
    let codeTxt2: MainTextField2 = {
        let view: MainTextField2 = MainTextField2(label: "認證碼", icon: "code_svg", placeholder: "請填寫收到的認證碼", isRequired: true)
        
        return view
    }()
    
    let submitButton: SubmitButton = SubmitButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showTop2 = ShowTop2(delegate: self)
        showTop2!.anchor(parent: self.view)
        if type == "email" {
            showTop2!.setTitle("Email認證")
            emailTxt2.setLabel("Email")
            emailTxt2.setValue(Member.instance.email)
        } else if type == "mobile" {
            showTop2!.setTitle("手機認證")
            emailTxt2.setLabel("手機號碼")
            emailTxt2.setValue(Member.instance.mobile)
            emailTxt2.setIcon("mobild_svg")
        }
        submitButton.delegate = self
        
        anchor()

//        typeTxt.backgroundColor = UIColor(SEARCH_BACKGROUND)
//        typeTxt.textColor = UIColor(MY_GREEN)
//
//        codeTxt.backgroundColor = UIColor(SEARCH_BACKGROUND)
//        codeTxt.textColor = UIColor(MY_GREEN)
//
//        codeTxt.attributedPlaceholder = NSAttributedString(
//            string: "認證碼",
//            attributes: [NSAttributedString.Key.foregroundColor: UIColor(SEARCH_BACKGROUND_PLACEHOLDER)]
//        )
//
//        reSendBtn.backgroundColor = UIColor(MY_PURPLE)
//
//        if type == "email" {
//            titleLbl.text = "email認證"
//            //typeLbl.text = "email"
//
//            typeTxt.text = Member.instance.email
//            typeTxt.attributedPlaceholder = NSAttributedString(
//                string: "EMail",
//                attributes: [NSAttributedString.Key.foregroundColor: UIColor(SEARCH_BACKGROUND_PLACEHOLDER)]
//            )
//            typeTxt.keyboardType = UIKeyboardType.emailAddress
//        } else if type == "mobile" {
//            titleLbl.text = "手機認證"
//            //typeLbl.text = "手機"
//
//            typeTxt.text = Member.instance.mobile
//            typeTxt.attributedPlaceholder = NSAttributedString(
//                string: "手機號碼",
//                attributes: [NSAttributedString.Key.foregroundColor: UIColor(SEARCH_BACKGROUND_PLACEHOLDER)]
//            )
//            typeTxt.keyboardType = UIKeyboardType.phonePad
//
//            codeTxt.keyboardType = UIKeyboardType.numberPad
//        }
        hideKeyboardWhenTappedAround()
    }
    
    func anchor() {
        self.view.addSubview(emailTxt2)
        emailTxt2.snp.makeConstraints { make in
            make.top.equalTo(showTop2!.snp.bottom).offset(100)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        self.view.addSubview(codeTxt2)
        codeTxt2.snp.makeConstraints { make in
            make.top.equalTo(emailTxt2.snp.bottom).offset(36)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        self.view.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(codeTxt2.snp.bottom).offset(65)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
            make.height.equalTo(52)
        }
    }

//    @IBAction func resend(_ sender: Any) {
//        let value = typeTxt.text!
//        if value.count <= 0 {
//            var msg = ""
//            if type == "email" {
//                msg = "請填寫email"
//            } else if type == "mobile" {
//                msg = "請填寫手機號碼"
//            }
//            SCLAlertView().showWarning("警告", subTitle: msg)
//        } else {
//            Global.instance.addSpinner(superView: self.view)
//            MemberService.instance.sendVaildateCode(type: type, value: value, token: Member.instance.token) { (success) in
//                Global.instance.removeSpinner(superView: self.view)
//                if (success) {
//                    var msg = ""
//                    if self.type == "email" {
//                        msg = "已經將認證信寄到註冊的信箱了"
//                    } else if self.type == "mobile" {
//                        msg = "已經將認證碼發送到註冊的手機了"
//                    }
//                    SCLAlertView().showInfo("訊息", subTitle: msg)
//                } else {
//                    SCLAlertView().showWarning("警告", subTitle: MemberService.instance.msg)
//                }
//            }
//        }
//    }
}

extension ValidateVC: SubmitButtonDelegate {
    func submit2() {
        
        let code = codeTxt2.value
        if code.count <= 0 {
            let msg = "請填寫認證碼"
            SCLAlertView().showWarning("警告", subTitle: msg)
        } else {
            Global.instance.addSpinner(superView: self.view)
            MemberService.instance.validate(type: type, code: code, token: Member.instance.token) { (success) in
                Global.instance.removeSpinner(superView: self.view)
                if (success) {

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
                        self.info(msg: "認證成功", buttonTitle: "關閉") {
                            Global.instance.addSpinner(superView: self.view)
                            MemberService.instance.getOne(params: ["token": Member.instance.token]) { success in
                                Global.instance.removeSpinner(superView: self.view)

                                if success {

                                    let jsonData: Data = MemberService.instance.jsonData!
                                    do {
                                        let table: MemberTable = try JSONDecoder().decode(MemberTable.self, from: jsonData)
                                        table.toSession(isLoggedIn: true)
                                        self.toMemberItem(MainMemberEnum.info)
                                    } catch {
                                        self.warning(error.localizedDescription)
                                    }
                                }
                            }
                        }
                    } else {
                        self.warning(s.msg)
                    }

                } else {
                    SCLAlertView().showWarning("警告", subTitle: MemberService.instance.msg)
                }
            }
        }
    }
}
