//
//  MatchGroupService.swift
//  bm
//
//  Created by ives on 2023/4/27.
//  Copyright © 2023 bm. All rights reserved.
//

import Foundation

class MatchPlayerService: DataService {
    
    static let instance = MatchPlayerService()
    
    override init() {
        super.init()
        //_model = Arena.instance
    }
    
    override func getListURL() -> String {
        return URL_MATCH_TEAM_PLAYER_LIST
    }
    
    override func getSource() -> String? {
        return "match_player"
    }
    
    override func getUpdateURL()-> String {
        return URL_MATCH_TEAM_PLAYER_UPDATE
    }
}
