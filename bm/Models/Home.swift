//
//  Home.swift
//  bm
//
//  Created by ives on 2017/10/4.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

struct Home {
    
    var id: Int
    var title: String
    var featured: UIImage
    var youtube: String
    var vimeo: String
    var path: String
    var token: String
    var type: String
    
    init(id: Int, title: String, path: String, youtube: String, vimeo: String, token: String, type: String) {
        self.id = id
        self.title = title
        self.path = path
        self.youtube = youtube
        self.vimeo = vimeo
        self.featured = UIImage()
        self.token = token
        self.type = type
    }
}

