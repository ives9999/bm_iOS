//
//  Facebook.swift
//  bm
//
//  Created by ives on 2017/12/18.
//  Copyright © 2017年 bm. All rights reserved.
//

import Foundation
//import FacebookCore
//import FacebookLogin
import FBSDKLoginKit
//import FBSDKLoginKit

/*
 fileprivate struct FBProfileRequest: GraphRequestProtocol {
 
 
 
 struct Respose: GraphResponseProtocol {
 init(rawResponse: Any?) {
 
 }
 }
 var graphPath: String = "/me"
 var parameters: [String : Any]? = ["fields": "id, name"]
 var accessToken: AccessToken? = AccessToken.current
 var httpMethod: GraphRequestHTTPMethod = .GET
 var apiVersion: GraphAPIVersion = .defaultVersion
 }
 */
class Facebook {
    static let instance = Facebook()
    var uid: String = ""
    var email: String = ""
    var name: String = ""
    var sex: String = "M"
    //var token: String = ""
    var avatar: String = ""
    var social: String = "fb"
    var channel: String = CHANNEL
    
    //let readPermissions = [.publicProfile, .email, .userFriends]
    let params: [String: Any] = ["fields":"email,first_name,last_name,gender,picture.width(1000).height(1000)"]
    
    init() {
    }
    
    func login(viewController: UIViewController, completion: @escaping CompletionHandler) {
        logout()
        
        
        
        let loginManager = LoginManager()
        
        loginManager.logIn(permissions: ["public_profile", "email"], from: viewController) { (loginResult, error) in
            
//            let token = loginResult?.token!
//            let connection = GraphRequestConnection()
//            var request = GraphRequest.init(graphPath: "/me")
//            request.parameters = self.params
//            connection.add(request) { (connection, result, error) in
//                print(result);
//            }
            
            
            GraphRequest(graphPath: "me", parameters: self.params).start(completionHandler: {
                connection, result, error -> Void in
                
                if error != nil {
                    print("登入失敗")
                    print("login error = \(error)")
                    completion(false)
                } else {
                    if let resultNew = result as? [String: Any] {
                        //print("登入成功")
                        
                        let uid = resultNew["id"] as! String
                        //print(uid)
                        self.uid = uid
                        let email = resultNew["email"] as! String
                        //print(email)
                        self.email = email
                        let first_name = resultNew["first_name"] as! String
                        //print(first_name)
                            
                        let last_name = resultNew["last_name"] as! String
                        //print(last_name)
                        self.name = last_name + first_name
                        
                        if let picture = resultNew["picture"] as? NSDictionary,
                            let data = picture["data"] as? NSDictionary,
                            let url = data["url"] as? String {
                            //print(url) //臉書大頭貼的url, 再放入imageView內秀出來
                            self.avatar = url
                        }
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            })
            
            
            
//            switch loginResult {
//            case .failed(let error):
//                print(error)
//            case .cancelled:
//                //print("User canceled login.")
//                var i = 6
//                i = i+1
//            case .success(let grantedPermissions, _, _):
//                //print("login in!")
//                //print(accessToken)
//                let connection = GraphRequestConnection()
//                var request = GraphRequest.init(graphPath: "/me")
//                request.parameters = self.params
                
                
                
//                connection.add(request) {
//                    connection, result, err in
//                    switch result {
//                    case .success(response: let response):
//                        //print("Graph Request Response: \(response)")
//                        if let responseDictionary = response.dictionaryValue {
//                            self.uid = responseDictionary["id"] as! String
//                            self.email = responseDictionary["email"] as! String
//                            let first_name: String = responseDictionary["first_name"] as! String
//                            let last_name: String = responseDictionary["last_name"] as! String
//                            self.name = last_name + first_name
//                            if responseDictionary["gender"] != nil {
//                                self.sex = self.sexChange(responseDictionary["gender"] as! String)
//                            }
//                            let picture = responseDictionary["picture"] as! NSDictionary
//                            let picture_data = picture["data"] as! NSDictionary
//                            self.avatar = picture_data["url"] as! String
//                            //print(self.avatar)
//                            //print(self.uid)
//                            //print(self.email)
//                            completion(true)
//                        }
//                    case .failed(let error):
//                        print("Graph Request failed: \(error)")
//                    }
                    //print("Facebook graph Result:", result)
                    //let json = JSON(result)
                    //print("Facebook graph Response:", response)
                    //let id: String = json["id"].string!
                    //print(id)
//                }
//                connection.start()
//            }
        }
    }
    
    func logout() {
        LoginManager().logOut()
    }
    func sexChange(_ raw: String) -> String {
        let res: String = raw == "male" ? "M" : "F"
        return res
    }
}

