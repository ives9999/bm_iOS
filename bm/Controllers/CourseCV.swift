//
//  CourseCV.swift
//  bm
//
//  Created by ives on 2017/10/22.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class CourseCV: ListVC {
    
    let _type:String = "course"
        
    override func viewDidLoad() {
        setIden(item:_type)
        super.viewDidLoad()
        getData(type: _type, titleField: "title")
    }
}
