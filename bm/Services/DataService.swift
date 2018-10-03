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
    var homes: Dictionary<String, [Home]> = Dictionary<String, [Home]>()
    var dataLists: [SuperData] = [SuperData]()
    var totalCount: Int!
    var page: Int!
    var perPage: Int!
    var show: Dictionary<String, Any> = Dictionary<String, Any>()
    var show_html: String = ""
    //var downloadImageNum: Int = 0
    var needDownloads: [Dictionary<String, Any>] = [Dictionary<String, Any>]()
    var image: UIImage?
    //var homesRaw: Dictionary<String, [Dictionary<String, String>]> = Dictionary<String, [Dictionary<String, String>]>()
    //var titles: [String] = [String]()
    //var pathes: [String] = [String]()
    //var featureds: [UIImage] = [UIImage]()
    
    var citys: [City] = [City]()
    var arenas: [Arena] = [Arena]()
    var citysandarenas:[Int:[String:Any]] = [Int:[String:Any]]()
    var msg:String = ""
    var success: Bool = false
    
    var model: SuperData {
        get {
            return SuperData()
        }
    }
    func setData(id: Int, title: String, path: String, token: String, youtube: String = "", vimeo: String = "") -> SuperData {
        let list = SuperData(id: id, title: title, path: path, token: token, youtube: youtube, vimeo: vimeo)
        return list
    }
    
    func setData1(obj: JSON)->Dictionary<String, [String: Any]> {
        let list = Dictionary<String, [String: Any]>()
        return list
    }
    
    func getList(type: String, titleField: String, page: Int, perPage: Int, filter:[[Any]]?, completion: @escaping CompletionHandler) {
        self.needDownloads = [Dictionary<String, Any>]()
        var body: [String: Any] = ["source": "app", "channel": CHANNEL, "page": String(page), "perPage": String(perPage)]
        if filter != nil {
            body["where"] = filter
        }
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
                    let arr: [JSON] = json["rows"].arrayValue
                    for i in 0 ..< arr.count {
                        let obj = arr[i]
                        let title: String = obj[titleField].stringValue
                        let id: Int = obj["id"].intValue
                        let token: String = obj["token"].stringValue
                        let vimeo: String = obj["vimeo"].stringValue
                        let youtube: String = obj["youtube"].stringValue
                        
                        var path: String!
                        let path1 = obj["featured_path"].stringValue
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
                        let map = self.setData1(obj: obj)
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
    
    func delete(token: String, type: String, completion: @escaping CompletionHandler) {
        let body: [String: String] = ["source": "app", "channel": "bm", "token": token]
        let url: String = String(format: URL_TEAM_DELETE, type)
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
    func getArenaByCityIDs(city_ids: [Int], completion: @escaping CompletionHandler) {
        let body: [String: Any] = ["source": "app", "channel":"bm","citys": city_ids]
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
}
