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
//        if value != nil && value!.count > 0 {
//            let tmps: [String] = value!.components(separatedBy: ",")
//            for tmp in tmps {
//                for city in citysFromCache {
//                    if city["value"] == tmp {
//                        selected_city_names.append(city["title"]!)
//                        break
//                    }
//                }
//                if let n: Int = Int(tmp) {
//                    selected_city_ids.append(n)
//
//                }
//            }
//        }
    }
}
