//
//  MemberBankVC.swift
//  bm
//
//  Created by ives on 2022/6/28.
//  Copyright © 2022 bm. All rights reserved.
//

import Foundation

class MemberBankVC: BaseViewController {
    
    @IBOutlet weak var top: Top!
    @IBOutlet weak var dataContainer: UIView!
    
    @IBOutlet var bankTF: SuperTextField!
    @IBOutlet var branchTF: SuperTextField!
    @IBOutlet var bankCodeTF: SuperTextField!
    @IBOutlet var accountTF: SuperTextField!
    
    @IBOutlet var bankLbl: SuperLabel!
    @IBOutlet var branchLbl: SuperLabel!
    @IBOutlet var bankCodeLbl: SuperLabel!
    @IBOutlet var accountLbl: SuperLabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        top.setTitle(title: "會員銀行帳戶")
        top.delegate = self
        
        dataContainer.layer.cornerRadius = CORNER_RADIUS
        dataContainer.clipsToBounds = true
        dataContainer.backgroundColor = UIColor(SEARCH_BACKGROUND)
        
        bankLbl.textAlignment = .right
        branchLbl.textAlignment = .right
        bankCodeLbl.textAlignment = .right
        accountLbl.textAlignment = .right
        
        initData()
        
    }
    
    func initData() {
        bankTF.text = Member.instance.bank
        branchTF.text = Member.instance.branch
        bankCodeTF.text = Member.instance.bank_code
        accountTF.text = Member.instance.account
    }
    
    @IBAction func submit(_ sender: Any) {
        
        let member_token: String = Member.instance.token
        
        msg = ""
        
        if bankTF.text!.count == 0 {
            msg += "沒有填寫銀行名稱\n"
        }
        
        if branchTF.text!.count == 0 {
            msg += "沒有填寫分行名稱\n"
        }
        
        if bankCodeTF.text!.count == 0 {
            msg += "沒有填寫銀行代碼\n"
        }
        
        if accountTF.text!.count == 0 {
            msg += "沒有填寫銀行帳號\n"
        }
        
        params["bank"] = bankTF.text
        params["branch"] = branchTF.text
        params["bank_code"] = bankCodeTF.text
        params["account"] = accountTF.text
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
    
    @IBAction func clearButtonPressed(view: UIView) {
        if let clearButton: UIButton = view as? UIButton {
            let tag: Int = clearButton.tag
            switch (tag) {
            case 1:
                self.bankTF.text = ""
            case 2:
                self.branchTF.text = ""
            case 3:
                self.bankCodeTF.text = ""
            case 4:
                self.accountTF.text = ""
            default:
                self.warning("此按鈕沒有定義")
            }
        }
    }
    
    @IBAction func prev1() {
        prev()
    }
}
