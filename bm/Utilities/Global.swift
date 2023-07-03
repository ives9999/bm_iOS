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



class Global {
    
    static let instance = Global()
    
    let weekdays: [[String: Any]] = [
        ["value":0,"text":"星期一","simple_text":"一","checked":false],
        ["value":1,"text":"星期二","simple_text":"二","checked":false],
        ["value":2,"text":"星期三","simple_text":"三","checked":false],
        ["value":3,"text":"星期四","simple_text":"四","checked":false],
        ["value":4,"text":"星期五","simple_text":"五","checked":false],
        ["value":5,"text":"星期六","simple_text":"六","checked":false],
        ["value":6,"text":"星期日","simple_text":"日","checked":false]
    ]
    
    func today()-> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    func makeTimes(start_time: String="07:00", end_time: String="23:00", interval: Int=60)-> [String] {
        
        var allTimes: [String] = [String]()
        var s: Date? = start_time.toDateTime(format: "HH:mm")
        let e: Date? = end_time.toDateTime(format: "HH:mm")
        
        if s != nil && e != nil {
            allTimes.append(s!.toString(format: "HH:mm"))
            while s! < e! {
                s = s!.addingTimeInterval(TimeInterval(Double(interval)*60.0))
                allTimes.append(s!.toString(format: "HH:mm"))
            }
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
    
//    func setupTabbar(_ ctrl: UIViewController) {
//        let tbC = ctrl.tabBarController
//        //tbC!.tabBar.barTintColor = UIColor.red
//        if (tbC != nil) {
//            tbC!.tabBar.barTintColor = UIColor(TABBAR_BACKGROUND)
//            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: FONT_NAME, size: FONT_SIZE_TABBAR)!], for: UIControl.State.normal)
//        }
////        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: UIControlState.normal)
////        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor(MY_GREEN)], for: UIControlState.selected)
//    }
    
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
    
    func getMonthLastDay(year: Int, month: Int)->Int {
        let calendar = Calendar.current
        var comps = DateComponents(calendar: calendar, year: year, month: month)
        comps.setValue(month + 1, for: .month)
        comps.setValue(0, for: .day)
        let date = calendar.date(from: comps)
        return calendar.component(.day, from: date!)
    }
    
    func now()-> String {
        let now = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = format.string(from: now)
        
        return dateString
    }
    
    func getCitys()-> [City] {
        
        var citys: [City] = [City]()
        for zone in Zone.instance.zones {
            if zone.keyExist(key: "parent") {
                let parent: Int = zone["parent"] as! Int
                if parent == 0 {
                    var id: Int? = nil
                    var name: String? = nil
                    if zone.keyExist(key: "id") {
                        id = zone["id"] as? Int
                    }
                    if zone.keyExist(key: "name") {
                        name = zone["name"] as? String
                    }
                    if id != nil && name != nil {
                        let city: City = City(id: id!, name: name!)
                        citys.append(city)
                    }
                }
            }
        }
        
        return citys
    }
    
    func getAreasByCityID(city_id: Int)-> [Area] {
        
        var areas: [Area] = [Area]()
        for zone in Zone.instance.zones {
            if zone.keyExist(key: "parent") {
                let parent: Int = zone["parent"] as! Int
                if parent == city_id {
                    var id: Int? = nil
                    var name: String? = nil
                    if zone.keyExist(key: "id") {
                        id = zone["id"] as? Int
                    }
                    if zone.keyExist(key: "name") {
                        name = zone["name"] as? String
                    }
                    if id != nil && name != nil {
                        let area: Area = Area(id: id!, name: name!)
                        areas.append(area)
                    }
                }
            }
        }
        
        return areas
    }
    
    func zoneIDToName(_ zone_id: Int)-> String {
        var value = ""
        for zone in Zone.instance.zones {
            let id = zone["id"] as? Int
            if id == zone_id {
                value = (zone["name"] as? String)!
                break
            }
        }
        return value
    }
    
    func intsToStringComma(_ ints: [Int])-> String {
        
        var tmp: [String] = [String]()
        for val in ints {
            tmp.append(String(val))
        }
        
        return tmp.joined(separator: ",")
    }
    
    private func _addSpinner(spinner: UIActivityIndicatorView, superView: UIView) {
        spinner.center = superView.center
        spinner.style = .whiteLarge
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
    func withTraits(traits:UIFontDescriptor.SymbolicTraits) -> UIFont {
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

//extension UIApplication {
//    var statusBarView: UIView? {
//        return value(forKey: "statusBar") as? UIView
//    }
//}

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
    
    func setStatusBar(color: UIColor) {
        let tag = 12321
        if let taggedView = self.view.viewWithTag(tag){
            taggedView.removeFromSuperview()
        }
        let overView = UIView()
        overView.frame = UIApplication.shared.statusBarFrame
        overView.backgroundColor = color
        overView.tag = tag
        self.view.addSubview(overView)
    }
}

extension UserDefaults {
    
    func dump() {
        for (key, value) in self.dictionaryRepresentation() {
            print("\(key) => \(value)")
        }
    }
    
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
    
    // return is [
    //             ["id": "5", "name": "新北市"],
    //             ["id": "6", "name": "台北市"]
    //           ]
    func getArrayDictionary(_ key: String) -> [[String: String]] {
        var tmp: [[String: String]] = [[String: String]]()
        let tmp1 = object(forKey: key)
        if tmp1 != nil {
            tmp = tmp1 as? [[String: String]] ?? [[String: String]]()
        }
        
        return tmp
    }
    
    // return is [
    //             "52": [
    //                     "id": "52",
    //                     "name": ["新北市"],
    //                     "rows": [
    //                          ["id": "5", "name": "中和"],
    //                          ["id": "6", "name": "永和"]
    //                     ]
    //                  ]
    //           ]
    func getAllAreas() -> [String:[String: Any]] {
        var tmp: [String: [String: Any]] = [String: [String: Any]]()
        let key: String = "areas"
        let obj = object(forKey: key)
        //print(obj)
        if obj != nil {
            tmp = obj as! [String: [String: Any]]
        }
        
        return tmp
    }
    
    // return is [
    //             ["id": "5", "name": "中區"],
    //             ["id": "6", "name": "西區"]
    //           ]
    func getAreasByCity(_ city_id: Int) -> [[String: String]] {
        //var tmp: [[String: String]] = [[String: String]]()
        
        let tmp1 = getAllAreas()
        if let tmp = tmp1[String(city_id)]?["rows"] as? [[String: String]] {
            return tmp
        } else {
            return [[String: String]]()
        }
//        let key: String = "areas"
//        let obj = object(forKey: key)
//        if obj != nil {
//            let tmp1: [String: [String: Any]] = obj as! [String: [String: Any]]
//            for (_city_id, area) in tmp1 {
//                if city_id == Int(_city_id) {
//                    let rows = area["rows"] as! [[String: Any]]
//                    for row in rows {
//                        //print(row)
//                        let id: String = row["id"] as! String
//                        let name: String = row["name"] as! String
//                        tmp.append(["id": id, "name": name])
//                    }
//                }
//            }
//        }
        
        //return tmp
    }
    
    // return is [
    //             "52": [
    //                     "id": "52",
    //                     "name": ["新北市"],
    //                     "rows": [
    //                          ["id": "5", "name": "中和"],
    //                          ["id": "6", "name": "永和"]
    //                     ]
    //                  ]
    //           ]
    //// not test
    func getAreasByCitys(_ city_ids: [Int]) -> [String: [String: Any]] {
        
        let tmp1 = getAllAreas()
        var tmp: [String: [String: Any]] = [String: [String: Any]]()
        for (session_city_id, session_city) in tmp1 {
            for city_id in city_ids {
                if Int(session_city_id) == city_id {
                    tmp[session_city_id] = session_city
                }
            }
        }
        
        return tmp
    }
    
    
    // not complete, if area_id not in session must get from server, but not implement it.
    func getAreaByAreaID(_ area_id: Int) -> [String: String] {
        
        let tmp1 = getAllAreas()//dictionary
        var tmp: [String: String] = [String: String]()
        var bFind = false
        for (_, areas) in tmp1 {
            if areas["rows"] != nil {
                let rows = areas["rows"] as! [[String: String]]
                for row in rows {
                    for (key, _) in row {
                        let _value: String = row["id"]!
                        if key == "id" && Int(_value) == area_id {
                            bFind = true
                        }
                        if bFind {
                            tmp[key] = _value
                        }
                    }
                    if bFind {
                        break
                    }
                }
                if bFind {
                    break
                }
            }
        }
        
        return tmp
    }
    
    func set(_ key: String, _ value: Any) {
        set(value, forKey: key)
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return object(forKey: key) != nil
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

extension Array where Element: Comparable {
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
}

extension UIStackView {
    
    func addCancelBtn1()-> CancelButton {
        
        let view: CancelButton = CancelButton()
        self.addArrangedSubview(view)
        
        return view
    }
}

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter
    }()
}

extension Numeric {
    var formattedWithSeparator: String {
        Formatter.withSeparator.string(for: self)!
    }
}

protocol ArrayProtocol{}

extension Array: ArrayProtocol {
    
}

extension Mirror {

//    label=>Optional("coach_id"):value=>Optional(40):type=>Optional("Int")
//    label=>Optional("price"):value=>Optional(450):type=>Optional("Int")
//    label=>Optional("price_unit"):value=>Optional("week"):type=>Optional("String")
//    label=>Optional("price_desc"):value=>Optional("每週開課，每位學員450元"):type=>Optional("String")
    
    func toDictionary() -> [[String: Any]] {
        var dict = [[String: Any]]()

        // Properties of this instance:
        for attr in self.children {
            
            if let propertyName = attr.label {
                var res: [String: Any] = [String: Any]()
                res["label"] = propertyName as String
                res["value"] = attr.value
                res["type"] = String(describing: type(of: attr.value))
                dict.append(res)
            }
        }

        // Add properties of superclass:
        if let parent = self.superclassMirror {
            for attr in parent.children {
                
                if let propertyName = attr.label {
                    var res: [String: Any] = [String: Any]()
                    res["label"] = propertyName as String
                    res["value"] = attr.value
                    res["type"] = String(describing: type(of: attr.value))
                    dict.append(res)
                }
            }
        }

        return dict
    }
}







