//
//  DataService.swift
//  bm
//
//  Created by ives on 2017/10/4.
//  Copyright © 2017年 bm. All rights reserved.
//

import Foundation
import Alamofire

class DataService {
    static let instance = DataService()
    
//    private let homes = [
//        Home(featured: "1.jpg", title: "艾傑早安羽球團8月份會內賽"),
//        Home(featured: "2.jpg", title: "永遠支持的戴資穎"),
//        Home(featured: "3.jpg", title: "外媒評十大羽毛球美女，馬琳竟上榜！")
//    ]
    var homes: [Home] = [Home]()
    
    
    func getHomes(completion: @escaping CompletionHandler) {
        let body: [String: Any] = ["source": "mobile"]
        
        //print(URL_HOME)
        
        Alamofire.request(URL_HOME, method: .post, parameters: body, encoding: JSONEncoding.default, headers: gRequestHeader).responseJSON {
            (response) in
            if response.result.error == nil {
                if let json = response.result.value as? Dictionary<String, Any> {
                    //print(json)
                    if let news = json["news"] as? [Dictionary<String, Any>] {
                        //print(news)
                        for item in news {
                            let title: String = item["title"] as! String
                            var path: String!
                            if let featureds: [Dictionary<String, Any>] = item["featured"] as? [Dictionary<String, Any>] {
                                for item1 in featureds {
                                    path = item1["path"] as! String
                                }
                            }
                            let featured = BASE_URL + path
                            let home: Home = Home(featured: featured, title: title)
                            self.homes.append(home)
                        }
                    }
                }
                //print(self.homes)
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
}
