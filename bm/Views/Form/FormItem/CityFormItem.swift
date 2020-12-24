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
    
    //var citysFromCache:[[String: String]] = [[String: String]]()
    //let session: UserDefaults = UserDefaults.standard
    
    required init(name: String = CITY_ID_KEY, title: String = "縣市", isRequire: Bool = false) {
        super.init(name: name, title: title, placeholder: nil, value: nil, isRequired: isRequire)
        //segue = TO_SINGLE_SELECT
        uiProperties.cellType = .more
        self.isRequired = isRequire
        
//        if session.array(forKey: "citys") != nil {
//            citysFromCache = (session.array(forKey: "citys") as! [[String: String]])
//        }
        reset()
    }
    
    override func reset() {
        super.reset()
        value = nil
        selected_city_ids.removeAll()
        selected_city_names.removeAll()
        make()
    }
    
    override func make() {
        
        //value is a number string by divide ,
        valueToAnother()
        if selected_city_names.count > 0 {
            show = selected_city_names.joined(separator: ",")
        } else {
            show = ""
        }
        if selected_city_ids.count > 0 {
            sender = (selected_city_ids.map{String($0)}).joined(separator: ",")
            value = (sender as! String)
        } else {
            sender = nil
        }
    }
    
    //parse value to array
    override func valueToAnother() {
        //value is 1,2,3 or 1 is city id
        if value != nil && value!.count > 0 {
            let tmps: [String] = value!.components(separatedBy: ",")
            let citys: [City] = Global.instance.getCitys()
            for tmp in tmps {
                for city in citys {
                    if city.id == Int(tmp) {
                        selected_city_names.append(city.name)
                    }
                }
                
                
//                for city in citysFromCache {
//                    if city["id"] == tmp {
//                        selected_city_names.append(city["name"]!)
//                        break
//                    }
//                }
                if let n: Int = Int(tmp) {
                    selected_city_ids.append(n)
                    
                }
            }
        }
    }
}
