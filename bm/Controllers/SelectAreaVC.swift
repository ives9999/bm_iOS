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
                    self.rows1Bridge(rowsFromSession: rows)
                    self.tableView.reloadData()
                }
                rows1Bridge(rowsFromSession: session_rows)
            }
        }
    }
}
