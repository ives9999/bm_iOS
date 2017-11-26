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
    var data:Dictionary<String, [String: Any]> = Dictionary<String, [String: Any]>()
    init() {
        let none: UITableViewCellAccessoryType = UITableViewCellAccessoryType.none
        let more: UITableViewCellAccessoryType = UITableViewCellAccessoryType.disclosureIndicator
        data = [
            TEAM_ID_KEY:["ch":"編號","vtype":"Int","value":-1,"use":true],
            TEAM_CHANNEL_KEY:["ch":"頻道","vtype":"String","value":"","use":false],
            TEAM_NAME_KEY:["ch":"名稱","vtype":"String","value":"","use":true,"atype":none],
            TEAM_LEADER_KEY:["ch":"隊長","vtype":"String","value":"","use":true,"atype":none],
            TEAM_MOBILE_KEY:["ch":"電話","vtype":"String","value":"","use":true,"atype":none],
            TEAM_EMAIL_KEY:["ch":"EMail","vtype":"String","value":"","use":true,"atype":none],
            TEAM_WEBSITE_KEY:["ch":"網站","vtype":"String","value":"","use":false],
            TEAM_FB_KEY:["ch":"FB","vtype":"String","value":"","use":false],
            TEAM_YOUTUBE_KEY:["ch":"youtube","vtype":"String","value":"","use":false],
            TEAM_PLAY_START_KEY:["ch":"開始時間","vtype":"String","value":"","use":true,"atype":more,"iden":TO_SELECT_TIME],
            TEAM_PLAY_END_KEY:["ch":"結束時間","vtype":"String","value":"","use":true,"atype":more,"iden":TO_SELECT_TIME],
            TEAM_BALL_KEY:["ch":"使用球種","vtype":"String","value":"","use":true,"atype":more],
            TEAM_DEGREE_KEY:["ch":"球隊程度","vtype":"array","value":[String](),"use":true,"atype":more,"iden":TO_SELECT_DEGREE],
            TEAM_SLUG_KEY:["ch":"插槽","vtype":"String","value":"","use":true],
            TEAM_CHARGE_KEY:["ch":"收費說明","vtype":"String","value":"","use":true,"atype":more,"iden":TO_TEXT_INPUT],
            TEAM_CONTENT_KEY:["ch":"球隊說明","vtype":"String","value":"","use":true,"atype":more,"iden":TO_TEXT_INPUT],
            TEAM_MANAGER_ID_KEY:["ch":"管理者編號","vtype":"Int","value":-1,"use":true],
            TEAM_TEMP_FEE_M_KEY:["ch":"臨打費用：男","vtype":"Int","value":-1,"use":true,"atype":none],
            TEAM_TEMP_FEE_F_KEY:["ch":"臨打費用：女","vtype":"Int","value":-1,"use":true,"atype":none],
            TEAM_TEMP_QUANTITY_KEY:["ch":"臨打人數","vtype":"Int","value":-1,"use":false],
            TEAM_TEMP_CONTENT_KEY:["ch":"臨打說明","vtype":"String","value":"","use":true,"atype":more,"iden":TO_TEXT_INPUT],
            TEAM_TEMP_STATUS_KEY:["ch":"臨打狀態","vtype":"String","value":"","use":false],
            TEAM_PV_KEY:["ch":"瀏覽數","vtype":"Int","value":-1,"use":false],
            TEAM_TOKEN_KEY:["ch":"球隊token","vtype":"String","value":"","use":false],
            TEAM_CREATED_ID_KEY:["ch":"建立者","vtype":"Int","value":-1,"use":true],
            TEAM_CREATED_AT_KEY:["ch":"建立時間","vtype":"String","value":"","use":false],
            TEAM_UPDATED_AT_KEY:["ch":"最後一次修改時間","vtype":"String","value":"","use":false],
            TEAM_THUMB_KEY:["ch":"代表圖","vtype":"String","value":"","use":false],
            TEAM_CITY_KEY:["ch":"區域","vtype":"array","value":[String:Any](),"use":false,"atype":more,"iden":TO_CITY],
            TEAM_ARENA_KEY:["ch":"球館","vtype":"array","value":[String:Any](),"use":false,"atype":more,"iden":TO_ARENA],
            TEAM_DAY_KEY:["ch":"星期幾","vtype":"array","value":[Int](),"use":false,"atype":more,"iden":TO_DAY],
            TEAM_FEATURED_KEY:["ch":"代表圖","vtype":"image","value":UIImage(),"path":"","use":false]
        ]
    }
}
