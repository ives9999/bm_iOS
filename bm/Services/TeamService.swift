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
                        multipartFormData.append(("\(d)").data(using: .utf8)!, withName: "play_day[]")
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
                })
                completion(true)
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
                let json = JSON(data)
                //print(json)
                
                //var images: [String] = [String]()
                for (key, item) in Team.instance.data {
                    if json[key] != JSON.null {
                        let tmp = json[key]
                        var value: Any?
                        let type: String = item["vtype"] as! String
                        if type == "Int" {
                            value = tmp.intValue
                            Team.instance.data[key]!["value"] = value
                            Team.instance.data[key]!["show"] = "\(value ?? "")"
                        } else if type == "String" {
                            value = tmp.stringValue
                            Team.instance.data[key]!["value"] = value
                            Team.instance.data[key]!["show"] = value
                        } else if type == "array" {
                            if key == TEAM_CITY_KEY {
                                let id: Int = tmp["id"].intValue
                                let name: String = tmp["name"].stringValue
                                let city: City = City(id: id, name: name)
                                Team.instance.updateCity(city)
                            } else if key == TEAM_ARENA_KEY {
                                let id: Int = tmp["id"].intValue
                                let name: String = tmp["name"].stringValue
                                let arena: Arena = Arena(id: id, name: name)
                                Team.instance.updateArena(arena)
                            } else if key == TEAM_DAYS_KEY {
                                let tmp1: [JSON] = tmp.arrayValue
                                var days: [Int] = [Int]()
                                for item in tmp1 {
                                    days.append(item["day"].intValue)
                                }
                                Team.instance.updateDays(days)
                            } else if key == TEAM_DEGREE_KEY {
                                let tmp1: String = tmp.stringValue
                                let degrees: [String] = tmp1.components(separatedBy: ",")
                                Team.instance.updateDegree(degrees)
                            }
                        } else if type == "image" {
                            if key == TEAM_FEATURED_KEY {
                                var tmp1: String = tmp.stringValue
                                if (tmp1.count > 0) {
                                    tmp1 = BASE_URL + tmp1
                                    Team.instance.data[key]!["path"] = tmp1
                                }
                            }
                        }
                    }
                }
                Team.instance.updatePlayStartTime()
                Team.instance.updatePlayEndTime()                
                Team.instance.updateTempContent()
                Team.instance.updateCharge()
                Team.instance.updateContent()
                //print(Team.instance.data)
                
                let path: String = Team.instance.data[TEAM_FEATURED_KEY]!["path"] as! String
                if path.count > 0 {
                    DataService.instance.getImage(url: path, completion: { (success) in
                        if success {
                            Team.instance.data[TEAM_FEATURED_KEY]!["value"] = DataService.instance.image
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
//    func update(params: [String: Any], completion: @escaping CompletionHandler) {
//        var body: [String: Any] = ["source": "app"]
//        body.merge(params)
//        print(body)
//        Alamofire.request(URL_TEAM_UPDATE, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
//            if response.result.error == nil {
//                guard let data = response.result.value else {
//                    print("data error")
//                    return
//                }
//                let json = JSON(data)
//                self.success = json["success"].boolValue
//                if self.success {
//                    self.id = json["id"].intValue
//                } else {
//                    let errors: [String] = json["msg"].arrayObject as! [String]
//                    for i in 0 ..< errors.count {
//                        self.msg += errors[i]
//                    }
//                    //print(self.msg)
//                }
//                completion(true)
//            }
//        }
//    }
    
}
