//
//  JSONParse.swift
//  bm
//
//  Created by ives on 2018/6/25.
//  Copyright © 2018年 bm. All rights reserved.
//

import Foundation
import SwiftyJSON
 
class JSONParse {
    public static func parse<T: SuperModel>(data: JSON) -> T {
        var d: [String: Any] = [String: Any]()
        for (key, value) in data {
            //print("\(key)=>\(value)")
            d[key] = value
        }
        return T(dict: d) 
    }
}

















