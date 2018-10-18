//
//  ArenaService.swift
//  bm
//
//  Created by ives on 2018/7/28.
//  Copyright © 2018年 bm. All rights reserved.
//

import Foundation
import SwiftyJSON

class ArenaService: DataService {
    static let instance = ArenaService()
    override var model: Arena {
        get {
            return Arena.instance
        }
    }
    
    override func setData(id: Int, title: String, path: String, token: String, youtube: String, vimeo: String) -> Arena {
        let superData = Arena(id: id, title: title, path: path, token: token, youtube: youtube, vimeo: vimeo)
        return superData
    }
    override func setData1(row: JSON) -> Dictionary<String, [String : Any]> {
        model.listReset()
        for (key, value) in model.data {
            if row[key].exists() {
                //row[key]: remote value, item: local setup
                _jsonToData(tmp: row[key], key: key, item: value)
            }
            if key == CITY_KEY {
                if row["city_id"].exists() {
                    model.data[CITY_KEY]!["value"] = row["city_id"].intValue
                }
            }
            if key == AREA_KEY {
                if row["area_id"].exists() {
                    model.data[AREA_KEY]!["value"] = row["area_id"].intValue
                }
            }
        }
        //print(model.data)
        return model.data
    }
    
    func _jsonToData(tmp: JSON, key: String, item: [String: Any]) {
        var value: Any?
        let type: String = item["vtype"] as! String
        if type == "Boolean" {
            let _value: Bool = tmp.boolValue
            model.data[key]!["value"] = _value
            let show = (_value) ? "有" : "無"
            model.data[key]!["show"] = show
        } else if type == "Int" {
            value = tmp.intValue
            model.data[key]!["value"] = value
            model.data[key]!["show"] = "\(value ?? "")"
        } else if type == "String" {
            value = tmp.stringValue
            //print("\(key) => \(value!)")
            if (value as! String).count == 0 || (value as! String) == "null" {
                value = "未提供"
            }
            model.data[key]!["value"] = value!
            model.data[key]!["show"] = value!
            if key == TEL_KEY {
                model.telOrMobileShow()
            }
            if key == ARENA_OPEN_TIME_KEY {
                model.updateOpenTime((value as! String))
            }
            if key == ARENA_CLOSE_TIME_KEY {
                model.updateCloseTime((value as! String))
            }
        } else if type == "array" {
            
        }
    }
}
