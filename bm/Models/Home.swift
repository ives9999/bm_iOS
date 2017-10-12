//
//  Home.swift
//  bm
//
//  Created by ives on 2017/10/4.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

struct Home {
    
    var title: String
    var featured: UIImage
    var youtube: String
    var vimeo: String
    var path: String
    
    init(title: String, path: String, youtube: String, vimeo: String) {
        self.title = title
        self.path = path
        self.youtube = youtube
        self.vimeo = vimeo
        self.featured = UIImage()
    }
}

