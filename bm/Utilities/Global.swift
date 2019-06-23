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
var gReset: Bool = false

enum MYCOLOR: Int {
    case primary = 0x245580
    case warning = 0xF1C40F
    case info = 0x659be0
    case danger = 0xc12e2a
    case success = 0x419641
    case white = 0xe1e1e1
    
    static let allValues = [primary, warning, info, danger, success, white]
    
    init(color: String) {
        switch color {
        case "danger":
            self = .danger
        case "success":
            self = .success
        case "primary":
            self = .primary
        case "warning":
            self = .warning
        case "info":
            self = .info
        case "white":
            self = .white
        default:
            self = .success
        }
    }
    
    func toString()->String {
        switch self {
        case .danger:
            return "danger"
        case .success:
            return "success"
        case .primary:
            return "primary"
        case .warning:
            return "warning"
        case .info:
            return "info"
        case .white:
            return "white"
        }
    }
    
    func toColor()-> UIColor {
        return UIColor(rgb: self.rawValue)
    }
    
    static func all()-> [[String: Any]] {
        var res: [[String: Any]] = [[String: Any]]()
        for item in allValues {
            res.append(["key":item.toString(), "value":item,"color":item.toColor()])
        }
        
        return res
    }
}

enum WEEKDAY: Int {
    case mon = 1
    case tue = 2
    case wed = 3
    case thu = 4
    case fri = 5
    case sat = 6
    case sun = 7
    
    static let allValues = [mon, tue, wed, thu, fri, sat, sun]
    
    init(weekday: Int) {
        switch weekday {
        case 1:
            self = .mon
        case 2:
            self = .tue
        case 3:
            self = .wed
        case 4:
            self = .thu
        case 5:
            self = .fri
        case 6:
            self = .sat
        case 7:
            self = .sun
        default:
            self = .mon
        }
    }
    
    func toString()->String {
        switch self {
        case .mon:
            return "星期一"
        case .tue:
            return "星期二"
        case .wed:
            return "星期三"
        case .thu:
            return "星期四"
        case .fri:
            return "星期五"
        case .sat:
            return "星期六"
        case .sun:
            return "星期日"
        }
    }
    
    static func intToString(_ value: Int)-> String {
        switch value {
        case 1:
            return "星期一"
        case 2:
            return "星期二"
        case 3:
            return "星期三"
        case 4:
            return "星期四"
        case 5:
            return "星期五"
        case 6:
            return "星期六"
        case 7:
            return "星期日"
        default:
            return"星期一"
        }
    }
    
    static func enumToString(_ value: WEEKDAY)-> String {
    
        return WEEKDAY.intToString(value.rawValue)
    }
    
    static func makeSelect()-> [[String: String]] {
        var res: [[String: String]] = [[String: String]]()
        for key in allValues {
            res.append(["title": key.toString(), "value": String(key.rawValue)])
        }
        return res
    }
}

enum STATUS: String {
    case online = "上線"
    case offline = "下線"
    case padding = "草稿"
    case trash = "垃圾桶"
    case delete = "刪除"
    
    static let allValues = [online, offline, padding, trash, delete]
    
    init(status: String) {
        switch status {
        case "online":
            self = .online
        case "offline":
            self = .offline
        case "trash":
            self = .trash
        case "delete":
            self = .delete
        default:
            self = .online
        }
    }
    
    func toString()->String {
        switch self {
        case .online:
            return "online"
        case .offline:
            return "offline"
        case .padding:
            return "padding"
        case .trash:
            return "trash"
        case .delete:
            return "delete"
        }
    }
    
    static func all()-> [[String: Any]] {
        var res: [[String: Any]] = [[String: Any]]()
        for item in allValues {
            res.append(["key":item.toString(), "value":item, "ch":item.rawValue])
        }
        
        return res
    }
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
enum SELECT_DATE_TYPE: Int {
    case start, end
}
enum TEXT_INPUT_TYPE: String {
    case temp_play = "臨打說明"
    case charge = "收費說明"
    case content = "詳細說明"
    case exp = "經歷"
    case feat = "比賽成績"
    case license = "證照"
    case timetable_coach = "課程說明"
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

enum CYCLE_UNIT: String {
    
    case month = "月"
    case week = "週"
    
    static func enumFromString(string: String) -> CYCLE_UNIT {
        switch string {
        case "month" :
            return self.month
        case "week" :
            return self.week
        default :
            return self.month
        }
    }
    
    static func DBValue(_ cycle_unit: CYCLE_UNIT) -> String {
        var res: String = ""
        switch cycle_unit {
        case .month:
            res = "month"
            break
        case .week:
            res = "week"
            break
        }
        return res
    }
    
    static func all() -> [CYCLE_UNIT: String] {
        var cycle_units: [CYCLE_UNIT: String] = [CYCLE_UNIT: String]()
        cycle_units[CYCLE_UNIT.month] = "月"
        cycle_units[CYCLE_UNIT.week] = "週"
        return cycle_units
    }
    
    func toString()->String {
        switch self {
        case .month:
            return "month"
        case .week:
            return "week"
        }
    }
    
    static func makeSelect()-> [[String: String]] {
        var res: [[String: String]] = [[String: String]]()
        for (key, value) in all() {
            res.append(["title": value, "value": key.toString()])
        }
        return res
    }
}

enum COURSE_KIND: String {
    
    case one = "一次性"
    case cycle = "週期性"
    
    static func enumFromString(string: String) -> COURSE_KIND {
        switch string {
        case "one" :
            return self.one
        case "cycle" :
            return self.cycle
        default :
            return self.cycle
        }
    }
    
    static func DBValue(_ course_kind: COURSE_KIND) -> String {
        var res: String = ""
        switch course_kind {
        case .one:
            res = "one"
            break
        case .cycle:
            res = "cycle"
            break
        }
        return res
    }
    
    static func all() -> [COURSE_KIND: String] {
        var cours_kinds: [COURSE_KIND: String] = [COURSE_KIND: String]()
        cours_kinds[COURSE_KIND.one] = "一次性"
        cours_kinds[COURSE_KIND.cycle] = "週期性"
        return cours_kinds
    }
    
    func toString()->String {
        switch self {
        case .one:
            return "one"
        case .cycle:
            return "cycle"
        }
    }
    
    static func makeSelect()-> [[String: String]] {
        var res: [[String: String]] = [[String: String]]()
        for (key, value) in all() {
            res.append(["title": value, "value": key.toString()])
        }
        return res
    }
}

enum PRICE_UNIT: String {
    
    case month = "每月"
    case week = "每週"
    case season = "每季"
    case year = "每年"
    case span = "每期"
    case other = "其他"
    
    static func enumFromString(string: String) -> PRICE_UNIT {
        switch string {
        case "month" :
            return self.month
        case "week" :
            return self.week
        case "season" :
            return self.season
        case "year" :
            return self.year
        case "span" :
            return self.span
        case "other" :
            return self.other
        default :
            return self.month
        }
    }
    
    func toString()->String {
        switch self {
        case .week:
            return "week"
        case .month:
            return "month"
        case .season:
            return "season"
        case .year:
            return "year"
        case .span:
            return "span"
        case .other:
            return "other"
        }
    }
    
    static func DBValue(_ price_unit: PRICE_UNIT) -> String {
        var res: String = ""
        switch price_unit {
        case .month:
            res = "month"
            break
        case .week:
            res = "week"
            break
        case .season:
            res = "season"
            break
        case .year:
            res = "year"
            break
        case .span:
            res = "span"
            break
        case .other:
            res = "other"
            break
        }
        return res
    }
    
    static func all() -> [PRICE_UNIT: String] {
        var price_units: [PRICE_UNIT: String] = [PRICE_UNIT: String]()
        price_units[PRICE_UNIT.month] = "每月"
        price_units[PRICE_UNIT.week] = "每週"
        price_units[PRICE_UNIT.season] = "每季"
        price_units[PRICE_UNIT.year] = "每年"
        price_units[PRICE_UNIT.span] = "每期"
        price_units[PRICE_UNIT.other] = "其他"
        return price_units
    }
    
    static func makeSelect()-> [[String: String]] {
        var res: [[String: String]] = [[String: String]]()
        for (key, value) in all() {
            res.append(["title": value, "value": key.toString()])
        }
        return res
    }
}

let df : DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter
}()

class Global {
    
    static let instance = Global()
    
    let weekdays: [[String: Any]] = [
        ["value":1,"text":"星期一","simple_text":"一","checked":false],
        ["value":2,"text":"星期二","simple_text":"二","checked":false],
        ["value":3,"text":"星期三","simple_text":"三","checked":false],
        ["value":4,"text":"星期四","simple_text":"四","checked":false],
        ["value":5,"text":"星期五","simple_text":"五","checked":false],
        ["value":6,"text":"星期六","simple_text":"六","checked":false],
        ["value":7,"text":"星期日","simple_text":"日","checked":false]
    ]
    
    func today()-> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    func makeTimes(start_time: String="07:00", end_time: String="23:00", interval: Int=60)-> [String] {
        
        var allTimes: [String] = [String]()
        var s = start_time.toDateTime(format: "HH:mm")
        let e = end_time.toDateTime(format: "HH:mm")
        allTimes.append(s.toString(format: "HH:mm"))
        while s < e {
            s = s.addingTimeInterval(TimeInterval(Double(interval)*60.0))
            allTimes.append(s.toString(format: "HH:mm"))
        }
        
        return allTimes
    }
    
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
                //subview = nil
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
    
    func weekdaysParse(_ value: Int)-> [Int] {
        var arr: [Int] = [Int]()
        if value > 0 && value < 128 {
            for i in 0...6 {
                let two = Int(pow(Float(2), Float(i)))
                if (value & two) > 0 {
                    arr.append(i + 1)
                }
            }
        }
    
        return arr
    }
    
    func weekdaysToDBValue(_ arr: [Int])-> Int {
        var res: Int = 0
        for value in arr {
            if value >= 0 && value <= 6 {
                res = res | Int(pow(Float(2), Float(value - 1)))
            }
        }
        
        return res
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
    
    //Date()->getH()
    func getH()->Int {
        let calendar = Calendar.current
        return calendar.component(.hour, from: self)
    }
    
    func getm()->Int {
        let calendar = Calendar.current
        return calendar.component(.minute, from: self)
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
    
    func toJSONString()-> String {
        var json: String = "{"
        var tmps: [String] = [String]()
        for (key, value) in self {
            let str = "\"\(key)\":\"\(value)\""
            
            tmps.append(str)
        }
        json += tmps.joined(separator: ",")
        json += "}"
        
        return json
    }
    
    func toJSON1()-> String? {
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: self,
            options: []) {
            var theJSONText = String(data: theJSONData,
                                     encoding: .utf8)
            theJSONText = theJSONText!.replace(target: "\\", withString: "")
            return theJSONText
        }
        return nil
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
        dateFormatter.locale = Locale(identifier: "zh_TW")
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
    func noTime() -> String {
        let arr: [String] = self.components(separatedBy: " ")
        return arr[0]
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
    
    func youtube() {
        if self.count > 0 {
            var app = ""
            if self.startWith("https") {
                app = self.replace(target: "https", withString: "youtube")
            } else if self.startWith("http") {
                app = self.replace(target: "http", withString: "youtube")
            }
            let appURL = URL(string: app)!
            let webURL = URL(string: self)!
            let application = UIApplication.shared
            if application.canOpenURL(appURL) {
                application.openURL(appURL)
            } else {
                application.openURL(webURL)
            }
        }
    }
    
    func fb() {
        if self.count > 0 {
            var app = ""
            if self.startWith("https") {
                app = self.replace(target: "https", withString: "fb")
            } else if self.startWith("http") {
                app = self.replace(target: "http", withString: "fb")
            }
            let appURL = URL(string: app)!
            let webURL = URL(string: self)!
            let application = UIApplication.shared
            if application.canOpenURL(appURL) {
                application.openURL(appURL)
            } else {
                application.openURL(webURL)
            }
        }
    }
    
    func line() {
        if self.count > 0 {
            let app = "line://ti/p/@"+self
            let appURL = URL(string: app)!
            let application = UIApplication.shared
            application.openURL(appURL)
        }
    }
    
    func website() {
        if self.count > 0 {
            UIApplication.shared.openURL(URL(string: self)!)
        }
    }
    
    func email() {
        if self.count > 0 {
            let url = "mailto:\(self)"
            UIApplication.shared.openURL(URL(string: url)!)
        }
    }
    
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    var isDate: Bool {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        
        if dateFormatterGet.date(from: self) != nil {
            return true
        } else {
            return false
        }
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
    
    func replace(target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func convertHtml() -> NSAttributedString?{
        
        let htmlData = NSString(string: self).data(using: String.Encoding.unicode.rawValue)
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType:
            NSAttributedString.DocumentType.html]
        let attributedString = try? NSMutableAttributedString(data: htmlData ?? Data(),
                                                              options: options,
                                                              documentAttributes: nil)
        
        return attributedString
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
    enum Visibility {
        case visible
        case invisible
        case gone
    }
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
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    var visibility: Visibility {
        get {
            let constraint = (self.constraints.filter{$0.firstAttribute == .height && $0.constant == 0}.first)
            if let constraint = constraint, constraint.isActive {
                return .gone
            } else {
                return self.isHidden ? .invisible : .visible
            }
        }
        set {
            if self.visibility != newValue {
                self.setVisibility(newValue)
            }
        }
    }
    
    private func setVisibility(_ visibility: Visibility) {
        let constraint = (self.constraints.filter{$0.firstAttribute == .height && $0.constant == 0}.first)
        
        switch visibility {
        case .visible:
            constraint?.isActive = false
            self.isHidden = false
            break
        case .invisible:
            constraint?.isActive = false
            self.isHidden = true
            break
        case .gone:
            if let constraint = constraint {
                constraint.isActive = true
            } else {
                let constraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 0)
                self.addConstraint(constraint)
                constraint.isActive = true
            }
        }
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

protocol ArrayProtocol{}

extension Array: ArrayProtocol {}









