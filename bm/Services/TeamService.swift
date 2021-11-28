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

class TeamService: DataService {
    
    static let instance = TeamService()
    
    //var team: Team = Team()
    //override var model: SuperData = Team.instance
    var tempPlayDates: Array<String> = Array()
    var tempPlayDatePlayer: TempPlayDatePlayer = TempPlayDatePlayer()
    
    var tempPlayList: [DATA] = [DATA]()
    
//    override init() {
//        super.init()
//        _model = Team.instance
//    }
    
    override func getListURL() -> String {
        return URL_TEAM_LIST
    }
    
    override func getSource() -> String? {
        return "team"
    }
    
    override func getLikeURL(token: String? = nil) -> String {
        var url: String = URL_TEAM_LIKE
        if token != nil {
            url = url + "/" + token!
        }
        
        return url
    }
    
    override func getUpdateURL()-> String {
        return String(format: URL_UPDATE, "team")
    }
    
    func tempPlay_onoff(token: String, completion: @escaping CompletionHandler) {
        let body: [String: String] = ["source": "app", "token": token, "strip_html": "true"]
        
        AF.request(URL_TEAM_TEMP_PLAY, method: .post, parameters: body, encoder: JSONParameterEncoder.default, headers: HEADER).responseJSON { (response) in
            
            switch response.result {
            case .success(_):
                if response.data != nil {
                    self.jsonData = response.data
                    completion(true)
                } else {
                    self.msg = "網路錯誤，請稍後再試"
                    completion(false)
                }
            case .failure(let error):
                self.msg = "伺服器回傳錯誤，所以無法解析字串，請洽管理員"
                completion(false)
                print(error)
                return
            }
            
//            if response.result.error == nil {
//                //print(response.result.value)
//                guard let data = response.result.value else {
//                    print("get response result value error")
//                    self.msg = "網路錯誤，請稍後再試"
//                    completion(false)
//                    return
//                }
//                let json = JSON(data)
//                completion(true)
//            } else {
//                self.msg = "網路錯誤，請稍後再試"
//                completion(false)
//            }
        }
    }
    
    func tempPlay_list(params:[String:String],page:Int, perPage: Int, completion: @escaping CompletionHandler) {
            
        var body: [String: String] = ["source": "app", "channel": CHANNEL, "page": String(page), "perPage": String(perPage)]
        body = body.merging(params){ (current, _) in current }
        //print(body)
        //print(URL_TEAM_TEMP_PLAY_LIST)
        tempPlayList = [DATA]()
        
        AF.request(URL_TEAM_TEMP_PLAY_LIST, method: .post, parameters: body, encoder: JSONParameterEncoder.default, headers: HEADER).responseJSON { (response) in
            
            
            switch response.result {
            case .success(_):
                if response.data != nil {
                    self.jsonData = response.data
                    completion(true)
                } else {
                    self.msg = "網路錯誤，請稍後再試"
                    completion(false)
                }
            case .failure(let error):
                self.msg = "伺服器回傳錯誤，所以無法解析字串，請洽管理員"
                completion(false)
                print(error)
                return
            }
            
//            if response.result.error == nil {
//                //print(response.result.value)
//                guard let data = response.result.value else {
//                    print("get response result value error")
//                    self.msg = "網路錯誤，請稍後再試"
//                    completion(false)
//                    return
//                }
//                //print(data)
//
//                let json = JSON(data)
//                self.tempPlayList = [DATA]()
//                self.totalCount = json["totalCount"].intValue
//                if self.totalCount > 0 {
//                    self.page = json["page"].intValue
//                    self.perPage = json["perPage"].intValue
//                    let arr: [JSON] = json["rows"].arrayValue
//                    //print(arr)
//                    completion(true)
//                } else {// total count == 0
//                    completion(true)
//                }
//            } else {
//                self.msg = "網路錯誤，請稍後再試"
//                completion(false)
//            }
//        }
        }
    }
    
    func tempPlay_date(token: String,completion: @escaping CompletionHandler) {
        let url: String = URL_TEAM_TEMP_PLAY_DATE
        let body: [String: String] = ["source":"app","channel":CHANNEL,"token":token]
        //print(body)
        //print(url)
        
        
        AF.request(url, method: .post, parameters: body, encoder: JSONParameterEncoder.default, headers: HEADER).responseJSON { (response) in
            
            switch response.result {
            case .success(_):
                if response.data != nil {
                    self.jsonData = response.data
                    completion(true)
                } else {
                    self.msg = "網路錯誤，請稍後再試"
                    completion(false)
                }
            case .failure(let error):
                self.msg = "伺服器回傳錯誤，所以無法解析字串，請洽管理員"
                completion(false)
                print(error)
                return
            }
                
            //            if response.result.error == nil {
            //                //print(response.result.value)
            //                guard let data = response.result.value else {
            //                    print("get response result value error")
            //                    self.msg = "網路錯誤，請稍後再試"
            //                    completion(false)
            //                    return
            //                }
            //                //print(data)
            //                let json = JSON(data)
            //                let success: Bool = json["success"].boolValue
            //                if success {
            //                    let arr: [JSON] = json["rows"].arrayValue
            //                    //print(arr)
            //                    self.tempPlayDates.removeAll()
            //                    for i in 0 ..< arr.count {
            //                        let date: String = arr[i].stringValue
            //                        self.tempPlayDates.append(date)
            //                    }
            //                    completion(true)
            //                } else {
            //                    self.msg = json["msg"].stringValue
            //                    completion(false)
            //                }
            //            } else {
            //                self.msg = "網路錯誤，請稍後再試"
            //                completion(false)
            //            }
        }
    }
        
    func tempPlay_datePlayer(date:String,token: String, completion: @escaping CompletionHandler) {
        let url: String = URL_TEAM_TEMP_PLAY_DATE_PLAYER
        let body: [String: String] = ["source":"app","channel":CHANNEL,"token":token,"date":date]
        //print(body)
        //print(url)
        
        AF.request(url, method: .post, parameters: body, encoder: JSONParameterEncoder.default, headers: HEADER).responseJSON { (response) in
            //print(response.result.value)
            
            switch response.result {
            case .success(_):
                if response.data != nil {
                    self.jsonData = response.data
                    completion(true)
                } else {
                    self.msg = "網路錯誤，請稍後再試"
                    completion(false)
                }
            case .failure(let error):
                self.msg = "伺服器回傳錯誤，所以無法解析字串，請洽管理員"
                completion(false)
                print(error)
                return
            }
            
    //            if response.result.error == nil {
    //                //print(response.result.value)
    //                guard let data = response.result.value else {
    //                    print("get response result value error")
    //                    self.msg = "網路錯誤，請稍後再試"
    //                    completion(false)
    //                    return
    //                }
    //                let json = JSON(data)
    //                self.tempPlayDatePlayer = JSONParse.parse(data: json)
    //                //print(self.tempPlayDatePlayer!.rows)
    //
    //                let success: Bool = self.tempPlayDatePlayer.success
    //                if success {
    //                    completion(true)
    //                } else {
    //                    self.msg = json["msg"].stringValue
    //                    completion(false)
    //                }
    //            } else {
    //                self.msg = "網路錯誤，請稍後再試"
    //                completion(false)
    //            }
        }
    }
        
    //    func _jsonToData(tmp: JSON, key: String, item: [String: Any]) {
    //        var value: Any?
    //        let type: String = item["vtype"] as! String
    //        if type == "Int" {
    //            value = tmp.intValue
    //            model.data[key]!["value"] = value
    //            model.data[key]!["show"] = "\(value ?? "")"
    //        } else if type == "String" {
    //            value = tmp.stringValue
    //            //print("\(key) => \(value!)")
    //            model.data[key]!["value"] = value!
    //            model.data[key]!["show"] = value!
    //            if key == TEAM_PLAY_START_KEY || key == TEAM_PLAY_END_KEY {
    //                model.updateTime(key: key, value as? String)
    //            }
    //        } else if type == "array" {
    //            if key == CITY_KEY {
    //                let id: Int = tmp["id"].intValue
    //                let name: String = tmp["name"].stringValue
    //                let city: City = City(id: id, name: name)
    //                model.updateCity(city)
    //            } else if key == ARENA_KEY {
    //                let id: Int = tmp["id"].intValue
    //                let name: String = tmp["name"].stringValue
    //                let arena: Arena = Arena(id: id, name: name)
    //                model.updateArena(arena)
    //            } else if key == TEAM_WEEKDAYS_KEY {
    //                let tmp1: [JSON] = tmp.arrayValue
    //                var days: [Int] = [Int]()
    //                for item in tmp1 {
    //                    days.append(item["weekday"].intValue)
    //                }
    //                model.updateWeekdays(days)
    //            } else if key == TEAM_DEGREE_KEY {
    //                let tmp1: String = tmp.stringValue
    //                let degrees: [String] = tmp1.components(separatedBy: ",")
    //                model.updateDegree(strsToDegree(degrees))
    //            }
    //        }
    //    }
    func plusOne(title: String, near_date: String, token: String, completion: @escaping CompletionHandler) {
        var url: String = "\(URL_TEAM_PLUSONE)\(title)?source=app&date=\(near_date)&token=\(token)"
        //print(url)
        url = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            //print(url)
    //        Alamofire.request(url).response { (response) in
    //            print("Request: \(response.request)")
    //            print("Response: \(response.response)")
    //            print("Error: \(response.error)")
    //
    //            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
    //                print("Data: \(utf8Text)")
    //            }
    //        }
        AF.request(url).responseJSON { (response) in
            
            switch response.result {
            case .success(_):
                if response.data != nil {
                    self.jsonData = response.data
                    completion(true)
                } else {
                    self.msg = "網路錯誤，請稍後再試"
                    completion(false)
                }
            case .failure(let error):
                self.msg = "伺服器回傳錯誤，所以無法解析字串，請洽管理員"
                completion(false)
                print(error)
                return
            }
            
//            if response.result.error == nil {
//                guard let data = response.result.value else {
//                    print("get response result value error")
//                    return
//                }
//                let json = JSON(data)
//                //print(json)
//                self.success = json["success"].boolValue
//                if !self.success {
//                    self.msg = json["msg"].stringValue
//                }
//                completion(self.success)
//            }
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
            
        AF.request(url).responseJSON { (response) in
            
            switch response.result {
            case .success(_):
                if response.data != nil {
                    self.jsonData = response.data
                    completion(true)
                } else {
                    self.msg = "網路錯誤，請稍後再試"
                    completion(false)
                }
            case .failure(let error):
                self.msg = "伺服器回傳錯誤，所以無法解析字串，請洽管理員"
                completion(false)
                print(error)
                return
            }
            
//            if response.result.error == nil {
//                guard let data = response.result.value else {
//                    print("get response result value error")
//                    return
//                }
//                let json = JSON(data)
//                self.success = json["success"].boolValue
//                if !self.success {
//                    self.msg = json["msg"].stringValue
//                }
//                completion(true)
//            }
        }
    }
    
    func addBlackList(teamToken: String, playerToken: String, managerToken:String,reason: String, completion: @escaping CompletionHandler) {
        
        let body: [String: String] = ["source": "app","channel":CHANNEL,"teamToken":teamToken,"playerToken":playerToken,"managerToken":managerToken,"memo":reason,"do":"add"]
        //print(body)
        _blacklist(body: body, completion: completion)
    }
        
    func removeBlackList(teamToken:String,playerToken:String,managerToken:String,completion: @escaping CompletionHandler) {
        
        let body: [String: String] = ["source": "app","channel":CHANNEL,"teamToken":teamToken,"playerToken":playerToken,"managerToken":managerToken,"do":"remove"]
        //print(body)
        _blacklist(body: body, completion: completion)
    }
            
    func _blacklist(body: [String: String], completion: @escaping CompletionHandler) {
        
        let url: String = URL_TEAM_TEMP_PLAY_BLACKLIST
        AF.request(url, method: .post, parameters: body, encoder: JSONParameterEncoder.default).responseJSON { (response) in
            
            switch response.result {
            case .success(_):
                if response.data != nil {
                    self.jsonData = response.data
                    completion(true)
                } else {
                    self.msg = "網路錯誤，請稍後再試"
                    completion(false)
                }
            case .failure(let error):
                self.msg = "伺服器回傳錯誤，所以無法解析字串，請洽管理員"
                completion(false)
                print(error)
                return
            }
            
//            if response.result.error == nil {
//                guard let data = response.result.value else {
//                    print("get response result value error")
//                    return
//                }
//                let json = JSON(data)
//                //print(json)
//                self.success = json["success"].boolValue
//                if !self.success {
//                    self.msg = json["msg"].stringValue
//                }
//                completion(self.success)
//            }
        }
    }
    
    override func strsToDegree(_ strs: [String])-> [Degree] {
        
        var res: [Degree] = [Degree]()
        for str in strs {
            let value = DEGREE.enumFromString(string: str)
            let text = value.rawValue
            let degree = Degree(value: value, text: text)
            res.append(degree)
        }
        return res
    }
    
//    override func setData(id: Int, title: String, path: String, token: String, youtube: String, vimeo: String) -> Team {
//        let superData = Team(id: id, title: title, path: path, token: token, youtube: youtube, vimeo: vimeo)
//        return superData
//    }
//    override func setData1(row: JSON) -> Dictionary<String, [String : Any]> {
//        model.listReset()
//        for (key, value) in model.data {
//            if row[key].exists() {
//                _jsonToData(tmp: row[key], key: key, item: value)
//            }
//        }
//        if row["near_date_w"] != JSON.null {
//            let n2: String = row["near_date_w"].stringValue
//            model.data[TEAM_NEAR_DATE_KEY]!["value1"] = n2
//        }
//        var signups:[[String: String]] = [[String: String]]()
//        
//        if row["signups"] != JSON.null {
//            let items: [JSON] = row["signups"].arrayValue
//            for item in items {
//                let member: JSON = item["member"]
//                //print(member)
//                let nickname: String = member["nickname"].stringValue
//                let token: String = member["token"].stringValue
//                let created_at: String = item["created_at"].stringValue
//                let status: String = item["status"].stringValue
//                let off_at: String = item["off_at"].stringValue
//                signups.append(["nickname":nickname, "token":token,"created_at":created_at,"status":status,"off_at":off_at])
//                //print(signups)
//            }
//            if model.data["signups"] == nil {
//                model.data["signups"] = [String: Any]()
//            }
//            model.data["signups"]!["value"] = signups
//            model.data["signups"]!["vtype"] = "array"
//            //print(model.data)
//            
//        }
//        
//        model.initTimeShow()
//        model.updateNearDate()
//        model.updateInterval()
//        model.setAllTextSender()
//        return model.data
//    }
    
    
}











