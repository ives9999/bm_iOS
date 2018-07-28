//
//  Arena.swift
//  bm
//
//  Created by ives on 2017/11/13.
//  Copyright © 2017年 bm. All rights reserved.
//

import Foundation

class Arena: SuperData {
    static let instance = Arena()
    
    override init(){
        super.init()
    }
    required init(id: Int, name: String) {
        super.init(id: id, title: name, path: "", token: "")
    }
    required override init(id: Int, title: String, path: String, token: String, youtube: String = "", vimeo: String = "") {
        super.init(id: id, title: title, path: path, token: token)
    }
    
    func initData() {
        data = [
            ID_KEY:["ch":"編號","vtype":"Int","value":-1,"show":""],
            NAME_KEY:["ch":"姓名","vtype":"String","value":"","show":"","submit":false],
            CHANNEL_KEY:["ch":"頻道","vtype":"String","value":"","show":"","submit":false],
            TEL_KEY:["ch":"電話","vtype":"String","value":"","show":"","submit":false],
            FB_KEY:["ch":"FB","vtype":"String","value":"","show":"","submit":false],
            WEBSITE_KEY:["ch":"網站","vtype":"String","value":"","show":"","submit":false],
            EMAIL_KEY:["ch":"email","vtype":"String","value":"","show":"","submit":false],
            ARENA_OPEN_TIME_KEY:["ch":"營業開始時間","vtype":"String","value":"","show":"","submit":false],
            ARENA_CLOSE_TIME_KEY:["ch":"營業結束時間","vtype":"String","value":"","show":"","submit":false],
            ARENA_INTERVAL_KEY:["ch":"營業時間","vtype":"String","value":"","show":"","submit":false],
            ARENA_BLOCK_KEY:["ch":"場地","vtype":"Int","value":0,"show":"","submit":false],
            CITY_KEY:["ch":"縣市","vtype":"String","value":"","show":"","submit":false],
            AREA_KEY:["ch":"區域","vtype":"String","value":"","show":"","submit":false],
            ROAD_KEY:["ch":"路名","vtype":"String","value":"","show":"","submit":false],
            ZIP_KEY:["ch":"郵遞區號","vtype":"String","value":"","show":"","submit":false],
            ARENA_AIR_CONDITION_KEY:["ch":"冷氣","vtype":"Boolean","value":false,"show":"","submit":false],
            ARENA_PARKING_KEY:["ch":"停車位","vtype":"Int","value":0,"show":"","submit":false],
            ARENA_BATHROOM_KEY:["ch":"浴室","vtype":"Int","value":0,"show":"","submit":false],
            ARENA_CHARGE_KEY:["ch":"收費標準","vtype":"String","value":"","show":"","submit":false],
            CONTENT_KEY:["ch":"內容","vtype":"String","value":"","show":"","submit":false],
            MANAGER_ID_KEY:["ch":"","vtype":"Int","value":0,"show":"","submit":false],
            SLUG_KEY:["ch":"插槽","vtype":"String","value":"","show":"","submit":false],
            PV_KEY:["ch":"瀏覽數","vtype":"Int","value":0,"show":""],
            SORT_ORDER_KEY:["ch":"","vtype":"Int","value":0,"show":""],
            COLOR_KEY:["ch":"","vtype":"String","value":"","show":"","submit":false],
            STATUS_KEY:["ch":"狀態","vtype":"String","value":"","show":"","submit":false],
            TOKEN_KEY:["ch":"","vtype":"String","value":"","show":"","submit":false],
            CREATED_ID_KEY:["ch":"建立者","vtype":"Int","value":0,"show":""],
            CREATED_AT_KEY:["ch":"建立時間","vtype":"String","value":"","show":"","submit":false],
            UPDATED_AT_KEY:["ch":"最後一次修改時間","vtype":"String","value":"","show":"","submit":false]
        ]
        
        for (key, _) in data {
            data[key]!["show"] = "未提供"
        }
    }
    
    override func listReset() {
        initData()
    }
    func updateOpenTime(_ time: String? = nil) {
        if time != nil {
            data[ARENA_OPEN_TIME_KEY]!["value"] = time
        }
        let tmp: String = data[ARENA_OPEN_TIME_KEY]!["value"] as! String
        data[ARENA_OPEN_TIME_KEY]!["show"] = tmp.noSec()
    }
    func updateCloseTime(_ time: String? = nil) {
        if time != nil {
            data[ARENA_CLOSE_TIME_KEY]!["value"] = time
        }
        let tmp: String = data[ARENA_CLOSE_TIME_KEY]!["value"] as! String
        data[ARENA_CLOSE_TIME_KEY]!["show"] = tmp.noSec()
    }
    func updateInterval(_ _openTime: String? = nil, _ _closeTime: String? = nil) {
        var openTime = _openTime
        if openTime == nil {
            openTime = data[ARENA_OPEN_TIME_KEY]!["show"] as? String
        }
        var closeTime = _closeTime
        if closeTime == nil {
            closeTime = data[ARENA_CLOSE_TIME_KEY]!["show"] as? String
        }
        let tmp: String = openTime! + " ~ " + closeTime!
        data[ARENA_INTERVAL_KEY]!["show"] = tmp
    }
}
