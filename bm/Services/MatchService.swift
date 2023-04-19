//
//  MatchService.swift
//  bm
//
//  Created by ives on 2023/4/19.
//  Copyright © 2023 bm. All rights reserved.
//

import Foundation
import SwiftyJSON

class MatchService: DataService {
    static let instance = MatchService()
    
    override init() {
        super.init()
        //_model = Arena.instance
    }
    
    override func getListURL() -> String {
        return URL_MATCH_LIST
    }
    
    override func getSource() -> String? {
        return "match"
    }
}
