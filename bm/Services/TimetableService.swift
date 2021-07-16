//
//  TimeTableService.swift
//  bm
//
//  Created by ives on 2019/1/22.
//  Copyright © 2019 bm. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class TimetableService: DataService {
    
    static let instance = TimetableService()
    var timetable: Timetable = Timetable()
    //var superCoach: SuperCoach = SuperCoach()
    
    func getOne(id: Int, source: String, token: String, completion: @escaping CompletionHandler) {
        
        //print(model)
        //model.neverFill()
        downloadImageNum = 0
        let body: [String: Any] = ["device": "app", "type": source, "type_token": token,"id":id]
        
        //print(body)
        let url: String = String(format: URL_ONE, "timetable")
        //print(url)
        
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            
            if response.result.error == nil {
                //print(response.result.value)
                guard let data = response.result.value else {
                    print("get response result value error")
                    self.msg = "網路錯誤，請稍後再試"
                    completion(false)
                    return
                }
                //print(data)
                let json = JSON(data)
                //print(json)
                let tt = json["tt"]
                //print(tt)
                self.timetable = JSONParse.parse(data: tt)
                //self.timetable.printRow()
                if json["type"].exists() {
                    let type: String = json["type"].string!
                    if type == "coach" {
                        //self.superCoach = JSONParse.parse(data: json["model"])
                        //self.superCoach.printRow()
                    }
                }
                completion(true)
                
            } else {
                self.msg = "網路錯誤，請稍後再試"
                completion(false)
                debugPrint(response.result.error as Any)
            }
            
        }
    }
}
