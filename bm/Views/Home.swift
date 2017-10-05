//
//  Home.swift
//  bm
//
//  Created by ives on 2017/10/4.
//  Copyright © 2017年 bm. All rights reserved.
//

import Foundation

struct Home {
    private(set) public var featured: String
    private(set) public var title: String
    
    init(featured: String, title: String) {
        self.featured = featured
        self.title = title
    }
}
