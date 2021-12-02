//
//  RequestManagerTeamVC.swift
//  bm
//
//  Created by ives on 2021/11/30.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation
import UIKit

class RequestManagerTeamVC: BaseViewController {
    
    @IBOutlet var teamNameClearBtn: UIButton!
    @IBOutlet var managerTokenClearBtn: UIButton!
    @IBOutlet var managerView: UIView!
    @IBOutlet var teamNameTF: SuperTextField!
    @IBOutlet var memberStackView: UIStackView!
    @IBOutlet var manager_tokenTF: SuperTextField!
    @IBOutlet var nicknameLbl: SuperLabel!
    @IBOutlet var emailLbl: SuperLabel!
    @IBOutlet var mobileLbl: SuperLabel!
    @IBOutlet var submitBtn: SubmitButton!
    @IBOutlet var cancelBtn: CancelButton!
    @IBOutlet var line2: UIView!
    
    var managerTable: MemberTable?
    
    override func viewDidLoad() {
        
        dataService = TeamService.instance
        able_type = "team"
        
        super.viewDidLoad()
        
        teamNameClearBtn.setTitle("", for: .normal)
        managerTokenClearBtn.setTitle("", for: .normal)
        
        managerView.isHidden = true
        line2.isHidden = true
    }
    
    func checkManagerToken() {
        
        managerView.isHidden = false
        memberStackView.isHidden = true
    }
    
    @IBAction func isNameExist() {
        
        let teamName: String = teamNameTF.text ?? ""
        if teamName.count == 0 {
            warning("請填球隊名稱")
        } else {
            Global.instance.addSpinner(superView: self.view)
            dataService.isNameExist(name: teamName) { success in
                
                Global.instance.removeSpinner(superView: self.view)
                
                if success {
                    
                    let jsonData: Data = self.dataService.jsonData!
                    do {
                        let successTable: SuccessTable = try JSONDecoder().decode(SuccessTable.self, from: jsonData)
                        if successTable.success {
                            self.checkManagerToken()
                        } else {
                            self.warning("球隊名稱錯誤，系統無此球隊，須完全符合系統幫您建立的球隊名稱")
                        }
                    } catch {
                        self.warning(error.localizedDescription)
                    }
                } else {
                    self.warning("取得會員資訊錯誤")
                }
            }
        }
    }
    
    func getMemberOne(token: String) {
        
        Global.instance.addSpinner(superView: self.view)
        MemberService.instance.getOne(params: ["token": token]) { success in
            
            Global.instance.removeSpinner(superView: self.view)
            
            if success {
                
                let jsonData: Data = MemberService.instance.jsonData!
                do {
                    let successTable: SuccessTable = try JSONDecoder().decode(SuccessTable.self, from: jsonData)
                    if successTable.success {
                        self.managerTable = try JSONDecoder().decode(MemberTable.self, from: jsonData)
                        if self.managerTable != nil {

                            self.nicknameLbl.text = self.managerTable!.nickname
                            self.emailLbl.text = self.managerTable!.email
                            self.mobileLbl.text = self.managerTable!.mobile

                            self.memberStackView.isHidden = false
                            self.line2.isHidden = false
                            //self.submitBtn.isHidden = false
                            //self.cancelBtn.isHidden = false
                        }
                    } else {
                        self.warning("管理員金鑰錯誤，系統無此會員!!")
                    }
                    //self.managerTable = try JSONDecoder().decode(MemberTable.self, from: jsonData)
                    //let n = 6
                    
                } catch {
                    self.warning(error.localizedDescription)
                }
            } else {
                self.warning("取得會員資訊錯誤")
            }
        }
    }
    
    @IBAction func validate(_ sender: Any) {
        //memberStackView.isHidden = true
        let manager_token: String = manager_tokenTF.text!
        if manager_token.count == 0 {
            warning("請輸入管理員金鑰")
        } else {
            getMemberOne(token: manager_token)
        }
    }
    
    @IBAction func nameClear() {
        teamNameTF.text = ""
    }
    
    @IBAction func tokenClear() {
        manager_tokenTF.text = ""
    }
}
