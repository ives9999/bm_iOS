//
//  CityFormItem.swift
//  bm
//
//  Created by ives on 2020/11/22.
//  Copyright © 2020 bm. All rights reserved.
//

import Foundation

class CityFormItem: FormItem {
    
    var selected_city_ids:[Int] = [Int]()
    var selected_city_names: [String] = [String]()
    var citysFromCache:[[String: String]] = [[String: String]]()
    
    let session: UserDefaults = UserDefaults.standard
    
    required init(name: String = CITY_KEY, title: String = "縣市") {
        super.init(name: name, title: title, placeholder: nil, value: nil)
        segue = TO_SINGLE_SELECT
        uiProperties.cellType = .more
        
        if session.array(forKey: "citys") != nil {
            citysFromCache = (session.array(forKey: "citys") as! [[String: String]])
        }
        reset()
    }
    
    override func reset() {
        super.reset()
        value = nil
        make()
    }
    
    override func make() {
        
        //value is a number string by divide ,
        valueToAnother()
        if value != nil && value!.count > 0 {
            let tmps: [String] = value!.components(separatedBy: ",")
            for tmp in tmps {
                for city in citysFromCache {
                    if city["value"] == tmp {
                        selected_city_names.append(city["title"]!)
                        break
                    }
                }
                if let n: Int = Int(tmp) {
                    selected_city_ids.append(n)
                    
                }
            }
            show = selected_city_names.joined(separator: ",")
            sender = (selected_city_ids.map{String($0)}).joined(separator: ",")
        } else {
            value = nil
            show = ""
            sender = nil
        }
    }
}
