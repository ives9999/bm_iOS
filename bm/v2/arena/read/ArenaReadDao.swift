//
//  ArenaReadDao.swift
//  bm
//
//  Created by ives on 2024/5/8.
//  Copyright © 2024 bm. All rights reserved.
//

import Foundation

class ArenaReadDao: Codable {
    
    var status: Int = 500
    var data: ArenaData = ArenaData()
    
    class ArenaData: Codable {
        var rows: [Arena] = [Arena]()
        var meta: Meta = Meta()
        
        enum CodingKeys: String, CodingKey {
            case rows
            case meta = "_meta"
        }
        
        init(){}
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            rows = try container.decodeIfPresent([Arena].self, forKey: .rows) ?? [Arena]()
            meta = try container.decodeIfPresent(Meta.self, forKey: .meta) ?? Meta()
        }
    }
    
    class Arena: Codable {
        var id: Int = 0
        var name: String = ""
        var images: [Image] = [Image]()
        var zone: Zone = Zone()
        var member: MemberTable = MemberTable()
        var token: String = ""
        var pv: Int = 0
        var created_at: String = ""
        
        init() {}
        
        required init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
            name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
            images = try container.decodeIfPresent([Image].self, forKey: .images) ?? [Image]()
            zone = try container.decodeIfPresent(Zone.self, forKey: .zone) ?? Zone()
            member = try container.decodeIfPresent(MemberTable.self, forKey: .member) ?? MemberTable()
            token = try container.decodeIfPresent(String.self, forKey: .token) ?? ""
            pv = try container.decodeIfPresent(Int.self, forKey: .pv) ?? 0
            created_at = try container.decodeIfPresent(String.self, forKey: .created_at) ?? ""
        }
    }
    
    class Meta: Codable {
        var totalCount: Int = 0
        var totalPage: Int = 0
        var currentPage: Int = 1
        var offset: Int = 0
        var perpage: Int = PERPAGE
        
        init() {}
        required init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            totalCount = try container.decodeIfPresent(Int.self, forKey: .totalCount) ?? 0
            totalPage = try container.decodeIfPresent(Int.self, forKey: .totalPage) ?? 0
            currentPage = try container.decodeIfPresent(Int.self, forKey: .currentPage) ?? 1
            offset = try container.decodeIfPresent(Int.self, forKey: .offset) ?? 1
            perpage = try container.decodeIfPresent(Int.self, forKey: .perpage) ?? PERPAGE
        }
    }
    
    class Image: Codable {
        var path: String = ""
        var upload_id: Int = 0
        var sort_order: Int = 0
        var isFeatured: Bool = false
        
        init() {}
        required init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<ArenaReadDao.Image.CodingKeys> = try decoder.container(keyedBy: ArenaReadDao.Image.CodingKeys.self)
            self.path = try container.decodeIfPresent(String.self, forKey: ArenaReadDao.Image.CodingKeys.path) ?? ""
            self.upload_id = try container.decodeIfPresent(Int.self, forKey: ArenaReadDao.Image.CodingKeys.upload_id) ?? 0
            self.sort_order = try container.decodeIfPresent(Int.self, forKey: ArenaReadDao.Image.CodingKeys.sort_order) ?? 0
            self.isFeatured = try container.decodeIfPresent(Bool.self, forKey: ArenaReadDao.Image.CodingKeys.isFeatured) ?? false
        }
    }
    
    class Zone: Codable {
        var city_id: Int = 0
        var area_id: Int = 0
        var city_name: String = ""
        var area_name: String = ""
        
        init() {}
        
        required init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            city_id = try container.decodeIfPresent(Int.self, forKey: .city_id) ?? 0
            area_id = try container.decodeIfPresent(Int.self, forKey: .area_id) ?? 0
            city_name = try container.decodeIfPresent(String.self, forKey: .city_name) ?? ""
            area_name = try container.decodeIfPresent(String.self, forKey: .area_name) ?? ""
        }
    }
    
    func printDao() {
        var mirror: Mirror? = Mirror(reflecting: self)
        repeat {
            for property in mirror!.children {
                print("\(property.label ?? ""): \(property.value)")
            }
            mirror = mirror?.superclassMirror
        } while mirror != nil
    }
}


