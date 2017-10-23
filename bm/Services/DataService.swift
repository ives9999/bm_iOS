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
import PMJSON

class DataService {
    static let instance = DataService()
    
//    private let homes = [
//        Home(featured: "1.jpg", title: "艾傑早安羽球團8月份會內賽"),
//        Home(featured: "2.jpg", title: "永遠支持的戴資穎"),
//        Home(featured: "3.jpg", title: "外媒評十大羽毛球美女，馬琳竟上榜！")
//    ]
    var homes: Dictionary<String, [Home]> = Dictionary<String, [Home]>()
    var lists: [List] = [List]()
    var show: Dictionary<String, Any> = Dictionary<String, Any>()
    var show_html: String = ""
    var downloadImageNum: Int = 0
    var image: UIImage?
    //var homesRaw: Dictionary<String, [Dictionary<String, String>]> = Dictionary<String, [Dictionary<String, String>]>()
    //var titles: [String] = [String]()
    //var pathes: [String] = [String]()
    //var featureds: [UIImage] = [UIImage]()
    
    
    func getHomes(completion: @escaping CompletionHandler) {
        let body: [String: Any] = ["device": "app"]
        //print(URL_HOME)
        
        Alamofire.request(URL_HOME, method: .post, parameters: body, encoding: JSONEncoding.default, headers: gRequestHeader).responseJSON {
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
    
    func getList(type: String, titleField: String, page: Int, perPage: Int, completion: @escaping CompletionHandler) {
        let body: [String: Any] = ["source": "app", "page": String(page), "perPage": String(perPage)]
        let url: String = String(format: URL_LIST, type)
        //print(url)
        lists = [List]()
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: gRequestHeader).responseString { (response) in
            
            if response.result.isSuccess {
                let jsonString = response.result.value
                print(jsonString)
                if let json = try? JSON.decode(jsonString!) {
                    if let arr = try? json.getArray() {
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
//                            if type == "course" {
//                                vimeo = try! arr[i].getString("vimeo")
//                                youtube = try! arr[i].getString("youtube")
//                            }
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
                        //print("need download image: \(self.downloadImageNum)")
                        for i in 0 ..< self.lists.count {
                            if self.lists[i].path.count > 0 {
                                self.getImage(url: self.lists[i].path, completion: { (success) in
                                    if success {
                                        self.lists[i].featured = self.image!
                                        //print("image url: \(self.lists[i].path)")
                                        self.downloadImageNum -= 1
                                        //print("has downloaded image: \(self.downloadImageNum)")
                                    } else {
                                        self.downloadImageNum -= 1
                                    }
                                    if self.downloadImageNum == 0 {
                                        //print(self.homes)
                                        completion(true)
                                    }
                                })
                            } else {
                                if (self.lists[i].vimeo.count==0) && (self.lists[i].youtube.count==0) {
                                    self.lists[i].featured = UIImage(named: "nophoto")!
                                }
                            }
                        }
                    } else {
                        print("JSON to array error")
                        completion(false)
                    }
                } else { // JSON string parse error
                    print("JSON string parse error")
                    completion(false)
                }
                //completion(false)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
            
        }
    }
    
    func getShow(type: String, id: Int, token: String, completion: @escaping CompletionHandler) {
        let body: [String: Any] = ["source": "app", "id": id, "token": token, "type": type]
        
        
        let url: String = String(format: URL_SHOW, type)
        //print(url)
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: gRequestHeader).responseString { (response) in

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
    
    
    
    
    
    
    
}
