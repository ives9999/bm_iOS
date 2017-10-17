//
//  Team.swift
//  bm
//
//  Created by ives on 2017/10/17.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

struct Team {
    var id: Int
    var name: String
    var featured: UIImage
    var path: String
    var token: String
    
    init(id: Int, name: String, path: String, token: String) {
        self.id = id
        self.name = name
        self.path = path
        self.featured = UIImage()
        self.token = token
    }
}
