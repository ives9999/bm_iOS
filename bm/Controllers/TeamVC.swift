//
//  TeamVC.swift
//  bm
//
//  Created by ives on 2017/10/3.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import Device_swift

class TeamVC: ListVC {
    
    @IBOutlet weak var managerBtn: UIButton!    
    
    override func viewDidLoad() {
        myTablView = tableView
        dataService = TeamService.instance
        _type = "team"
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
