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
    static let instance = DataService()
    
//    private let homes = [
//        Home(featured: "1.jpg", title: "艾傑早安羽球團8月份會內賽"),
//        Home(featured: "2.jpg", title: "永遠支持的戴資穎"),
//        Home(featured: "3.jpg", title: "外媒評十大羽毛球美女，馬琳竟上榜！")
//    ]
    var homes: Dictionary<String, [Home]> = Dictionary<String, [Home]>()
    var lists: [List] = [List]()
    var totalCount: Int!
    var page: Int!
    var perPage: Int!
    var show: Dictionary<String, Any> = Dictionary<String, Any>()
    var show_html: String = ""
    var downloadImageNum: Int = 0
    var image: UIImage?
    //var homesRaw: Dictionary<String, [Dictionary<String, String>]> = Dictionary<String, [Dictionary<String, String>]>()
    //var titles: [String] = [String]()
    //var pathes: [String] = [String]()
    //var featureds: [UIImage] = [UIImage]()
    
    var citys: [City] = [City]()
    var arenas: [Arena] = [Arena]()
    
    func getList(type: String, titleField: String, page: Int, perPage: Int, filter:[[Any]]?, completion: @escaping CompletionHandler) {
        self.downloadImageNum = 0
        var body: [String: Any] = ["source": "app", "page": String(page), "perPage": String(perPage)]
        if filter != nil {
            body["where"] = filter
        }
        print(body)
        let url: String = String(format: URL_LIST, type)
        //print(url)
        lists = [List]()
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            
            if response.result.error == nil {
                //print(response.result.value)
                guard let data = response.result.value else {
                    print("get response result value error")
                    return
                }
                let json = JSON(data)
                //print(json)
                self.totalCount = json["totalCount"].intValue
                self.page = json["page"].intValue
                self.perPage = json["perPage"].intValue
                let arr: [JSON] = json["rows"].arrayValue
                for i in 0 ..< arr.count {
                    let title: String = arr[i][titleField].stringValue
                    let id: Int = arr[i]["id"].intValue
                    let token: String = arr[i]["token"].stringValue
                    let vimeo: String = arr[i]["vimeo"].stringValue
                    let youtube: String = arr[i]["youtube"].stringValue
                    
                    var path: String!
                    let path1 = arr[i]["featured_path"].stringValue
                    if (path1.count > 0) {
                        path = BASE_URL + path1
                        self.downloadImageNum += 1
                    } else {
                        path = ""
                    }
                    
                    let list: List = List(id: id, title: title, path: path, token: token, youtube: youtube, vimeo: vimeo)
                    self.lists.append(list)
                }
                //print("need download image: \(self.downloadImageNum)")
                for i in 0 ..< self.lists.count {
                    if (self.downloadImageNum > 0) {
                        if self.lists[i].path.count > 0 {
                            self.getImage(url: self.lists[i].path, completion: { (success) in
                                if success {
                                    self.lists[i].featured = self.image!
                                }
                                self.downloadImageNum -= 1
                                //print("retain image download: \(self.downloadImageNum)")
                                if self.downloadImageNum == 0 {
                                    completion(true)
                                }
                            })
                        } else {
                            if (self.lists[i].vimeo.count==0) && (self.lists[i].youtube.count==0) {
                                self.lists[i].featured = UIImage(named: "nophoto")!
                            }
                        }
                    } else {
                        completion(true)
                    }
                }
                /*if let json = try? JSON.decode(jsonString!) {
                    self.totalCount = try? json.getInt("totalCount")
                    //print(self.totalCount)
                    self.page = try? json.getInt("page")
                    //print(self.page)
                    self.perPage = try? json.getInt("perPage")
                    //print(self.perPage)
                    if let arr = try? json.getArray("rows") {
                        for i in 0 ..< arr.count {
                            let title = try? arr[i].getString(titleField)
                            let id = try? arr[i].getInt("id")
                            let token = try? arr[i].getString("token")
                            var vimeo = "", youtube = ""
                            if let vimeo1 = try? arr[i].getString("vimeo") {
                                vimeo = vimeo1
                            }
                            if let youtube1 = try? arr[i].getString("youtube") {
                                youtube = youtube1
                            }
                            
                            var path: String!
                            if let path1 = try? arr[i].getString("featured_path") {
                                if (path1.count > 0) {
                                    path = BASE_URL + path1
                                    self.downloadImageNum += 1
                                }
                            } else {
                                path = ""
                            }
                            
                            let list: List = List(id: id!, title: title!, path: path!, token: token!, youtube: youtube, vimeo: vimeo)
                            self.lists.append(list)
                        }
                        print("need download image: \(self.downloadImageNum)")
                        for i in 0 ..< self.lists.count {
                            if (self.downloadImageNum > 0) {
                                if self.lists[i].path.count > 0 {
                                    self.getImage(url: self.lists[i].path, completion: { (success) in
                                        if success {
                                            self.lists[i].featured = self.image!
                                        }
                                        self.downloadImageNum -= 1
                                        print("retain image download: \(self.downloadImageNum)")
                                        if self.downloadImageNum == 0 {
                                            completion(true)
                                        }
                                    })
                                } else {
                                    if (self.lists[i].vimeo.count==0) && (self.lists[i].youtube.count==0) {
                                        self.lists[i].featured = UIImage(named: "nophoto")!
                                    }
                                }
                            } else {
                                completion(true)
                            }
                        }
                    } else {
                        print("JSON to array error")
                        completion(false)
                    }
                } else { // JSON string parse error
                    print("JSON string parse error")
                    completion(false)
                }*/
                //completion(false)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
            
        }
    }
    
    func getHomes(completion: @escaping CompletionHandler) {
        self.downloadImageNum = 0
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
                            self.downloadImageNum -= 1
                            //print(self.downloadImageNum)
                            //print(self.image)
                            if self.downloadImageNum == 0 {
                                //print(self.homes)
                                completion(true)
                            }
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
        for (key, value) in homes {
            for i in 0..<value.count {
            
                let path: String = value[i].path
                if path.count > 0 {
                    //print(path)
                    getImage(url: path, completion: { (success) in
                        if (success) {
                            self.homes[key]![i].featured = self.image!
                        }
                        completion(true)
                    })
                }
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
    
    func parseHomeJSON(array: [Dictionary<String, Any>], titleField: String, type: String, video: Bool=false) -> [Home] {
        var result: [Home] = [Home]()
        for item in array {
            let id: Int = item["id"] as? Int ?? 0
            let title: String = item[titleField] as? String ?? ""
            var path: String = item["featured_path"] as? String ?? ""
            if (path.count > 0) {
                path = BASE_URL + path
                downloadImageNum += 1
            }
            let youtube: String = item["youtube"] as? String ?? ""
            let vimeo: String = item["vimeo"] as? String ?? ""
            let token: String = item["token"] as? String ?? ""
            let home = Home(id: id, title: title, path: path, youtube: youtube, vimeo: vimeo, token: token, type: type)
            result.append(home)
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
