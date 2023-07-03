//
//  Dictionary.swift
//  bm
//
//  Created by ives on 2023/5/12.
//  Copyright © 2023 bm. All rights reserved.
//

import Foundation
extension Dictionary {
    
    mutating func merge(_ other: Dictionary) {
        for (key, value) in other {
            self.updateValue(value, forKey: key)
        }
    }
    
    func toJSONString()-> String {
        var json: String = "{"
        var tmps: [String] = [String]()
        for (key, value) in self {
            let str = "\"\(key)\":\"\(value)\""
            
            tmps.append(str)
        }
        json += tmps.joined(separator: ",")
        json += "}"
        
        return json
    }
    
    func toJSON1()-> String? {
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: self,
            options: []) {
            var theJSONText = String(data: theJSONData,
                                     encoding: .utf8)
            theJSONText = theJSONText!.replace(target: "\\", withString: "")
            return theJSONText
        }
        return nil
    }
    
    func keyExist(key: String)-> Bool {
        var isExist = false
        for (idx, _) in self {
            if let key1 = idx as? String {
                if key == key1 {
                    isExist = true
                    break
                }
            }
        }
        
        return isExist
    }
    
    func toJson() -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: []) else {
            return nil
        }
        
        var res: String? = String(data: data, encoding: String.Encoding.utf8)
        if res != nil {
            res = res!.replace(target: "\\", withString: "")
        }
        
        return res
    }
}
