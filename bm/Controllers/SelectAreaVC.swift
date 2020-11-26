//
//  SelectAreaVC.swift
//  bm
//
//  Created by ives sun on 2020/11/25.
//  Copyright © 2020 bm. All rights reserved.
//

import Foundation

class SelectAreaVC: SingleSelectVC {
    
    var city_id: Int?
    
    override func viewDidLoad() {
        myTablView = tableView
        title = "區域"
        if city_id != nil {
            super.viewDidLoad()

            //print(selected)
            if city_id != nil && city_id! > 0 {
                let session_rows = getAreasFromCity(city_id!) { rows in
                    //print(rows)
                    self.areasBridge(rowsFromSession: rows)
                    self.tableView.reloadData()
                }
                areasBridge(rowsFromSession: session_rows)
            }
        }
    }
    
    func areasBridge(rowsFromSession: [[String: String]]) {
        
        if rows1 != nil && rows1!.count > 0 {
            rows1!.removeAll()
        } else {
            rows1 = [[String: String]]()
        }
        for row in rowsFromSession {
            rows1!.append(["title": row["name"]!, "value": row["id"]!])
        }
    }
}
