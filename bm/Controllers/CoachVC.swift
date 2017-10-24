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
        setIden(item:_type, titleField: "name")
        super.viewDidLoad()
        getData()
//        DataService.instance.getList(type: _type, titleField: "name") { (success) in
//            if success {
//                self.lists = DataService.instance.lists
//                print(self.lists)
//                self.listCV.reloadData()
//            }
//            Global.instance.removeSpinner()
//            Global.instance.removeProgressLbl()
//        }
    }
}
