//
//  SelectCitysVC.swift
//  bm
//
//  Created by ives sun on 2020/11/24.
//  Copyright © 2020 bm. All rights reserved.
//

import Foundation

class SelectCitysVC: MultiSelectVC {
    
    override func viewDidLoad() {
        myTablView = tableView
        title = "縣市"
        super.viewDidLoad()
        
        //print(selected)
//        rows1 = session.getArrayDictionary("citys")
//        if rows1!.count == 0 {
//            getCitys() { rows in
//                self.rows1 = rows
//                self.tableView.reloadData()
//            }
//        }
        
        let citys: [City] = Global.instance.getCitys()
        rows1Bridge(citys: citys)
    }
    
    func rows1Bridge(citys: [City]) {
        
        if rows1!.count > 0 {
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
