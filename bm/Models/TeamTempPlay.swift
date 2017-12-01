//
//  TeamTempPlay.swift
//  bm
//
//  Created by ives on 2017/12/1.
//  Copyright © 2017年 bm. All rights reserved.
//

import Foundation

class TeamTempPlay {
    static let instance = TeamTempPlay()
    let sections: [String] = ["臨打開關"]
    let rows: [[Dictionary<String, String>]] = [
        [
            ["key": TEAM_TEMP_STATUS_KEY]
        ]
    ]
    
    var data: Dictionary<String, [String: Any]>?
    
    init() {
        data = [
            TEAM_ID_KEY:["ch":"編號","vtype":"Int","value":-1,"show":""],
        TEAM_TEMP_STATUS_KEY:["ch":"臨打狀態","vtype":"String","value":"off","show":"off"]
        ]
        for (section, value1) in rows.enumerated() {
            for (row, value2) in value1.enumerated() {
                let key: String = value2["key"]!
                for (key1, _) in data! {
                    if key == key1 {
                        data![key1]!["section"] = section
                        data![key1]!["row"] = row
                    }
                }
            }
        }
        for (key, _) in data! {
            data![key]!["key"] = key
        }
    }
}
