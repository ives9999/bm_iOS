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
    var arenas: [ArenaTable] = [ArenaTable]()
    var citysandarenas:[Int:[String:Any]] = [Int:[String:Any]]()
    var citysandareas:[Int:[String:Any]] = [Int:[String:Any]]()
    var msg:String = ""
    var success: Bool = false
    var signup_date: JSON = JSON()//signup_date use
    
    var _model: SuperData
    var model: SuperData {
        get {
            return _model
        }
        set {
            _model = newValue
        }
    }
    
    var timetables: Timetables = Timetables()
    
    var superModel: SuperModel = SuperModel()
    var able: SuperModel = SuperModel() // for signup list able model
    
    var table: Table?
    var tables: Tables?
    
    var jsonData: Data?
    
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
    
    func getList(token: String?, _filter:[String: Any]?, page: Int, perPage: Int, completion: @escaping CompletionHandler) {
        
        self.needDownloads = [Dictionary<String, Any>]()
        var filter: [String: Any] = ["source": "app", "channel": CHANNEL, "page": page, "perPage": perPage]
        if _filter != nil {
            filter.merge(_filter!)
        }
        
        if (Member.instance.isLoggedIn) {
            filter.merge(["member_token":Member.instance.token])
        }
        //print(filter.toJSONString())
        
        var url: String = getListURL()
        if (token != nil) {
            url = url + "/" + token!
        }
        //print(url)
                
        Alamofire.request(url, method: .post, parameters: filter, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            
            switch response.result {
            //case .success(let value):
            case .success(_):
                if response.data != nil {
                    //let json = JSON(value)
                    //print(json)
                    self.jsonData = response.data
                    completion(true)
                    //s = try JSONDecoder().decode(t, from: response.data!)
                    //if s != nil {
                        //self.tables = s!
                        //s!.printRow()
                        
//                            let a1: CoursesTable = s! as! CoursesTable
//                            let rows:[CourseTable] = a1.rows
//                            for row in rows {
//                                print(row.coachTable)
//                                row.coachTable?.printRow()
//                                row.filterRow()
//                                row.printRow()
//                            }
                        
                        //completion(true)
//                        } else {
//                            self.msg = "解析JSON字串時，得到空直，請洽管理員"
//                            completion(false)
//                        }
                } else {
                    self.msg = "沒有任何伺服器回傳的訊息"
                    completion(false)
                }
            case .failure(let error):
                self.msg = "伺服器回傳錯誤，所以無法解析字串，請洽管理員"
                completion(false)
                print(error)
                return
            }
        }
    }
    
    func getOne1<T: Table>(t: T.Type, params: [String: String], completion: @escaping CompletionHandler){
        
        var body: [String: Any] = ["device": "app","strip_html": false]
        if params["token"] != nil {
            body["token"] = params["token"]
        }
        if params["member_token"] != nil {
            body["member_token"] = params["member_token"]
        }
        
        //print(body)
        let source: String? = getSource()
        var url: String?
        if source != nil {
            url = String(format: URL_ONE, source!)
        }
        //print(url)
        if url != nil {
            Alamofire.request(url!, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
                
                switch response.result {
                //case .success(let value):
                case .success(_):
                    var s: T? = nil
                    do {
                        if response.data != nil {
                            s = try JSONDecoder().decode(t, from: response.data!)
                            if s != nil {
                                self.table = s!
                                self.table!.filterRow()
                                completion(true)
                            } else {
                                self.msg = "解析JSON字串時，得到空直，請洽管理員"
                                completion(false)
                            }
                        } else {
                            self.msg = "沒有任何伺服器回傳的訊息"
                            completion(false)
                        }
                    } catch {
                        //print("Error:\(error)")
                        self.msg = error.localizedDescription
                        completion(false)
                    }
                case .failure(let error):
                    self.msg = "伺服器回傳錯誤，所以無法解析字串，請洽管理員"
                    completion(false)
                    print(error)
                    return
                }
            }
        }
    }
    
    func getOne(params: [String: String], completion: @escaping CompletionHandler){
        
        var body: [String: Any] = ["device": "app","strip_html": false]
        if params["token"] != nil {
            body["token"] = params["token"]
        }
        if params["member_token"] != nil {
            body["member_token"] = params["member_token"]
        }
        
        //print(body)
        let source: String? = getSource()
        var url: String?
        if source != nil {
            url = String(format: URL_ONE, source!)
        }
        //print(url)
        if url != nil {
            Alamofire.request(url!, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
                
                switch response.result {
                //case .success(let value):
                case .success(_):
                    if response.data != nil {
                        //let json = JSON(value)
                        //print(json)
                        if (response.data != nil) {
                            self.jsonData = response.data!
                            completion(true)
                        } else {
                            self.msg = "解析JSON字串時，得到空直，請洽管理員"
                            completion(false)
                        }
                    } else {
                        self.msg = "沒有任何伺服器回傳的訊息"
                        completion(false)
                    }
                case .failure(let error):
                    self.msg = "伺服器回傳錯誤，所以無法解析字串，請洽管理員"
                    completion(false)
                    print(error)
                    return
                }
            }
        }
    }
    
    //token is able token
    func like(token: String, able_id: Int) {
        
        let likeUrl: String = getLikeURL(token: token)
        //print(likeUrl)
        let url = URL(string: likeUrl)
        var request = URLRequest(url: url!)
        
        let member_token: String = Member.instance.token
        let body: [String: Any] = ["device":"app","member_token":member_token,"able_id":able_id]
        //print(body)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request)
        
        task.resume()
    }
    
//    func getList<T: SuperModel, T1: SuperModel>(t:T.Type, t1: T1.Type, token: String?, _filter:[String: Any]?, page: Int, perPage: Int, completion: @escaping CompletionHandler) {
//
//        self.needDownloads = [Dictionary<String, Any>]()
//        var filter: [String: Any] = ["source": "app", "channel": CHANNEL, "page": page, "perPage": perPage]
//        if _filter != nil {
//            filter.merge(_filter!)
//        }
//        //print(filter.toJSONString())
//
//        var url: String = getListURL()
//        if (token != nil) {
//            url = url + "/" + token!
//        }
//        //print(url)
//
//        Alamofire.request(url, method: .post, parameters: filter, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
//
//            switch response.result {
//            case .success(let value):
//                let json = JSON(value)
//                //print(json)
//                var s: T1? = nil
//                do {
//                    s = try JSONParse.parse(data: json, l: 5)
//                } catch {
//
//                }
//                if (s != nil) {
//                    self.superModel = s!
//
//                    let rows: [T] = s!.getRows() ?? [T]()
//                    for row in rows {
//                        row.filterRow()
//                        //row.printRow()
//                    }
//                    completion(true)
//                } else {
//                    self.msg = "解析伺服器字串錯誤，請洽管理員"
//                    completion(false)
//                }
//            case .failure(let error):
//                self.msg = "伺服器回傳錯誤，所以無法解析字串，請洽管理員"
//                completion(false)
//                print(error)
//                return
//            }
//
////            if response.result.error == nil {
////                guard let data = response.result.value else {
////                    //print("get response result value error")
////                    self.msg = "網路錯誤，請稍後再試"
////                    completion(false)
////                    return
////                }
////                let json: JSON = JSON(data)
////                print(json)
////                let s: T1 = JSONParse.parse(data: json)
////                //print(type(of: s))
////                //self.superModel.printRows()
////                //self.superCourses = JSONParse.parse(data: json)
////                self.superModel = s
////
////                let rows: [T] = s.getRows() ?? [T]()
////                for row in rows {
////                    row.filterRow()
////                    //row.printRow()
////                }
////                completion(true)
////            } else {
////                self.msg = "網路錯誤，請稍後再試"
////                completion(false)
////                debugPrint(response.result.error as Any)
////            }
//        }
//    }
    
//    func getList(type: String, titleField: String, params:[String:Any], page: Int, perPage: Int, filter:[[Any]]?, completion: @escaping CompletionHandler) {
//
//        self.needDownloads = [Dictionary<String, Any>]()
//        var body: [String: Any] = ["source": "app", "channel": CHANNEL, "page": String(page), "perPage": String(perPage)]
//        if filter != nil {
//            body["where"] = filter
//        }
//        body = body.merging(params){ (current, _) in current }
//        //print(body)
//        let url: String = String(format: URL_LIST, type)
//        //print(url)
//        dataLists = [SuperData]()
//
//        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
//
//            if response.result.error == nil {
//                //print(response.result)
//                guard let data = response.result.value else {
//                    print("get response result value error")
//                    self.msg = "網路錯誤，請稍後再試"
//                    completion(false)
//                    return
//                }
//                let json = JSON(data)
//                //print(json)
//                //if page == 1 {
//                    self.dataLists = [SuperData]()
//                //}
//                //print("page: \(page)")
//                self.totalCount = json["totalCount"].intValue
//                if self.totalCount > 0 {
//                    self.page = json["page"].intValue
//                    self.perPage = json["perPage"].intValue
//                    let rows: [JSON] = json["rows"].arrayValue
//                    for i in 0 ..< rows.count {
//                        let row = rows[i]
//                        let title: String = row[titleField].stringValue
//                        let id: Int = row["id"].intValue
//                        let token: String = row["token"].stringValue
//                        let vimeo: String = row["vimeo"].stringValue
//                        let youtube: String = row["youtube"].stringValue
//
//                        let path = row["featured_path"].stringValue
//                        if (path.count > 0) {
//                            self.needDownloads.append(["idx": i, "path": path])
//                        }
//
//                        let list = self.setData(id: id, title: title, path: path, token: token, youtube: youtube, vimeo: vimeo)
//                        let map = self.setData1(row: row)
//                        list.data = map
//                        self.dataLists.append(list)
//                    }
//                    //self.model.aPrint()
//                    //print(self.dataLists)
////                    for item in self.dataLists {
////                        print(item.data)
////                    }
//                    //print("need download image: \(self.needDownloads.count)")
//                    let needDownload: Int = self.needDownloads.count
//                    if (needDownload > 0) {
//                        var tmp: Int = needDownload
//                        for i in 0 ..< needDownload {
//                            self.getImage(_url: self.needDownloads[i]["path"] as! String, completion: { (success) in
//                                if success {
//                                    let idx: Int = self.needDownloads[i]["idx"] as! Int
//                                    self.dataLists[idx].featured = self.image!
//                                }
//                                tmp -= 1
//                                if (tmp == 0) {
//                                    completion(true)
//                                }
//                            })
//                        }
//                    } else {
//                        completion(true)
//                    }
//                } else {// total count == 0
//                    completion(true)
//                }
//            } else {
//                self.msg = "網路錯誤，請稍後再試"
//                completion(false)
//                debugPrint(response.result.error as Any)
//            }
//
//        }
//    }
    
    func calendar<T: SuperModel, T1: SuperModel>(t:T.Type, t1: T1.Type, token: String?, _filter:[String: Any]?, completion: @escaping CompletionHandler) {
            
            self.needDownloads = [Dictionary<String, Any>]()
            var filter: [String: Any] = ["device": "app", "channel": CHANNEL]
            if _filter != nil {
                filter.merge(_filter!)
            }
            //print(filter.toJSONString())
            
            var url: String = getCalendarURL()
            if (token != nil) {
                url = url + "/" + token!
            }
            //print(url)
                    
            Alamofire.request(url, method: .post, parameters: filter, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
                
                if response.result.error == nil {
                    guard let data = response.result.value else {
                        //print("get response result value error")
                        self.msg = "網路錯誤，請稍後再試"
                        completion(false)
                        return
                    }
                    let json = JSON(data)
                    //print(json)
                    let s: T1 = JSONParse.parse(data: json)
                    //print(type(of: s))
                    //self.superModel.printRows()
                    //self.superCourses = JSONParse.parse(data: json)
                    self.superModel = s
                    
                    let rows: [T] = s.getRows() ?? [T]()
                    for row in rows {
                        row.filterRow()
                    }
                    completion(true)
    //                self.makeNeedDownloadImageArr(rows, t: T.self)
    //                let needDownload: Int = self.needDownloads.count
    //                if needDownload > 0 {
    //                    self.needDownloadImage(needDownload, t: T1.self, completion: completion)
    //                } else {
    //                    completion(true)
    //                }
                } else {
                    self.msg = "網路錯誤，請稍後再試"
                    completion(false)
                    debugPrint(response.result.error as Any)
                }
            }
        }
    
    func getListURL()-> String { return ""}
    func getLikeURL(token: String? = nil)-> String { return ""}
    func getCalendarURL(token: String? = nil)-> String { return ""}
    func getUpdateURL()-> String {return ""}
    
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
                    self.msg = "網路錯誤，請稍後再試"
                    completion(false)
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
                
                //let path: String = self.model.data[FEATURED_KEY]!["path"] as! String
                let path: String =  json[FEATURED_KEY].stringValue
                if path.count > 0 {
                    self.getImage(_url: path, completion: { (success) in
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
                self.msg = "網路錯誤，請稍後再試"
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
//    func getOne<T: SuperModel>(t: T.Type, params: [String: String], completion: @escaping CompletionHandler){
//
//        var body: [String: Any] = ["device": "app","strip_html": false]
//        if params["token"] != nil {
//            body["token"] = params["token"]
//        }
//        if params["member_token"] != nil {
//            body["member_token"] = params["member_token"]
//        }
//
//        //print(body)
//        let source: String? = getSource()
//        var url: String?
//        if source != nil {
//            url = String(format: URL_ONE, source!)
//        }
//        //print(url)
//        if url != nil {
//            Alamofire.request(url!, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
//
//                if response.result.error == nil {
//                    //print(response.result.value)
//                    guard let data = response.result.value else {
//                        //print("get response result value error")
//                        self.msg = "網路錯誤，請稍後再試"
//                        completion(false)
//                        return
//                    }
//                    //print(data)
//                    let json = JSON(data)
//                    //print(json)
//                    let s: T = JSONParse.parse(data: json)
//                    self.superModel = s
//                    self.superModel.filterRow()
//                    //self.superModel.printRow()
//                    completion(true)
//
//                } else {
//                    self.msg = "網路錯誤，請稍後再試"
//                    completion(false)
//                    debugPrint(response.result.error as Any)
//                }
//            }
//        }
//    }
    
    func update(_params: [String: String], image: UIImage?, completion: @escaping CompletionHandler) {
        
        let url: String = getUpdateURL()
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
        var params: [String: String] = ["source": "app","channel":CHANNEL,"device":"app"]
        params.merge(_params)
        
        //print(url)
        //print(params)
        msg = ""
        Alamofire.upload(
            multipartFormData: { (multipartFormData) in
                if image != nil {
                    let imageData: Data = image!.jpegData(compressionQuality: 0.2)! as Data
                    multipartFormData.append(imageData, withName: "file", fileName: "test.jpg", mimeType: "image/jpeg")
                }
                for (key, value) in params {
                    multipartFormData.append(("\(value)").data(using: .utf8)!, withName: key)
                }
            },
            usingThreshold: UInt64.init(),
            to: url,
            method: .post,
            headers: headers
        ) { (result) in
            
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { (response) in
                    if response.result.error == nil {
                        guard let data = response.result.value else {
                            self.handleErrorMsg("伺服器錯誤，請洽管理員")
                            //print("data error")
                            self.msg = "伺服器錯誤，請洽管理員"
                            completion(false)
                            return
                        }
                        let json = JSON(data)
                        //print(json)
                        self.success = json["success"].boolValue
                        if self.success {
                            self.id = json["id"].intValue
                            if _params.keyExist(key: "token") { // update
                                self.jsonToMember(json: json["model"])
                            }
                        } else {
                            if json["errors"].exists() {
                                let _errors = json["errors"].arrayValue
                                for _error in _errors {
                                    let error: String = _error.stringValue
                                    self.msg += error + "\n"
                                }
                                //self.handleErrorMsg(nil, errors)
                            }
                            //print(self.msg)
                        }
                        
                        completion(true)
                    } else {
                        self.handleErrorMsg("回傳錯誤值，請洽管理員")
                        completion(false)
                    }
                })
            case .failure(let error):
                //print(error)
                //onError(error)
                self.handleErrorMsg("網路錯誤，請稍後再試，" + error.localizedDescription)
                completion(false)
            }
        }
    }
    
    func update(type: String, params: [String: Any], _ image: UIImage?, key: String, filename: String, mimeType: String, completion: @escaping CompletionHandler) {
        
        let url: String = String(format: URL_UPDATE, type)
        //print(url)
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
        var body: [String: Any] = ["source": "app","channel":CHANNEL]
        body.merge(params)
        //print(body)
        Alamofire.upload( multipartFormData: { (multipartFormData) in
            if image != nil {
                let imageData: Data = image!.jpegData(compressionQuality: 0.2)! as Data
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
                } else if key == TEAM_WEEKDAYS_KEY {
                    for d in value as! [Int] {
                        multipartFormData.append(("\(d)").data(using: .utf8)!, withName: "weekdays[]")
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
                        //self.success = true
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
                //print(error)
                //onError(error)
                self.msg = "網路錯誤，請稍後再試"
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
                    self.msg = "網路錯誤，請稍後再試"
                    completion(false)
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
                self.msg = "網路錯誤，請稍後再試"
                completion(false)
            }
        }
    }
    
    func signup_date(token: String, member_token: String, date_token: String, completion: @escaping CompletionHandler) {
        let url = getSignupDateURL(token: token)
        //print(url)
        let body: [String: String] = ["device": "app", "channel": "bm", "member_token": member_token, "date_token": date_token]
        //print(body)
        
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.result.value else {
                    print("data error")
                    self.msg = "無法解析伺服器傳回值錯誤，請洽管理員"
                    completion(false)
                    return
                }
                //print(data)
                let json: JSON = JSON(data)
                //print(json)
                self.success = json["success"].boolValue
                if self.success {
                    self.signup_date = json
                } else {
                    self.msg = json["msg"].stringValue
                }
                completion(true)
            } else {
                self.msg = "取得報名日期錯誤，請洽管理員"
                completion(false)
            }
        }
    }
    
    func signup(token: String, member_token: String, date_token: String, course_deadline: String, completion: @escaping CompletionHandler) {
        let url = getSignupURL(token: token)
        //print(url)
        let body: [String: String] = ["device": "app", "channel": "bm", "member_token": member_token, "able_date_token": date_token, "cancel_deadline": course_deadline]
        
        //print(body)
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.result.value else {
                    print("data error")
                    self.msg = "網路錯誤，請稍後再試"
                    completion(false)
                    return
                }
                //print(data)
                let json: JSON = JSON(data)
                self.success = json["success"].boolValue
                if json["msg"].exists() {
                    self.msg = json["msg"].stringValue
                }
                completion(self.success)
            } else {
                self.msg = "網路錯誤，請稍後再試"
                completion(false)
            }
        }
    }
//    func signup(type: String, token: String, member_token: String, tt_id: Int, completion: @escaping CompletionHandler) {
//        let body: [String: String] = ["source": "app", "channel": "bm","member_token":member_token,"tt_id":String(tt_id)]
//        let url: String = String(format: URL_SIGNUP, type, token)
//        //print(url)
//        //print(body)
//
//        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
//            if response.result.error == nil {
//                guard let data = response.result.value else {
//                    print("data error")
//                    self.msg = "網路錯誤，請稍後再試"
//                    completion(false)
//                    return
//                }
//                //print(data)
//                let json: JSON = JSON(data)
//                self.success = json["success"].boolValue
//                if self.success {
//                } else {
//                    self.msg = json["msg"].stringValue
//                }
//                completion(self.success)
//            } else {
//                self.msg = "網路錯誤，請稍後再試"
//                completion(false)
//            }
//        }
//
//    }
//    func cancelSignup(type: String, member_token: String, signup_id: Int, completion: @escaping CompletionHandler) {
//        let body: [String: String] = ["source": "app", "channel": "bm","member_token":member_token]
//        let url: String = String(format: URL_CANCEL_SIGNUP, type, signup_id)
//        //print(url)
//        //print(body)
//
//        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
//            if response.result.error == nil {
//                guard let data = response.result.value else {
//                    print("data error")
//                    self.msg = "網路錯誤，請稍後再試"
//                    completion(false)
//                    return
//                }
//                //print(data)
//                let json: JSON = JSON(data)
//                self.success = json["success"].boolValue
//                if self.success {
//                } else {
//                    self.msg = json["msg"].stringValue
//                }
//                completion(self.success)
//            } else {
//                self.msg = "網路錯誤，請稍後再試"
//                completion(false)
//            }
//        }
//
//    }
    
    func getSignupURL(token: String)-> String { return ""}
    func getSignupDateURL(token: String)-> String { return ""}
    
    func signup_list(token: String? = nil, page: Int = 1, perPage: Int = 8, completion: @escaping CompletionHandler) {
        let url: String = getSignupListURL(token: token)
        //print(url)
        let body: [String: String] = ["device": "app", "channel": "bm", "page":String(page), "perPage":String(perPage)]
        //print(body)
        
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
                    
                    if response.result.error == nil {
                        guard let data = response.result.value else {
                            //print("get response result value error")
                            self.msg = "網路錯誤，請稍後再試"
                            completion(false)
                            return
                        }
                        let json = JSON(data)
                        //print(json["able"])
                        if json["able"].exists() {
                            self.able = self.parseAbleForSingupList(data: json["able"])
                            //print(able.printRow())
                        }
                        
                        let s: SuperSignups = JSONParse.parse(data: json)
                        self.superModel = s
                        
                        let rows: [SuperSignup] = s.getRows() ?? [SuperSignup]()
                        for row in rows {
                            row.filterRow()
                            //row.printRow()
                        }
                        completion(true)
                    } else {
                        self.msg = "網路錯誤，請稍後再試"
                        completion(false)
                        debugPrint(response.result.error as Any)
                    }
                }
    }
    
    func getSignupListURL(token: String? = nil)-> String { return ""}
    func parseAbleForSingupList(data: JSON)-> SuperModel { return SuperModel() }
    
    func getHomes(completion: @escaping CompletionHandler) {
        let body: [String: Any] = ["device": "app"]
        //print(URL_HOME)
        
        Alamofire.request(URL_HOME, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON {
            (response) in
            if response.result.error == nil {
                if let json = response.result.value as? Dictionary<String, Any> {
                    //print(json)
                    let teachArray = json["teaches"] as! [Dictionary<String, AnyObject>]
                    let teachHome = self.parseHomeJSON(array: teachArray, titleField: "title", type: "teach", video: true)
                    //print(teachArray1)
                    self.homes["teaches"] = teachHome
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
                self.msg = "網路錯誤，請稍後再試"
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
                getImage(_url: path, completion: { (success) in
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
    
    func getImage(_url: String, completion: @escaping CompletionHandler) {
        var url = _url
        if (!_url.startWith("http://") && !_url.startWith("https://")) {
            url = BASE_URL + _url
        }
        //print(url)
//        let urlRequest = URLRequest(url: URL(string: url)!)
//        URLCache.shared.removeCachedResponse(for: urlRequest)
//        URLCache.shared.removeAllCachedResponses()
        
        Alamofire.request(url).responseData { (response) in
            //debugPrint(response)
            if response.result.isSuccess {
                if response.response?.statusCode == 200 {
                    if let data = response.data {
                        self.image = UIImage(data: data)
                    } else {
                        self.image = UIImage(named: "nophoto")
                    }
                } else {
                    self.image = UIImage(named: "nophoto")
                }
                //print(self.image!.size.width)
                //image?.af_imageAspectScaled(toFill: )
            } else {
                self.image = UIImage(named: "nophoto")
            }
            completion(true)
        }
//        Alamofire.request(url).responseImage(completionHandler: { (response) in
//            if response.result.isSuccess {
//                guard let image = response.result.value else { return }
//                print(image.size.width)
//                self.image = image
//            } else {
//                //print("download image false: \(url)")
//                self.image = UIImage(named: "nophoto")
//            }
//            completion(true)
//        })
    }
    
    func makeNeedDownloadImageArr<T: SuperModel>(_ rows: [SuperModel], t: T.Type) {
        for i in 0 ..< rows.count {
            let row: T = rows[i] as! T
            row.filterRow()
            //row.printRow()
            let featured_path = row.getFeaturedPath()
            if featured_path.count > 0 {
                let path = BASE_URL + featured_path
                self.needDownloads.append(["idx": i, "path": path])
            }
        }
    }
    
    func needDownloadImage<T: SuperModel>(_ needDownload: Int, t: T.Type, completion: @escaping CompletionHandler) {
        var tmp: Int = needDownload
        for i in 0 ..< needDownload {
            let imageUrl = self.needDownloads[i]["path"] as! String
            let d = { (_ success: Bool) in
                if success {
                    let idx: Int = self.needDownloads[i]["idx"] as! Int
                    self.setImage(idx, t: T.self)
                    //self.superCourses.rows[idx].featured = self.image!
                }
                tmp -= 1
                if (tmp == 0) {
                    completion(true)
                }
            }
            self.getImage(_url: imageUrl, completion: d)
        }
    }
    
    func setImage<T: SuperModel>(_ idx: Int, t: T.Type) {
        if image != nil {
            let rows: [T] = superModel.getRows() ?? [T]()
            if rows.count >= idx {
                let row = superModel.getRowFromIdx(idx)
                if row != nil {
                    row?.setFeatured(image!)
                }
            }
        }
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
                self.msg = "網路錯誤，請稍後再試"
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
                    self.msg = "網路錯誤，請稍後再試"
                    completion(false)
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
            } else {
                self.msg = "網路錯誤，請稍後再試"
                completion(false)
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
                    self.msg = "網路錯誤，請稍後再試"
                    completion(false)
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
            } else {
                self.msg = "網路錯誤，請稍後再試"
                completion(false)
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
                    self.msg = "網路錯誤，請稍後再試"
                    completion(false)
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
            } else {
                self.msg = "網路錯誤，請稍後再試"
                completion(false)
            }
        }
    }
    
    func getArenaByCityID(city_id: Int, completion: @escaping CompletionHandler) {
        let body: [String: Any] = ["source": "app", "city": city_id]
        Alamofire.request(URL_ARENA_BY_CITY_ID, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.result.value else {
                    print("data error")
                    self.msg = "網路錯誤，請稍後再試"
                    completion(false)
                    return
                }
                let json = JSON(data)
                let jsonArray: [JSON] = json[].arrayValue
                self.arenas = [ArenaTable]()
                for arena in jsonArray {
                    let id: Int = arena["id"].intValue
                    let name: String = arena["name"].stringValue
                    let arenaTable: ArenaTable = ArenaTable()
                    arenaTable.id = id
                    arenaTable.name = name
                    self.arenas.append(arenaTable)
                }
                
                completion(true)
            } else {
                self.msg = "網路錯誤，請稍後再試"
                completion(false)
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
                    self.msg = "網路錯誤，請稍後再試"
                    completion(false)
                    return
                }
                let json = JSON(data)
                //print(json)
                self.citysandareas.removeAll()
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
            } else {
                self.msg = "網路錯誤，請稍後再試"
                completion(false)
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
                    self.msg = "網路錯誤，請稍後再試"
                    completion(false)
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
            } else {
                self.msg = "網路錯誤，請稍後再試"
                completion(false)
            }
        }
    }
    
    func getTT(token: String, type:String, completion: @escaping CompletionHandler) {
        let body: [String: Any] = ["source": "app", "channel": "bm","token":token]
        let url: String = String(format: URL_TT, type)
        //print(url)
        //print(body)
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.result.value else {
                    print("data error")
                    self.msg = "網路錯誤，請稍後再試"
                    completion(false)
                    return
                }
                let json = JSON(data)
                //print(json)
                self.timetables = JSONParse.parse(data: json)
                for row in self.timetables.rows {
                    row.filterRow()
                    //row.printRow()
                }
                
//                var rows: [JSON] = [JSON]()
//                if json["rows"].exists() {
//                    rows = json["rows"].arrayValue
//                    for row in rows {
//                        self.timeTable = JSONParse.parse(data: row)
//                    }
//                }
                //print(self.timeTable.printRows())
                
                
                completion(true)
            } else {
                self.msg = "網路錯誤，請稍後再試"
                completion(false)
            }
        }
    }
    
    func updateTT(type: String, params:[String:Any], completion: @escaping CompletionHandler) {
        var body: [String: Any] = ["source": "app", "channel": CHANNEL]
        body = body.merging(params){ (current, _) in current }
        //print(body)
        let url: String = String(format: URL_TT_UPDATE, type)
        //print(url)
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.result.value else {
                    print("data error")
                    self.msg = "網路錯誤，請稍後再試"
                    completion(false)
                    return
                }
                let json = JSON(data)
                self.msg = ""
                let success = json["success"].boolValue
                if success {
                    self.timetables = Timetables()
                    self.timetables = JSONParse.parse(data: json)
                    for row in self.timetables.rows {
                        row.filterRow()
                        //row.printRow()
                    }
                } else {
                    self.msg = json["msg"].stringValue
                    //print(self.msg)
                }
                completion(success)
            } else {
                //print(response.result.error)
                self.msg = "網路錯誤，請稍後再試"
                completion(false)
            }
        }
        
    }
    
    func deleteTT(type: String, params:[String:Any], completion: @escaping CompletionHandler) {
        var body: [String: Any] = ["source": "app", "channel": CHANNEL]
        body = body.merging(params){ (current, _) in current }
        //print(body)
        let url: String = String(format: URL_TT_DELETE, type)
        //print(url)
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.result.value else {
                    print("data error")
                    self.msg = "網路錯誤，請稍後再試"
                    completion(false)
                    return
                }
                let json = JSON(data)
                self.msg = ""
                let success = json["success"].boolValue
                if success {
                    self.timetables = Timetables()
                    self.timetables = JSONParse.parse(data: json)
                    for row in self.timetables.rows {
                        row.filterRow()
                        //row.printRow()
                    }
                } else {
                    self.msg = json["msg"].stringValue
                    //print(self.msg)
                }
                completion(success)
            } else {
                //print(response.result.error)
                self.msg = "網路錯誤，請稍後再試"
                completion(false)
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
            key = "teaches"
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
            key = "teaches"
            type = "cours"
            chTitle = "課程"
        }
        
        return (key, chTitle, type)
    }
    
    func strsToDegree(_ strs: [String])-> [Degree] {
        return [Degree]()
    }
    
    func handleErrorMsg(_ msg: String?, _ msgs: [String: JSON]? = nil) {
        if msg != nil {
            self.msg = msg!
        } else {
            if msgs != nil {
                for (_, value) in msgs! {
                    let error = value.stringValue
                    self.msg += error + "\n"
                }
            }
        }
    }
    
    func getSource()-> String? {
        return nil
    }
    
    func jsonToMember(json: JSON) {}
}
