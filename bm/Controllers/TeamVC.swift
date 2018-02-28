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
    
    override func viewDidLoad() {
        setIden(item:_type, titleField: "name")
        super.viewDidLoad()
        Global.instance.setupTabbar(self)
        refresh()
        Global.instance.menuPressedAction(menuBtn, self)
    }
    
}
