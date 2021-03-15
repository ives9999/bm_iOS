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
    
    enum SuperError: Error {
        
        case parseError
    }
    
    public static func parse<T: SuperModel>(data: JSON) -> T {
        var d: [String: Any] = [String: Any]()
        for (key, value) in data {
            //print("\(key)=>\(value)")
            d[key] = value
        }
        return T(dict: d) 
    }
    
    public static func parse<T: SuperModel>(data: JSON, l: Int) throws -> T {
        
        let d: [String: Any] = jsonToDictionary(data)
        let t: T = T(dict: d)
        //throw SuperError.parseError
        return t
    }
    
    private static func jsonToDictionary(_ data: JSON)-> [String: Any] {
        
        var d: [String: Any] = [String: Any]()
        for (key, value) in data {
            //print("\(key)=>\(value)")
            d[key] = value
        }
        return d
    }
}

















