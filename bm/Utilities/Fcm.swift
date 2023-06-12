//
//  Fcm.swift
//  bm
//
//  Created by ives on 2023/6/12.
//  Copyright © 2023 bm. All rights reserved.
//

import Foundation
import FirebaseMessaging

class Fcm: NSObject, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    override init() {
        super.init()
    }
    
    func registerForFcm() {
        if #available(iOS 10.0, *) {
            // For iOS display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in }
            )
            
            //For iOS 10 data message (sent via FCM)
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        
        UIApplication.shared.registerForRemoteNotifications()
        updateFirebasePushTokenIfNeeded()
    }
    
    func updateFirebasePushTokenIfNeeded() {
        if let token = Messaging.messaging().fcmToken {
            let n = 4
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        print("Firbase registration token: \(String(describing: fcmToken))")

        //self.fcmToken = fcmToken

        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.

        if fcmToken != nil {
            //sendDeviceToken(device_token: fcmToken!)
        }
        
        //updateFirebasePushTokenIfNeeded()
    }
}
































