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
    var superCourse: SuperCourse = SuperCourse()
    
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
                    //print("get response result value error")
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
    
    override func getOne(token: String, completion: @escaping CompletionHandler) {
        
        //print(model)
        //model.neverFill()
        downloadImageNum = 0
        let body: [String: Any] = ["device": "app", "token": token,"strip_html": false]
        
        //print(body)
        let url: String = String(format: URL_ONE, "course")
        //print(url)
        
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            
            if response.result.error == nil {
                //print(response.result.value)
                guard let data = response.result.value else {
                    //print("get response result value error")
                    self.msg = "網路錯誤，請稍後再試"
                    completion(false)
                    return
                }
                //print(data)
                let json = JSON(data)
                //print(json)
                self.superCourse = JSONParse.parse(data: json)
                
                //self.setData1(row: json)
                let path: String =  json[FEATURED_KEY].stringValue
                if path.count > 0 {
                    self.getImage(_url: path, completion: { (success) in
                        if success {
                            if self.image != nil {
                                self.superCourse.featured = self.image!
                            }
                            completion(true)
                            //print(team.data)
                        }
                    })
                } else {
                    completion(true)
                }
                completion(true)
                
            } else {
                self.msg = "網路錯誤，請稍後再試"
                completion(false)
                debugPrint(response.result.error as Any)
            }
            
        }
    }
    
    override func update(_params: [String : String], image: UIImage?, completion: @escaping CompletionHandler) {
        
        let url: String = String(format: URL_UPDATE, "course")
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
        var params: [String: String] = ["source": "app","channel":CHANNEL]
        params.merge(_params)
        
        Alamofire.upload(
            multipartFormData: { (multipartFormData) in
                if image != nil {
                    let imageData: Data = UIImageJPEGRepresentation(image!, 0.2)! as Data
                    multipartFormData.append(imageData, withName: "file", fileName: "test.jpg", mimeType: "image/jpeg")
                }
                for (key, value) in params {
                    multipartFormData.append(("\(value)").data(using: .utf8)!, withName: key)
                }
            },
            usingThreshold: UInt64.init(),
            to: url,
            method: .post, headers: headers
        ) { (result) in
            
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { (response) in
                    if response.result.error == nil {
                        guard let data = response.result.value else {
                            self.handleErrorMsg("伺服器錯誤，請洽管理員")
                            //print("data error")
                            completion(false)
                            return
                        }
                        //print(data)
                        let json = JSON(data)
                        self.success = json["success"].boolValue
                        if self.success {
                            self.id = json["id"].intValue
                        } else {
                            if json["fields"].exists() {
                                let errors: [String: JSON] = json["fields"].dictionary!
                                self.handleErrorMsg(nil, errors)
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
}
