//
//  SignupDateTable.swift
//  bm
//
//  Created by ives on 2021/11/12.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class SignupDateTable: Table {
    
    var success: Bool = true
    var signupable_id: Int = 0
    var signupable_type: String = ""
    var isSignup: Bool = false
    var cancel: Bool = false
    var date: String = ""
    var deadline: String = ""
    var standby: Bool = true
    var isStandby: Bool = true
    var canSignup: Bool = false
    var msg: String = ""
    
    enum CodingKeys: String, CodingKey {
        case success
        case signupable_id
        case signupable_type
        case isSignup
        case cancel
        case date
        case deadline
        case standby
        case isStandby
        case canSignup
        case msg
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? true
        signupable_id = try container.decodeIfPresent(Int.self, forKey: .signupable_id) ?? 0
        signupable_type = try container.decodeIfPresent(String.self, forKey: .signupable_type) ?? ""
        isSignup = try container.decodeIfPresent(Bool.self, forKey: .isSignup) ?? false
        cancel = try container.decodeIfPresent(Bool.self, forKey: .cancel) ?? false
        date = try container.decodeIfPresent(String.self, forKey: .date) ?? ""
        deadline = try container.decodeIfPresent(String.self, forKey: .deadline) ?? ""
        standby = try container.decodeIfPresent(Bool.self, forKey: .standby) ?? true
        isStandby = try container.decodeIfPresent(Bool.self, forKey: .isStandby) ?? true
        canSignup = try container.decodeIfPresent(Bool.self, forKey: .canSignup) ?? false
        msg = try container.decodeIfPresent(String.self, forKey: .msg) ?? ""
    }
    
    override func filterRow() {
        super.filterRow()
    }
    
    override public func printRow() {
        //super.printRow()
        let mirror: Mirror? = Mirror(reflecting: self)
        for property in mirror!.children {
            print("\(property.label ?? "")=>\(property.value)")
        }
    }
}
