//
//  Data.swift
//  bm
//
//  Created by ives on 2023/5/4.
//  Copyright © 2023 bm. All rights reserved.
//

import Foundation

extension Data {
    func toString()-> String {
        return String(decoding: self, as: UTF8.self)
    }
}
