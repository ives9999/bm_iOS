//
//  File.swift
//  bm
//
//  Created by ives on 2023/5/5.
//  Copyright © 2023 bm. All rights reserved.
//

import Foundation

class MatchTeamService: DataService {
    
    static let instance = MatchTeamService()
    
    override init() {
        super.init()
        //_model = Arena.instance
    }
    
    override func getListURL() -> String {
        return URL_MATCH_TEAM_LIST
    }
    
    override func getSource() -> String? {
        return "match_team"
    }
    
    override func getUpdateURL()-> String {
        return URL_MATCH_TEAM_UPDATE
    }
}
