//
//  SuperStore.swift
//  bm
//
//  Created by ives on 2020/10/23.
//  Copyright © 2020 bm. All rights reserved.
//

import Foundation

@objc(SuperStore)
class SuperStore: SuperModel {
    
    @objc dynamic var id: Int = -1
    @objc dynamic var name: String = ""
    @objc dynamic var channel: String = ""
    @objc dynamic var slug: String = ""
    
    @objc dynamic var tel: String = ""
    @objc dynamic var mobile: String = ""
    @objc dynamic var fb: String = ""
    @objc dynamic var website: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var line: String = ""
    
    @objc dynamic var open_time: String = ""
    @objc dynamic var close_time: String = ""
    
    @objc dynamic var city_id: Int = 0
    @objc dynamic var area_id: Int = 0
    @objc dynamic var road: String = ""
    @objc dynamic var zip: String = ""
    
    @objc dynamic var content: String = ""
    @objc dynamic var status: String = "online"
    @objc dynamic var token: String = ""
    @objc dynamic var sort_order: Int = 0
    @objc dynamic var pv: Int = 0
    @objc dynamic var created_id: Int = 0
    @objc dynamic var created_at: String = ""
    @objc dynamic var updated_at: String = ""
    @objc dynamic var created_at_text: String = ""
    @objc dynamic var featured_path: String = ""
    @objc dynamic var thumb: String = ""
    
    @objc dynamic var featured: UIImage = UIImage(named: "nophoto")!
    @objc dynamic var city: String = ""
    @objc dynamic var open_time_text: String = ""
    @objc dynamic var close_time_text: String = ""
    @objc dynamic var address: String = ""
    @objc dynamic var tel_text: String = ""
    @objc dynamic var mobile_text: String = ""
    
    override func filterRow() {
        created_at_text = created_at.noTime()
        if featured_path.count > 0 {
            if !featured_path.hasPrefix("http://") || !featured_path.hasPrefix("https://") {
                featured_path = BASE_URL + featured_path
                //print(featured_path)
            }
        }
    }
    
    override func getFeaturedPath() -> String {
        return featured_path
    }
    
    override func setFeatured(_ image: UIImage) {
        featured = image
    }
}

class SuperStores: SuperModel {
    @objc dynamic var success: Bool = false
    @objc dynamic var page: Int = 0
    @objc dynamic var totalCount: Int = 0
    @objc dynamic var perPage: Int = 0
    @objc dynamic var rows: [SuperStore] = Array()
    
    override func printRows() {
        let row = rows[0]
        row.printRow()
    }
    
    override func getRows<SuperStore>() -> [SuperStore]? {
        return (rows as! [SuperStore])
    }
    
    override func getRowFromIdx<T>(_ idx: Int) -> T? where T : SuperModel {
        if rows.count >= idx {
            return (rows[idx] as! T)
        } else {
            return nil
        }
    }
}
