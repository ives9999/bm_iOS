//
//  Data.swift
//  bm
//
//  Created by ives on 2023/5/4.
//  Copyright © 2023 bm. All rights reserved.
//

import Foundation

extension Data {
    
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        print(prettyPrintedString)

        return prettyPrintedString
    }
    
    func toString()-> String {
        return String(decoding: self, as: UTF8.self)
    }
}
