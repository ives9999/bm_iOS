//
//  TeamService.swift
//  bm
//
//  Created by ives on 2017/11/12.
//  Copyright © 2017年 bm. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON

class TeamService {
    static let instance = TeamService()
    
    var msg:String = ""
    var success: Bool = false
    var id: Int = 0
    var downloadImageNum: Int = 0
    //var team: Team = Team()
    var model:Team!
    
    init() {
        model = Team.instance
    }
    
    func update(params: [String: Any], _ image: UIImage?, key: String, filename: String, mimeType: String, completion: @escaping CompletionHandler) {
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
        var body: [String: Any] = ["source": "app"]
        body.merge(params)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if image != nil {
                let imageData: Data = UIImageJPEGRepresentation(image!, 0.2)!
                //print(imageData)
                //let base64: String = imageData.base64EncodedString(options: .lineLength64Characters)
                multipartFormData.append(imageData, withName: key, fileName: filename, mimeType: mimeType)
            }
            //print(params)
            for (key, value) in body {
                if key == TEAM_DEGREE_KEY {
                    for d in value as! [String] {
                        multipartFormData.append(("\(d)").data(using: .utf8)!, withName: "degree[]")
                    }
                } else if key == TEAM_DAYS_KEY {
                    for d in value as! [Int] {
                        multipartFormData.append(("\(d)").data(using: .utf8)!, withName: "days[]")
                    }
                } else if key == TEAM_CAT_KEY {
                    for d in value as! [Int] {
                        multipartFormData.append(("\(d)").data(using: .utf8)!, withName: "cat_id[]")
                    }
                } else {
                    multipartFormData.append(("\(value)").data(using: .utf8)!, withName: key)
                }
            }
            //print(multipartFormData.boundary)
        }, usingThreshold: UInt64.init(), to: URL_TEAM_UPDATE, method: .post, headers: headers) { (result) in
            switch result {
            case .success(let upload, _, _):
//                upload.responseString { (response) in
//                    print(response)
//                    completion(true)
//                }
                upload.responseJSON(completionHandler: { (response) in
                    //print(response)
                    if response.result.error == nil {
                        guard let data = response.result.value else {
                            print("data error")
                            return
                        }
                        //print(data)
                        let json = JSON(data)
                        self.success = true
                        self.success = json["success"].boolValue
                        if self.success {
                            self.id = json["id"].intValue
                        } else {
                            let errors: [String] = json["msg"].arrayObject as! [String]
                            for i in 0 ..< errors.count {
                                self.msg += errors[i]
                            }
                        }
                    }
                    completion(true)
                })
            case .failure(let error):
                print(error)
                //onError(error)
                completion(false)
            }
        }
    }
    func getOne(type: String, token: String, completion: @escaping CompletionHandler) {
        self.downloadImageNum = 0
        let body: [String: Any] = ["source": "app", "token": token, "strip_html": true]
        
        //print(body)
        let url: String = String(format: URL_ONE, type)
        
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            
            if response.result.error == nil {
                //print(response.result.value)
                guard let data = response.result.value else {
                    print("get response result value error")
                    return
                }
                //print(data)
                let model: Team = Team.instance
                let json = JSON(data)
                //print(json)
                
                //var images: [String] = [String]()
                for (key, item) in model.data {
                    if json[key] != JSON.null {
                        let tmp = json[key]
                        var value: Any?
                        let type: String = item["vtype"] as! String
                        if type == "Int" {
                            value = tmp.intValue
                            model.data[key]!["value"] = value
                            model.data[key]!["show"] = "\(value ?? "")"
                        } else if type == "String" {
                            value = tmp.stringValue
                            model.data[key]!["value"] = value
                            model.data[key]!["show"] = value
                        } else if type == "array" {
                            if key == TEAM_CITY_KEY {
                                let id: Int = tmp["id"].intValue
                                let name: String = tmp["name"].stringValue
                                let city: City = City(id: id, name: name)
                                model.updateCity(city)
                            } else if key == TEAM_ARENA_KEY {
                                let id: Int = tmp["id"].intValue
                                let name: String = tmp["name"].stringValue
                                let arena: Arena = Arena(id: id, name: name)
                                model.updateArena(arena)
                            } else if key == TEAM_DAYS_KEY {
                                let tmp1: [JSON] = tmp.arrayValue
                                var days: [Int] = [Int]()
                                for item in tmp1 {
                                    days.append(item["day"].intValue)
                                }
                                model.updateDays(days)
                            } else if key == TEAM_DEGREE_KEY {
                                let tmp1: String = tmp.stringValue
                                let degrees: [String] = tmp1.components(separatedBy: ",")
                                model.updateDegree(degrees)
                            }
                        } else if type == "image" {
                            if key == TEAM_FEATURED_KEY {
                                var tmp1: String = tmp.stringValue
                                if (tmp1.count > 0) {
                                    tmp1 = BASE_URL + tmp1
                                    model.data[key]!["path"] = tmp1
                                }
                            }
                        }
                    }
                }
                if json["near_date_w"] != JSON.null {
                    let n2: String = json["near_date_w"].stringValue
                    model.data[TEAM_NEAR_DATE_KEY]!["value1"] = n2
                }
                var signups:[[String: String]] = [[String: String]]()
                
                if json["signups"] != JSON.null {
                    let items: [JSON] = json["signups"].arrayValue
                    for item in items {
                        let member: JSON = item["member"]
                        //print(member)
                        let nickname: String = member["nickname"].stringValue
                        let token: String = member["token"].stringValue
                        let created_at: String = item["created_at"].stringValue
                        signups.append(["nickname":nickname, "token":token,"created_at":created_at])
                        //print(signups)
                    }
                    if model.data["signups"] == nil {
                        model.data["signups"] = [String: Any]()
                    }
                    model.data["signups"]!["value"] = signups
                    model.data["signups"]!["vtype"] = "array"
                    //print(model.data)
 
                }
 
                model.updatePlayStartTime()
                model.updatePlayEndTime()
                model.updateTempContent()
                model.updateCharge()
                model.updateContent()
                model.updateNearDate()
                model.feeShow()
                //print(model.data)
                
                let path: String = model.data[TEAM_FEATURED_KEY]!["path"] as! String
                if path.count > 0 {
                    DataService.instance.getImage(url: path, completion: { (success) in
                        if success {
                            model.data[TEAM_FEATURED_KEY]!["value"] = DataService.instance.image
                            completion(true)
                            //print(team.data)
                        }
                    })
                } else {
                    completion(true)
                }
                
                /*
                 let id: Int = json["id"].intValue
                 let channel: String = json["channel"].stringValue
                 let name: String = json["name"].stringValue
                 let mobile: String = json["mobile"].stringValue
                 let email: String = json["email"].stringValue
                 let website: String = json["website"].stringValue
                 let fb: String = json["fb"].stringValue
                 let youtube: String = json["youtube"].stringValue
                 let play_start: String = json["play_start"].stringValue
                 let play_end: String = json["play_end"].stringValue
                 let ball: String = json["ball"].stringValue
                 let degree: String = json["degree"].stringValue
                 let slug: String = json["slug"].stringValue
                 let charge: String = json["charge"].stringValue
                 let content: String = json["content"].stringValue
                 let manager_id: Int = json["manager_id"].intValue
                 let temp_fee_M: Int = json["temp_fee_M"].intValue
                 let temp_fee_F: Int = json["temp_fee_F"].intValue
                 let temp_quantity: Int = json["temp_quantity"].intValue
                 let temp_content: String = json["temp_content"].stringValue
                 let temp_status: String = json["temp_status"].stringValue
                 let pv: Int = json["pv"].intValue
                 let token: String = json["token"].stringValue
                 let created_id: Int = json["created_id"].intValue
                 let created_at: String = json["created_at"].stringValue
                 let updated_at: String = json["updated_id"].stringValue
                 let thumb: String = json["thumb"].stringValue
                 let arena_json: JSON = JSON(json["arena"])
                 let arena: [String: Any] = [
                 "id": arena_json["id"].intValue, "name": arena_json["name"].stringValue
                 ]
                 let days_json: [JSON] = json["days"].arrayValue
                 var days: [Int] = [Int]()
                 for day in days_json {
                 days.append(day["day"].intValue)
                 }
                 
                 var path: String = ""
                 let path1 = json["featured_path"].stringValue
                 if (path1.count > 0) {
                 path = BASE_URL + path1
                 self.downloadImageNum += 1
                 }
                 */
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
            
        }
    }
    func tempPlay_onoff(token: String, completion: @escaping CompletionHandler) {
        let body: [String: Any] = ["source": "app", "token": token, "strip_html": true]
        
        Alamofire.request(URL_TEAM_TEMP_PLAY, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                //print(response.result.value)
                guard let data = response.result.value else {
                    print("get response result value error")
                    return
                }
                let json = JSON(data)
                for (key, item) in self.model.temp_play_data {
                    if json[key] != JSON.null {
                        let tmp = json[key]
                        var value: Any?
                        let type: String = item["vtype"] as! String
                        if type == "Int" {
                            value = tmp.intValue
                            self.model.temp_play_data[key]!["value"] = value
                            self.model.temp_play_data[key]!["show"] = "\(value ?? "")"
                        } else if type == "String" {
                            value = tmp.stringValue
                            self.model.temp_play_data[key]!["value"] = value
                            self.model.temp_play_data[key]!["show"] = value
                        } else if type == "array" {
                            if key == TEAM_CITY_KEY {
                                let id: Int = tmp["id"].intValue
                                let name: String = tmp["name"].stringValue
                                let city: City = City(id: id, name: name)
                                self.model.updateCity(city)
                            } else if key == TEAM_ARENA_KEY {
                                let id: Int = tmp["id"].intValue
                                let name: String = tmp["name"].stringValue
                                let arena: Arena = Arena(id: id, name: name)
                                self.model.updateArena(arena)
                            } else if key == TEAM_DAYS_KEY {
                                let tmp1: [JSON] = tmp.arrayValue
                                var days: [Int] = [Int]()
                                for item in tmp1 {
                                    days.append(item["day"].intValue)
                                }
                                self.model.updateDays(days)
                            } else if key == TEAM_DEGREE_KEY {
                                let tmp1: String = tmp.stringValue
                                let degrees: [String] = tmp1.components(separatedBy: ",")
                                self.model.updateDegree(degrees)
                            }
                        }
                    }
                }
                completion(true)
            }
        }
    }
    func tempPlay_list(completion: @escaping CompletionHandler) {
        let body: [String: Any] = ["source": "app"]
        
        Alamofire.request(URL_TEAM_TEMP_PLAY_LIST, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                //print(response.result.value)
                guard let data = response.result.value else {
                    print("get response result value error")
                    return
                }
                //print(data)
                let model: Team = Team.instance
                let json = JSON(data)
                let arr: [JSON] = json["rows"].arrayValue
                //print(arr)
                model.list = [DATA]()
                
                for i in 0 ..< arr.count {
                    for (key, value) in model.data {
                        if arr[i][key] != JSON.null {
                            self._jsonToData(tmp: arr[i][key], key: key, item: value)
                        }
                    }
                    model.updatePlayStartTime()
                    model.updatePlayEndTime()
                    var data: Dictionary<String, [String: Any]> = model.data
                    
                    var near_date: Dictionary<String, Any> = [String: Any]()
                    let n1: String = arr[i]["near_date"].stringValue
                    let n2: String = arr[i]["near_date_w"].stringValue
                    near_date["value"] = n1
                    near_date["value1"] = n2
                    near_date["show"] = n1 + "(" + n2 + ")"
                    data["near_date"] = near_date
                    
                    var city: Dictionary<String, Any> = [String: Any]()
                    city["value"] = arr[i]["city_id"].intValue
                    city["show"] = arr[i]["city_name"].stringValue
                    data["city"] = city
                    
                    var arena: Dictionary<String, Any> = [String: Any]()
                    arena["value"] = arr[i]["arena_id"].intValue
                    arena["show"] = arr[i]["arena_name"].stringValue
                    data["arena"] = arena
                    
                    var count: Dictionary<String, Any> = [String: Any]()
                    let tmp: Int = arr[i][TEAM_TEMP_QUANTITY_KEY].intValue
                    
                    count["quantity"] = arr[i][TEAM_TEMP_QUANTITY_KEY].intValue
                    count["signup"] = arr[i]["temp_signup_count"].intValue
                    data["count"] = count
                    
                    //print(data)
                    model.list.append(data)
                }
                completion(true)
            }
        }
    }
    
    func _jsonToData(tmp: JSON, key: String, item: [String: Any]) {
        var value: Any?
        let type: String = item["vtype"] as! String
        if type == "Int" {
            value = tmp.intValue
            model.data[key]!["value"] = value
            model.data[key]!["show"] = "\(value ?? "")"
        } else if type == "String" {
            value = tmp.stringValue
            model.data[key]!["value"] = value
            model.data[key]!["show"] = value
        } else if type == "array" {
            if key == TEAM_CITY_KEY {
                let id: Int = tmp["id"].intValue
                let name: String = tmp["name"].stringValue
                let city: City = City(id: id, name: name)
                model.updateCity(city)
            } else if key == TEAM_ARENA_KEY {
                let id: Int = tmp["id"].intValue
                let name: String = tmp["name"].stringValue
                let arena: Arena = Arena(id: id, name: name)
                model.updateArena(arena)
            } else if key == TEAM_DAYS_KEY {
                let tmp1: [JSON] = tmp.arrayValue
                var days: [Int] = [Int]()
                for item in tmp1 {
                    days.append(item["day"].intValue)
                }
                model.updateDays(days)
            } else if key == TEAM_DEGREE_KEY {
                let tmp1: String = tmp.stringValue
                let degrees: [String] = tmp1.components(separatedBy: ",")
                model.updateDegree(degrees)
            }
        }
    }
    func plusOne(title: String, near_date: String, token: String, completion: @escaping CompletionHandler) {
        var url: String = URL_TEAM_PLUSONE + title + "?source=app&date=" + near_date + "&token=" + token
        //print(url)
        url = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
//        Alamofire.request(url).response { (response) in
//            print("Request: \(response.request)")
//            print("Response: \(response.response)")
//            print("Error: \(response.error)")
//
//            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                print("Data: \(utf8Text)")
//            }
//        }
        Alamofire.request(url).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.result.value else {
                    print("get response result value error")
                    return
                }
                let json = JSON(data)
                self.success = json["success"].boolValue
                if !self.success {
                    self.msg = json["msg"].stringValue
                }
                completion(self.success)
            }
        }
    }
    func cancelPlusOne(title: String, near_date: String, token: String, completion: @escaping CompletionHandler) {
        var url: String = URL_TEAM_CANCELPLUSONE + title + "?source=app&date=" + near_date + "&token=" + token
        //print(url)
        url = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        //print(url)
        
//                Alamofire.request(url).response { (response) in
//                    print("Request: \(response.request)")
//                    print("Response: \(response.response)")
//                    print("Error: \(response.error)")
//
//                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                        print("Data: \(utf8Text)")
//                    }
//                }
        
        Alamofire.request(url).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.result.value else {
                    print("get response result value error")
                    return
                }
                let json = JSON(data)
                self.success = json["success"].boolValue
                if !self.success {
                    self.msg = json["msg"].stringValue
                }
                completion(true)
            }
        }
 
    }
}











