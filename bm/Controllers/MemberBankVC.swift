//
//  MemberBankVC.swift
//  bm
//
//  Created by ives on 2022/6/28.
//  Copyright © 2022 bm. All rights reserved.
//

import Foundation

class MemberBankVC: BaseViewController {
    
//    @IBOutlet weak var dataContainer: UIView!
//
//    @IBOutlet var bankTF: SuperTextField!
//    @IBOutlet var branchTF: SuperTextField!
//    @IBOutlet var bankCodeTF: SuperTextField!
//    @IBOutlet var accountTF: SuperTextField!
//
//    @IBOutlet var bankLbl: SuperLabel!
//    @IBOutlet var branchLbl: SuperLabel!
//    @IBOutlet var bankCodeLbl: SuperLabel!
//    @IBOutlet var accountLbl: SuperLabel!
    
    var showTop2: ShowTop2?
    
    let nameTxt2: MainTextField2 = {
        let view: MainTextField2 = MainTextField2(label: "銀行名稱", icon: "email_svg", placeholder: "台灣銀行", isRequired: true)
        
        return view
    }()
    
    let branchTxt2: MainTextField2 = {
        let view: MainTextField2 = MainTextField2(label: "分行名稱", icon: "email_svg", placeholder: "中正分行", isRequired: true)
        
        return view
    }()
    
    let codeTxt2: MainTextField2 = {
        let view: MainTextField2 = MainTextField2(label: "銀行代碼", icon: "code_svg", placeholder: "100", isRequired: true, keyboard: KEYBOARD.numberPad)
        
        return view
    }()
    
    let accountTxt2: MainTextField2 = {
        let view: MainTextField2 = MainTextField2(label: "帳號", icon: "email_svg", placeholder: "0065432", isRequired: true, keyboard: KEYBOARD.numberPad)
        
        return view
    }()
    
    let submitButton: SubmitButton = SubmitButton()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        showTop2 = ShowTop2(delegate: self)
        showTop2!.anchor(parent: self.view)
        showTop2!.setTitle("會員銀行帳戶")
        
        submitButton.delegate = self
        
        anchor()
        
//        top.setTitle(title: "會員銀行帳戶")
//        top.delegate = self
//        
//        dataContainer.layer.cornerRadius = CORNER_RADIUS
//        dataContainer.clipsToBounds = true
//        dataContainer.backgroundColor = UIColor(SEARCH_BACKGROUND)
//        
//        bankLbl.textAlignment = .right
//        branchLbl.textAlignment = .right
//        bankCodeLbl.textAlignment = .right
//        accountLbl.textAlignment = .right
//        
        initData()
        
    }
    
    func anchor() {
        self.view.addSubview(nameTxt2)
        nameTxt2.snp.makeConstraints { make in
            make.top.equalTo(showTop2!.snp.bottom).offset(100)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        self.view.addSubview(branchTxt2)
        branchTxt2.snp.makeConstraints { make in
            make.top.equalTo(nameTxt2.snp.bottom).offset(36)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        self.view.addSubview(codeTxt2)
        codeTxt2.snp.makeConstraints { make in
            make.top.equalTo(branchTxt2.snp.bottom).offset(36)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        self.view.addSubview(accountTxt2)
        accountTxt2.snp.makeConstraints { make in
            make.top.equalTo(codeTxt2.snp.bottom).offset(36)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        self.view.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(accountTxt2.snp.bottom).offset(65)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
            make.height.equalTo(52)
        }
    }
    
    func initData() {
        nameTxt2.setValue(Member.instance.bank)
        branchTxt2.setValue(Member.instance.branch)
        codeTxt2.setValue(String(Member.instance.bank_code))
        accountTxt2.setValue(Member.instance.account)
    }
}

extension MemberBankVC: SubmitButtonDelegate {
    func submit2() {
        let member_token: String = Member.instance.token
        
        msg = ""
        
        if nameTxt2.value.count == 0 {
            msg += "沒有填寫銀行名稱\n"
        }
        
        if branchTxt2.value.count == 0 {
            msg += "沒有填寫分行名稱\n"
        }
        
        if codeTxt2.value.count == 0 {
            msg += "沒有填寫銀行代碼\n"
        }
        
        if accountTxt2.value.count == 0 {
            msg += "沒有填寫銀行帳號\n"
        }
        
        params["bank"] = nameTxt2.value
        params["branch"] = branchTxt2.value
        params["bank_code"] = codeTxt2.value
        params["account"] = accountTxt2.value
        params["member_token"] = member_token
        params["do"] = "update"
        
        if msg.count > 0 {
            warning(msg)
        } else {
            Global.instance.addSpinner(superView: self.view)
            MemberService.instance.bank(_params: params) { success in
                Global.instance.removeSpinner(superView: self.view)
                if success {
                    let jsonData: Data = MemberService.instance.jsonData!
                    do {
                        let table = try JSONDecoder().decode(SuccessTable.self, from: jsonData)
                        if (!table.success) {
                            self.warning(table.msg)
                        } else {
                            Member.instance.bank = self.params["bank"]!
                            Member.instance.branch = self.params["branch"]!
                            Member.instance.bank_code = Int(self.params["bank_code"]!)!
                            Member.instance.account = self.params["account"]!
                            self.info("已經更新您銀行帳戶資料")
                        }
                    } catch {
                        //self.warning(error.localizedDescription)
                        self.warning(self.dataService.msg)
                    }
                } else {
                    Global.instance.removeSpinner(superView: self.view)
                    self.warning("伺服器錯誤，請稍後再試，或洽管理人員")
                    //SCLAlertView().showWarning("錯誤", subTitle: "註冊失敗，伺服器錯誤，請稍後再試")
                
                }
            }
        }
    }
}
