//
//  ArenaVC.swift
//  bm
//
//  Created by ives on 2018/7/28.
//  Copyright © 2018年 bm. All rights reserved.
//

import UIKit

class ArenaVC: ListVC {
    
    override func viewDidLoad() {
        myTablView = tableView
        dataService = ArenaService.instance
        _type = "arena"
        _titleField = "name"
        super.viewDidLoad()
    }

    @IBAction func prevBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
