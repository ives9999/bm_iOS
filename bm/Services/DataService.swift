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
    var show: Dictionary<String, Any> = Dictionary<String, Any>()
    var downloadImageNum: Int = 0
    var image: UIImage?
    //var homesRaw: Dictionary<String, [Dictionary<String, String>]> = Dictionary<String, [Dictionary<String, String>]>()
    //var titles: [String] = [String]()
    //var pathes: [String] = [String]()
    //var featureds: [UIImage] = [UIImage]()
    
    
    func getHomes(completion: @escaping CompletionHandler) {
        let body: [String: Any] = ["source": "mobile"]
        //print(URL_HOME)
        
        Alamofire.request(URL_HOME, method: .post, parameters: body, encoding: JSONEncoding.default, headers: gRequestHeader).responseJSON {
            (response) in
            if response.result.error == nil {
                if let json = response.result.value as? Dictionary<String, Any> {
                    //print(json)
                    let courseArray = json["courses"] as! [Dictionary<String, AnyObject>]
                    let courseHome = self.parseHomeJSON(array: courseArray, titleField: "title", video: true)
                    //print(courseArray1)
                    self.homes["courses"] = courseHome
                    let newsArray = json["news"] as! [Dictionary<String, AnyObject>]
                    let newsHome = self.parseHomeJSON(array: newsArray, titleField: "title")
                    self.homes["news"] = newsHome
                    let arenaArray = json["arenas"] as! [Dictionary<String, AnyObject>]
                    let arenaHome = self.parseHomeJSON(array: arenaArray, titleField: "name")
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
            guard let image = response.result.value else { return }
            self.image = image
            completion(true)
        })
    }
    
    func parseHomeJSON(array: [Dictionary<String, Any>], titleField: String, video: Bool=false) -> [Home] {
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
            let home = Home(id: id, title: title, path: path, youtube: youtube, vimeo: vimeo, token: token)
            result.append(home)
        }
        
        return result
    }
    
    func getHomeItem(indexPath: IndexPath) -> Home {
        let key: String = sectionToKey(section: indexPath.section).key
        return homes[key]![indexPath.row]
    }
    
    func sectionToKey(section: Int) -> (key: String, chTitle: String) {
        var key: String
        var chTitle: String
        switch section {
        case 0:
            key = "courses"
            chTitle = "課程"
            break
        case 1:
            key = "news"
            chTitle = "新聞"
            break
        case 2:
            key = "arenas"
            chTitle = "球館"
            break
        default:
            key = "courses"
            chTitle = "課程"
        }
        
        return (key, chTitle)
    }
    
    func getShow(type: String, id: Int, token: String, completion: @escaping CompletionHandler) {
        let body: [String: Any] = ["source": "mobile", "id": id, "token": token]
        
        
        let url: String = String(format: URL_SHOW, type)
        //print(url)
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: gRequestHeader).responseString { (response) in

            if response.result.isSuccess {
                let jsonString = response.result.value
                //print(jsonString)
                if let json = try? JSON.decode(jsonString!) {
                    let title = try? json.getString("title")
                    let content = try? json.getString("content")
                    var path = try? json.getString("featured_path")
                    self.show = ["title": title!, "path": path!, "content": content!]
                    if (path!.count > 0) {
                        path = BASE_URL + path!
                        self.show["path"] = path!
                        self.getImage(url: path!, completion: { (success) in
                            if success {
                                self.show["featured"] = self.image
                            }
                            completion(true)
                        })
                    }
                }
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    
    
    
    
    
    
}
