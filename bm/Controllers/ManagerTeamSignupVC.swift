//
//  ManagerTeamSignup.swift
//  bm
//
//  Created by ives on 2021/12/19.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation


class ManagerTeamSignupVC: ManagerSignupVC {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    override func initRows() -> [MemberRow] {
        
        var rows: [MemberRow] = [MemberRow]()
        
        let r1: MemberRow = MemberRow(title: "臨打報名列表", icon: "signup", segue: TO_MANAGER_SIGNUPLIST)
        r1.color = UIColor(MY_LIGHT_WHITE)
        rows.append(r1)
        
        let r3: MemberRow = MemberRow(title: "黑名單", icon: "blacklist", segue: TO_BLACKLIST)
        r3.color = UIColor(MY_LIGHT_WHITE)
        rows.append(r3)
        
        return rows
    }
}
