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
    
    func uploadImage(_ imageData: Data, key: String, filename: String, mimeType: String) {
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData, withName: key, fileName: filename, mimeType: mimeType)
        }, to: URL_FEATURED) { (result) in
            
        }
    }
    func update(data: [String: Any], completion: @escaping CompletionHandler) {
        var body: [String: Any] = ["source": "app"]
        body.merge(data)
        print(body)
        Alamofire.request(URL_TEAM_UPDATE, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.result.value else {
                    print("data error")
                    return
                }
                let json = JSON(data)
                self.success = json["success"].boolValue
                if self.success {
                    self.id = json["id"].intValue
                } else {
                    let errors: [String] = json["msg"].arrayObject as! [String]
                    for i in 0 ..< errors.count {
                        self.msg += errors[i]
                    }
                    //print(self.msg)
                }
                completion(true)
            }
        }
    }
    
}
