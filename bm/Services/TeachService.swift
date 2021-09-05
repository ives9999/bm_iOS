//
//  File.swift
//  bm
//
//  Created by ives on 2018/7/31.
//  Copyright © 2018年 bm. All rights reserved.
//

import Foundation
import SwiftyJSON

class TeachService: DataService {
    static let instance = TeachService()
    
//    override init() {
//        super.init()
//        _model = Team.instance
//    }
    
    override func getListURL() -> String {
        return URL_TEACH_LIST
    }
    
    override func getSource() -> String? {
        return "teach"
    }
    
    override func getLikeURL(token: String? = nil) -> String {
        var url: String = URL_TEACH_LIKE
        if token != nil {
            url = url + "/" + token!
        }
        
        return url
    }
    
//    override func setData(id: Int, title: String, path: String, token: String, youtube: String, vimeo: String) -> Arena {
//        let superData = Arena(id: id, title: title, path: path, token: token, youtube: youtube, vimeo: vimeo)
//        return superData
//    }
//    override func setData1(row: JSON) -> Dictionary<String, [String : Any]> {
//        model.listReset()
//        for (key, value) in model.data {
//            if row[key].exists() {
//                _jsonToData(tmp: row[key], key: key, item: value)
//            }
//        }
//        return model.data
//    }
//    
//    func _jsonToData(tmp: JSON, key: String, item: [String: Any]) {
//        var value: Any?
//        let type: String = item["vtype"] as! String
//        if type == "Boolean" {
//            let _value: Bool = tmp.boolValue
//            model.data[key]!["value"] = _value
//            let show = (_value) ? "有" : "無"
//            model.data[key]!["show"] = show
//        } else if type == "Int" {
//            value = tmp.intValue
//            model.data[key]!["value"] = value
//            model.data[key]!["show"] = "\(value ?? "")"
//        } else if type == "String" {
//            value = tmp.stringValue
//            //print("\(key) => \(value!)")
//            if (value as! String).count == 0 || (value as! String) == "null" {
//                value = "未提供"
//            }
//            model.data[key]!["value"] = value!
//            model.data[key]!["show"] = value!
//        } else if type == "array" {
//            
//        }
//    }
}
