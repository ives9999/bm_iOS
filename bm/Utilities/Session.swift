//
//  Session.swift
//  bm
//
//  Created by ives on 2019/4/22.
//  Copyright © 2019 bm. All rights reserved.
//

import Foundation

class Session: NSObject {
    
    private override init() {}
    
    static let shared = Session()
    
    private let UD = UserDefaults.standard
    
    //public let loginResetKey = "login_reset"
    
//    var loginReset: Bool {
//        get {
//            return UD.bool(forKey: loginResetKey)
//        }
//        set {
//            UD.set(loginResetKey, newValue)
//        }
//    }
    
    func clear(key: String) {
        if exist(key: key) {
            UD.removeObject(forKey: key)
        }
    }
    
    func exist(key: String)-> Bool {
        var isExist = false
        if UD.object(forKey: key) != nil {
            isExist = true
        }
        
        return isExist
    }
}
