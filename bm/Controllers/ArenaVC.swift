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
    
    @objc func mapPrepare(sender: UITapGestureRecognizer) {
        let label = sender.view as! UILabel
        let idx = label.tag
        let row = lists[idx]
        let address = row.data[ADDRESS_KEY]!["value"] as! String
        let title = row.title
        let sender: [String: String] = [
            "title": title,
            "address": address
        ]
        performSegue(withIdentifier: "toMap", sender: sender)
    }

    @IBAction func prevBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
