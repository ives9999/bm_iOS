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
            //session.removeObject(forKey: "areas")
            rows1 = session.getAreas(city_id!)
            //print(rows1)
            //let areas: [String: Any] = 
            if rows1!.count == 0 {
                if city_id != nil && city_id! > 0 {
                    getAreasFromCity(city_id!) { rows in
                        self.rows1 = rows
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    
}
