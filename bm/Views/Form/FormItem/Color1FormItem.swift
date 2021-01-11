//
//  Color1FormItem.swift
//  bm
//
//  Created by ives on 2021/1/9.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class Color1FormItem: FormItem {
    
    var colors: [String: String]?
    
    required init(name: String = COLOR_KEY, title: String = "顏色", isRequire: Bool = false) {
        super.init(name: name, title: title, placeholder: nil, value: nil, isRequired: isRequire)
        //segue = TO_SINGLE_SELECT
        uiProperties.cellType = .color1
        self.isRequired = isRequire
        
//        if session.array(forKey: "citys") != nil {
//            citysFromCache = (session.array(forKey: "citys") as! [[String: String]])
//        }
        reset()
    }
    
    func setColors(colors: [String: String]) {
        self.colors = colors
    }
    
    override func reset() {
        super.reset()
        value = nil
        make()
    }
    
    override func make() {
        
        //value is a number string by divide ,
        valueToAnother()
//        if selected_city_names.count > 0 {
//            show = selected_city_names.joined(separator: ",")
//        } else {
//            show = ""
//        }
//        if selected_city_ids.count > 0 {
//            sender = (selected_city_ids.map{String($0)}).joined(separator: ",")
//            value = (sender as! String)
//        } else {
//            sender = nil
//        }
    }
    
    //parse value to array
    override func valueToAnother() {
        //value is 1,2,3 or 1 is city id
        if value != nil && value!.count > 0 {
            
        }
    }
}
