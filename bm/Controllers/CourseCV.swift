//
//  CourseCV.swift
//  bm
//
//  Created by ives on 2017/10/22.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class CourseCV: CollectionVC {
    
    let _type:String = "course"
    
    let _searchRows: [[String: Any]] = [
        ["ch":"關鍵字","atype":UITableViewCellAccessoryType.none,"key":"keyword","show":"","hint":"請輸入教學名稱關鍵字","text_field":true]
        ]
        
    override func viewDidLoad() {
        dataService = CourseService.instance
        searchRows = _searchRows
        setIden(item:_type, titleField: "title")
        super.viewDidLoad()
        refresh()
    }
    @IBAction func prevBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func searchBtnPressed(_ sender: Any) {
        showSearchPanel()
    }
}
