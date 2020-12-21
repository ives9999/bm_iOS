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
//            if city_id! > 0 {
//                let session_rows = getAreasFromCity(city_id!) { rows in
//                    //print(rows)
//                    self.rows1Bridge(rowsFromSession: rows)
//                    self.tableView.reloadData()
//                }
//                rows1Bridge(rowsFromSession: session_rows)
//            }
            
            let areas: [Area] = Global.instance.getAreasByCityID(city_id: city_id!)
            rows1Bridge(areas: areas)
        }
    }
    
    func rows1Bridge(areas: [Area]) {
        
        if rows1 != nil && rows1!.count > 0 {
            rows1!.removeAll()
        } else {
            rows1 = [[String: String]]()
        }
        for area in areas {
            let name = area.name
            let id = area.id
            rows1!.append(["title": name, "value": String(id)])
        }
    }
}
