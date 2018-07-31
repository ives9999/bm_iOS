//
//  CoachVC.swift
//  bm
//
//  Created by ives on 2017/10/19.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class CoachVC: ListVC {
    
    override func viewDidLoad() {
        myTablView = tableView
        dataService = CoachService.instance
        _type = "coach"
        _titleField = "name"
        Global.instance.setupTabbar(self)
        Global.instance.menuPressedAction(menuBtn, self)
        super.viewDidLoad()
    }
    
    @IBAction func manager(_ sender: Any) {
        if !Member.instance.isLoggedIn {
            SCLAlertView().showError("警告", subTitle: "請先登入為會員")
        } else {
            performSegue(withIdentifier: TO_TEAM_MANAGER, sender: nil)
        }
    }
}
