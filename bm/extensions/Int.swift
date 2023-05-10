//
//  Int.swift
//  bm
//
//  Created by ives on 2023/2/22.
//  Copyright © 2023 bm. All rights reserved.
//

import Foundation

extension Int {
    
    func numberToChinese() -> String {
        switch (self) {
        case 1:
            return "一"
        case 2:
            return "二"
        case 3:
            return "三"
        case 4:
            return "四"
        case 5:
            return "五"
        case 6:
            return "六"
        case 7:
            return "七"
        case 8:
            return "八"
        case 9:
            return "九"
        case 10:
            return "十"
        default:
            return ""
        }
    }
    
    
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
