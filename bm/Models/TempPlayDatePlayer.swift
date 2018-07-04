//
//  TempPlayDatePlayer.swift
//  bm
//
//  Created by ives on 2018/6/23.
//  Copyright © 2018年 bm. All rights reserved.
//

import Foundation

class TempPlayDatePlayer: SuperModel {
    @objc dynamic var success: Bool = false
    @objc dynamic var rows: [Row] = Array()
    
    @objc(Row)
    class Row: SuperModel {
        @objc dynamic var id: Int = -1
        @objc dynamic var team_id: Int = -1
        @objc dynamic var member_id: Int = -1
        @objc dynamic var name: String = ""
        @objc dynamic var mobile: String = ""
        @objc dynamic var token: String = ""
        @objc dynamic var play_date: String = ""
        @objc dynamic var created_at: String = ""
        @objc dynamic var updated_at: String = ""
    }
}

