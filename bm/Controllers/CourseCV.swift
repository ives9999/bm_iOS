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
        setIden(item:_type, titleField: "title")
        super.viewDidLoad()
        refresh()
    }
    @IBAction func prevBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
