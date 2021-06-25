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
import OneSignal
import ECPayPaymentGatewayKit
//import FacebookCore
//import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

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
        
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: true]
        
        // Replace 'YOUR_APP_ID' with your OneSignal App ID.
        
        OneSignal.initWithLaunchOptions(
            launchOptions,
            appId: "856c8fdb-79fb-418d-a397-d58b9c6b880b",                                        handleNotificationReceived: {
                notification in
                
                MyNotificationReceivedHandler.instance.notificationReceived(notification: notification)
            self.goShowPNVC()
        },
            handleNotificationAction: { result in
            MyNotificationOpenedHandler.instance.notificationOpened(result: result)
            self.goShowPNVC()
        },
            settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        //OneSignal.promptForPushNotifications(userResponse: { accepted in
            //print("User accepted notifications: \(accepted)")
        //})
        
         //Sync hashed email if you have a login system or collect it.
           //Will be used to reach the user at the most optimal time of day.
         //OneSignal.syncHashedEmail(userEmail)
        
        //let storyboard: UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
        //let tbController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        //tbController.tabBar.barTintColor = UIColor("#191c25")

        //UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Arial", size: 14)!], for: UIControlState.normal)
        
        //UIApplication.shared.statusBarStyle = .default
        //UIApplication.shared.statusBarView?.backgroundColor = UIColor(STATUS_GREEN)
        //let color = UIColor(red: 128/255, green: 100/255, blue: 0, alpha: 1)
        //setStatusBarBackgroundColor(color: color)
        
        let deviceType: DeviceType = UIDevice.current.deviceType
        if deviceType == .simulator {
            gSimulate = true
        }
        //gSimulate = true
        
        //ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        ECPayPaymentGatewayManager.sharedInstance().initialize(env: .Prod)
        
        Member.instance.justGetMemberOne = false
        return true
    }
    
    func setStatusBarBackgroundColor(color: UIColor) {
        guard let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView else { return }
        statusBar.backgroundColor = color
    }
    
    
    private func goShowPNVC() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let showPNVC: ShowPNVC = mainStoryboard.instantiateViewController(withIdentifier: TO_PN) as! ShowPNVC
        let root = UIApplication.shared.keyWindow!.rootViewController
        root?.present(showPNVC, animated: true, completion: nil)
//        self.window = UIWindow(frame: UIScreen.main.bounds)
//        self.window!.rootViewController = showPNVC
//        self.window!.makeKeyAndVisible()
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        let notificationTypes: UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound]
//        let pushNotificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: nil)
//        application.registerUserNotificationSettings(pushNotificationSettings)
//        application.registerForRemoteNotifications()
        
//      stop facebook login support for 1.5.0 above
//        let appId: String = Settings.appID!
//        if url.scheme != nil && url.scheme!.hasPrefix("fb\(appId)") && url.host == "authorize" {
//            return ApplicationDelegate.shared.application(application,
//                                                         open: url,
//                                                         sourceApplication: sourceApplication,
//                                                         annotation: annotation)
//        }
        return false
    }
    
    //      stop facebook login support for 1.5.0 above
//    @available(iOS 9.0, *)
//    func application(_ application: UIApplication,
//                     open url: URL,
//                     options: [UIApplicationOpenURLOptionsKey: Any]) -> Bool {
//        return ApplicationDelegate.shared.application(application, open: url, options: options)
//    }
}

extension UIApplication {
    var statusBarView: UIView? {
        let v = value(forKey: "statusBar") as? UIView
//        if responds(to: Selector("statusBar")) {
//            return value(forKey: "statusBar") as? UIView
//        }
        return v
    }
}

extension AppDelegate {
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //use response.notification.request.content.userInfo to fetch push data
        //print("didReceive > 10.0")
    }
    
    // for iOS < 10
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        //use notification.userInfo to fetch push data
        //print("didReceive < 10")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //use userInfo to fetch push data
        //print("background")
    }
}





