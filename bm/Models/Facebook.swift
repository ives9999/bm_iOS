//
//  Facebook.swift
//  bm
//
//  Created by ives on 2017/12/18.
//  Copyright © 2017年 bm. All rights reserved.
//

import Foundation
import FacebookCore
import FacebookLogin

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
    
    let readPermissions: [ReadPermission] = [.publicProfile, .email, .userFriends]
    let params: [String: Any] = ["fields":"email,first_name,last_name,gender,picture.width(1000).height(1000)"]
    
    init() {
    }
    
    func login(viewController: UIViewController, completion: @escaping CompletionHandler) {
        logout()
        let loginManager = LoginManager()
        
        loginManager.logIn(readPermissions: readPermissions, viewController: viewController) { (loginResult) in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                //print("User canceled login.")
                var i = 6
                i = i+1
            case .success(grantedPermissions: _, declinedPermissions: _, token: _):
                //print("login in!")
                //print(accessToken)
                let connection = GraphRequestConnection()
                var request = GraphRequest.init(graphPath: "/me")
                request.parameters = self.params
                
                connection.add(request, completion: {
                    (urlResponse, result) in
                    switch result {
                    case .success(response: let response):
                        //print("Graph Request Response: \(response)")
                        if let responseDictionary = response.dictionaryValue {
                            self.uid = responseDictionary["id"] as! String
                            self.email = responseDictionary["email"] as! String
                            let first_name: String = responseDictionary["first_name"] as! String
                            let last_name: String = responseDictionary["last_name"] as! String
                            self.name = last_name + first_name
                            if responseDictionary["gender"] != nil {
                                self.sex = self.sexChange(responseDictionary["gender"] as! String)
                            }
                            let picture = responseDictionary["picture"] as! NSDictionary
                            let picture_data = picture["data"] as! NSDictionary
                            self.avatar = picture_data["url"] as! String
                            //print(self.avatar)
                            //print(self.uid)
                            //print(self.email)
                            completion(true)
                        }
                    case .failed(let error):
                        print("Graph Request failed: \(error)")
                    }
                    //print("Facebook graph Result:", result)
                    //let json = JSON(result)
                    //print("Facebook graph Response:", response)
                    //let id: String = json["id"].string!
                    //print(id)
                })
                connection.start()
            }
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

