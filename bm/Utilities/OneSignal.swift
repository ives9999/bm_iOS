//
//  OneSignal.swift
//  bm
//
//  Created by ives on 2019/3/7.
//  Copyright © 2019 bm. All rights reserved.
//

import Foundation
import UIKit
import OneSignal
import SwiftyJSON

class MyNotification {
    
    func getServerPNID(data: Dictionary<AnyHashable, Any>)-> String {
        let member_id = String(Member.instance.id)
        var id = "0"
        for (key, value) in data {
            let tmp = value as! String
            if tmp == member_id {
                id = key as! String
            }
        }
        
        return id
    }
}

class MyNotificationOpenedHandler: MyNotification {
    static let instance = MyNotificationOpenedHandler()
    
    func notificationOpened(result: OSNotificationOpenedResult?) {
        //print("open")
        if (result != nil) {
            let actionType = result!.action.type
            let data = result!.notification.payload.additionalData
            let id = result!.notification.payload.notificationID
            let title = result!.notification.payload.title
            let content = result!.notification.payload.body
            
            var pnID = "0"
            if (data != nil) {
                //let customKey = data!["customkey"] as! String
                //if (customKey != nil) {
                    //print("OpenedHandler customkey set with value: $customKey")
                //}
                pnID = getServerPNID(data: data!)
            }
            
            //if (actionType == OSNotificationAction.) {
                //            println("OpenedHandler Button pressed with id: ${result.action.actionID}")
            //}
            //print("open handle")
            MyOneSignal.instance.save(id: id!, title: title, content: content!, pnID: pnID)
        }
    }
}

class MyNotificationReceivedHandler: MyNotification {
    static let instance = MyNotificationReceivedHandler()
    
    func notificationReceived(notification: OSNotification?) {
        //print("receive")
        if (notification != nil) {
            let data = notification!.payload.additionalData
            let id = notification!.payload.notificationID
            let contentAvailable = notification!.payload.contentAvailable
            let badge = notification!.payload.badge
            let title = notification!.payload.title
            let content = notification!.payload.body
            let subtitle = notification!.payload.subtitle
            let launchURL = notification!.payload.launchURL
            let sound = notification!.payload.sound
            let attachments = notification!.payload.attachments
            let actionButtons = notification!.payload.actionButtons
            let rawPayload = notification!.payload.rawPayload
            
//            print("additionalData = \(data)")
            var pnID = "0"
            if (data != nil) {
                pnID = getServerPNID(data: data!)
                //print(pnID)
            }
            
            //print("receive handle")
            MyOneSignal.instance.save(id: id!, title: title, content: content!, pnID: pnID)
        }
    }
}

class MyOneSignal {
    static let instance = MyOneSignal()
    
    let session: UserDefaults = UserDefaults.standard
    
    func save(id: String, title: String?, content: String, pnID: String) {
        //session.removeObject(forKey: "pn")
        var pnObj:Dictionary<String, String> = ["id": id, "content": content]
        if title != nil {
            pnObj["title"] = title!
        }
        //if pnID > 0 {
            pnObj["pnid"] = pnID
        //}
        var pnArr = self.getSession()
        if pnArr == nil {
            pnArr = Array<Dictionary<String, String>>()
            pnArr!.append(pnObj)
            session.set(pnArr, forKey: "pn")
        } else {
            if !self.isExist(id: id) {
                pnArr!.append(pnObj)
                session.set(pnArr, forKey: "pn")
            }
        }
        
        //if (pnID > 0) {
            session.set("pnid", pnID)
        //}
        
        //let res = (session.array(forKey: "pn") as! Array<Dictionary<String, String>>)
        //print(res)
    }
    
    func getSession()-> Array<Dictionary<String, String>>? {
        var pnArr: Array<Dictionary<String, String>>?
        if session.array(forKey: "pn") != nil {
            pnArr = (session.array(forKey: "pn") as! Array<Dictionary<String, String>>)
        }
        return pnArr
    }
    
    func remove(id: String)-> Bool {
        var pnArr: Array<Dictionary<String, String>>? = self.getSession()
        if pnArr != nil {
            var i = 0
            for pnObj: Dictionary<String, String> in pnArr! {
                let id1 = pnObj["id"]
                if id == id1 {
                    pnArr!.remove(at: i)
                    session.set(pnArr, forKey: "pn")
                    break
                }
                i = i + 1
            }
        }
        return true
    }
    
    func clear() {
        session.removeObject(forKey: "pn")
    }
    
    func isExist(id: String)-> Bool {
        var pnArr: Array<Dictionary<String, String>>? = self.getSession()
        var b: Bool = false
        if pnArr != nil {
            for pnObj: Dictionary<String, String> in pnArr! {
                let id1 = pnObj["id"]
                if id == id1 {
                    b = true
                    break
                }
            }
        }
        return b
    }
}


