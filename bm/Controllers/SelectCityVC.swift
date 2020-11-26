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
        rows1 = getCitys() { rows in
            print(rows)
            self.rows1 = rows
            self.tableView.reloadData()
        }
    }
    
    func citysBridge(rowsFromSession: [[String: String]]) {
        
    }
}
