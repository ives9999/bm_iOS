//
//  Table.swift
//  bm
//
//  Created by ives on 2021/3/15.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class Table: Codable {
    
    public func filterRow(){
//        if featured_path.count > 0 {
//            if !featured_path.hasPrefix("http://") || !featured_path.hasPrefix("https://") {
//                featured_path = BASE_URL + featured_path
//                //print(featured_path)
//            }
//        }
    }
    
    public func printRow() {
        let mirror: Mirror? = Mirror(reflecting: self)
        for property in mirror!.children {
            print("\(property.label ?? "")=>\(property.value)")
        }
    }
}
