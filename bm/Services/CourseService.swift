//
//  CourseService.swift
//  bm
//
//  Created by ives on 2019/5/26.
//  Copyright © 2019 bm. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON

class CourseService: DataService {
    
    static let instance = CourseService()
    var superCourses: SuperCourses = SuperCourses()
    
    func getList(token: String?, filter:[[Any]]?, page: Int, perPage: Int, completion: @escaping CompletionHandler) {
        
        self.needDownloads = [Dictionary<String, Any>]()
        var body: [String: Any] = ["source": "app", "channel": CHANNEL, "page": String(page), "perPage": String(perPage)]
        if filter != nil {
            body["where"] = filter
        }
        
        //print(body)
        var url: String = URL_COURSE_LIST
        if (token != nil) {
            url = url + "/" + token!
        }
        //print(url)
        
        superCourses = SuperCourses()
        
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            
            if response.result.error == nil {
                guard let data = response.result.value else {
                    print("get response result value error")
                    self.msg = "網路錯誤，請稍後再試"
                    completion(false)
                    return
                }
                let json = JSON(data)
                //print(json)
                self.superCourses = JSONParse.parse(data: json)
                let rows = self.superCourses.rows
                for i in 0 ..< rows.count {
                    let row: SuperCourse = rows[i]
                    row.filterRow()
                    //row.printRow()
                    if row.featured_path.count > 0 {
                        let path = BASE_URL + row.featured_path
                        self.needDownloads.append(["idx": i, "path": path])
                    }
                }
                let needDownload: Int = self.needDownloads.count
                if needDownload > 0 {
                    var tmp: Int = needDownload
                    for i in 0 ..< needDownload {
                        self.getImage(_url: self.needDownloads[i]["path"] as! String, completion: { (success) in
                            if success {
                                let idx: Int = self.needDownloads[i]["idx"] as! Int
                                self.superCourses.rows[idx].featured = self.image!
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
            } else {
                self.msg = "網路錯誤，請稍後再試"
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
}
