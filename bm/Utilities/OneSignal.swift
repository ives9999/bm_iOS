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

class MyNotificationOpenedHandler {
    static let instance = MyNotificationOpenedHandler()
    
    func notificationOpened(result: OSNotificationOpenedResult?) {

    }
}

class MyNotificationReceivedHandler {
    static let instance = MyNotificationReceivedHandler()
    
    func notificationReceived(notification: OSNotification?) {
        
    }
}

class MyOneSignal {
    static let instance = MyOneSignal()
}
