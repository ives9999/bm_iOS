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
    
    let _sections: [String] = ["", "聯絡資訊", "所在地", "打球時間", "臨打說明", "其他說明"]
    let _rows: [[String]] = [
    [NAME_KEY],
    [TEAM_LEADER_KEY,MOBILE_KEY,EMAIL_KEY],
    [CITY_KEY,ARENA_KEY],
    [TEAM_DAYS_KEY,TEAM_PLAY_START_KEY,TEAM_PLAY_END_KEY],
    [TEAM_TEMP_FEE_M_KEY,TEAM_TEMP_FEE_F_KEY,TEAM_TEMP_CONTENT_KEY],
    [TEAM_BALL_KEY,TEAM_DEGREE_KEY,CHARGE_KEY,CONTENT_KEY]
    ]
    
    override var textKeys:[String] {
        get { return [CHARGE_KEY,CONTENT_KEY]}
        set{}
    }
    
    override var cat_id: Int{
        get { return 17}
        set {}
    }
    
    override init(){
        super.init()
        sections = _sections
        rows = _rows
        initData()
    }
    required init(id: Int, name: String) {
        super.init(id: id, title: name, path: "", token: "")
        sections = _sections
        rows = _rows
    }
    required override init(id: Int, title: String, path: String, token: String, youtube: String = "", vimeo: String = "") {
        super.init(id: id, title: title, path: path, token: token)
        sections = _sections
        rows = _rows
    }
    
    override func initData() {
        data = [
            ID_KEY:["ch":"編號","vtype":"Int","value":-1,"show":""],
            NAME_KEY:["ch":"姓名","vtype":"String","atype":none,"value":"","show":"","submit":true,"keyboardType":defaultPad,"text_field":true],
            CHANNEL_KEY:["ch":"頻道","vtype":"String","value":"","show":"","submit":false],
            TEL_KEY:["ch":"電話","vtype":"String","atype":none,"value":"","show":"","submit":true,"keyboardType":numberPad,"text_field":true],
            FB_KEY:["ch":"FB","vtype":"String","atype":none,"value":"","show":"","submit":true,"keyboardType":defaultPad,"text_field":true],
            WEBSITE_KEY:["ch":"網站","vtype":"String","atype":none,"value":"","show":"","submit":true,"keyboardType":defaultPad,"text_field":true],
            EMAIL_KEY:["ch":"email","vtype":"String","atype":none,"value":"","show":"","submit":true,"keyboardType":emailPad,"text_field":true],
            ARENA_OPEN_TIME_KEY:["ch":"營業開始時間","vtype":"String","atype":more,"value":"","show":"","segue":TO_SELECT_TIME,"sender":[String: Any](),"submit":true],
            ARENA_CLOSE_TIME_KEY:["ch":"營業結束時間","vtype":"String","atype":more,"value":"","show":"","segue":TO_SELECT_TIME,"sender":[String: Any](),"submit":true],
            ARENA_INTERVAL_KEY:["ch":"營業時間","vtype":"String","value":"","show":"","submit":false],
            ARENA_BLOCK_KEY:["ch":"場地","vtype":"Int","atype":none,"value":0,"show":"","submit":true,"keyboardType":numberPad,"text_field":true],
            CITY_KEY:["ch":"縣市","vtype":"String","atype":more,"value":"","show":"","segue":TO_CITY,"sender":0,"submit":true],
            AREA_KEY:["ch":"區域","vtype":"String","atype":more,"value":"","show":"","segue":TO_AREA,"sender":0,"submit":true],
            ROAD_KEY:["ch":"路名","vtype":"String","atype":none,"value":"","show":"","submit":true,"keyboardType":defaultPad,"text_field":true],
            ADDRESS_KEY:["ch":"住址","vtype":"String","value":"","show":"","submit":false],
            ZIP_KEY:["ch":"郵遞區號","vtype":"String","value":"","show":"","submit":false],
            ARENA_AIR_CONDITION_KEY:["ch":"冷氣","vtype":"Boolean","atype":none,"value":false,"show":"","submit":true],
            ARENA_PARKING_KEY:["ch":"停車位","vtype":"Int","atype":none,"value":0,"show":"","submit":true],
            ARENA_BATHROOM_KEY:["ch":"浴室","vtype":"Int","atype":none,"value":0,"show":"","submit":true],
            CHARGE_KEY:["ch":"收費標準","vtype":"String","atype":more,"value":"","show":"","segue":TO_TEXT_INPUT,"sender":[String: Any](),"submit":true],
            CONTENT_KEY:["ch":"詳細說明","vtype":"String","atype":more,"value":"","show":"","segue":TO_TEXT_INPUT,"sender":[String: Any](),"submit":true],
            MANAGER_ID_KEY:["ch":"","vtype":"Int","value":0,"show":"","submit":false],
            SLUG_KEY:["ch":"插槽","vtype":"String","value":"","show":"","submit":false],
            PV_KEY:["ch":"瀏覽數","vtype":"Int","value":0,"show":""],
            SORT_ORDER_KEY:["ch":"","vtype":"Int","value":0,"show":""],
            COLOR_KEY:["ch":"","vtype":"String","value":"","show":"","submit":false],
            STATUS_KEY:["ch":"狀態","vtype":"String","value":"","show":"","submit":false],
            TOKEN_KEY:["ch":"","vtype":"String","value":"","show":"","submit":false],
            CREATED_ID_KEY:["ch":"建立者","vtype":"Int","value":0,"show":""],
            CREATED_AT_KEY:["ch":"建立時間","vtype":"String","value":"","show":"","submit":false],
            UPDATED_AT_KEY:["ch":"最後一次修改時間","vtype":"String","value":"","show":"","submit":false],
            FEATURED_KEY:["ch":"代表圖","vtype":"image","value":UIImage(named: "nophoto")!,"path":"","submit":false,"show":""]
        ]
        
        for (key, _) in data {
            data[key]!["show"] = "未提供"
            data[key]!["change"] = false
        }
        setSectionAndRow()
        for (key, _) in data {
            data[key]!["key"] = key
        }
    }
    
    override func listReset() {
        initData()
    }
    
    override func updateInterval(_ _openTime: String? = nil, _ _closeTime: String? = nil) {
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
