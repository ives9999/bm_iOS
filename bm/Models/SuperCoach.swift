//
//  SuperCoach.swift
//  bm
//
//  Created by ives on 2019/1/28.
//  Copyright © 2019 bm. All rights reserved.
//

import Foundation

@objc(SuperCoach)
class SuperCoach: SuperModel {
    @objc dynamic var citys: Array<SuperCity> = Array()
    //@objc dynamic var city: Dictionary = [String: Any]()
    @objc dynamic var id: Int = -1
    @objc dynamic var name: String = ""
    @objc dynamic var channel: String = ""
    @objc dynamic var mobile: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var website: String = ""
    @objc dynamic var fb: String = ""
    @objc dynamic var youtube: String = ""
    @objc dynamic var line: String = ""
    @objc dynamic var seniority: Int = -1
    @objc dynamic var exp: String = ""
    @objc dynamic var feat: String = ""
    @objc dynamic var license: String = ""
    @objc dynamic var slug: String = ""
    @objc dynamic var charge: String = ""
    @objc dynamic var content: String = ""
    @objc dynamic var status: String = "online"
    @objc dynamic var color: String = ""
    @objc dynamic var token: String = ""
    @objc dynamic var manager_id: Int = 0
    @objc dynamic var sort_order: Int = 0
    @objc dynamic var pv: Int = 0
    @objc dynamic var created_id: Int = 0
    @objc dynamic var created_at: String = ""
    @objc dynamic var updated_at: String = ""
    @objc dynamic var featured_path: String = ""
    @objc dynamic var thumb: String = ""
    
    override func filterRow() {
        if featured_path.count > 0 {
            if !featured_path.hasPrefix("http://") || !featured_path.hasPrefix("https://") {
                featured_path = BASE_URL + featured_path
                //print(featured_path)
            }
        }
    }
}

class SuperCoaches: SuperModel {
    @objc dynamic var success: Bool = false
    @objc dynamic var rows: [SuperCoach] = Array()
    
    override func printRows() {
        let row = rows[0]
        row.printRow()
    }
}
