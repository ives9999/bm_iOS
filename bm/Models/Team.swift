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
    var title: String
    var featured: UIImage
    var path: String
    var token: String
    
    init(id: Int, title: String, path: String, token: String) {
        self.id = id
        self.title = title
        self.path = path
        self.featured = UIImage()
        self.token = token
    }
}
