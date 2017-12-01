//
//  TeamTempPlayEditVC.swift
//  bm
//
//  Created by ives on 2017/11/30.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class TeamTempPlayEditVC: MyTableVC {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
//        let _sections: [String] = [""]
//        let _rows: [[Dictionary<String, Any>]] = [[Dictionary<String, Any>]]()
//        setData(sections: _sections, rows: _rows)
        sections = TeamTempPlay.instance.sections
        myTablView = tableView
        super.viewDidLoad()

    }

    @IBAction func prevBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
