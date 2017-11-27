//
//  Team.swift
//  bm
//
//  Created by ives on 2017/11/9.
//  Copyright © 2017年 bm. All rights reserved.
//

import Foundation

class Team {
    static let instance = Team()
    let sections: [String] = ["", "聯絡資訊", "所在地", "打球時間", "臨打說明", "其他說明"]
    let rows: [[Dictionary<String, String>]] = [
        [
            ["key": TEAM_NAME_KEY]
        ],
        [
            ["key": TEAM_LEADER_KEY],["key": TEAM_MOBILE_KEY],["key": TEAM_EMAIL_KEY]
        ],
        [
            ["key": TEAM_CITY_KEY],["key": TEAM_ARENA_KEY]
        ],
        [
            ["key": TEAM_DAY_KEY],["key": TEAM_PLAY_START_KEY],["key": TEAM_PLAY_END_KEY]
        ],
        [
            ["key": TEAM_TEMP_FEE_M_KEY],["key": TEAM_TEMP_FEE_F_KEY],["key": TEAM_TEMP_CONTENT_KEY]
        ],
        [
            ["key": TEAM_BALL_KEY],["key": TEAM_DEGREE_KEY],["key": TEAM_CHARGE_KEY],["key": TEAM_CONTENT_KEY]
        ]
    ]
    var data:Dictionary<String, [String: Any]> = Dictionary<String, [String: Any]>()
    init() {
        let none: UITableViewCellAccessoryType = UITableViewCellAccessoryType.none
        let more: UITableViewCellAccessoryType = UITableViewCellAccessoryType.disclosureIndicator
        data = [
            TEAM_ID_KEY:["ch":"編號","vtype":"Int","value":-1,"use":true,"show":""],
            TEAM_CHANNEL_KEY:["ch":"頻道","vtype":"String","value":"","use":false,"show":""],
            TEAM_NAME_KEY:["ch":"名稱","vtype":"String","value":"","use":true,"atype":none,"show":""],
            TEAM_LEADER_KEY:["ch":"隊長","vtype":"String","value":"","use":true,"atype":none,"show":""],
            TEAM_MOBILE_KEY:["ch":"電話","vtype":"String","value":"","use":true,"atype":none,"show":""],
            TEAM_EMAIL_KEY:["ch":"EMail","vtype":"String","value":"","use":true,"atype":none,"show":""],
            TEAM_WEBSITE_KEY:["ch":"網站","vtype":"String","value":"","use":false,"show":""],
            TEAM_FB_KEY:["ch":"FB","vtype":"String","value":"","use":false,"show":""],
            TEAM_YOUTUBE_KEY:["ch":"youtube","vtype":"String","value":"","use":false,"show":""],
            TEAM_PLAY_START_KEY:["ch":"開始時間","vtype":"String","value":"","use":true,"atype":more,"iden":TO_SELECT_TIME,"show":""],
            TEAM_PLAY_END_KEY:["ch":"結束時間","vtype":"String","value":"","use":true,"atype":more,"iden":TO_SELECT_TIME,"show":""],
            TEAM_BALL_KEY:["ch":"使用球種","vtype":"String","value":"","use":true,"atype":more,"show":""],
            TEAM_DEGREE_KEY:["ch":"球隊程度","vtype":"array","value":[String](),"use":true,"atype":more,"iden":TO_SELECT_DEGREE,"show":""],
            TEAM_SLUG_KEY:["ch":"插槽","vtype":"String","value":"","use":true,"show":""],
            TEAM_CHARGE_KEY:["ch":"收費說明","vtype":"String","value":"","use":true,"atype":more,"iden":TO_TEXT_INPUT,"show":""],
            TEAM_CONTENT_KEY:["ch":"球隊說明","vtype":"String","value":"","use":true,"atype":more,"iden":TO_TEXT_INPUT,"show":""],
            TEAM_MANAGER_ID_KEY:["ch":"管理者編號","vtype":"Int","value":-1,"use":true,"show":""],
            TEAM_TEMP_FEE_M_KEY:["ch":"臨打費用：男","vtype":"Int","value":-1,"use":true,"atype":none,"show":""],
            TEAM_TEMP_FEE_F_KEY:["ch":"臨打費用：女","vtype":"Int","value":-1,"use":true,"atype":none,"show":""],
            TEAM_TEMP_QUANTITY_KEY:["ch":"臨打人數","vtype":"Int","value":-1,"use":false,"show":""],
            TEAM_TEMP_CONTENT_KEY:["ch":"臨打說明","vtype":"String","value":"","use":true,"atype":more,"iden":TO_TEXT_INPUT,"show":""],
            TEAM_TEMP_STATUS_KEY:["ch":"臨打狀態","vtype":"String","value":"","use":false,"show":""],
            TEAM_PV_KEY:["ch":"瀏覽數","vtype":"Int","value":-1,"use":false,"show":""],
            TEAM_TOKEN_KEY:["ch":"球隊token","vtype":"String","value":"","use":false,"show":""],
            TEAM_CREATED_ID_KEY:["ch":"建立者","vtype":"Int","value":-1,"use":true,"show":""],
            TEAM_CREATED_AT_KEY:["ch":"建立時間","vtype":"String","value":"","use":false,"show":""],
            TEAM_UPDATED_AT_KEY:["ch":"最後一次修改時間","vtype":"String","value":"","use":false,"show":""],
            TEAM_THUMB_KEY:["ch":"代表圖","vtype":"String","value":"","use":false,"show":""],
            TEAM_CITY_KEY:["ch":"區域","vtype":"array","value":[String:Any](),"use":false,"atype":more,"iden":TO_CITY,"show":""],
            TEAM_ARENA_KEY:["ch":"球館","vtype":"array","value":[String:Any](),"use":false,"atype":more,"iden":TO_ARENA,"show":""],
            TEAM_DAY_KEY:["ch":"星期幾","vtype":"array","value":[Int](),"use":false,"atype":more,"iden":TO_DAY,"show":""],
            TEAM_FEATURED_KEY:["ch":"代表圖","vtype":"image","value":UIImage(),"path":"","use":false,"show":""]
        ]
        
        for (key, _) in data {
            data[key]!["key"] = key
        }
        for (section, value1) in rows.enumerated() {
            for (row, value2) in value1.enumerated() {
                let key: String = value2["key"]!
                for (key1, _) in data {
                    if key == key1 {
                        data[key1]!["section"] = section
                        data[key1]!["row"] = row
                    }
                }
            }
        }
        //print(data)
    }
    
    func extraShow() {
        daysShow()
        cityShow()
        arenaShow()
    }
    func daysShow() {
        let row: [String: Any] = data[TEAM_DAY_KEY]!
        if row["value"] != nil {
            let days: [Int] = row["value"] as! [Int]
            if days.count > 0 {
                var res: [String] = [String]()
                for day in days {
                    for item in Global.instance.days {
                        let idx: Int = item["value"] as! Int
                        let text: String = item["text"] as! String
                        if idx == day {
                            res.append(text)
                        }
                    }
                }
                let show: String = res.joined(separator: ",")
                data[TEAM_DAY_KEY]!["show"] = show
            }
        }
    }
    func cityShow() {
        
    }
    func arenaShow() {
        
    }
}
