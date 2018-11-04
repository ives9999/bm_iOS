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
enum TEXT_INPUT_TYPE: String {
    case temp_play = "臨打說明"
    case charge = "收費說明"
    case team = "球隊詳細說明"
    case exp = "經歷"
    case feat = "比賽成績"
    case license = "證照"
    case coach = "教練詳細說明"
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
    static func all() -> [DEGREE: String] {
        var degrees: [DEGREE: String] = [DEGREE: String]()
        degrees[DEGREE.new] = "新手"
        degrees[DEGREE.soso] = "普通"
        degrees[DEGREE.high] = "高手"
        return degrees
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
        ["value":1,"text":"星期一","simple_text":"一","checked":false],
        ["value":2,"text":"星期二","simple_text":"二","checked":false],
        ["value":3,"text":"星期三","simple_text":"三","checked":false],
        ["value":4,"text":"星期四","simple_text":"四","checked":false],
        ["value":5,"text":"星期五","simple_text":"五","checked":false],
        ["value":6,"text":"星期六","simple_text":"六","checked":false],
        ["value":7,"text":"星期日","simple_text":"日","checked":false]
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
    func noSec() -> String {
        let arr: [String] = self.components(separatedBy: ":")
        var res: String = self
        if arr.count > 2 {
            res = "\(arr[0]):\(arr[1])"
        }
        return res
    }
    func makeCall() {
        let formatedNumber = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        let phoneUrl: String = "tel://\(formatedNumber)"
        if let url: URL = URL(string: phoneUrl) {
            if UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        
    }
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    func indexDistance(of character: Character) -> Int? {
        guard let index = index(of: character) else { return nil }
        return distance(from: startIndex, to: index)
    }
    func substring(from idx: Int) -> String {
        if self.count > idx {
            let startIndex = self.index(self.startIndex, offsetBy: idx)
            let res = self[startIndex ..< self.endIndex]
            return String(res)
        } else {
            return self
        }
    }
    func substring(from range: NSRange) -> String {
        let lowBound = range.lowerBound
        let upperBound = range.upperBound
        //print("\(lowBound), \(upperBound)")
        let start = index(startIndex, offsetBy: lowBound)
        let end = index(startIndex, offsetBy: upperBound)
        let substring = self[start ..< end]
        return String(substring)
    }
    func substring(from range: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(endIndex, offsetBy: range.upperBound)
        let substring = self[start ..< end]
        return String(substring)
    }
    func reMatches(for pattern: String, str _str: String?=nil) -> [String] {
        var str = _str
        if (str == nil) {
            str = self
        }
        do {
            let re = try NSRegularExpression(pattern: pattern, options: [])
            let nsstr = str! as NSString
            let all = NSRange(location: 0, length: nsstr.length)
            var matches: [String] = [String]()
            re.enumerateMatches(in: str!, options:NSRegularExpression.MatchingOptions(rawValue: 0), range: all) { (match, _, stop) in
                for n in 0 ..< match!.numberOfRanges {
                    let range = match!.range(at: n)
                    let substring = str!.substring(from: range)
                    matches.append(String(substring))
                }
                
            }
            return matches
            //re.matches(in: self, options: [], range: NSRange(self.startIndex..., in: self))
            
//            return matches.map {
//                String(self[Range($0.range, in: self)!])
//            }
        } catch let e {
            print("invalid regex: \(e.localizedDescription)")
            return []
        }
    }
    func mobileShow() -> String {
        var res = self
        res = res.replacingOccurrences(of: " ", with: "")
        res = res.replacingOccurrences(of: "-", with: "")
        let pattern = "^(09\\d\\d)\\-?(\\d\\d\\d)\\-?(\\d\\d\\d)$";
        let matches = reMatches(for: pattern, str: res)
        //print(res)
        var mobile = self
        if matches.count > 3 {
            mobile = matches[1] + "-" + matches[2] + "-" + matches[3]
        }
        return mobile
    }
    func telShow() -> String {
        var res = self
        res = res.replacingOccurrences(of: " ", with: "")
        res = res.replacingOccurrences(of: "-", with: "")
        let pattern = "^(0\\d)\\-?(\\d\\d\\d\\d)\\-?(\\d\\d\\d\\d?)$";
        let matches = reMatches(for: pattern, str: res)
        //print(res)
        var tel = self
        if matches.count > 3 {
            tel = matches[1] + "-" + matches[2] + "-" + matches[3]
        }
        return tel
    }
    func telOrMobileShow()-> String {
        if (self.hasPrefix("09")) {
            return self.mobileShow()
        }
        if (self.hasPrefix("0")) {
            return self.telShow()
        }
        return self
    }
    func startWith(_ prefix: String)-> Bool {
        return hasPrefix(prefix)
    }
    
    func height(font: UIFont)-> CGFloat {
        let fontAttr = [NSAttributedStringKey.font: font]
        let size = (self as NSString).size(withAttributes: fontAttr)
        return size.height
    }
    
//    func substring(_ range: CountableRange<Int>) -> String {
//        let idx1 = index(startIndex, offsetBy: max(0, range.lowerBound))
//        let idx2 = index(startIndex, offsetBy: min(self.count, range.upperBound))
//        return String(self[idx1..<idx2])
//    }
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
                pattern = "H:|[\(key)]-30-|"
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









