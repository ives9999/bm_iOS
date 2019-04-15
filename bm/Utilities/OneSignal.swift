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

class MyNotificationOpenedHandler {
    static let instance = MyNotificationOpenedHandler()
    
    func notificationOpened(result: OSNotificationOpenedResult?) {
        //print("open")
        if (result != nil) {
            let actionType = result!.action.type
            let data = result!.notification.payload.additionalData
            let id = result!.notification.payload.notificationID
            let title = result!.notification.payload.title
            let content = result!.notification.payload.body
            
            if (data != nil) {
                let customKey = data!["customkey"] as! String
                if (customKey != nil) {
                    //print("OpenedHandler customkey set with value: $customKey")
                }
            }
            
            //if (actionType == OSNotificationAction.) {
                //            println("OpenedHandler Button pressed with id: ${result.action.actionID}")
            //}
            print("open handle")
            MyOneSignal.instance.save(id: id!, title: title, content: content!)
        }
    }
}

class MyNotificationReceivedHandler {
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
            let additionalData = notification!.payload.additionalData
            let attachments = notification!.payload.attachments
            let actionButtons = notification!.payload.actionButtons
            let rawPayload = notification!.payload.rawPayload
            
            print("receive handle")
            MyOneSignal.instance.save(id: id!, title: title, content: content!)
        }
    }
}

class MyOneSignal {
    static let instance = MyOneSignal()
    
    let session: UserDefaults = UserDefaults.standard
    func save(id: String, title: String?, content: String) {
        //session.removeObject(forKey: "pn")
        var pnObj:Dictionary<String, String> = ["id": id, "content": content]
        if title != nil {
            pnObj["title"] = title!
        }
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
