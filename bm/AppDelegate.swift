//
//  AppDelegate.swift
//  bm
//
//  Created by ives on 2017/10/3.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import Device_swift
import UIColor_Hex_Swift
//import OneSignal
import ECPayPaymentGatewayKit
import FirebaseCore
import FirebaseMessaging

//public var BASE_URL: String = ""
//let REMOTE_BASE_URL = "https://bm.sportpassword.com"
//let LOCALHOST_BASE_URL = "http://bm.sportpassword.localhost"
//var URL_HOME = ""

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    //var fcmTokenUser : String?
    let gcmMessageIDKey: String = "grm.message_id"
    var fcmToken: String?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        
        
//        let status:OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
//        let hasPrompted = status.permissionStatus.hasPrompted
//        print("hasPrompted = \(hasPrompted)")
//
//        let userStatus = status.permissionStatus.status
//        print("userStatus = \(userStatus)")
//
//        let isSubscribed = status.subscriptionStatus.subscribed
//        print("isSubscribed = \(isSubscribed)")
//
//        let userID = status.subscriptionStatus.userId
//        print("userID = \(userID)")
//
//        let pushToken = status.subscriptionStatus.pushToken
//        print("pushToken = \(pushToken)")
//
//        OneSignal.promptForPushNotifications { (accepted) in
//            print("User accepted notifications: \(accepted)")
//            if !accepted {
//                OneSignal.presentAppSettings()
//            }
//        }
        
        //let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: true]
        
        // Replace 'YOUR_APP_ID' with your OneSignal App ID.
        
//        OneSignal.initWithLaunchOptions(launchOptions)
//        OneSignal.setAppId("856c8fdb-79fb-418d-a397-d58b9c6b880b")
//
//        // promptForPushNotifications will show the native iOS notification permission prompt.
//        // We recommend removing the following code and instead using an In-App Message to prompt for notification permission (See step 8)
//        OneSignal.promptForPushNotifications(userResponse: { accepted in
//            //print("User accepted notifications: \(accepted)")
//
//        }, fallbackToSettings: true)
//
//        OneSignal.register(forProvisionalAuthorization: { accepted in
//            //handle authorization
//        })
//
////        let notificationWillShowInForegroundBlock: OSNotificationWillShowInForegroundBlock = { notification, completion in
////          print("Received Notification: ", notification.notificationId ?? "no id")
////          print("launchURL: ", notification.launchURL ?? "no launch url")
////          print("content_available = \(notification.contentAvailable)")
////
////          if notification.notificationId == "example_silent_notif" {
////            // Complete with null means don't show a notification
////            completion(nil)
////          } else {
////            // Complete with a notification means it will show
////            completion(notification)
////          }
////        }
////        OneSignal.setNotificationWillShowInForegroundHandler(notificationWillShowInForegroundBlock)
//
//
//        OneSignal.setNotificationWillShowInForegroundHandler(MyOneSignal.instance.notificationWillShowInForegroundBlock)
//
//        OneSignal.setNotificationOpenedHandler(MyOneSignal.instance.notificationOpenedBlock)
        
        //let pushManager = Fcm()
        //pushManager.registerForFcm()
        
        FirebaseApp.configure()
        
        // [START set_messaging_delegate]
        Messaging.messaging().delegate = self
        // [END set_messaging_delegate]

        // Register for remote notifications. This shows a permission dialog on first run, to
        // show the dialog at a more appropriate time move this registration accordingly.
        // [START register_for_notifications]

        UNUserNotificationCenter.current().delegate = self
        
        //取得推播權限
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, _ in
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }

        application.registerForRemoteNotifications()
        
        
//        OneSignal.initWithLaunchOptions(
//            launchOptions,
//            appId: "856c8fdb-79fb-418d-a397-d58b9c6b880b",                                        handleNotificationReceived: {
//                notification in
//
//                MyNotificationReceivedHandler.instance.notificationReceived(notification: notification)
//            self.goShowPNVC()
//        },
//            handleNotificationAction: { result in
//            MyNotificationOpenedHandler.instance.notificationOpened(result: result)
//            self.goShowPNVC()
//        },
//            settings: onesignalInitSettings)
        
        //OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        //OneSignal.promptForPushNotifications(userResponse: { accepted in
            //print("User accepted notifications: \(accepted)")
        //})
        
         //Sync hashed email if you have a login system or collect it.
           //Will be used to reach the user at the most optimal time of day.
         //OneSignal.syncHashedEmail(userEmail)
        
        #if os(iOS) && targetEnvironment(simulator)
            gSimulate = true
        #else
            gSimulate = false
        #endif
        
        //gSimulate = false
        //print(gSimulate)
        //BASE_URL = (gSimulate) ? LOCALHOST_BASE_URL : REMOTE_BASE_URL
        
        
        //ECPayPaymentGatewayManager.sharedInstance().initialize(env: .Stage)
        ECPayPaymentGatewayManager.sharedInstance().initialize(env: .Prod)
        
        if #available(iOS 13.0, *) {
            self.window?.overrideUserInterfaceStyle = .light
        }
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "TempPlay", bundle: nil)
        let controller: SearchVC = mainStoryboard.instantiateViewController(withIdentifier: "toSearch") as! SearchVC
        self.window?.rootViewController = controller
        self.window?.makeKeyAndVisible()
        
        //Member.instance.justGetMemberOne = false
        return true
    }
    
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        fcmTokenUser = fcmToken
//    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message
        print(userInfo)
    }
    
    //silent notification
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }

        // Print full message.
        print(userInfo)

        return UIBackgroundFetchResult.newData
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        InstanceID

        var tokenString = ""
        for byte in deviceToken {
            let hexString = String(format: "%02x", byte)
            tokenString += hexString
        }
        //let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("APNs device token: \(tokenString)")

//        if tokenString.count > 0 {
//            self.sendDeviceToken(device_token: tokenString)
//        }
    }
    
    func application(_ application: UIApplication, didFailToContinueUserActivityWithType userActivityType: String, error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
    }
    
//    private func goShowPNVC() {
//        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let showPNVC: ShowPNVC = mainStoryboard.instantiateViewController(withIdentifier: TO_PN) as! ShowPNVC
//        let root = UIApplication.shared.keyWindow!.rootViewController
//        root?.present(showPNVC, animated: true, completion: nil)
//    }
    
    func sendDeviceToken(device_token: String) {
        DataService.instance1.deviceToken(device_token: device_token, member_token: Member.instance.token) { (success) in
            print("success: \(success)")
        }
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        let v = value(forKey: "statusBar") as? UIView
        return v
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    //當訊息進來app在前景時，收到推播會呼叫此函式
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // [START_EXCLUDE]
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
          print("Message ID: \(messageID)")
        }
        // [END_EXCLUDE]
        // Print full message.
        print(userInfo)
        
        
        //for key in userInfo.keys {
            //print("\(key) => \(userInfo[key])")
            
        //}

        // Change this to your preferred presentation option
        return [[.banner, .sound]]
    }

    //當app在背景時，使用者點選推播時，就會進入此函式
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo

        // [START_EXCLUDE]
        // Print message ID
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        // [END_EXCLUDE]
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print full message.
        print(userInfo)
        
        if userInfo.keyExist(key: "type") {
            if let type: String = userInfo["type"] as? String {
                if type == "order" {
                    
                    if let vc: BaseViewController = self.getCurrentVC() {
                        vc.toMemberOrderList()
                    }
                } else if type == "course" {
                    if let vc: BaseViewController = self.getCurrentVC() {
                        vc.toCourse()
                    }
                }
            }
        }
    }
    
    //https://stackoverflow.com/questions/30592521/opening-view-controller-from-app-delegate-using-swift
    func getCurrentVC()-> BaseViewController? {
        
        if let window = self.window, let rootViewController = window.rootViewController {
            var currentController = rootViewController
            while let presentedController = currentController.presentedViewController {
                currentController = presentedController
            }
            
            if let vc = currentController as? BaseViewController {
                return vc
            }
        }
        
        return nil
    }
}

// [END ios_10_message_handling]

extension AppDelegate: MessagingDelegate {

    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firbase registration token: \(String(describing: fcmToken))")

        self.fcmToken = fcmToken

        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.

        if fcmToken != nil {
            sendDeviceToken(device_token: fcmToken!)
        }
    }

    // [END refresh_token]
}




