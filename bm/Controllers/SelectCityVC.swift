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
        rows1 = session.getArrayDictionary("citys")
        if rows1!.count == 0 {
            getCitys() { rows in
                self.rows1 = rows
                self.tableView.reloadData()
            }
        }
    }
}
