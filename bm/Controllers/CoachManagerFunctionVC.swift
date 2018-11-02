//
//  CoachManagerFunctionVC.swift
//  bm
//
//  Created by ives on 2018/11/1.
//  Copyright © 2018 bm. All rights reserved.
//

import UIKit

class CoachManagerFunctionVC: MyTableVC {

    var name: String = ""
    var token: String = ""
    var _rows: [Dictionary<String, Any>] = [
        ["text": "編輯", "icon": "edit1", "segue": TO_TEAM_SUBMIT],
        ["text": "教球時段編輯", "icon": "tempplayedit", "segue": TO_TEAM_TEMP_PLAY],
        ["text": "報名學員名單", "icon": "tempplaylist", "segue": TO_TEAM_TEMP_PLAY],
        ["text": "刪除", "icon": "clear"]
    ]
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func prevBtnPressed(_ sender: Any) {
        prev()
    }
}
