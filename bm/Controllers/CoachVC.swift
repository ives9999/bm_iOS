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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._init(type: _type)
    }
}
