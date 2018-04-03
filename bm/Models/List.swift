//
//  Team.swift
//  bm
//
//  Created by ives on 2017/10/17.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

struct List {
    var id: Int
    var title: String
    var featured: UIImage
    var path: String
    var token: String
    var youtube: String
    var vimeo: String
    
    init(id: Int, title: String, path: String, token: String, youtube: String = "", vimeo: String = "") {
        self.id = id
        self.title = title
        self.path = path
        self.featured = UIImage(named: "nophoto")!
        self.token = token
        self.vimeo = vimeo
        self.youtube = youtube
    }
}
