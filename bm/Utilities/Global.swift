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
    
    static func enumFromString(string: String) -> SEX {
        switch string {
        case "M" :
            return self.M
        case "F" :
            return self.F
        default :
            return self.M
        }
    }
    static func all() -> [[String: String]] {
        return [
            ["key": "M","value": "先生"],
            ["key": "F", "value": "小姐"]
        ]
    }
}
enum MEMBER_ROLE: String {
    case member, sale, designer, manager, admin
}
enum SELECT_TIME_TYPE: Int {
    case play_start, play_end
}
enum TEXT_INPUT_TYPE: Int {
    case temp_play, charge, team
}
enum DEGREE: String {
    case new = "新手"
    case soso = "普通"
    case high = "高手"
    
    static func enumFromString(string: String) -> DEGREE {
        switch string {
        case "new" :
            return self.new
        case "soso" :
            return self.soso
        case "high":
            return self.high
        default :
            return self.high
        }
    }
    static func DBValue(_ degree: DEGREE) -> String {
        var res: String = ""
        switch degree {
        case .new:
            res = "new"
            break
        case .soso:
            res = "soso"
            break
        case .high:
            res = "high"
            break
        }
        return res
    }
    static func all() -> [[String: String]] {
        return [
            ["new": "新手"], ["soso": "普通"], ["high": "高手"]
        ]
    }
}
let df : DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter
}()

class Global {
    
    static let instance = Global()
    
    let days: [[String: Any]] = [
        ["value": 1, "text": "星期一", "checked": false],
        ["value": 2, "text": "星期二", "checked": false],
        ["value": 3, "text": "星期三", "checked": false],
        ["value": 4, "text": "星期四", "checked": false],
        ["value": 5, "text": "星期五", "checked": false],
        ["value": 6, "text": "星期六", "checked": false],
        ["value": 7, "text": "星期日", "checked": false]
    ]
    
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
    
    func noSec(_ time: String) -> String {
        let arr: [String] = time.components(separatedBy: ":")
        var res: String = time
        if arr.count > 2 {
            res = "\(arr[0]):\(arr[1])"
        }
        return res
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
    
    func getSelf() -> UIViewController {
        return self
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
    /*
    init?(value: String) {
        guard !value.isEmpty else { return nil }
        let formatter = DateFormatter()
        //formatter.dateFormat = format
        guard let date = formatter.date(from: value) else {
            return nil
        }
        self.init(timeInterval: 0, since: date)
    }
 
 */
    func toString(format: String = "yyyy-MM-dd") -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

extension CGRect {
    func setWidth(_ width: CGFloat) -> CGRect {
        return CGRect(x: self.origin.x, y: self.origin.y, width: width, height: self.size.height)
    }
    func setX(_ x: CGFloat) -> CGRect {
        return CGRect(x: x, y: self.origin.y, width: self.size.width, height: self.size.height)
    }
}

extension Dictionary {
    mutating func merge(_ other: Dictionary) {
        for (key, value) in other {
            self.updateValue(value, forKey: key)
        }
    }
}

extension String {
    /**
     Truncates the string to the specified length number of characters and appends an optional trailing string if longer.
     
     - Parameter length: A `String`.
     - Parameter trailing: A `String` that will be appended after the truncation.
     
     - Returns: A `String` object.
     */
    func truncate(length: Int, trailing: String = "…") -> String {
        if self.count > length {
            return String(self.prefix(length)) + trailing
        } else {
            return self
        }
    }
    func toDateTime(format: String = "yyyy-MM-dd HH:mm:ss") -> Date
    {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        
        //Specify Format of String to Parse
        dateFormatter.dateFormat = format
        
        //Parse into NSDate
        let dateFromString : Date = dateFormatter.date(from: self)!
        
        //Return Parsed Date
        return dateFromString
    }
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}

extension Array where Element: Comparable {
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
}

extension UIView {
    func tempPlayShowTableConstraint(_ items:[[String: UILabel]]) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
        var views: [String: UILabel] = [String: UILabel]()
        for item in items {
            for (key, value) in item {
                views[key] = value
            }
        }
        if  items.count > 0 {
            let item: [String: UILabel] = items[0]
            var pattern: String = ""
            for (key, value) in item {
                pattern = "H:|-30-[\(key)]"
                let c2: NSLayoutConstraint = NSLayoutConstraint(item: value, attribute: .centerY, relatedBy: .equal, toItem: value.superview, attribute: .centerY, multiplier:
                    1, constant: 0)
                constraints.append(c2)
                value.translatesAutoresizingMaskIntoConstraints = false
            }
            if pattern.count > 0 {
                let c1: [NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: pattern, options: .alignAllCenterY, metrics: nil, views: views)
                constraints += c1
            }
        }
        if items.count > 1 {
            let item: [String: UILabel] = items[1]
            var pattern: String = ""
            for (key, value) in item {
                pattern = "H:[\(key)]-30-|"
                let c2: NSLayoutConstraint = NSLayoutConstraint(item: value, attribute: .centerY, relatedBy: .equal, toItem: value.superview, attribute: .centerY, multiplier:
                    1, constant: 0)
                constraints.append(c2)
                value.translatesAutoresizingMaskIntoConstraints = false
            }
            if pattern.count > 0 {
                let c1: [NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: pattern, options: .alignAllCenterY, metrics: nil, views: views)
                constraints += c1
            }
        }
        
        return constraints
    }
}









