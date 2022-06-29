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
        
    }
}
