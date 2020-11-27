//
//  AreaFormItem.swift
//  bm
//
//  Created by ives on 2020/11/23.
//  Copyright © 2020 bm. All rights reserved.
//

import Foundation

class AreaFormItem: FormItem {
    
    var selected_area_ids:[Int] = [Int]()
    var selected_area_names: [String] = [String]()
    var city_id: Int?
    
    var areasFromCache:[[String: String]] = [[String: String]]()
    let session: UserDefaults = UserDefaults.standard
    
    required init(name: String = AREA_KEY, title: String = "區域") {
        super.init(name: name, title: title, placeholder: nil, value: nil)
        segue = TO_SINGLE_SELECT
        uiProperties.cellType = .more
    
        reset()
    }
    
    override func reset() {
        super.reset()
        value = nil
        selected_area_ids.removeAll()
        selected_area_names.removeAll()
        make()
    }
    
    override func make() {
        
        //value is a number string by divide ,
        if city_id != nil {
            if session.getAreasByCity(city_id!).count > 0 {
                areasFromCache = session.getAreasByCity(city_id!)
            }
        }
        valueToAnother()
        if selected_area_names.count > 0 {
            show = selected_area_names.joined(separator: ",")
        } else {
            show = ""
        }
        if selected_area_ids.count > 0 {
            sender = (selected_area_ids.map{String($0)}).joined(separator: ",")
            value = (sender as! String)
        } else {
            sender = nil
        }
    }
    
    override func valueToAnother() {
        if value != nil && value!.count > 0 {
            let tmps: [String] = value!.components(separatedBy: ",")
            for tmp in tmps {
                for area in areasFromCache {
                    if area["id"] == tmp {
                        selected_area_names.append(area["name"]!)
                        break
                    }
                }
                if let n: Int = Int(tmp) {
                    selected_area_ids.append(n)

                }
            }
        }
    }
}
