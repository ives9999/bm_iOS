//
//  TeamService.swift
//  bm
//
//  Created by ives on 2017/11/12.
//  Copyright © 2017年 bm. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON

class TeamService {
    static let instance = TeamService()
    
    var msg:String = ""
    var success: Bool = false
    var id: Int = 0
    
    func update(params: [String: Any], _ image: UIImage?, key: String, filename: String, mimeType: String, completion: @escaping CompletionHandler) {
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
        var body: [String: Any] = ["source": "app"]
        body.merge(params)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if image != nil {
                let imageData: Data = UIImageJPEGRepresentation(image!, 0.2)!
                //print(imageData)
                //let base64: String = imageData.base64EncodedString(options: .lineLength64Characters)
                multipartFormData.append(imageData, withName: key, fileName: filename, mimeType: mimeType)
            }
            //print(params)
            for (key, value) in body {
                if key == "degree" {
                    for d in value as! [String] {
                        multipartFormData.append(("\(d)").data(using: .utf8)!, withName: "degree[]")
                    }
                } else if key == "play_day" {
                    for d in value as! [Int] {
                        multipartFormData.append(("\(d)").data(using: .utf8)!, withName: "play_day[]")
                    }
                } else {
                    multipartFormData.append(("\(value)").data(using: .utf8)!, withName: key)
                }
            }
            //print(multipartFormData.boundary)
        }, usingThreshold: UInt64.init(), to: URL_TEAM_UPDATE, method: .post, headers: headers) { (result) in
            switch result {
            case .success(let upload, _, _):
//                upload.responseString { (response) in
//                    print(response)
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
                        if self.success {
                            self.id = json["id"].intValue
                        } else {
                            let errors: [String] = json["msg"].arrayObject as! [String]
                            for i in 0 ..< errors.count {
                                self.msg += errors[i]
                            }
                        }
                    }
                })
                completion(true)
            case .failure(let error):
                print(error)
                //onError(error)
                completion(false)
            }
        }
    }
//    func update(params: [String: Any], completion: @escaping CompletionHandler) {
//        var body: [String: Any] = ["source": "app"]
//        body.merge(params)
//        print(body)
//        Alamofire.request(URL_TEAM_UPDATE, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
//            if response.result.error == nil {
//                guard let data = response.result.value else {
//                    print("data error")
//                    return
//                }
//                let json = JSON(data)
//                self.success = json["success"].boolValue
//                if self.success {
//                    self.id = json["id"].intValue
//                } else {
//                    let errors: [String] = json["msg"].arrayObject as! [String]
//                    for i in 0 ..< errors.count {
//                        self.msg += errors[i]
//                    }
//                    //print(self.msg)
//                }
//                completion(true)
//            }
//        }
//    }
    
}
