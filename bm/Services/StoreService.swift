//
//  StoreService.swift
//  bm
//
//  Created by ives on 2020/10/23.
//  Copyright © 2020 bm. All rights reserved.
//

import Foundation

class StoreService: DataService {
    static let instance = StoreService()
    
    override init() {
        super.init()
    }
    
    override func getListURL() -> String {
        return URL_STORE_LIST
    }
    
    override func getSource() -> String? {
        return "store"
    }
    
    override func getLikeURL(token: String? = nil) -> String {
        var url: String = URL_STORE_LIKE
        if token != nil {
            url = url + "/" + token!
        }
        
        return url
    }
}
