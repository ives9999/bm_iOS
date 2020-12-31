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
    var superStores: SuperStores = SuperStores()
    var superStore: SuperStore = SuperStore()
    
    override init() {
        super.init()
        superModel = SuperStores(dict: [String : Any]())
    }
    
    override func getListURL() -> String {
        return URL_STORE_LIST
    }
    
    override func getSource() -> String? {
        return "store"
    }
}
