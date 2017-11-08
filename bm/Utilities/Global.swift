//
//  Global.swift
//  bm
//
//  Created by ives on 2017/10/7.
//  Copyright © 2017年 bm. All rights reserved.
//

import Foundation
import UIKit
import Device_swift

var gSimulate:Bool = false

enum STATUS: String {
    case online, offline, trash, delete
}
enum SEX: String {
    case M = "先生"
    case F = "小姐"
    
    static func enumFronString(string: String) -> SEX {
        switch string {
        case "M" :
            return self.M
        case "F" :
            return self.F
        default :
            return self.M
        }
    }
}
enum MEMBER_ROLE: String {
    case member, sale, designer, manager, admin
}

class Global {
    
    static let instance = Global()
    
    func deviceType(frameWidth: CGFloat) -> DeviceType {
        var deviceType: DeviceType = UIDevice.current.deviceType
        if (deviceType == .simulator) {
            deviceType = (frameWidth >= 500) ? .iPad : .iPhone7
        } else {
            let tmp: String = UIDevice.current.deviceType.displayName
            //print(tmp)
            if tmp.hasPrefix("iPad") {
                deviceType = .iPad
            } else {
                deviceType = .iPhone7
            }
        }
        
        return deviceType
    }
    
    func addSpinner(superView: UIView) {
        let mask: UIView = UIView()
        let spinner: UIActivityIndicatorView = UIActivityIndicatorView()
        let text: UILabel = UILabel()
        
        mask.tag = 5001
        spinner.tag = 5002
        text.tag = 5003
        
        _addMask(mask: mask, superView: superView)
        _addSpinner(spinner: spinner, superView: superView)
        _addText(text: text, superView: superView)
    }
    
    func removeSpinner(superView: UIView) {
        for subview in superView.subviews {
            if subview.tag > 5000 {
                subview.removeFromSuperview()
            }
        }
    }
    
    func setupTabbar(_ ctrl: UIViewController) {
        let tbC = ctrl.tabBarController
        //tbC!.tabBar.barTintColor = UIColor.red
        tbC!.tabBar.barTintColor = UIColor(TABBAR_BACKGROUND)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: FONT_NAME, size: FONT_SIZE_TABBAR)!], for: UIControlState.normal)
//        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: UIControlState.normal)
//        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor(MY_GREEN)], for: UIControlState.selected)
    }
    
    func menuPressedAction(_ menuBtn: UIButton, _ ctrl: UIViewController) {
        menuBtn.addTarget(ctrl.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        ctrl.view.addGestureRecognizer(ctrl.revealViewController().panGestureRecognizer())
        ctrl.view.addGestureRecognizer(ctrl.revealViewController().tapGestureRecognizer())
    }
    
    private func _addSpinner(spinner: UIActivityIndicatorView, superView: UIView) {
        spinner.center = superView.center
        spinner.activityIndicatorViewStyle = .whiteLarge
        spinner.color = #colorLiteral(red: 0.6862745098, green: 0.9882352941, blue: 0.4823529412, alpha: 1)
        spinner.startAnimating()
        superView.addSubview(spinner)
    }
    
    private func _addMask(mask: UIView, superView: UIView) {
        mask.backgroundColor = UIColor(white: 0, alpha: 0.5) //you can modify this to whatever you need
        mask.frame = CGRect(x: 0, y: 0, width: superView.frame.width, height: superView.frame.height)
        superView.addSubview(mask)
    }
    
    private func _addText(text: UILabel, superView: UIView) {
        let center: CGPoint = superView.center
        text.frame = CGRect(x: Int(center.x) - LOADING_WIDTH / 2, y: Int(center.y) + LOADING_HEIGHT / 2, width: LOADING_WIDTH, height: LOADING_HEIGHT)
        text.font = UIFont(name: "Avenir Next", size: 18)
        text.textColor = #colorLiteral(red: 0.6862745098, green: 0.9882352941, blue: 0.4823529412, alpha: 1)
        text.textAlignment = .center
        text.text = LOADING
        superView.addSubview(text)
    }
}
extension UIFont {
    func withTraits(traits:UIFontDescriptorSymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0) //size 0 means keep size as it is
    }
    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }
    
    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UserDefaults {
    func getBool(_ key: String) -> Bool {
        if isKeyPresentInUserDefaults(key: key) {
            return bool(forKey: key)
        } else {
            return false
        }
    }
    func getString(_ key: String) -> String {
        if isKeyPresentInUserDefaults(key: key) {
            return string(forKey: key)!
        } else {
            return ""
        }
    }
    func getInt(_ key: String) -> Int {
        if isKeyPresentInUserDefaults(key: key) {
            return integer(forKey: key)
        } else {
            return 0
        }
    }
    func set(_ key: String, _ value: Any) {
        set(value, forKey: key)
    }
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return object(forKey: key) != nil
    }
}

extension Date {
    init?(value: String) {
        guard !value.isEmpty else { return nil }
        let formatter = DateFormatter()
        guard let date = formatter.date(from: value) else {
            return nil
        }
        self.init(timeInterval: 0, since: date)
    }
    
    func toString(format: String = "yyyy-MM-dd") -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}











