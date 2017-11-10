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
    let info: Dictionary<String, [String: String]> = [
        TEAM_ID_KEY: ["ch": "編號", "type": "Int"],
        TEAM_NAME_KEY: ["ch": "名稱", "type": "String"],
        TEAM_LEADER_KEY: ["ch": "隊長", "type": "String"],
        TEAM_MOBILE_KEY: ["ch": "電話", "type": "String"],
        TEAM_EMAIL_KEY: ["ch": "EMail", "type": "String"],
        TEAM_ZONE_ID_KEY: ["ch": "區域", "type": "String"],
        TEAM_ARENA_ID_KEY: ["ch": "球館", "type": "String"],
        TEAM_DAY_KEY: ["ch": "星期幾", "type": "String"],
        TEAM_PLAY_START_KEY: ["ch": "開始時間", "type": "String"],
        TEAM_PLAY_END_KEY: ["ch": "結束時間", "type": "String"],
        TEAM_TEMP_FEE_M_KEY: ["ch": "臨打費用：男", "type": "String"],
        TEAM_TEMP_FEE_F_KEY: ["ch": "臨打費用：女", "type": "String"],
        TEAM_TEMP_CONTENT_KEY: ["ch": "臨打說明", "type": "String"],
        TEAM_BALL_KEY: ["ch": "使用球種", "type": "String"],
        TEAM_DEGREE_KEY: ["ch": "球隊程度", "type": "String"],
        TEAM_CHARGE_KEY: ["ch": "收費說明", "type": "String"],
        TEAM_CONTENT_KEY: ["ch": "球隊說明", "type": "String"]
    ]
}
