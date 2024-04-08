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
import OneSignal

struct FooRequestParameters : Codable {
    let paramName1: Int
    let paramName2: String
}

class DataService {
    static let instance1 = DataService()
    
//    private let homes = [
//        Home(featured: "1.jpg", title: "艾傑早安羽球團8月份會內賽"),
//        Home(featured: "2.jpg", title: "永遠支持的戴資穎"),
//        Home(featured: "3.jpg", title: "外媒評十大羽毛球美女，馬琳竟上榜！")
//    ]
    var id: Int = 0
    var homes: Dictionary<String, [Home]> = Dictionary<String, [Home]>()
    //var dataLists: [SuperData] = [SuperData]()
    var totalCount: Int!
    var page: Int!
    var perPage: Int!
    var show: Dictionary<String, Any> = Dictionary<String, Any>()
    var show_html: String = ""
    var downloadImageNum: Int = 0
    var needDownloads: [Dictionary<String, Any>] = [Dictionary<String, Any>]()
    var image: UIImage?
    //var homesRaw: Dictionary<String, [Dictionary<String, String>]> = Dictionary<String, [Dictionary<String, String>]>()
    //var titles: [String] = [String]()
    //var pathes: [String] = [String]()
    //var featureds: [UIImage] = [UIImage]()
    
    var citys: [City] = [City]()
    var arenas: [ArenaTable] = [ArenaTable]()
    var citysandarenas:[Int:[String:Any]] = [Int:[String:Any]]()
    var citysandareas:[Int:[String:Any]] = [Int:[String:Any]]()
    var msg:String = ""
    var myError: MYERROR = MYERROR.NOERROR
    var success: Bool = false
    var signup_date: JSON = JSON()//signup_date use
    
//    var _model: SuperData
//    var model: SuperData {
//        get {
//            return _model
//        }
//        set {
//            _model = newValue
//        }
//    }
    
    var timetables: Timetables = Timetables()
    
    //var superModel: SuperModel = SuperModel()
    var able: SuperModel = SuperModel() // for signup list able model
    
    var table: Table?
    var tables: Tables?
    
    var jsonData: Data?
    
    init() {}
    
    func _simpleService(url: String, params: [String: String], completion: @escaping CompletionHandler) {
        
        AF.request(url, method: .post, parameters: params, encoder: JSONParameterEncoder.default, headers: HEADER)
            .validate()
            .responseData { (response) in
            
            switch response.result {
            case .success(let data):
                self.jsonData = data
                completion(true)
                
            case .failure(_):
                
                self.msg = ServiceErrorHandler.instance1.serverError(response: response)
                completion(false)
                print(self.msg)
                return
            }
        }
    }
    
    func delete(token: String, type: String, status: String = "trash", completion: @escaping CompletionHandler) {
        
        let body: [String: String] = ["device": "app", "channel": "bm", "token": token, "type": type, "status": status]
        
        let source: String? = getSource()
        var url: String?
        if source != nil {
            url = String(format: URL_DELETE, source!)
        }
        //let url: String = String(format: URL_DELETE, "cart")
        print(url)
        print(body)
        if url == nil {
            msg = "沒有網址錯誤，請洽管理員"
            completion(false)
        } else {
            //AF.request(url!, method: .post, parameters: body, encoder: JSONParameterEncoder.default, headers: HEADER).responseDecodable(decoder: jsonDecoder) { (response: DataResponse<)
            AF.request(url!, method: .post, parameters: body, encoder: JSONParameterEncoder.default, headers: HEADER).response { (response) in
                
                switch response.result {
                case .success(_):
                    if response.data != nil {
                        self.jsonData = response.data
                        completion(true)
                    } else {
                        self.msg = "網路錯誤，請稍後再試"
                        completion(false)
                    }
                case .failure(let error):
                    self.msg = "伺服器回傳錯誤，所以無法解析字串，請洽管理員"
                    completion(false)
                    print(error)
                    return
                }
            }
        }
    }
    
    func getCalendarURL(token: String? = nil)-> String { return ""}
    
    func deviceToken(device_token: String, member_token: String? = nil, completion: @escaping CompletionHandler) {
        
        let _member_token: String? = (Member.instance.token != "") ? Member.instance.token : nil
        
        let url: String = URL_DEVICE_TOKEN
        var params: [String: String] = ["device": "app","device_token":device_token,"device_type":"iOS"]
        if member_token != nil {
            params["member_token"] = _member_token
        }
        
        print(url)
        print(params)
        
        AF.request(url, method: .post, parameters: params, encoder: JSONParameterEncoder.default, headers: HEADER).response { (response) in
            
            switch response.result {
            case .success(_):
                if response.data != nil {
                    self.jsonData = response.data
                    completion(true)
                } else {
                    self.msg = "沒有任何伺服器回傳的訊息"
                    completion(false)
                }
            case .failure(let error):
                self.msg = "伺服器回傳錯誤，所以無法解析字串，請洽管理員"
                completion(false)
                print(error)
                return
            }
        }
    }
    
    func getArenaByCityID(city_id: Int, completion: @escaping CompletionHandler) {
        let body: [String: String] = ["device": "app", "city": String(city_id)]
        //print(URL_ARENA_BY_CITY_ID)
        //print(body)
        AF.request(URL_ARENA_BY_CITY_ID, method: .post, parameters: body, encoder: JSONParameterEncoder.default, headers: HEADER).responseJSON { (response) in
            
            switch response.result {
            case .success(_):
                if response.data != nil {
                    self.jsonData = response.data
                    completion(true)
                } else {
                    self.msg = "網路錯誤，請稍後再試"
                    completion(false)
                }
            case .failure(let error):
                self.msg = "伺服器回傳錯誤，所以無法解析字串，請洽管理員"
                completion(false)
                print(error)
                return
            }
//            if response.result.error == nil {
//                guard let data = response.result.value else {
//                    print("data error")
//                    self.msg = "網路錯誤，請稍後再試"
//                    completion(false)
//                    return
//                }
//                let json = JSON(data)
//                let jsonArray: [JSON] = json[].arrayValue
//                self.arenas = [ArenaTable]()
//                for arena in jsonArray {
//                    let id: Int = arena["id"].intValue
//                    let name: String = arena["name"].stringValue
//                    let arenaTable: ArenaTable = ArenaTable()
//                    arenaTable.id = id
//                    arenaTable.name = name
//                    self.arenas.append(arenaTable)
//                }
//
//                completion(true)
//            } else {
//                self.msg = "網路錯誤，請稍後再試"
//                completion(false)
//            }
        }
    }
    
    func getIsNameExistUrl()->String { return "" }
    func getLikeURL(token: String? = nil)-> String { return ""}
    
    func ezshipReturnCode(token: String, completion: @escaping CompletionHandler) {
        let url: String = URL_ORDER_RETURN
        let params: [String: String] = ["device": "app", "channel": CHANNEL, "token": token]
        
        //print(url)
        //print(params)
        
        AF.request(url, method: .post, parameters: params, encoder: JSONParameterEncoder.default, headers: HEADER).response { (response) in
            switch response.result {
            case .success(_):
                if response.data != nil {
                    self.jsonData = response.data
                    completion(true)
                } else {
                    self.msg = "沒有任何伺服器回傳的訊息"
                    completion(false)
                }
            case .failure(let error):
                self.msg = "伺服器回傳錯誤，所以無法解析字串，請洽管理員"
                completion(false)
                print(error)
                return
            }
        }
    }
    
    func getList(token: String?, _filter:[String: String]?, page: Int, perPage: Int, completion: @escaping CompletionHandler) {
        
        if (!testNetwork()) {
            myError = MYERROR.NONETWORK
            //msg = "無法連到網路，請檢查您的網路設定"
            completion(false)
            return
        }
        
        self.needDownloads = [Dictionary<String, Any>]()
        var filter: [String: String] = ["device": "app", "channel": CHANNEL, "page": String(page), "perpage": String(perPage)]
        if (_filter != nil) {
            filter = filter.merging(_filter!, uniquingKeysWith: { (first, _) in first })
        }
//        if _filter != nil {
//            filter.merge(_filter!)
//        }
        
        if (Member.instance.isLoggedIn) {
            filter.merge(["member_token":Member.instance.token])
        }
        print(filter.toJSONString())
        
        var url: String = getListURL()
        if (token != nil) {
            url = url + "/" + token!
        }
        print(url)
        
        
        //let a: FooRequestParameters = FooRequestParameters(paramName1: 1, paramName2: "aaa")
        AF.request(url, method: .post, parameters: filter, encoder: JSONParameterEncoder.default, headers: HEADER).response { (response) in
            
//            let str = String(decoding: response.data!, as: UTF8.self)
//            print(str)
            switch response.result {
            case .success(_):
                if response.data != nil {

                    self.jsonData = response.data
                    completion(true)
                    //let str = String(decoding: response.data!, as: UTF8.self)
                    //print(str)
                    //s = try JSONDecoder().decode(t, from: response.data!)
                    //if s != nil {
                        //self.tables = s!
                        //s!.printRow()
                        
//                            let a1: CoursesTable = s! as! CoursesTable
//                            let rows:[CourseTable] = a1.rows
//                            for row in rows {
//                                print(row.coachTable)
//                                row.coachTable?.printRow()
//                                row.filterRow()
//                                row.printRow()
//                            }
                        
                        //completion(true)
//                        } else {
//                            self.msg = "解析JSON字串時，得到空直，請洽管理員"
//                            completion(false)
//                        }
                } else {
                    self.msg = "沒有任何伺服器回傳的訊息"
                    completion(false)
                }
            case .failure(let error):
                self.msg = "伺服器回傳錯誤，所以無法解析字串，請洽管理員"
                completion(false)
                print(error)
                return
            }
        }
    }
    
    func getListURL()-> String { return ""}
    
    func getOne(params: [String: String], completion: @escaping CompletionHandler) {
        
        var body: [String: String] = ["device": "app","strip_html": "false"]
        for (key, param) in params {
            body[key] = param
        }
        
        if (Member.instance.isLoggedIn) {
            body.merge(["member_token":Member.instance.token])
        }
        
        print(body)
        let source: String? = getSource()
        var url: String?
        if source != nil {
            url = String(format: URL_ONE, source!)
        }
        print(url)
        
        if url != nil {
            AF.request(url!, method: .post, parameters: body, encoder: JSONParameterEncoder.default, headers: HEADER).response { (response) in
                
//                let str = String(decoding: response.data!, as: UTF8.self)
//                print(str)
                switch response.result {
                //case .success(let value):
                case .success(_):
                    if response.data != nil {
                        //let str = response.data!.prettyPrintedJSONString
                        //print(str)
                        if (response.data != nil) {
                            self.jsonData = response.data!
                            completion(true)
                        } else {
                            self.msg = "解析JSON字串時，得到空直，請洽管理員"
                            completion(false)
                        }
                    } else {
                        self.msg = "沒有任何伺服器回傳的訊息"
                        completion(false)
                    }
                case .failure(let error):
                    self.msg = "伺服器回傳錯誤，所以無法解析字串，請洽管理員"
                    completion(false)
                    print(error)
                    return
                }
            }
        }
    }
    
    func getSignupDateURL(token: String)-> String { return ""}

    func getPlayerID() -> String {
        
        var playerID: String = ""
        let deviceState = OneSignal.getDeviceState()
        
        if let temp: String = deviceState?.userId {
            playerID = temp
        }
        
        return playerID
    }
    
    func getSignupListURL(token: String? = nil)-> String { return ""}
    func getSignupURL(token: String)-> String { return ""}
    
    func getSource()-> String? {
        return nil
    }
    
    func getUpdateURL()-> String {return ""}
    
    func isNameExist(name: String, completion: @escaping CompletionHandler) {
        
        let url: String = getIsNameExistUrl()
        //print(url)
        let params: [String: String] = ["device": "app", "channel": CHANNEL, "name": name, "member_token": Member.instance.token]
        //print(params)
        
        AF.request(url, method: .post, parameters: params, encoder: JSONParameterEncoder.default, headers: HEADER).response {
            (response) in
            
            switch response.result {
                
            case .success(_):
                if response.data != nil {
                    self.jsonData = response.data
                    completion(true)
                } else {
                    self.msg = "網路錯誤，請稍後再試"
                    completion(false)
                }
            case .failure(let error):
                self.msg = "伺服器回傳錯誤，所以無法解析字串，請洽管理員"
                completion(false)
                print(error)
                return
            }
        }
    }
    
    //token is able token
    func like(token: String, able_id: Int) {
        
        let likeUrl: String = getLikeURL(token: token)
        //print(likeUrl)
        let url = URL(string: likeUrl)
        var request = URLRequest(url: url!)
        
        let member_token: String = Member.instance.token
        let body: [String: Any] = ["device":"app","member_token":member_token,"able_id":able_id]
        //print(body)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request)
        
        task.resume()
    }
    
    func managerSignupList(able_type: String, able_token: String, page: Int, perPage: Int, completion: @escaping CompletionHandler) {
        
        let url = String(format: URL_MANAGER_SIGNUPLIST, able_type)
        let params: [String: String] = [
            "channel":CHANNEL,
            "device":"app",
            "page":String(page),
            "perPage":String(perPage),
            "able_token":able_token,
            "manager_token":Member.instance.token
        ]
        
        //print(url)
        //print(params)
        
        AF.request(url, method: .post, parameters: params, encoder: JSONParameterEncoder.default, headers: HEADER).response { (response) in
            
            switch response.result {
            case .success(_):
                if response.data != nil {
                    //print(response.value)
                    if (response.data != nil) {
                        self.jsonData = response.data!
                        completion(true)
                    } else {
                        self.msg = "解析JSON字串時，得到空直，請洽管理員"
                        completion(false)
                    }
                } else {
                    self.msg = "沒有任何伺服器回傳的訊息"
                    completion(false)
                }
            case .failure(let error):
                self.msg = "伺服器回傳錯誤，所以無法解析字串，請洽管理員"
                completion(false)
                print(error)
                return
            }
        }
    }
    
    func requestManager(_params: [String: String], images: [UIImage]?, completion: @escaping CompletionHandler) {
        
        let url: String = URL_REQUEST_MANAGER
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
        var params: [String: String] = ["channel":CHANNEL,"device":"app"]
        params.merge(_params)
        
        //print(url)
        //print(params)
        
//        AF.request(url, method: .post, parameters: params, encoder: JSONParameterEncoder.default, headers: HEADER).responseJSON { (response) in
//
//            let str = String(decoding: response.data!, as: UTF8.self)
//            print(str)
//            let i = 6
//        }
        
        msg = ""
        AF.upload(
            multipartFormData: { (multipartFormData) in
                if images != nil {

                    for (idx, image) in images!.enumerated() {
                        let imageData: Data = image.jpegData(compressionQuality: 0.2)! as Data
                        let withName: String = "image" + String(idx + 1)
                        let fileName: String = "image" + String(idx + 1) + ".jpg"
                        multipartFormData.append(imageData, withName: withName, fileName: fileName, mimeType: "image/jpeg")
                    }
                }
                for (key, value) in params {
                    multipartFormData.append(("\(value)").data(using: .utf8)!, withName: key)
                }
            },
            to: url,
            usingThreshold: UInt64.init(),
            method: .post,
            headers: headers
        )
            .response(completionHandler: { response in
                
//                let str = String(decoding: response.data!, as: UTF8.self)
//                print(str)
                if (response.data != nil) {
                    self.jsonData = response.data
                    completion(true)
                } else {
                    self.msg = "伺服器錯誤，請洽管理員"
                    completion(false)
                    return
                }
            })
            .uploadProgress(queue: .main, closure: { progress in
                //Current upload progress of file
                //print("Upload Progress: \(progress.fractionCompleted)")
            })
    }
    
    func signup(token: String, member_token: String, date_token: String, course_deadline: String? = nil, completion: @escaping CompletionHandler) {
        let url = getSignupURL(token: token)
        print(url)
        
        let player_id: String = getPlayerID()
        //print(player_id)
        var body: [String: String] = ["device": "app", "channel": "bm", "member_token": member_token, "able_date_token": date_token, "player_id": player_id]
        if course_deadline != nil {
            body["cancel_deadline"] = course_deadline
        }
        
        print(body)
        AF.request(url, method: .post, parameters: body, encoder: JSONParameterEncoder.default, headers: HEADER).response { (response) in
            
            //let str = String(decoding: response.data!, as: UTF8.self)
            //print(str)
            
            switch response.result {
            case .success(_):
                if response.data != nil {
                    self.jsonData = response.data
                    completion(true)
                } else {
                    self.msg = "網路錯誤，請稍後再試"
                    completion(false)
                }
            case .failure(let error):
                self.msg = "伺服器回傳錯誤，所以無法解析字串，請洽管理員"
                completion(false)
                print(error)
                return
            }
//            if response.result.error == nil {
//                guard let data = response.result.value else {
//                    print("data error")
//                    self.msg = "網路錯誤，請稍後再試"
//                    completion(false)
//                    return
//                }
//                //print(data)
//                let json: JSON = JSON(data)
//                self.success = json["success"].boolValue
//                if json["msg"].exists() {
//                    self.msg = json["msg"].stringValue
//                }
//                completion(self.success)
//            } else {
//                self.msg = "網路錯誤，請稍後再試"
//                completion(false)
//            }
        }
    }
    
    func signup_date(token: String, member_token: String, date_token: String, completion: @escaping CompletionHandler) {
        let url = getSignupDateURL(token: token)
        //print(url)
        let body: [String: String] = ["device": "app", "channel": "bm", "member_token": member_token, "date_token": date_token]
        //print(body)
        
        AF.request(url, method: .post, parameters: body, encoder: JSONParameterEncoder.default, headers: HEADER).response { (response) in
            
            switch response.result {
            case .success(_):
                if response.data != nil {
                    self.jsonData = response.data
                    completion(true)
                } else {
                    self.msg = "網路錯誤，請稍後再試"
                    completion(false)
                }
            case .failure(let error):
                self.msg = "伺服器回傳錯誤，所以無法解析字串，請洽管理員"
                completion(false)
                print(error)
                return
            }
//            if response.result.error == nil {
//                guard let data = response.result.value else {
//                    print("data error")
//                    self.msg = "無法解析伺服器傳回值錯誤，請洽管理員"
//                    completion(false)
//                    return
//                }
//                //print(data)
//                let json: JSON = JSON(data)
//                //print(json)
//                self.success = json["success"].boolValue
//                if self.success {
//                    self.signup_date = json
//                } else {
//                    self.msg = json["msg"].stringValue
//                }
//                completion(true)
//            } else {
//                self.msg = "取得報名日期錯誤，請洽管理員"
//                completion(false)
//            }
        }
    }
    
    func signup_list(token: String? = nil, page: Int = 1, perPage: Int = 20, completion: @escaping CompletionHandler) {
        let url: String = getSignupListURL(token: token)
        //print(url)
        let body: [String: String] = ["device": "app", "channel": "bm", "page":String(page), "perPage":String(perPage)]
        //print(body)
        
        AF.request(url, method: .post, parameters: body, encoder: JSONParameterEncoder.default, headers: HEADER).response { (response) in
            
            switch response.result {
            case .success(_):
                if response.data != nil {
                    self.jsonData = response.data
                    completion(true)
                } else {
                    self.msg = "網路錯誤，請稍後再試"
                    completion(false)
                }
            case .failure(let error):
                self.msg = "伺服器回傳錯誤，所以無法解析字串，請洽管理員"
                completion(false)
                print(error)
                return
            }
                    
//            if response.result.error == nil {
//                guard let data = response.result.value else {
//                    //print("get response result value error")
//                    self.msg = "網路錯誤，請稍後再試"
//                    completion(false)
//                    return
//                }
//                let json = JSON(data)
//                //print(json["able"])
//                if json["able"].exists() {
//                    self.able = self.parseAbleForSingupList(data: json["able"])
//                    //print(able.printRow())
//                }
//                completion(true)
//            } else {
//                self.msg = "網路錯誤，請稍後再試"
//                completion(false)
//                debugPrint(response.result.error as Any)
//            }
        }
    }
    
    func testNetwork()-> Bool {
        
        var bConnect: Bool = false
        if Connectivity.isConnectedToInternet {
             bConnect = true
        }
        
        return bConnect
    }
    
    func update(_params: [String: String], image: UIImage?, completion: @escaping CompletionHandler) {
        
        let url: String = getUpdateURL()
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
        var params: [String: String] = ["channel":CHANNEL,"device":"app"]
        params.merge(_params)

        //print(url)
        //print(params)
        msg = ""
        AF.upload(
            multipartFormData: { (multipartFormData) in
                if image != nil {
                    let imageData: Data = image!.jpegData(compressionQuality: 0.2)! as Data
                    multipartFormData.append(imageData, withName: "file", fileName: "test.jpg", mimeType: "image/jpeg")
                }
                
                for (key, value) in params {
                    multipartFormData.append(("\(value)").data(using: .utf8)!, withName: key)
                }
            },
            to: url,
            usingThreshold: UInt64.init(),
            method: .post,
            headers: headers
        )
            .response(completionHandler: { response in
                //print(response.value)
                if (response.data != nil) {
                    self.jsonData = response.data
                    completion(true)
                } else {
                    self.msg = "伺服器錯誤，請洽管理員"
                    completion(false)
                    return
                }
            })
            .uploadProgress(queue: .main, closure: { progress in
                //Current upload progress of file
                //print("Upload Progress: \(progress.fractionCompleted)")
            })
    }
    
    func update(_params: [String: String], images: [UIImage]?, completion: @escaping CompletionHandler) {
        
        let url: String = getUpdateURL()
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
        var params: [String: String] = ["channel":CHANNEL,"device":"app"]
        params.merge(_params)

        //print(url)
        //print(params)
        msg = ""
        AF.upload(
            multipartFormData: { (multipartFormData) in
                if images != nil {
                    
                    for (idx, image) in images!.enumerated() {
                        let imageData: Data = image.jpegData(compressionQuality: 0.2)! as Data
                        let fileName: String = "image" + String(idx + 1)
                        multipartFormData.append(imageData, withName: "file", fileName: fileName, mimeType: "image/jpeg")
                    }
                }
                for (key, value) in params {
                    multipartFormData.append(("\(value)").data(using: .utf8)!, withName: key)
                }
            },
            to: url,
            usingThreshold: UInt64.init(),
            method: .post,
            headers: headers
        )
            .response(completionHandler: { response in
                //print(response.value)
                if (response.data != nil) {
                    self.jsonData = response.data
                    completion(true)
                } else {
                    self.msg = "伺服器錯誤，請洽管理員"
                    completion(false)
                    return
                }
            })
            .uploadProgress(queue: .main, closure: { progress in
                //Current upload progress of file
                //print("Upload Progress: \(progress.fractionCompleted)")
            })
    }
    
    func update(token: String = "", params: [String: String], completion: @escaping CompletionHandler) {
        
        var url: String = getUpdateURL()
        if token.count > 0 {
            url = url + "/" + token
        }
        print(url)
        print(params)
        
        AF.request(url, method: .post, parameters: params, encoder: JSONParameterEncoder.default, headers: HEADER).response { (response) in
            
            switch response.result {
            
            case .success(_):
                if response.data != nil {
                    self.jsonData = response.data
                    completion(true)
                } else {
                    self.msg = "沒有任何伺服器回傳的訊息"
                    completion(false)
                }
            case .failure(let error):
                self.msg = "伺服器回傳錯誤，所以無法解析字串，請洽管理員"
                completion(false)
                print(error)
                return
            }
        }
    }
    
    func update(token: String = "", query: Dictionary<String, Any>, completion: @escaping CompletionHandler) {
        
        var url: String = getUpdateURL()
        if token.count > 0 {
            url = url + "/" + token
        }
        print(url)
        print(query.toJson())
        
        var request: URLRequest = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = query.toJson()!.description.data(using: .utf8)
        //print(request.httpBody)
        AF.request(request).response { (response) in
            switch response.result {

            case .success(_):
                if response.data != nil {
                    //response.data?.prettyPrintedJSONString
                    self.jsonData = response.data
                    completion(true)
                } else {
                    self.msg = "沒有任何伺服器回傳的訊息"
                    completion(false)
                }
            case .failure(let error):
                self.msg = "伺服器回傳錯誤，所以無法解析字串，請洽管理員"
                completion(false)
                print(error)
                return
            }
        }
    }
}

struct Connectivity {
  static let sharedInstance = NetworkReachabilityManager()!
  static var isConnectedToInternet:Bool {
      return self.sharedInstance.isReachable
    }
}

class ServiceErrorHandler {
    
    static let instance1 = ServiceErrorHandler()
    
    func getStatusCode(response: AFDataResponse<Data>)-> Int {
        var statusCode: Int = 200
        if let code: Int = response.response?.statusCode {
            statusCode = code
        }
        
        return statusCode
    }
    
    func serverError(response: AFDataResponse<Data>)-> String {
        
        var msg: String = ""
        
        var statusCode: Int = ServiceErrorHandler.instance1.getStatusCode(response: response)
        
        guard case let .failure(error) = response.result else { return "cast error" }
        
        switch error {
        case .invalidURL(let url):
            msg = "Invalid URL: \(url) - \(error.localizedDescription)"
        case .parameterEncodingFailed(let reason):
            msg = "Parameter encoding failed: \(error.localizedDescription)"
            msg += "Failure Reason: \(reason)"
        case .multipartEncodingFailed(let reason):
            msg = "Multipart encoding failed: \(error.localizedDescription)"
            msg += "Failure Reason: \(reason)"
        case .responseValidationFailed(let reason):
            msg = "Response validation failed: \(error.localizedDescription)"
            msg += "Failure Reason: \(reason)"

            switch reason {
            case .dataFileNil, .dataFileReadFailed:
                msg += "Downloaded file could not be read"
            case .missingContentType(let acceptableContentTypes):
                msg += "Content Type Missing: \(acceptableContentTypes)"
            case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                msg += "Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)"
            case .unacceptableStatusCode(let code):
                msg += "Response status code was unacceptable: \(code)"
            case .customValidationFailed(error: let error):
                msg += "Response custom validation failed: \(error.localizedDescription)"
            }
        case .responseSerializationFailed(let reason):
            msg = "Response serialization failed: \(error.localizedDescription)"
            msg += "Failure Reason: \(reason)"
        case .createUploadableFailed(error: let reason):
            msg = "create uploadable failed: \(reason.localizedDescription)"
        case .createURLRequestFailed(error: let reason):
            msg = "create url request failed: \(reason.localizedDescription)"
        case .downloadedFileMoveFailed(error: let reason, source: let source, destination: let destination):
            msg = "download file move failed: \(reason.localizedDescription) sorce:\(source) destination:\(destination)"
        case .explicitlyCancelled:
            msg = "explicitly cancelled: \(error.localizedDescription)"
        case .parameterEncoderFailed(reason: let reason):
            msg = "create uploadable failed: \(reason)"
        case .requestAdaptationFailed(error: let reason):
            msg = "request adatpation failed: \(reason.localizedDescription)"
        case .requestRetryFailed(retryError: let retryError, originalError: let originalError):
            msg = "request Retry failed: \(retryError.localizedDescription) originalError:\(originalError))"
        case .serverTrustEvaluationFailed(reason: let reason):
            msg = "server trust evaluation failed: \(reason)"
        case .sessionDeinitialized:
            msg = "session deinitialized: \(error.localizedDescription)"
        case .sessionInvalidated(error: let reason):
            msg = "session invalidate: \(reason!.localizedDescription)"
        case .sessionTaskFailed(error: let reason):
            msg = "session task failed: \(reason.localizedDescription)"
        case .urlRequestValidationFailed(reason: let reason):
            msg = "url request validation failed: \(reason)"
        }
        
        msg += "\n伺服器錯誤，無法接收回傳資料，請洽管理員" + "\n" + error.localizedDescription + "\n\(statusCode)"
        
        return msg
    }
}
