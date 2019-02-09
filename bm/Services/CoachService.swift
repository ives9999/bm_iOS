//
//  CoachService.swift
//  bm
//
//  Created by ives on 2018/7/24.
//  Copyright © 2018年 bm. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class CoachService: DataService {
    
    static let instance = CoachService()
    
    var superCoach: SuperCoach = SuperCoach()
    
    override init() {
        super.init()
        _model = Coach.instance
    }
    
    override func getOne(type: String, token: String, completion: @escaping CompletionHandler) {
        
        //print(model)
        //model.neverFill()
        downloadImageNum = 0
        let body: [String: Any] = ["device": "app", "token": token,"strip_html": false]
        
        //print(body)
        let url: String = String(format: URL_ONE, type)
        //print(url)
        
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            
            if response.result.error == nil {
                //print(response.result.value)
                guard let data = response.result.value else {
                    print("get response result value error")
                    self.msg = "網路錯誤，請稍後再試"
                    completion(false)
                    return
                }
                //print(data)
                let json = JSON(data)
                //print(json)
                if type == "coach" {
                    self.superCoach = JSONParse.parse(data: json)
                    //self.superCoach.printRow()
                }
                completion(true)
                
            } else {
                self.msg = "網路錯誤，請稍後再試"
                completion(false)
                debugPrint(response.result.error as Any)
            }
            
        }
    }
    
    override func setData(id: Int, title: String, path: String, token: String, youtube: String, vimeo: String) -> Coach {
        let superData = Coach(id: id, title: title, path: path, token: token, youtube: youtube, vimeo: vimeo)
        return superData
    }
    override func setData1(row: JSON) -> Dictionary<String, [String : Any]> {
        model.listReset()
        for (key, value) in model.data {
            if row[key].exists() {
                _jsonToData(tmp: row[key], key: key, item: value)
            }
        }
        model.setAllTextSender()
        
        return model.data
    }
    
    func _jsonToData(tmp: JSON, key: String, item: [String: Any]) {
        var value: Any?
        let type: String = item["vtype"] as! String
        if type == "Int" {
            value = tmp.intValue
            if key == COACH_SENIORITY_KEY {
                var show = "未提供"
                if tmp != JSON.null {
                    show = "\(value ?? "")" + "年"
                }
                model.data[key]!["show"] = show
            } else {
                model.data[key]!["show"] = "\(value ?? "")"
            }
            model.data[key]!["value"] = value
        } else if type == "String" {
            value = tmp.stringValue
            //print("\(key) => \(value!)")
            model.data[key]!["value"] = value!
            model.data[key]!["show"] = value!
            if key == MOBILE_KEY {
                model.mobileShow()
            }
        } else if type == "array" {
            if key == CITY_KEY {
                let id: Int = tmp["id"].intValue
                let name: String = tmp["name"].stringValue
                let city: City = City(id: id, name: name)
                model.updateCity(city)
            }
        }
    }
}
