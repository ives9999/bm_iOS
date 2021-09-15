//
//  MemberTable.swift
//  bm
//
//  Created by ives sun on 2021/9/15.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class MemberTable: Table {
    
    static let instance = MemberTable()
    
    var nickname: String = ""
    var dob: String = ""
    var sex: String = ""
    var email: String = ""
    var city: Int = -1
    var area: Int = -1
    var road: String = ""
    var zip: Int = 0
    var pid: String = ""
    var avatar: String = ""
    var player_id: String = ""
    var type: Int = 0
    var social: String = ""
    var fb: String = ""
    var line: String = ""
    var role: String = ""
    var validate: Int = 0
    
    var isLoggedIn: Bool = false
    
    var area_show: String = ""
    
    enum CodingKeys: String, CodingKey {
        
        case nickname
        case dob
        case sex
        case email
        case city = "city_id"
        case area = "area_id"
        case road
        case zip
        case pid
        case avatar
        case player_id
        case type
        case social
        case fb
        case line
        case role
        case validate
    }
    
    override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
//        for child in Mirror(reflecting: self).children {
//            guard let flag = child.value as? DecodableFlag else {
//
//            }
//        }
        
        nickname = try container.decodeIfPresent(String.self, forKey: .nickname) ?? ""
        dob = try container.decodeIfPresent(String.self, forKey: .dob) ?? ""
        sex = try container.decodeIfPresent(String.self, forKey: .sex) ?? ""
        email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
        city = try container.decodeIfPresent(Int.self, forKey: .city) ?? -1
        area = try container.decodeIfPresent(Int.self, forKey: .area) ?? -1
        road = try container.decodeIfPresent(String.self, forKey: .road) ?? ""
        zip = try container.decodeIfPresent(Int.self, forKey: .zip) ?? 0
        avatar = try container.decodeIfPresent(String.self, forKey: .avatar) ?? ""
        player_id = try container.decodeIfPresent(String.self, forKey: .player_id) ?? ""
        type = try container.decodeIfPresent(Int.self, forKey: .type) ?? 0
        social = try container.decodeIfPresent(String.self, forKey: .social) ?? ""
        fb = try container.decodeIfPresent(String.self, forKey: .fb) ?? ""
        line = try container.decodeIfPresent(String.self, forKey: .line) ?? ""
        validate = try container.decodeIfPresent(Int.self, forKey: .validate) ?? 0
    }
    
    override func filterRow() {
        super.filterRow()
        
        if (city > 0) {
            city_show = Global.instance.zoneIDToName(city)
        }
        
        if (area > 0) {
            area_show = Global.instance.zoneIDToName(area)
        }
        
        if (area_show.count > 0 && city_show.count > 0) {
            address = "\(city_show)\(area_show)\(zip)\(road)"
        }
    }
    
    func toSession() {
        
        let session: UserDefaults = UserDefaults.standard
        var mirror: Mirror? = Mirror(reflecting: self)
        repeat {
            for property in mirror!.children {
                //print("\(property.label ?? ""): \(property.value)")
                if let label: String = property.label {
                    let value = property.value
                    session.set(label, value)
                }
            }
            mirror = mirror?.superclassMirror
        } while mirror != nil
    }
}
