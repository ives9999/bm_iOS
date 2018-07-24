//
//  CoachService.swift
//  bm
//
//  Created by ives on 2018/7/24.
//  Copyright © 2018年 bm. All rights reserved.
//

import Foundation
import SwiftyJSON

class CoachService: DataService {
    
    static let instance = CoachService()
    override var model: Coach {
        get {
            return Coach.instance
        }
    }
    
    override func setData(id: Int, title: String, path: String, token: String, youtube: String, vimeo: String) -> Coach {
        let list = Coach(id: id, title: title, path: path, token: token, youtube: youtube, vimeo: vimeo)
        return list
    }
    override func setData1(obj: JSON) -> Dictionary<String, [String : Any]> {
        model.listReset()
        for (key, value) in model.data {
            if obj[key].exists() {
                _jsonToData(tmp: obj[key], key: key, item: value)
            }
        }
        return model.data
    }
    
    func _jsonToData(tmp: JSON, key: String, item: [String: Any]) {
    }
}
