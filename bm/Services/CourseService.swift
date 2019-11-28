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
    
    override init() {
        super.init()
        superModel = SuperCourses(dict: [String : Any]())
    }
    
    override func getListURL() -> String {
        return URL_COURSE_LIST
    }
    
    override func getSource() -> String? {
        return "course"
    }
    
    override func getCalendarURL(token: String? = nil) -> String {
        var url: String = URL_COURSE_CALENDAR
        if token != nil {
            url = url + "/" + token!
        }
        
        return url
    }
    
    override func getSignupListURL(token: String? = nil)-> String {
        var url: String = String(format: URL_SIGNUP_LIST, "course")
        if token != nil {
            url = url + "/" + token!
        }
        
        return url
    }
    
    override func getSignupURL(token: String)-> String {
        let url: String = String(format: URL_SIGNUP, "course", token)
        
        return url
    }
    
    override func getSignupDateURL(token: String)-> String {
        let url: String = String(format: URL_SIGNUP_DATE, "course", token)
        
        return url
    }
    
    override func parseAbleForSingupList(data: JSON) -> SuperModel {
        let s: SuperCourse = JSONParse.parse(data: data)
        
        return s
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
