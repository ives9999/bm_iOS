//
//  CitySelect1VC.swift
//  bm
//
//  Created by ives on 2020/11/24.
//  Copyright © 2020 bm. All rights reserved.
//

import Foundation

class SelectCityVC: SingleSelectVC {
    
    var selecteds: [String] = [String]()
    
    override func viewDidLoad() {
        myTablView = tableView
        title = "縣市"
        super.viewDidLoad()
        
        //print(selected)
        let session_rows = getCitys() { rows in
            //print(rows)
            self.rows1Bridge(rowsFromSession: rows)
            self.tableView.reloadData()
        }
        rows1Bridge(rowsFromSession: session_rows)
    }
}
