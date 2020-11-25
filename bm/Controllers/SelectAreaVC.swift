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
        
        super.viewDidLoad()
        
        //print(selected)
        //rows1 = session.getArrayDictionary("citys")
        //if rows1!.count == 0 {
        if city_id != nil && city_id! > 0 {
            getAreasFromCity(city_id!) { rows in
                self.rows1 = rows
                self.tableView.reloadData()
            }
        }
        //}
    }
}
