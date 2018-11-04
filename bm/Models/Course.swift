//
//  Course.swift
//  bm
//
//  Created by ives on 2018/7/31.
//  Copyright © 2018年 bm. All rights reserved.
//

import Foundation

class Course: SuperData {
    static let instance = Course()
    
    override func initData() {
        data = [
            ID_KEY:["ch":"編號","vtype":"Int","value":-1,"show":""],
            TITLE_KEY:["ch":"標題","vtype":"String","value":"","show":""],
            CHANNEL_KEY:["ch":"頻道","vtype":"String","value":"","show":""],
            CONTENT_KEY:["ch":"內容","vtype":"String","value":"","show":""],
            SLUG_KEY:["ch":"插槽","vtype":"String","value":"","show":""],
            VIMEO_KEY:["ch":"vimeo","vtype":"String","value":"","show":""],
            YOUTUBE_KEY:["ch":"youtube","vtype":"String","value":"","show":""],
            PV_KEY:["ch":"瀏覽數","vtype":"Int","value":0,"show":""],
            COURSE_PROVIDER_KEY:["ch":"出處","vtype":"String","value":"","show":""],
            SORT_ORDER_KEY:["ch":"","vtype":"Int","value":0,"show":""],
            STATUS_KEY:["ch":"狀態","vtype":"String","value":"","show":""],
            TOKEN_KEY:["ch":"","vtype":"String","value":"","show":""],
            CREATED_ID_KEY:["ch":"建立者","vtype":"Int","value":0,"show":""],
            CREATED_AT_KEY:["ch":"建立時間","vtype":"String","value":"","show":""],
            UPDATED_AT_KEY:["ch":"最後一次修改時間","vtype":"String","value":"","show":""]
        ]
        for (key, _) in data {
            data[key]!["show"] = "未提供"
        }
    }
    
    override func listReset() {
        initData()
    }
}
