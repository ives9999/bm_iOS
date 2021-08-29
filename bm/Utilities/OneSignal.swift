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

class MyNotificationService: UNNotificationServiceExtension {
    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var receivedRequest: UNNotificationRequest!
    var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        
        self.receivedRequest = request
        self.contentHandler = contentHandler
        self.bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            //If your SDK version is < 3.5.0 uncomment and use this code:
                        /*
                        OneSignal.didReceiveNotificationExtensionRequest(self.receivedRequest, with: self.bestAttemptContent)
                        contentHandler(bestAttemptContent)
                        */
                        
                        /* DEBUGGING: Uncomment the 2 lines below to check this extension is excuting
                                      Note, this extension only runs when mutable-content is set
                                      Setting an attachment or action buttons automatically adds this */
                        //OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)
                        //bestAttemptContent.body = "[Modified] " + bestAttemptContent.body
            
            OneSignal.didReceiveNotificationExtensionRequest(self.receivedRequest, with: bestAttemptContent, withContentHandler: self.contentHandler)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
            OneSignal.serviceExtensionTimeWillExpireRequest(self.receivedRequest, with: self.bestAttemptContent)
            contentHandler(bestAttemptContent)
        }
    }
    
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

//class MyNotificationOpenedHandler: MyNotification {
//    static let instance = MyNotificationOpenedHandler()
//
//    func notificationOpened(result: OSNotificationOpenedResult?) {
//        //print("open")
//        if (result != nil) {
//            let actionType = result!.action.type
//            let data = result!.notification.payload.additionalData
//            let id = result!.notification.payload.notificationID
//            let title = result!.notification.payload.title
//            let content = result!.notification.payload.body
//
//            var pnID = "0"
//            if (data != nil) {
//                //let customKey = data!["customkey"] as! String
//                //if (customKey != nil) {
//                    //print("OpenedHandler customkey set with value: $customKey")
//                //}
//                pnID = getServerPNID(data: data!)
//            }
//
//            //if (actionType == OSNotificationAction.) {
//                //            println("OpenedHandler Button pressed with id: ${result.action.actionID}")
//            //}
//            //print("open handle")
//            MyOneSignal.instance.save(id: id!, title: title, content: content!, pnID: pnID)
//        }
//    }
//}
//
//class MyNotificationReceivedHandler: MyNotification {
//    static let instance = MyNotificationReceivedHandler()
//
//    func notificationReceived(notification: OSNotification?) {
//        //print("receive")
//        if (notification != nil) {
//            let data = notification!.payload.additionalData
//            let id = notification!.payload.notificationID
//            let contentAvailable = notification!.payload.contentAvailable
//            let badge = notification!.payload.badge
//            let title = notification!.payload.title
//            let content = notification!.payload.body
//            let subtitle = notification!.payload.subtitle
//            let launchURL = notification!.payload.launchURL
//            let sound = notification!.payload.sound
//            let attachments = notification!.payload.attachments
//            let actionButtons = notification!.payload.actionButtons
//            let rawPayload = notification!.payload.rawPayload
//
////            print("additionalData = \(data)")
//            var pnID = "0"
//            if (data != nil) {
//                pnID = getServerPNID(data: data!)
//                //print(pnID)
//            }
//
//            //print("receive handle")
//            MyOneSignal.instance.save(id: id!, title: title, content: content!, pnID: pnID)
//        }
//    }
//}

class MyOneSignal {
    static let instance = MyOneSignal()
    
    let session: UserDefaults = UserDefaults.standard
    
    let notificationWillShowInForegroundBlock: OSNotificationWillShowInForegroundBlock = { notification, completion in
        
        print("Received Notification: ", notification.notificationId ?? "no id")
        print("launchURL:", notification.launchURL ?? "no launch url")
        print("content_available = \(notification.contentAvailable)")
        
        if notification.notificationId == "example_silent_notif" {
            // Complete with null means don't show a notification
            completion(nil)
        } else {
            // Complete with a notification means it will show

            let data = notification.additionalData

            let id = notification.notificationId
            let title = notification.title
            let content = notification.body

//            let smallIcon = notification.smallIcon
//            let largeIcon = notification.largeIcon
//            let bigPicture = notification.bigPicture
//            let smallIconAccentColor = notification.smallIconAccentColor
            let sound = notification.sound
//            let ledColor = notification.ledColor
//            let lockScreenVisibility = notification.lockScreenVisibility
//            let groupKey = notification.groupKey
//            let groupMessage = notification.groupMessage
//            let fromProjectNumber = notification.fromProjectNumber
            let rawPayload = notification.rawPayload

            var pnID = "0"
            if (data != nil) {
                //pnID = getServerPNID(data)
            }

            MyOneSignal.instance.save(id: String(id!), title: title, content: content!, pnID: pnID)

            //notificationReceivedEvent.complete(notification)
            //toShowPNVC(context)
            completion(notification)
        }
    }
    
    let notificationOpenedBlock: OSNotificationOpenedBlock = { result in
        
        // This block gets called when the user reacts to a notification received
        let notification: OSNotification = result.notification
        print("Message: ", notification.body ?? "empty body")
        print("badge number: ", notification.badge)
        print("notification sound: ", notification.sound ?? "No sound")
        
        if let additionalData = notification.additionalData {
            print("additionalData: ", additionalData)
            if let actionSelected = notification.actionButtons {
                print("actionSelected: ", actionSelected)
            }
            if let actionID = result.action.actionId {
                //handle the action
                
                let actionType = result.action.type
                let data = result.notification.additionalData
                let id = result.notification.notificationId
                let title = result.notification.title
                let content = result.notification.body

                var pnID = "0"
                if (data != nil) {
                    //pnID = getServerPNID(data)
                }
                MyOneSignal.instance.save(id: String(id!), title: title, content: content!, pnID: pnID)
            }
        }
    }
    
//    func openHandler(result: OSNotificationOpenedResult) {
//
//        let actionType = result.action.type
//        let data = result.notification.additionalData
//        let id = result.notification.notificationId
//        let title = result.notification.title
//        let content = result.notification.body
//
//        var pnID = "0"
//        if (data != nil) {
//            //pnID = getServerPNID(data)
//        }
//        save(id: String(id!), title: title, content: content!, pnID: pnID)
//
//        //toShowPNVC(context)
//    }
//
//    func showInForegroundHandler(notificationReceivedEvent: OSNotificationR) {
//
//        let notification = notificationReceivedEvent.notification
//
//        let data = notification.additionalData
//
//        let id = notification.androidNotificationId
//        let title = notification.title
//        let content = notification.body
//
//        let smallIcon = notification.smallIcon
//        let largeIcon = notification.largeIcon
//        let bigPicture = notification.bigPicture
//        let smallIconAccentColor = notification.smallIconAccentColor
//        let sound = notification.sound
//        let ledColor = notification.ledColor
//        let lockScreenVisibility = notification.lockScreenVisibility
//        let groupKey = notification.groupKey
//        let groupMessage = notification.groupMessage
//        let fromProjectNumber = notification.fromProjectNumber
//        let rawPayload = notification.rawPayload
//
//        var pnID = "0"
//        if (data != nil) {
//            //pnID = getServerPNID(data)
//        }
//
//        save(id: String(id!), title: title, content: content!, pnID: pnID)
//
//        notificationReceivedEvent.complete(notification)
//        //toShowPNVC(context)
//    }
    
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


