//
//  Dictionary.swift
//  bm
//
//  Created by ives on 2023/5/12.
//  Copyright © 2023 bm. All rights reserved.
//

import Foundation
extension Dictionary {
    
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
