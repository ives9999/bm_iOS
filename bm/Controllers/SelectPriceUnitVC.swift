//
//  SelectPriceUnitVC.swift
//  bm
//
//  Created by ives sun on 2021/7/2.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class SelectPriceUnitVC: SingleSelectVC {
    
    override func viewDidLoad() {
        myTablView = tableView
        title = "收費週期"
        super.viewDidLoad()
        
        //print(selected)
//        let session_rows = getCitys() { rows in
//            //print(rows)
//            self.rows1Bridge(rowsFromSession: rows)
//            self.tableView.reloadData()
//        }
        rows1 = PRICE_UNIT.makeSelect()
    }
}
