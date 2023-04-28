//
//  MatchGroupService.swift
//  bm
//
//  Created by ives on 2023/4/27.
//  Copyright © 2023 bm. All rights reserved.
//

import Foundation

class MatchGroupService: DataService {
    
    static let instance = MatchGroupService()
    
    override init() {
        super.init()
        //_model = Arena.instance
    }
    
    override func getListURL() -> String {
        return URL_MATCH_GROUP_LIST
    }
    
    override func getSource() -> String? {
        return "match_group"
    }
}
