//
//  Int.swift
//  bm
//
//  Created by ives on 2023/2/22.
//  Copyright © 2023 bm. All rights reserved.
//

import Foundation

extension Int {
    
    func toTwoString()-> String {
        
        let s: String = String(self)
        let count: Int = s.count
        
        switch (count) {
        case 1:
            return "0\(s)"
        default:
            return s
        }
    }
}
