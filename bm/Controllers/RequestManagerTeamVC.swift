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
    
    override func viewDidLoad() {
        
        dataService = TeamService.instance
        able_type = "team"
        
        super.viewDidLoad()
        
        teamNameClearBtn.setTitle("", for: .normal)
        managerTokenClearBtn.setTitle("", for: .normal)
        
        managerView.isHidden = true
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
    
    @IBAction func nameClear() {
        
        teamNameTF.text = ""
    }
}
