//
//  SelectAreasVC.swift
//  bm
//
//  Created by ives sun on 2020/11/25.
//  Copyright © 2020 bm. All rights reserved.
//

import Foundation

class SelectAreasVC: MultiSelectVC {
    
    var city_ids: [Int]?
    override func viewDidLoad() {
        myTablView = tableView
        title = "區域"
        
        //print(selected)
        if city_ids != nil {
            super.viewDidLoad()

            //print(selected)
            if city_ids!.count > 0 {
                let session_rows = getAreasFromCitys(city_ids!) { rows in
                    //print(rows)
                    //self.rows1Bridge(rowsFromSession: rows)
                    self.tableView.reloadData()
                }
                //rows1Bridge(rowsFromSession: session_rows)
            }
        }
    }
}
