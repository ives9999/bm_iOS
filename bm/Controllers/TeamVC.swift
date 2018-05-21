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
    
    let _type:String = "team"
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var managerBtn: UIButton!
    
    override func viewDidLoad() {
        setIden(item:_type, titleField: "name")
        super.viewDidLoad()
        Global.instance.setupTabbar(self)
        managerBtn.layer.cornerRadius = 12
        refresh()
        Global.instance.menuPressedAction(menuBtn, self)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let vc: TeamManagerVC = segue.destination as! TeamManagerVC
//    }
    
    @IBAction func manager(_ sender: Any) {
        if !Member.instance.isLoggedIn {
            SCLAlertView().showError("警告", subTitle: "請先登入為會員")
        } else {
            performSegue(withIdentifier: TO_TEAM_MANAGER, sender: nil)
        }
    }
}
