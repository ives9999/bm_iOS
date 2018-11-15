//
//  DataService.swift
//  bm
//
//  Created by ives on 2017/10/4.
//  Copyright © 2017年 bm. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON

class DataService {
    static let instance1 = DataService()
    
//    private let homes = [
//        Home(featured: "1.jpg", title: "艾傑早安羽球團8月份會內賽"),
//        Home(featured: "2.jpg", title: "永遠支持的戴資穎"),
//        Home(featured: "3.jpg", title: "外媒評十大羽毛球美女，馬琳竟上榜！")
//    ]
    var id: Int = 0
    var homes: Dictionary<String, [Home]> = Dictionary<String, [Home]>()
    var dataLists: [SuperData] = [SuperData]()
    var totalCount: Int!
    var page: Int!
    var perPage: Int!
    var show: Dictionary<String, Any> = Dictionary<String, Any>()
    var show_html: String = ""
    var downloadImageNum: Int = 0
    var needDownloads: [Dictionary<String, Any>] = [Dictionary<String, Any>]()
    var image: UIImage?
    //var homesRaw: Dictionary<String, [Dictionary<String, String>]> = Dictionary<String, [Dictionary<String, String>]>()
    //var titles: [String] = [String]()
    //var pathes: [String] = [String]()
    //var featureds: [UIImage] = [UIImage]()
    
    var citys: [City] = [City]()
    var arenas: [Arena] = [Arena]()
    var citysandarenas:[Int:[String:Any]] = [Int:[String:Any]]()
    var citysandareas:[Int:[String:Any]] = [Int:[String:Any]]()
    var msg:String = ""
    var success: Bool = false
    
    var _model: SuperData
    var model: SuperData {
        get {
            return _model
        }
        set {
            _model = newValue
        }
    }
    
    init() {
        _model = Team.instance
    }
    
    func setData(id: Int, title: String, path: String, token: String, youtube: String = "", vimeo: String = "") -> SuperData {
        let list = SuperData(id: id, title: title, path: path, token: token, youtube: youtube, vimeo: vimeo)
        return list
    }
    
    func setData1(row: JSON)->Dictionary<String, [String: Any]> {
        let list = Dictionary<String, [String: Any]>()
        return list
    }
    
    func getList(type: String, titleField: String, params:[String:Any], page: Int, perPage: Int, filter:[[Any]]?, completion: @escaping CompletionHandler) {
        
        self.needDownloads = [Dictionary<String, Any>]()
        var body: [String: Any] = ["source": "app", "channel": CHANNEL, "page": String(page), "perPage": String(perPage)]
        if filter != nil {
            body["where"] = filter
        }
        body = body.merging(params){ (current, _) in current }
        //print(body)
        let url: String = String(format: URL_LIST, type)
        //print(url)
        dataLists = [SuperData]()
        
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            
            if response.result.error == nil {
                //print(response.result)
                guard let data = response.result.value else {
                    print("get response result value error")
                    return
                }
                let json = JSON(data)
                //print(json)
                //if page == 1 {
                    self.dataLists = [SuperData]()
                //}
                //print("page: \(page)")
                self.totalCount = json["totalCount"].intValue
                if self.totalCount > 0 {
                    self.page = json["page"].intValue
                    self.perPage = json["perPage"].intValue
                    let rows: [JSON] = json["rows"].arrayValue
                    for i in 0 ..< rows.count {
                        let row = rows[i]
                        let title: String = row[titleField].stringValue
                        let id: Int = row["id"].intValue
                        let token: String = row["token"].stringValue
                        let vimeo: String = row["vimeo"].stringValue
                        let youtube: String = row["youtube"].stringValue
                        
                        var path: String!
                        let path1 = row["featured_path"].stringValue
                        if (path1.count > 0) {
                            if (!path1.startWith("http://") && !path1.startWith("https://")) {
                                path = BASE_URL + path1
                            } else {
                                path = path1
                            }
                            self.needDownloads.append(["idx": i, "path": path])
                        } else {
                            path = ""
                        }
                        
                        let list = self.setData(id: id, title: title, path: path, token: token, youtube: youtube, vimeo: vimeo)
                        let map = self.setData1(row: row)
                        list.data = map
                        self.dataLists.append(list)
                    }
                    //self.model.aPrint()
                    //print(self.dataLists)
//                    for item in self.dataLists {
//                        print(item.data)
//                    }
                    //print("need download image: \(self.needDownloads.count)")
                    let needDownload: Int = self.needDownloads.count
                    if (needDownload > 0) {
                        var tmp: Int = needDownload
                        for i in 0 ..< needDownload {
                            self.getImage(url: self.needDownloads[i]["path"] as! String, completion: { (success) in
                                if success {
                                    let idx: Int = self.needDownloads[i]["idx"] as! Int
                                    self.dataLists[idx].featured = self.image!
                                }
                                tmp -= 1
                                if (tmp == 0) {
                                    completion(true)
                                }
                            })
                        }
                    } else {
                        completion(true)
                    }
                } else {// total count == 0
                    completion(true)
                }
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
            
        }
    }
    
    func getOne(type: String, token: String, completion: @escaping CompletionHandler) {
        
        //print(model)
        //model.neverFill()
        downloadImageNum = 0
        let body: [String: Any] = ["source": "app", "token": token, "strip_html": true]
        
        //print(body)
        let url: String = String(format: URL_ONE, type)
        //print(url)
        
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            
            if response.result.error == nil {
                //print(response.result.value)
                guard let data = response.result.value else {
                    print("get response result value error")
                    return
                }
                //print(data)
                let json = JSON(data)
                //print(json)
                self.setData1(row: json)
                
                //var images: [String] = [String]()
//                for (key, item) in self.model.data {
//                    if json[key] != JSON.null {
//                        let tmp = json[key]
//                        var value: Any?
//                        let vType: String = item["vtype"] as! String
//                        if vType == "Int" {
//                            value = tmp.intValue
//                            self.model.data[key]!["value"] = value
//                            self.model.data[key]!["show"] = "\(value ?? "")"
//                        } else if vType == "String" {
//                            value = tmp.stringValue
//                            self.model.data[key]!["value"] = value
//                            self.model.data[key]!["show"] = value
//                        } else if vType == "array" {
//                            if key == CITY_KEY {
//                                let id: Int = tmp["id"].intValue
//                                let name: String = tmp["name"].stringValue
//                                let city: City = City(id: id, name: name)
//                                self.model.updateCity(city)
//                            } else if key == ARENA_KEY {
//                                let id: Int = tmp["id"].intValue
//                                let name: String = tmp["name"].stringValue
//                                let arena: Arena = Arena(id: id, name: name)
//                                self.model.updateArena(arena)
//                            } else if key == TEAM_DAYS_KEY {
//                                let tmp1: [JSON] = tmp.arrayValue
//                                var days: [Int] = [Int]()
//                                for item in tmp1 {
//                                    days.append(item["day"].intValue)
//                                }
//                                self.model.updateDays(days)
//                            } else if key == TEAM_DEGREE_KEY {
//                                let tmp1: String = tmp.stringValue
//                                let degrees: [String] = tmp1.components(separatedBy: ",")
//                                self.model.updateDegree(self.strsToDegree(degrees))
//                            }
//                        } else if vType == "image" {
//                            if key == FEATURED_KEY {
//                                var tmp1: String = tmp.stringValue
//                                if (tmp1.count > 0) {
//                                    tmp1 = BASE_URL + tmp1
//                                    self.model.data[key]!["path"] = tmp1
//                                }
//                            }
//                        }
//                    }
//                }
                
                //print(self.model.data)
                
                let path: String = self.model.data[FEATURED_KEY]!["path"] as! String
                if path.count > 0 {
                    self.getImage(url: path, completion: { (success) in
                        if success {
                            self.model.data[FEATURED_KEY]!["value"] = self.image
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
    
    func update(type: String, params: [String: Any], _ image: UIImage?, key: String, filename: String, mimeType: String, completion: @escaping CompletionHandler) {
        
        let url: String = String(format: URL_UPDATE, type)
        //print(url)
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
        var body: [String: Any] = ["source": "app"]
        body.merge(params)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if image != nil {
                let imageData: Data = UIImageJPEGRepresentation(image!, 0.2)! as Data
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
                } else if key == CAT_KEY {
                    for d in value as! [Int] {
                        multipartFormData.append(("\(d)").data(using: .utf8)!, withName: "cat_id[]")
                    }
                } else {
                    multipartFormData.append(("\(value)").data(using: .utf8)!, withName: key)
                }
            }
            //print(multipartFormData.boundary)
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
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
                        //print(self.success)
                        if self.success {
                            self.id = json["id"].intValue
                        } else {
                            if json["fields"].exists() {
                                let errors: [String: JSON] = json["fields"].dictionary!
                                for (_, value) in errors {
                                    let error = value.stringValue
                                    self.msg += error + "\n"
                                }
                            }
                            //print(self.msg)
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
    
    func delete(token: String, type: String, completion: @escaping CompletionHandler) {
        let body: [String: String] = ["source": "app", "channel": "bm", "token": token]
        let url: String = String(format: URL_DELETE, type)
        //print(url)
        //print(body)
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.result.value else {
                    print("data error")
                    return
                }
                //print(data)
                let json: JSON = JSON(data)
                self.success = json["success"].boolValue
                if self.success {
                } else {
                    self.msg = json["msg"].stringValue
                }
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func getHomes(completion: @escaping CompletionHandler) {
        let body: [String: Any] = ["device": "app"]
        //print(URL_HOME)
        
        Alamofire.request(URL_HOME, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON {
            (response) in
            if response.result.error == nil {
                if let json = response.result.value as? Dictionary<String, Any> {
                    //print(json)
                    let courseArray = json["courses"] as! [Dictionary<String, AnyObject>]
                    let courseHome = self.parseHomeJSON(array: courseArray, titleField: "title", type: "course", video: true)
                    //print(courseArray1)
                    self.homes["courses"] = courseHome
                    let newsArray = json["news"] as! [Dictionary<String, AnyObject>]
                    let newsHome = self.parseHomeJSON(array: newsArray, titleField: "title", type: "news")
                    self.homes["news"] = newsHome
                    let arenaArray = json["arenas"] as! [Dictionary<String, AnyObject>]
                    let arenaHome = self.parseHomeJSON(array: arenaArray, titleField: "name", type: "arena")
                    self.homes["arenas"] = arenaHome
                    //let jsonString = JSON.encodeAsString(self.homes)
                    //print(self.downloadImageNum)
                    self.getHomeFeatured(completion: { (success) in
                        if(success) {
                            //self.downloadImageNum -= 1
                            //print(self.downloadImageNum)
                            //print(self.image)
                            //if self.downloadImageNum == 0 {
                                //print(self.homes)
                                completion(true)
                            //}
                        }
                    })
                }
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func getHomeFeatured(completion: @escaping CompletionHandler) {
        var allHomeImages: Dictionary<String, [Dictionary<String, Any>]> = Dictionary<String, [Dictionary<String, Any>]>()
        var allImages: [Dictionary<String, Any>]
        var count: Int = 0
        for (key, value) in homes {
            allImages = [Dictionary<String, Any>]()
            for i in 0..<value.count {
                let path: String = value[i].path
                if path.count > 0 {
                    //print(path)
                    allImages.append(["idx": i, "path": path])
                    count += 1
                }
            }
            allHomeImages[key] = allImages
        }
        for (key, value) in allHomeImages {
            needDownloads = value
            for i in 0..<needDownloads.count {
                let path: String = needDownloads[i]["path"] as! String
                let idx: Int = needDownloads[i]["idx"] as! Int
                getImage(url: path, completion: { (success) in
                    if (success) {
                        self.homes[key]![idx].featured = self.image!
                        count -= 1
                        if (count == 0) {
                            completion(true)
                        }
                    }
                })
            }
        }
    }
    
    func getImage(url: String, completion: @escaping CompletionHandler) {
        Alamofire.request(url).responseImage(completionHandler: { (response) in
            if response.result.isSuccess {
                guard let image = response.result.value else { return }
                self.image = image
            } else {
                //print("download image false: \(url)")
                self.image = UIImage(named: "nophoto")
            }
            completion(true)
        })
    }
    
    func getShow(type: String, id: Int, token: String, completion: @escaping CompletionHandler) {
        let body: [String: Any] = ["source": "app", "id": id, "token": token, "type": type]
        let url: String = String(format: URL_SHOW, type)
        //print(url)
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseString { (response) in

            if response.result.isSuccess {
                self.show_html = response.result.value!
                //print(self.show_html)
                completion(true)
//                let jsonString = response.result.value
//                //print(jsonString)
//                if let json = try? JSON.decode(jsonString!) {
//                    let title = try? json.getString("title")
//                    let content = try? json.getString("content")
//                    var path = try? json.getString("featured_path")
//                    self.show = ["title": title!, "path": path!, "content": content!]
//                    if (path!.count > 0) {
//                        path = BASE_URL + path!
//                        self.show["path"] = path!
//                        self.getImage(url: path!, completion: { (success) in
//                            if success {
//                                self.show["featured"] = self.image
//                            }
//                            completion(true)
//                        })
//                    }
//                }
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func getCitys(type: String="all", zone:Bool=false, completion: @escaping CompletionHandler) {
        let body: [String: Any] = ["source": "app","channel":"bm","type":type,"zone":zone]
        Alamofire.request(URL_CITYS, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.result.value else {
                    print("data error")
                    return
                }
                let json = JSON(data)
                //print(json)
                let jsonArray: [JSON] = json[].arrayValue
                self.citys = [City]()
                for city in jsonArray {
                    let id: Int = city["id"].intValue
                    let name: String = city["name"].stringValue
                    self.citys.append(City(id: id, name: name))
                }
                
                completion(true)
            }
        }
    }
    
    // 將不使用了，請使用getCitys代替
    func getAllCitys(completion: @escaping CompletionHandler) {
        let body: [String: Any] = ["source": "app"]
        Alamofire.request(URL_CITYS, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.result.value else {
                    print("data error")
                    return
                }
                let json = JSON(data)
                let jsonArray: [JSON] = json[].arrayValue
                self.citys = [City]()
                for city in jsonArray {
                    let id: Int = city["id"].intValue
                    let name: String = city["name"].stringValue
                    self.citys.append(City(id: id, name: name))
                }
                
                completion(true)
            }
        }
    }
    // 將不使用了，請使用getCitys代替
    func getCustomCitys(completion: @escaping CompletionHandler) {
        let body: [String: Any] = ["source": "app"]
        Alamofire.request(URL_CUSTOM_CITYS, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.result.value else {
                    print("data error")
                    return
                }
                let json = JSON(data)
                //print(json)
                let jsonArray: [JSON] = json[].arrayValue
                self.citys = [City]()
                for city in jsonArray {
                    let id: Int = city["id"].intValue
                    let name: String = city["name"].stringValue
                    self.citys.append(City(id: id, name: name))
                }
                //print(self.citys)
                
                completion(true)
            }
        }
    }
    
    func getArenaByCityID(city_id: Int, completion: @escaping CompletionHandler) {
        let body: [String: Any] = ["source": "app", "city": city_id]
        Alamofire.request(URL_ARENA_BY_CITY_ID, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.result.value else {
                    print("data error")
                    return
                }
                let json = JSON(data)
                let jsonArray: [JSON] = json[].arrayValue
                self.arenas = [Arena]()
                for arena in jsonArray {
                    let id: Int = arena["id"].intValue
                    let name: String = arena["name"].stringValue
                    self.arenas.append(Arena(id: id, name: name))
                }
                
                completion(true)
            }
        }
    }
    func getArenaByCityIDs(city_ids: [Int],city_type:String, completion: @escaping CompletionHandler) {
        let body: [String: Any] = ["source": "app", "channel":"bm","citys": city_ids,"city_type":city_type,"version":"1.2.5"]
        //print(body)
        //print(URL_ARENA_BY_CITY_IDS)
        Alamofire.request(URL_ARENA_BY_CITY_IDS, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.result.value else {
                    print("data error")
                    return
                }
                let json = JSON(data)
                //print(json)
                for (city_id, item) in json {
                    let id: Int = item["id"].intValue
                    let city_name: String = item["name"].stringValue
                    let _rows: [JSON] = item["rows"].arrayValue
                    var rows: [[String: Any]] = [[String: Any]]()
                    for _row in _rows {
                        let arena_id: Int = _row["id"].intValue
                        let arena_name: String = _row["name"].stringValue
                        rows.append(["id":arena_id,"name":arena_name])
                    }
                    self.citysandarenas[id] = ["id":id,"name":city_name,"rows":rows]
                }
                //print(self.citysandarenas)
                
                completion(true)
            }
        }
    }
    
    func getAreaByCityIDs(city_ids: [Int],city_type:String, completion: @escaping CompletionHandler) {
        let body: [String: Any] = ["source": "app", "channel":"bm","citys": city_ids,"city_type":city_type]
        //print(body)
        //print(URL_ARENA_BY_CITY_IDS)
        Alamofire.request(URL_AREA_BY_CITY_IDS, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.result.value else {
                    print("data error")
                    return
                }
                let json = JSON(data)
                //print(json)
                for (city_id, item) in json {
                    let id: Int = item["id"].intValue
                    let city_name: String = item["name"].stringValue
                    let _rows: [JSON] = item["rows"].arrayValue
                    var rows: [[String: Any]] = [[String: Any]]()
                    for _row in _rows {
                        let area_id: Int = _row["id"].intValue
                        let area_name: String = _row["name"].stringValue
                        rows.append(["id":area_id,"name":area_name])
                    }
                    self.citysandareas[id] = ["id":id,"name":city_name,"rows":rows]
                }
                //print(self.citysandareas)
                
                completion(true)
            }
        }
    }
    
    func parseHomeJSON(array: [Dictionary<String, Any>], titleField: String, type: String, video: Bool=false) -> [Home] {
        var result: [Home] = [Home]()
        var i: Int = 0
        for item in array {
            let id: Int = item["id"] as? Int ?? 0
            let title: String = item[titleField] as? String ?? ""
            var path: String = item["featured_path"] as? String ?? ""
            if (path.count > 0) {
                path = BASE_URL + path
            }
            let youtube: String = item["youtube"] as? String ?? ""
            let vimeo: String = item["vimeo"] as? String ?? ""
            let token: String = item["token"] as? String ?? ""
            let home = Home(id: id, title: title, path: path, youtube: youtube, vimeo: vimeo, token: token, type: type)
            result.append(home)
            i += 1
        }
        
        return result
    }
    
    func getHomeItem(indexPath: IndexPath) -> Home {
        let key: String = sectionToKey(section: indexPath.section).key
        return homes[key]![indexPath.row]
    }
    
    func sectionToKey(section: Int) -> (key: String, chTitle: String, type: String) {
        var key: String
        var chTitle: String
        var type : String
        switch section {
        case 0:
            key = "courses"
            type = "cours"
            chTitle = "課程"
            break
        case 1:
            key = "news"
            type = "news"
            chTitle = "新聞"
            break
        case 2:
            key = "arenas"
            type = "arena"
            chTitle = "球館"
            break
        default:
            key = "courses"
            type = "cours"
            chTitle = "課程"
        }
        
        return (key, chTitle, type)
    }
    func strsToDegree(_ strs: [String])-> [Degree] {
        return [Degree]()
    }
}
