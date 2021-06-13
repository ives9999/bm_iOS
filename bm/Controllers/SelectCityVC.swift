//
//  CitySelect1VC.swift
//  bm
//
//  Created by ives on 2020/11/24.
//  Copyright © 2020 bm. All rights reserved.
//

import Foundation

class SelectCityVC: SingleSelectVC {
    
    //var selecteds: [String] = [String]()
    
    override func viewDidLoad() {
        myTablView = tableView
        title = "縣市"
        super.viewDidLoad()
        
        //print(selected)
//        let session_rows = getCitys() { rows in
//            //print(rows)
//            self.rows1Bridge(rowsFromSession: rows)
//            self.tableView.reloadData()
//        }
        let citys: [City] = Global.instance.getCitys()
        rows1Bridge(citys: citys)
    }
    
    func rows1Bridge(citys: [City]) {
        
        if rows1 != nil && rows1!.count > 0 {
            rows1!.removeAll()
        } else {
            rows1 = [[String: String]]()
        }
        for city in citys {
            let name = city.name
            let id = city.id
            rows1!.append(["title": name, "value": String(id)])
        }
    }
}
