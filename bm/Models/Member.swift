//
//  Member.swift
//  bm
//
//  Created by ives on 2017/11/1.
//  Copyright © 2017年 bm. All rights reserved.
//

import Foundation

class Member: NSObject, NSCoding {
    var id: Int
    var nickname: String
    //var uid: String
    //var slug: String
    //var name: String
    //var channel: String
    //var dob: Date
    //var sex: sex
    //var tel: String
    //var mobile: String
    var email: String
    //var pid: String
    //var avatar: UIImage
    //var type: member_type
    //var social: String
    //var role: member_role
    //var status: status
    //var validate: Int
    //var mobile_validate: String
    var token: String
    //var created_at: Date
    //var updated_at: Date
    //var ip: Int
    
    var isLoggin: Bool
    
    override init() {
        isLoggin = false
        id = 0
        nickname = ""
        email = ""
        token = ""
    }
    
    required init(coder aDecoder: NSCoder) {
        //(id,nickname,uid,slug,name,channel,dob) = (0,"","","","","bm",Date())
        //(sex,tel,mobile,email,pid,avatar) = (.M,"","","","",UIImage(named: "nophoto")!)
        //(type,social,role,status,validate) = (.general,"",.member,.online,0)
        //(mobile_validate,token,created_at,updated_at,ip) = ("","",Date(),Date(),0)
        id = aDecoder.decodeInteger(forKey: "id")
        nickname = aDecoder.decodeObject(forKey: "nickname") as! String
        email = aDecoder.decodeObject(forKey: "email") as! String
        token = aDecoder.decodeObject(forKey: "token") as! String
        isLoggin = aDecoder.decodeBool(forKey: "isLoggin")
        
    }
//    convenience init(coder aDecoder: NSCoder) {
//        id = aDecoder.decodeInt32(forKey: "id")
//        nickname = aDecoder.decodeObject(forKey: "nickname") as! String
//        email = aDecoder.decodeObject(forKey: "email") as! String
//        token = aDecoder.decodeObject(forKey: "token") as! String
//        isLoggin = aDecoder.decodeBool(forKey: "isLoggin")
//    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(nickname, forKey: "nickname")
        aCoder.encode(token, forKey: "token")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(isLoggin, forKey: "isLoggin")
    }
    
}














