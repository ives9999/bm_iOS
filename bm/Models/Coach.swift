//
//  Coach.swift
//  bm
//
//  Created by ives on 2018/7/24.
//  Copyright © 2018年 bm. All rights reserved.
//

import Foundation
class Coach: SuperData {
    static let instance = Coach()
    
    func initData() {
        data = [
            ID_KEY:["ch":"編號","vtype":"Int","value":-1,"show":""],
            NAME_KEY:["ch":"姓名","vtype":"String","value":"","show":""],
            CHANNEL_KEY:["ch":"頻道","vtype":"String","value":"","show":""],
            WEBSITE_KEY:["ch":"網站","vtype":"String","value":"","show":""],
            FB_KEY:["ch":"FB","vtype":"String","value":"","show":""],
            YOUTUBE_KEY:["ch":"youtube","vtype":"String","value":"","show":""],
            MOBILE_KEY:["ch":"行動電話","vtype":"String","value":"","show":""],
            EMAIL_KEY:["ch":"email","vtype":"String","value":"","show":""],
            LINE_KEY:["ch":"line id","vtype":"String","value":"","show":""],
            SLUG_KEY:["ch":"插槽","vtype":"String","value":"","show":""],
            CITY_KEY:["ch":"區域","vtype":"array","value":0,"show":""],
            COACH_SENIORITY_KEY:["ch":"年資","vtype":"Int","value":-1,"show":""],
            COACH_EXP_KEY:["ch":"經歷","vtype":"String","value":"","show":""],
            COACH_FEAT_KEY:["ch":"比賽成績","vtype":"String","value":"","show":""],
            COACH_LICENSE_KEY:["ch":"證照","vtype":"String","value":"","show":""],
            COACH_CHARGE_KEY:["ch":"收費標準","vtype":"String","value":"","show":""],
            CONTENT_KEY:["ch":"內容","vtype":"String","value":"","show":""],
            MANAGER_ID_KEY:["ch":"","vtype":"Int","value":0,"show":""],
            SORT_ORDER_KEY:["ch":"","vtype":"Int","value":0,"show":""],
            PV_KEY:["ch":"瀏覽數","vtype":"Int","value":0,"show":""],
            COLOR_KEY:["ch":"","vtype":"String","value":"","show":""],
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
