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
    var id: String = ""
    var email: String = ""
    var first_name: String = ""
    var last_name: String = ""
    var token: String = ""
    var pictureUrl: String = ""
    
    let readPermissions: [ReadPermission] = [.publicProfile, .email, .userFriends]
    let params: [String: Any] = ["fields":"email,first_name,last_name,picture.width(1000).height(1000),birthday,gender"]
    
    init() {
    }
    
    func login(viewController: UIViewController, completion: @escaping CompletionHandler) {
        let loginManager = LoginManager()
        
        loginManager.logIn(readPermissions: readPermissions, viewController: viewController) { (loginResult) in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User canceled login.")
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
                        //print("Graph Request Response: \(response1)")
                        if let responseDictionary = response.dictionaryValue {
                            self.id = responseDictionary["id"] as! String
                            self.email = responseDictionary["email"] as! String
                            //print(id)
                            //print(email)
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
}
