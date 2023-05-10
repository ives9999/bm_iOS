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
    
    func keyExist(key: String)-> Bool {
        var isExist = false
        for (idx, _) in self {
            if let key1 = idx as? String {
                if key == key1 {
                    isExist = true
                    break
                }
            }
        }
        
        return isExist
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
        
        //let c1: NSLayoutConstraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 110)
        //let c2: NSLayoutConstraint = NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: view.superview, attribute: .centerX, multiplier: 1, constant: 110)
        //view.translatesAutoresizingMaskIntoConstraints = false
        //self.addConstraints([c1])
        
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

extension UILabel {
    
    func setLineHeight(lineHeight: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {

        guard let labelText = self.text else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineHeight
        paragraphStyle.lineHeightMultiple = lineHeightMultiple

        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }

        // (Swift 4.2 and above) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))


        // (Swift 4.1 and 4.0) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

        self.attributedText = attributedString
    }
    
    func setSpecialTextColor (fullText : String , changeText : String, color: UIColor) {
        
        let strNumber: NSString = fullText as NSString
        let range = (strNumber).range(of: changeText)
        let attributedString = NSMutableAttributedString.init(string: fullText)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color
        ]
        
        attributedString.addAttributes(attributes, range: range)
        
        self.attributedText = attributedString
    }
    
    func setSpecialTextBold (fullText : String , changeText : String, ofSize: CGFloat) {
        
        let strNumber: NSString = fullText as NSString
        let range = (strNumber).range(of: changeText)
        let attributedString = NSMutableAttributedString.init(string: fullText)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: ofSize)
        ]
        
        attributedString.addAttributes(attributes, range: range)
        
        self.attributedText = attributedString
    }
    
    func setSpecialTextColorAndBold (fullText : String , changeText : String, color: UIColor, ofSize: CGFloat) {
        
        let strNumber: NSString = fullText as NSString
        let range = (strNumber).range(of: changeText)
        let attributedString = NSMutableAttributedString.init(string: fullText)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color,
            .font: UIFont.boldSystemFont(ofSize: ofSize)
        ]
        
        attributedString.addAttributes(attributes, range: range)
        
        self.attributedText = attributedString
    }
}

protocol ArrayProtocol{}

extension Array: ArrayProtocol {
    
}

protocol DropDownTextFieldDelegate {
    func menuDidAnimate(up: Bool)
    func optionSelected(option: String)
}

class DropDownTextField: UIView {
    
    //public properties
    var boldColor = UIColor.black
    var lightColor = UIColor.white
    var dropDownColor = UIColor.gray
    var font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    
    var delegate: DropDownTextFieldDelegate?
    private var isDroppedDown = false
    
    //private properties
    private var options: [String]
    private var initialHeight: CGFloat = 0
    private let rowHeight: CGFloat = 40
    
    //UI properties
    var underline = UIView()
    
    let triangleIndicator: UIImageView = {
        let image = UIImage.Theme.triangle.image
        image.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let tapView: UIView = UIView()
    
    lazy var tableView: UITableView = {
        
        let tableView = UITableView()
        tableView.bounces = false
        tableView.backgroundColor = UIColor.clear
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.separatorColor = lightColor
        
        return tableView
    }()
    
    let animationView = UIView()
    
//    class TextField: UITextField {
//
//        let padding = UIEdgeInsets(top: 12.0, left: 8.0, bottom: 12.0, right: 0)
//
//        override func textRect(forBounds bounds: CGRect) -> CGRect {
//            return UIEdgeInsetsInsetRect(bounds, padding)
//        }
//
//        override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
//            return UIEdgeInsetsInsetRect(bounds, padding)
//        }
//
//        override func editingRect(forBounds bounds: CGRect) -> CGRect {
//            return UIEdgeInsetsInsetRect(bounds, padding)
//        }
//    }
    
    lazy var textField: SuperTextField = {
        
        let textField = SuperTextField(frame: .zero)
        //let textField = TextField(frame: .zero)
        //textField.textColor = UIColor.white
        textField.autocapitalizationType = .sentences
        textField.returnKeyType = .done
        //textField.keyboardType = .alphabet
        //textField.layer.borderColor = UIColor.gray.cgColor
        //textField.layer.borderWidth = 1.0
        
        return textField
    }()
    
    init(frame: CGRect, title: String, options: [String]) {
        self.options = options
        super.init(frame: frame)
        self.textField.text = title
        calculateHeight()
        setupViews()
        //self.backgroundColor = UIColor.gray
    }
    
    private override init(frame: CGRect) {
        
        options = []
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func animateMenu() {
        menuAnimate(up: isDroppedDown)
    }
}

extension DropDownTextField {
    
    public func setOptions(_ newOptions: [String]) {
        self.options = newOptions
        //tableView.heightConstraint?.constant = 300
        //print(tableView.contentSize.height)
        tableView.visibility = UIView.Visibility.visible
        //let frame = tableView.frame
        //tableView.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: 300)
        //print(tableView.frame)
        self.tableView.reloadData()
        self.menuAnimate(up: false)
    }
    
    private func calculateHeight() {
        
        self.initialHeight = self.bounds.height
        let rowCount = self.options.count
        let newHeight = self.initialHeight + (CGFloat(rowCount) * rowHeight)
        self.frame.size = CGSize(width: self.frame.width, height: newHeight)
    }
    
    private func setupViews() {
        
        removeSubviews()
        //addUnderline()
        addTriangleIndicator()
        addTextField()
        //addTapView()
        addTableView()
        addAnimationView()
    }
    
    private func removeSubviews() {
        
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
    
    private func addUnderline() {
        
        addSubview(underline)
        underline.backgroundColor = UIColor.green
        
        underline.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            underline.topAnchor.constraint(equalTo: topAnchor, constant: initialHeight - 2),
            underline.leadingAnchor.constraint(equalTo: leadingAnchor),
            underline.trailingAnchor.constraint(equalTo: trailingAnchor),
            underline.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
    
    private func addTriangleIndicator() {
        triangleIndicator.translatesAutoresizingMaskIntoConstraints = false
        triangleIndicator.tintColor = boldColor
        addSubview(triangleIndicator)
        let triSize: CGFloat = 12.0
        NSLayoutConstraint.activate([
            triangleIndicator.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            triangleIndicator.trailingAnchor.constraint(equalTo: trailingAnchor),
            triangleIndicator.heightAnchor.constraint(equalToConstant: triSize),
            triangleIndicator.widthAnchor.constraint(equalToConstant: triSize),
            //triangleIndicator.centerYAnchor.constraint(equalTo: topAnchor, constant: initialHeight / 2)
        ])
    }
    
    private func addTextField() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            //textField.centerYAnchor.constraint(equalTo: topAnchor, constant: initialHeight / 2),
            textField.trailingAnchor.constraint(equalTo: triangleIndicator.leadingAnchor, constant: -8),
            textField.heightAnchor.constraint(equalToConstant: 40)
        ])
        textField.font = self.font
    }
    
    private func addTapView() {
        
        tapView.translatesAutoresizingMaskIntoConstraints = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(animateMenu))
        tapView.addGestureRecognizer(tapGesture)
        tapView.backgroundColor = UIColor.red
        addSubview(tapView)
        //tapView.constraintsPinTo(leading: leadingAnchor, trailing: trailingAnchor, top: topAnchor, bottom: underline.bottomAnchor)
        tapView.constraintsPinTo(leading: leadingAnchor, trailing: trailingAnchor, top: underline.bottomAnchor, bottom: bottomAnchor)
    }
    
    private func addTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.green
        
        self.addSubview(tableView)
        //tableView.constraintsPinTo(leading: leadingAnchor, trailing: trailingAnchor, top: textField.bottomAnchor, bottom: bottomAnchor)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        tableView.isHidden = true
    }
    
    private func addAnimationView() {
        
        self.addSubview(animationView)
        animationView.frame = CGRect(x: 0.0, y: initialHeight, width: bounds.width, height: bounds.height - initialHeight)
        //animationView.frame = CGRect(x: 0.0, y: initialHeight, width: bounds.width, height: 0)
        self.sendSubviewToBack(animationView)
        //animationView.backgroundColor = dropDownColor
        animationView.backgroundColor = UIColor.red
        animationView.isHidden = true
    }
    
    private func menuAnimate(up: Bool) {
        
        let downFrame = animationView.frame
        let upFrame = CGRect(x: 0, y: self.initialHeight, width: self.bounds.width, height: 0)
        animationView.frame = up ? downFrame : upFrame
        animationView.isHidden = false
        tableView.isHidden = true
        
        UIView.animate(withDuration: 5, delay: 0.0, options: .curveEaseInOut, animations: {
            self.animationView.frame = up ? upFrame : downFrame
        }, completion: { (Bool) in
            self.isDroppedDown = !self.isDroppedDown
            self.animationView.isHidden = up
            self.animationView.frame = downFrame
            self.tableView.isHidden = up
            self.delegate?.menuDidAnimate(up: up)
        })
    }
}

extension DropDownTextField: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(options.count)
        return options.count
        //return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "option") as? DropDownCell ?? DropDownCell()
        cell.lightColor = self.lightColor
        cell.cellFont = font
        let title = indexPath.row < options.count ? options[indexPath.row] : "Other"
        cell.configreCell(with: title)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return tableView.frame.height / CGFloat(options.count)
        return 40
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == options.count {
            //otherChosen()
        } else {
            let chosen = options[indexPath.row]
            textField.text = chosen
            self.delegate?.optionSelected(option: chosen)
            animateMenu()
        }
    }
}

class DropDownCell: UITableViewCell {
    var lightColor = UIColor.lightGray
    var cellFont: UIFont = UIFont.systemFont(ofSize: 18, weight: .semibold)
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configreCell(with title: String) {
        
        self.selectionStyle = .none
        self.textLabel?.font = cellFont
        self.textLabel?.textColor = self.lightColor
        self.backgroundColor = UIColor.clear
        self.textLabel?.text = title
    }
}

extension String {
    
    func getTypeOfProperty()-> String? {
        var res: String = ""
        if
            self == PropertyTypes.OptionalInt.rawValue ||
            self == PropertyTypes.SwiftInt.rawValue ||
            self == PropertyTypes.Int.rawValue {
                res = PropertyTypes.Int.rawValue
        } else if
            self == PropertyTypes.OptionalString.rawValue ||
            self == PropertyTypes.SwiftString.rawValue ||
            self == PropertyTypes.String.rawValue {
                res = PropertyTypes.String.rawValue
        } else if
            self == PropertyTypes.OptionalBool.rawValue ||
            self == PropertyTypes.SwiftBool.rawValue ||
            self == PropertyTypes.Bool.rawValue {
                res = PropertyTypes.Bool.rawValue
        }
        return res
    }
    
    //Property Type Comparison
//    func propertyIsOfType(typeString: String, type: PropertyTypes)-> Bool {
//        if getTypeOfProperty(propertyName) == type.rawValue {
//            return true
//        }
//
//        return false
//    }
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

extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        print(prettyPrintedString)

        return prettyPrintedString
    }
}








