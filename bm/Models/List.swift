//
//  Team.swift
//  bm
//
//  Created by ives on 2017/10/17.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class List {
    var id: Int
    var title: String
    var featured: UIImage
    var path: String
    var token: String
    var youtube: String
    var vimeo: String
    var data: Dictionary<String, [String: Any]>
    
    init() {
        self.id = -1
        self.title = ""
        self.path = ""
        self.featured = UIImage()
        self.token = ""
        self.vimeo = ""
        self.youtube = ""
        self.data = Dictionary<String, [String: Any]>()
    }
    
    init(id: Int, title: String, path: String, token: String, youtube: String = "", vimeo: String = "") {
        self.id = id
        self.title = title
        self.path = path
        self.featured = UIImage(named: "nophoto")!
        self.token = token
        self.vimeo = vimeo
        self.youtube = youtube
        self.data = Dictionary<String, [String: Any]>()
    }
    
    func updateCity(_ city: City) {
        data[TEAM_CITY_KEY]!["value"] = city.id
        data[TEAM_CITY_KEY]!["show"] = city.name
        data[TEAM_CITY_KEY]!["sender"] = city.id
    }
    
    func mobileShow(_ _mobile: String? = nil) {
        var mobile = _mobile
        if _mobile == nil {
            mobile = data[MOBILE_KEY]!["value"] as! String
        }
        mobile = mobile!.mobileShow()
        data[MOBILE_KEY]!["show"] = mobile
    }
    
    func listReset() {}
    
    func aPrint() {
        let mirror: Mirror? = Mirror(reflecting: self)
        for property in mirror!.children {
            _print(it: property)
        }
    }
    
    func _print(it: Mirror.Child) {
        let key = it.label
        let value = it.label
        print("\(key) => \(value)")
    }
}
