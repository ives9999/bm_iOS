//
//  SelectVC.swift
//  bm
//
//  Created by ives on 2019/6/21.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit

protocol SelectDelegate: class {}

class SelectVC: MyTableVC {
    
    @IBOutlet weak var titleLbl: UILabel!
    
    var key: String? = nil
    var rows1: [[String: String]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        tableView.separatorStyle = .singleLine
//        tableView.separatorColor = UIColor.white
//        if key != nil && key == CITY_KEY {
//            getCitys()
//        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if rows1 != nil {
            return rows1!.count
        } else {
            return 0
        }
    }
    
//    func rows1Bridge(rowsFromSession: [[String: String]]) {
//
//        if rows1 != nil && rows1!.count > 0 {
//            rows1!.removeAll()
//        } else {
//            rows1 = [[String: String]]()
//        }
//        for row in rowsFromSession {
//            rows1!.append(["title": row["name"]!, "value": row["id"]!])
//        }
//    }
    
    func setSelectedStyle(_ cell: UITableViewCell) {
        cell.accessoryType = .checkmark
        cell.textLabel?.textColor = UIColor(MY_GREEN)
        cell.tintColor = UIColor(MY_GREEN)
    }
    
    func unSetSelectedStyle(_ cell: UITableViewCell) {
        cell.accessoryType = .none
        cell.textLabel?.textColor = UIColor.white
        cell.tintColor = UIColor.white
    }
    
    func setDelegate(_ delegate: SelectDelegate) {}
    
    @IBAction func cancel(_ sender: Any) {
        prev()
    }
    
    func alertError(_ msg: String) {
        
        warning(msg: msg, buttonTitle: "回上一頁", buttonAction: {
            self.prev()})
    }
}
