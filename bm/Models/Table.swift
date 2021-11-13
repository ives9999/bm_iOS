//
//  Table.swift
//  bm
//
//  Created by ives on 2021/3/15.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class Tables: Codable {
    var success: Bool = false
    var page: Int = -1
    var totalCount: Int = -1
    var perPage: Int = -1
    //var rows: [T] = [T]()
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decode(Bool.self, forKey: .success)
        page = try container.decode(Int.self, forKey: .page)
        totalCount = try container.decode(Int.self, forKey: .totalCount)
        perPage = try container.decode(Int.self, forKey: .perPage)
        //rows = try container.decode([T].self, forKey: .rows)
    }
}

class Table: Codable {
    
    var id: Int = -1
    var name: String = ""
    var title: String = ""
    var channel: String = ""
    var tel: String = ""
    var mobile: String = ""
    var city_id: Int = -1
    var slug: String = ""
    var status: String = "online"
    var token: String = ""
    var content: String = ""
    var sort_order: Int = 0
    var pv: Int = 0
    var like: Bool = false
    var like_count: Int = 0
    var created_id: Int = 0
    var featured_path: String = ""
    var created_at: String = ""
    var updated_at: String = ""
    
    var created_at_show: String = ""
    var updated_at_show: String = ""
    
    var address: String = ""
    var city_show: String = ""
    var tel_show: String = ""
    var mobile_show: String = ""
    
    init(){}
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {id = try container.decode(Int.self, forKey: .id)}catch{id = 0}
        do {name = try container.decode(String.self, forKey: .name)}catch{name = ""}
        do {title = try container.decode(String.self, forKey: .title)}catch{title = ""}
        do {channel = try container.decode(String.self, forKey: .channel)}catch{channel = ""}
        do {slug = try container.decode(String.self, forKey: .slug)}catch{slug = ""}
        do {status = try container.decode(String.self, forKey: .status)}catch{status = "online"}
        do {token = try container.decode(String.self, forKey: .token)}catch{token = ""}
        do {content = try container.decode(String.self, forKey: .content)}catch{content = ""}
        do {featured_path = try container.decode(String.self, forKey: .featured_path)}catch{featured_path = ""}
        do {sort_order = try container.decode(Int.self, forKey: .sort_order)}catch{sort_order = 0}
        do {pv = try container.decode(Int.self, forKey: .pv)}catch{pv = 0}
        do {like = try container.decode(Bool.self, forKey: .like)}catch{like = false}
        do {like_count = try container.decode(Int.self, forKey: .like_count)}catch{like_count = 0}
        do {created_at = try container.decode(String.self, forKey: .created_at)}catch{created_at = ""}
        do {updated_at = try container.decode(String.self, forKey: .updated_at)}catch{updated_at = ""}
        
        tel = try container.decodeIfPresent(String.self, forKey: .tel) ?? ""
        mobile = try container.decodeIfPresent(String.self, forKey: .mobile) ?? ""
        city_id = try container.decodeIfPresent(Int.self, forKey: .city_id) ?? -1
    }
    
    public func filterRow(){
        
        if featured_path.count > 0 {
            if !featured_path.hasPrefix("http://") && !featured_path.hasPrefix("https://") {
                featured_path = BASE_URL + featured_path
                //print(featured_path)
            }
        }
        
        if city_id > 0 {
            city_show = Global.instance.zoneIDToName(city_id)
        }
        
        if tel.count > 0 {
            tel_show = tel.telShow()
        }
        
        if mobile.count > 0 {
            mobile_show = mobile.mobileShow()
        }
        
        if created_at.count > 0 {
            created_at_show = created_at.noTime()
        }
        
        if updated_at.count > 0 {
            updated_at_show = updated_at.noTime()
        }
    }
    
    public func printRow() {
        
//        print("id=>\(id)")
//        print("name=>\(name)")
//        print("title=>\(title)")
//        print("address=>\(address)")
//        print("channel=>\(channel)")
//        print("tel=>\(tel)")
//        print("mobile=>\(mobile)")
//        print("slug=>\(slug)")
//        print("status=>\(status)")
//        print("token=>\(token)")
//        print("content=>\(content)")
//        print("sort_order=>\(sort_order)")
//        print("pv=>\(pv)")
//        print("like=>\(like)")
//        print("like_count=>\(like_count)")
//        print("created_id=>\(created_id)")
//        print("featured_path=>\(featured_path)")
//        print("created_at=>\(created_at)")
//        print("updateed_at=>\(updated_at)")
//        print("created_at_show=>\(created_at_show)")
//        print("updated_at_show=>\(updated_at_show)")
//        print("address=>\(address)")
//        print("city_show=>\(city_show)")
//        print("tel_show=>\(tel_show)")
//        print("mobile_show=>\(mobile_show)")
        
        var mirror: Mirror? = Mirror(reflecting: self)
        repeat {
            for property in mirror!.children {
                print("\(property.label ?? ""): \(property.value)")
            }
            mirror = mirror?.superclassMirror
        } while mirror != nil
//        for property in mirror!.children {
//            print("\(property.label ?? "")=>\(property.value)")
//        }
    }
}

class SuccessTable: Codable {
    var success: Bool = false
    var msg: String = ""
    
    init(){}
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        msg = try container.decodeIfPresent(String.self, forKey: .msg) ?? ""
    }
}
