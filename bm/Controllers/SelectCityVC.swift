//
//  CitySelect1VC.swift
//  bm
//
//  Created by ives on 2020/11/24.
//  Copyright © 2020 bm. All rights reserved.
//

import Foundation

class SelectCityVC: SingleSelectVC {
    
    override func viewDidLoad() {
        myTablView = tableView
        title = "縣市"
        super.viewDidLoad()
        
        //print(selected)
        let session_rows = getCitys() { rows in
            //print(rows)
            self.citysBridge(rowsFromSession: rows)
            self.tableView.reloadData()
        }
        citysBridge(rowsFromSession: session_rows)
    }
    
    func citysBridge(rowsFromSession: [[String: String]]) {
        
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
