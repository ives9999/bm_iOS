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
        ["ch":"關鍵字","atype":UITableViewCellAccessoryType.none,"key":"keyword","show":"","hint":"請輸入球隊名稱關鍵字","text_field":true],
        ["ch":"縣市","atype":UITableViewCellAccessoryType.disclosureIndicator,"key":CITY_KEY,"show":"全部","segue":TO_CITY,"sender":0],
        ["ch":"區域","atype":UITableViewCellAccessoryType.disclosureIndicator,"key":AREA_KEY,"show":"全部","segue":TO_AREA,"sender":0],
        ["ch":"空調","atype":UITableViewCellAccessoryType.none,"key":ARENA_AIR_CONDITION_KEY,"show":"全部","segue":"","sender":0,"switch":true],
        ["ch":"盥洗室","atype":UITableViewCellAccessoryType.none,"key":ARENA_BATHROOM_KEY,"show":"全部","segue":"","sender":0,"switch":true],
        ["ch":"停車場","atype":UITableViewCellAccessoryType.none,"key":ARENA_PARKING_KEY,"show":"全部","segue":"","sender":0,"switch":true],
        ]
        
    override func viewDidLoad() {
        dataService = CourseService.instance
        setIden(item:_type, titleField: "title")
        super.viewDidLoad()
        refresh()
    }
    @IBAction func prevBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func searchBtnPressed(_ sender: Any) {
        //showSearchPanel()
    }
}
