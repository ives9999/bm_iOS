//
//  ValidateVC.swift
//  bm
//
//  Created by ives on 2018/5/24.
//  Copyright © 2018年 bm. All rights reserved.
//

import UIKit

class ValidateVC: BaseViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var codeTxt: SuperTextField!
    var type: String = ""
    @IBOutlet weak var typeTxt: SuperTextField!
    @IBOutlet weak var typeLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if type == "email" {
            titleLbl.text = "email認證"
            typeLbl.text = "email"
            typeTxt.text = Member.instance.email
            typeTxt.keyboardType = UIKeyboardType.emailAddress
        } else if type == "mobile" {
            titleLbl.text = "手機認證"
            typeLbl.text = "手機"
            typeTxt.text = Member.instance.mobile
            typeTxt.keyboardType = UIKeyboardType.phonePad
            codeTxt.keyboardType = UIKeyboardType.numberPad
        }
        hideKeyboardWhenTappedAround()
    }

    @IBAction func submit(_ sender: Any) {
        let code = codeTxt.text!
        if code.count <= 0 {
            let msg = "請填寫認證碼"
            SCLAlertView().showWarning("警告", subTitle: msg)
        } else {
            Global.instance.addSpinner(superView: self.view)
            MemberService.instance.validate(type: type, code: code) { (success) in
                Global.instance.removeSpinner(superView: self.view)
                if (success) {
                    let appearance = SCLAlertView.SCLAppearance(
                        showCloseButton: false
                    )
                    let alert = SCLAlertView(appearance: appearance)
                    alert.addButton("確定", action: {
                        self.prev()
                    })
                    alert.showInfo("訊息", subTitle: "認證成功")
                } else {
                    SCLAlertView().showWarning("警告", subTitle: MemberService.instance.msg)
                }
            }
        }
    }
    @IBAction func resend(_ sender: Any) {
        let value = typeTxt.text!
        if value.count <= 0 {
            var msg = ""
            if type == "email" {
                msg = "請填寫email"
            } else if type == "mobile" {
                msg = "請填寫手機號碼"
            }
            SCLAlertView().showWarning("警告", subTitle: msg)
        } else {
            Global.instance.addSpinner(superView: self.view)
            MemberService.instance.sendVaildateCode(type: type, value: value, token: Member.instance.token) { (success) in
                Global.instance.removeSpinner(superView: self.view)
                if (success) {
                    var msg = ""
                    if self.type == "email" {
                        msg = "已經將認證信寄到註冊的信箱了"
                    } else if self.type == "mobile" {
                        msg = "已經將認證碼發送到註冊的手機了"
                    }
                    SCLAlertView().showInfo("訊息", subTitle: msg)
                } else {
                    SCLAlertView().showWarning("警告", subTitle: MemberService.instance.msg)
                }
            }
        }
    }
    @IBAction func prevBtnPressed(_ sender: Any) {
        prev()
    }

}
