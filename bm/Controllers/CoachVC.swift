//
//  CoachVC.swift
//  bm
//
//  Created by ives on 2017/10/19.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class CoachVC: ListVC {

    let _type:String = "coach"
    @IBOutlet weak var menuBtn: UIButton!
    
    override func viewDidLoad() {
        setIden(item:_type, titleField: "name")
        super.viewDidLoad()
        Global.instance.setupTabbar(self)
        refresh()
        Global.instance.menuPressedAction(menuBtn, self)
    }
}
