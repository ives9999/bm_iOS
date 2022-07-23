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

enum MYERROR: Int {
    case NONETWORK = 1
    case NOERROR = 100
    
    func toString()-> String {
        switch self {
        case .NONETWORK:
            return "無法連到網路，請檢查您的網路設定"
        case .NOERROR:
            return "沒有錯誤"
        }
    }
}

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
    
    func toShortString()->String {
        switch self {
        case .mon:
            return "一"
        case .tue:
            return "二"
        case .wed:
            return "三"
        case .thu:
            return "四"
        case .fri:
            return "五"
        case .sat:
            return "六"
        case .sun:
            return "日"
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

enum TAB: String {
    case tempPlay = "臨打"
    case course = "課程"
    case member = "會員"
    case team = "球隊"
    case more = "更多"
    
    static func idxToController(_ idx: Int, tabBarController: UITabBarController)-> BaseViewController {
        
        switch idx {
        case 0:
            return tabBarController.selectedViewController as! SearchVC
        case 1:
            return tabBarController.selectedViewController as! CourseVC
        case 2:
            return tabBarController.selectedViewController as! MemberVC
        case 3:
            return tabBarController.selectedViewController as! TeamVC
        case 4:
            return tabBarController.selectedViewController as! MoreVC
        default:
            return tabBarController.selectedViewController as! SearchVC
        }
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

enum MEMBER_COIN_IN_TYPE: String {
    
    case buy = "購買"
    case gift = "贈品"
    case none = "無"
    
    static func enumFromString(_ value: String) -> MEMBER_COIN_IN_TYPE {
        
        switch value {
        case "buy" :
            return .buy
        case "gift":
            return .gift
        case "none":
            return .none
        default:
            return .none
        }
    }
    
    static func DBValue(_ member_coin_in_type: MEMBER_COIN_IN_TYPE) -> String {
        
        switch member_coin_in_type {
        case .buy:
            return "購買"
        case .gift:
            return "贈品"
        case .none:
            return "無"
        }
    }
}

enum MEMBER_COIN_OUT_TYPE: String {
    
    case product = "商品"
    case course = "課程"
    case none = "無"
    
    static func enumFromString(_ value: String) -> MEMBER_COIN_OUT_TYPE {
        
        switch value {
        case "product" :
            return .product
        case "course":
            return .course
        case "none":
            return .none
        default :
            return .none
        }
    }
    
    static func DBValue(_ member_coin: MEMBER_COIN_OUT_TYPE) -> String {
        
        switch member_coin {
        case .product:
            return "商品"
        case .course:
            return "課程"
        case .none:
            return "無"
        }
    }
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
    case new = "新手"//新手 是 rawValue
    case soso = "普通"
    case high = "高手"
    
    static func enumFromString(string: String) -> DEGREE {
        switch string {
        case "new" :
            return .new
        case "soso" :
            return .soso
        case "high":
            return .high
        default :
            return .high
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

enum ORDER_PROCESS: String {
    case normal = "訂單成立"
    case gateway = "完成付款"
    case shipping = "出貨中"
    case store = "送達超商"
    case complete = "完成取貨"
    case returning = "商品退回中"
    case `return` = "商品已退回"
    case gateway_fail = "付款失敗"
    
    func enumToString()-> String {
        switch self {
        case .normal:
            return "normal"
        case .gateway:
            return "gateway"
        case .shipping:
            return "shipping"
        case .store:
            return "store"
        case .complete:
            return "complete"
        case .returning:
            return "returning"
        case .return:
            return "return"
        case .gateway_fail:
            return "gateway_fail"
        }
    }
    
    static func stringToEnum(_ enumString: String) -> ORDER_PROCESS {
        switch enumString {
        case "normal":
            return .normal
        case "gateway":
            return .gateway
        case "shipping":
            return .shipping
        case "store":
            return .store
        case "complete":
            return .complete
        case "returning":
            return .returning
        case "return":
            return .return
        case "gateway_fail":
            return .gateway_fail
        default:
            return .normal
        }
    }
    
    static func getRawValueFromString(_ string: String)-> String {
        let res: ORDER_PROCESS = stringToEnum(string)
        return res.rawValue
    }
}

enum ALL_PROCESS: String {
    case notexist = "不存在"
    case normal = "訂單成立"
    case gateway_on = "付款中"
    case gateway_off = "完成付款，準備出貨"
    case shipping = "準備出貨"
    case store = "商品到達便利商店"
    case complete = "完成取貨"
    case returning = "商品退回中"
    case `return` = "商品已退回"
    case gateway_fail = "付款失敗"
    
    func enumToString()-> String {
        switch self {
        case .notexist:
            return "notexist"
        case .normal:
            return "normal"
        case .gateway_on:
            return "gateway_on"
        case .gateway_off:
            return "gateway_off"
        case .shipping:
            return "shipping"
        case .store:
            return "store"
        case .complete:
            return "complete"
        case .returning:
            return "returning"
        case .return:
            return "return"
        case .gateway_fail:
            return "gateway_fail"
        }
    }
    
    static func intToEnum(_ enumInt: Int) -> ALL_PROCESS {
        switch enumInt {
        case 0:
            return .notexist
        case 1:
            return .normal
        case 2:
            return .gateway_on
        case 3:
            return .gateway_off
        case 4:
            return .shipping
        case 5:
            return .store
        case 6:
            return .complete
        case 7:
            return .returning
        case 8:
            return .return
        case 9:
            return .gateway_fail
        default:
            return .normal
        }
    }

//    static func getRawValueFromInt(_ int: Int)-> String {
//        let res: ALL_PROCESS = stringToEnum(string)
//        return res.rawValue
//    }
}

enum GATEWAY: String {
    
    case credit_card = "信用卡"
    case store_cvs = "超商代碼"
    case store_barcode = "超商條碼"
    case store_pay_711 = "7-11超商取貨付款"
    case store_pay_family = "全家超商取貨付款"
    case ATM = "虛擬帳戶"
    case remit = "匯款"
    case cash = "現金"
    case coin = "解碼點數"
    
    static func stringToEnum(_ enumString: String) -> GATEWAY {
        switch enumString {
        case "credit_card":
            return .credit_card
        case "store_cvs":
            return .store_cvs
        case "store_barcode":
            return .store_barcode
        case "store_pay_711":
            return .store_pay_711
        case "store_pay_family":
            return .store_pay_family
        case "ATM":
            return .ATM
        case "remit":
            return .remit
        case "cash":
            return .cash
        case "coin":
            return .coin
        default:
            return .credit_card
        }
    }
    
    static func getRawValueFromString(_ string: String)-> String {
        let res: GATEWAY = stringToEnum(string)
        return res.rawValue
    }
    
    func enumToECPay()-> String {
        switch self {
        case .store_pay_711:
            return "UNIMARTC2C"
        case .store_pay_family:
            return "FAMIC2C"
//        case .store_hilife
//            return "HILIFEC2C"
        default:
            return "UNIMARTC2C"
        }
    }
}

enum SHIPPING_WAY: String {
    
    case direct = "宅配"
    case store_711 = "7-11超商取貨"
    case store_family = "全家超商取貨"
    case cash = "面交"
    
    static func stringToEnum(_ enumString: String) -> SHIPPING_WAY {
        switch enumString {
        case "direct":
            return .direct
        case "store_711":
            return .store_711
        case "store_family":
            return .store_family
        case "cash":
            return .cash
        default:
            return .direct
        }
    }
    
    static func getRawValueFromString(_ string: String)-> String {
        let res: SHIPPING_WAY = stringToEnum(string)
        return res.rawValue
    }
}

enum GATEWAY_PROCESS: String {
    
    case normal = "未付款"    //未付款，就是這個normal的 raw value
    case code = "取得付款代碼"
    case complete = "完成付款"
    case fail = "付款失敗"
    case `return` = "完成退款"
    
    static func stringToEnum(_ enumString: String) -> GATEWAY_PROCESS {
        switch enumString {
        case "normal":
            return .normal
        case "code":
            return .code
        case "complete":
            return .complete
        case "fail":
            return .fail
        case "return":
            return .return
        default:
            return .normal
        }
    }
    
    func enumToString()-> String {
        switch self {
        case .normal:
            return "normal"
        case .code:
            return "code"
        case .complete:
            return "complete"
        case .fail:
            return "fail"
        case .return:
            return "return"
        }
    }
    
    static func getRawValueFromString(_ string: String)-> String {
        let res: GATEWAY_PROCESS = stringToEnum(string)
        return res.rawValue
    }
}

enum SHIPPING_PROCESS: String {
    case normal = "準備中"
    case shipping = "已經出貨"
    case store = "商品已到便利商店"
    case complete = "已完成取貨"
    case `return` = "貨物退回"
    
    func enumToString()-> String {
        switch self {
        case .normal:
            return "normal"
        case .shipping:
            return "shipping"
        case .store:
            return "store"
        case .complete:
            return "complete"
        case .return:
            return "back"
        }
    }
    
    static func stringToEnum(_ enumString: String) -> SHIPPING_PROCESS {
        switch enumString {
        case "normal":
            return .normal
        case "shipping":
            return .shipping
        case "store":
            return .store
        case "complete":
            return .complete
        case "back":
            return .return
        default:
            return .normal
        }
    }
    
    static func getRawValueFromString(_ string: String)-> String {
        let res: SHIPPING_PROCESS = stringToEnum(string)
        return res.rawValue
    }
}

enum KEYBOARD: String {
    
    case `default` = "default"
    case emailAddress = "emailAddress"
    case numberPad = "numberPad"
    case URL = "URL"
    
    static func stringToSwift(_ str: String)-> UIKeyboardType {
        switch str {
        case "default":
            return UIKeyboardType.default
        case "emailAddress":
            return UIKeyboardType.emailAddress
        case "numberPad":
            return UIKeyboardType.numberPad
        case "URL":
            return UIKeyboardType.URL
        default:
            return UIKeyboardType.default
        }
    }
    
    func enumToSwift()-> UIKeyboardType {
        switch self {
        case .default:
            return UIKeyboardType.default
        case .emailAddress:
            return UIKeyboardType.emailAddress
        case .numberPad:
            return UIKeyboardType.numberPad
        case .URL:
            return UIKeyboardType.URL
        }
    }
}

enum SIGNUP_STATUS: String {
    case normal = "報名"
    case standby = "候補"
    case cancel = "取消"
    
    static let allValues = [normal, standby, cancel]
    
    init(status: String) {
        switch status {
        case "normal":
            self = .normal
        case "standby":
            self = .standby
        case "cancel":
            self = .cancel
        default:
            self = .normal
        }
    }
    
    func toString()->String {
        switch self {
        case .normal:
            return "normal"
        case .standby:
            return "standby"
        case .cancel:
            return "cancel"
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

let df : DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter
}()

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
    
    func getY()->Int {
        let calendar = Calendar.current
        return calendar.component(.year, from: self)
    }
    
    func getm()->Int {
        let calendar = Calendar.current
        return calendar.component(.month, from: self)
    }
    
    func getd()->Int {
        let calendar = Calendar.current
        return calendar.component(.day, from: self)
    }
    
    func getH()->Int {
        let calendar = Calendar.current
        return calendar.component(.hour, from: self)
    }
    
    func geti()->Int {
        let calendar = Calendar.current
        return calendar.component(.minute, from: self)
    }
    
    func gets()->Int {
        let calendar = Calendar.current
        return calendar.component(.second, from: self)
    }
    
    func dateToWeekday()-> Int {
        let dc: DateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: self)
        var weekday = dc.weekday! - 1
        if weekday == 0 {
            weekday = 7
        }
        return weekday
    }
    
    func dateToWeekdayForChinese()-> String {
        let weekday = dateToWeekday()
        var res: String = "一"
        if weekday == 1 {
            res = "一"
        } else if weekday == 2 {
            res = "二"
        } else if weekday == 3 {
            res = "三"
        } else if weekday == 4 {
            res = "四"
        } else if weekday == 5 {
            res = "五"
        } else if weekday == 6 {
            res = "六"
        } else if weekday == 7 {
            res = "日"
        }
        
        return res
    }
    
    func startOfMonth(_ _y: Int?=nil, _ _m: Int?=nil) -> Date {
        let y = _y==nil ? Date().getY() : _y
        let m = _m==nil ? Date().getm() : _m
        let d = 1
        
        let dateString: String = "\(y!)-\(m!)-\(d)"
        var res: Date = Date()
        if let tmp: Date = dateString.toDateTime(format: "yyyy-MM-dd") {
            res = tmp
        }
        return res
    }
    
    func endOfMonth(_ _y: Int?=nil, _ _m: Int?=nil)-> Date {
        let y = _y==nil ? Date().getY() : _y
        let m = _m==nil ? Date().getm() : _m
        let date = Date().startOfMonth(y!, m!)
        let components:NSDateComponents = Calendar.current.dateComponents([.year, .month], from: date) as NSDateComponents
        //let y1 = components.year
        //let m1 = components.month
        
        components.month += 1
        components.day = 1
        components.day -= 1
        return Calendar.current.date(from: components as DateComponents)!
    }
    
    func getMonthDays(_ _y: Int?=nil, _ _m: Int?=nil)-> Int {
        let y = _y==nil ? Date().getY() : _y
        let m = _m==nil ? Date().getm() : _m
        
        let date = endOfMonth(y!, m!)
        
        return date.getd()
    }
    
    func isEqualTo(_ date: Date) -> Bool {
        return self == date
    }
      
    func isGreaterThan(_ date: Date) -> Bool {
        return self > date
    }
      
    func isSmallerThan(_ date: Date) -> Bool {
       return self < date
    }
    
    func myNow(format: String =  "yyyy-MM-dd HH:mm:ss", locale: Bool = false) -> Date {
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_Hant_TW")
        formatter.setLocalizedDateFormatFromTemplate(format)
        
        let tmp: String = formatter.string(from: self)
        var now: Date = Date()
        
        if format == "yyyy-MM-dd HH:mm:ss" {
            if let tmp1: Date = tmp.toDateTime(format: format, locale: locale) {
                now = tmp1
            }
        }
        
        return now
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
    
//    func toDate(format: String = "yyyy-MM-dd", locale: Bool = true) -> Date? {
//        //Create Date Formatter
//        let dateFormatter = DateFormatter()
//        if locale {
//            dateFormatter.locale = Locale(identifier: "zh_TW")
//        }
//        //Specify Format of String to Parse
//        dateFormatter.dateFormat = format
//
//        //Parse into NSDate
//        let dateFromString: Date? = dateFormatter.date(from: self)
//
//        //Return Parsed Date
//        return dateFromString
//    }
    
    func toDateTime(format: String = "yyyy-MM-dd HH:mm:ss", locale: Bool = true) -> Date? {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone.current
//        dateFormatter.locale = Locale.current
        if locale {
            dateFormatter.locale = Locale(identifier: "zh_TW")
        } else {
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        }
        //Specify Format of String to Parse
        dateFormatter.dateFormat = format
        
        //Parse into NSDate
        let dateFromString : Date? = dateFormatter.date(from: self)
        
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
    
    func noYear() -> String {
        let arr: [String] = self.components(separatedBy: "-")
        var res: String = self
        if arr.count > 2 {
            res = "\(arr[1])-\(arr[2])"
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
                application.open(appURL, options: [:], completionHandler: nil)
            } else {
                application.open(webURL, options: [:], completionHandler: nil)
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
                application.open(appURL, options: [:], completionHandler: nil)
            } else {
                application.open(webURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    func line() {
        if self.count > 0 {
            let app = "line://ti/p/@"+self
            let appURL = URL(string: app)!
            let application = UIApplication.shared
            application.open(appURL, options: [:], completionHandler: nil)
        }
    }
    
    func website() {
        if self.count > 0 {
            UIApplication.shared.open(URL(string: self)!, options: [:], completionHandler: nil)
        }
    }
    
    func email() {
        if self.count > 0 {
            let url = "mailto:\(self)"
            UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
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
    
    var isDateTime: Bool {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
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
        let fontAttr = [NSAttributedString.Key.font: font]
        let size = (self as NSString).size(withAttributes: fontAttr)
        return size.height
    }
    
    func replace(target: String, withString: String) -> String {
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
    
    func mask()-> UIView {
        
        let maskView: UIView = UIView()
        maskView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        maskView.backgroundColor = UIColor(hex: "#888888", alpha: 0.9)
        self.addSubview(maskView)
        
        return maskView
    }
    
    func unmask() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
        self.removeFromSuperview()

    }
    
    func blackView(left: CGFloat, top: CGFloat, width: CGFloat, height: CGFloat)-> UIView {
        let view: UIView = UIView()
        
//        let parent_width: CGFloat = self.frame.width
//        let parent_height: CGFloat = self.frame.height
//
//        let width: CGFloat =
        view.frame = CGRect(x: left, y: top, width: width, height: height)
        view.backgroundColor = UIColor(hex: "#000000", alpha: 0.9)
        self.addSubview(view)
        
        return view
    }
    
    func addBottomView(height: CGFloat = 50)-> UIView {
        let bottomView: UIView = UIView()
        bottomView.backgroundColor = UIColor.clear
        self.addSubview(bottomView)
        bottomView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        bottomView.backgroundColor = UIColor(SEARCH_BACKGROUND)
        
        return bottomView
    }
    
    func addStackView(height: CGFloat = 50)-> UIStackView {
        
        let bottomView: UIView = UIView()
        bottomView.backgroundColor = UIColor.clear
        self.addSubview(bottomView)
        
        let c1: NSLayoutConstraint = NSLayoutConstraint(item: bottomView, attribute: .leading, relatedBy: .equal, toItem: bottomView.superview, attribute: .leading, multiplier: 1, constant: 0)
        let c2: NSLayoutConstraint = NSLayoutConstraint(item: bottomView, attribute: .trailing, relatedBy: .equal, toItem: bottomView.superview, attribute: .trailing, multiplier: 1, constant: 0)
        let c3: NSLayoutConstraint = NSLayoutConstraint(item: bottomView, attribute: .bottom, relatedBy: .equal, toItem: bottomView.superview, attribute: .bottom, multiplier: 1, constant: 0)
        let c4: NSLayoutConstraint = NSLayoutConstraint(item: bottomView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height)
        let c5: NSLayoutConstraint = NSLayoutConstraint(item: bottomView, attribute: .centerX, relatedBy: .equal, toItem: bottomView.superview, attribute: .centerX, multiplier: 1, constant: 0)
//        let c6: NSLayoutConstraint = NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: view.superview, attribute: .centerY, multiplier: 1, constant: 0)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.backgroundColor = UIColor(SEARCH_BACKGROUND)
        self.addConstraints([c1, c2, c3, c4, c5])
        
        let view: UIStackView = UIStackView()
        bottomView.addSubview(view)
        //view.backgroundColor = UIColor.green
//        let c6: NSLayoutConstraint = NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: view.superview, attribute: .centerX, multiplier: 1, constant: 0)
//        let c7: NSLayoutConstraint = NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: view.superview, attribute: .centerY, multiplier: 1, constant: 0)
//        let c8: NSLayoutConstraint = NSLayoutConstraint(item: view1, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)
//        let c9: NSLayoutConstraint = NSLayoutConstraint(item: view1, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 59)
//        
        view.translatesAutoresizingMaskIntoConstraints = false
        //bottomView.addConstraints([c6])
        
        view.centerXAnchor.constraint(equalTo: view.superview!.centerXAnchor).isActive = true
        view.topAnchor.constraint(equalTo: view.superview!.topAnchor, constant: 16).isActive = true
        
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .equalCentering
        view.spacing = 20
        
        return view
    }
    
    func addCancelBtn()-> CancelButton {
        
        let view: CancelButton = CancelButton()
        self.addSubview(view)
        
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        //view.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        view.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.translatesAutoresizingMaskIntoConstraints = false
        //self.addArrangedSubview(view)
        
        //let c1: NSLayoutConstraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 110)
        //let c2: NSLayoutConstraint = NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: view.superview, attribute: .centerX, multiplier: 1, constant: 110)
        //view.translatesAutoresizingMaskIntoConstraints = false
        //self.addConstraints([c1])
        
        return view
    }
    
    func addSubmitBtn()-> SubmitButton {
        
        //let view: SubmitButton = SubmitButton()
        let view: SubmitButton = SubmitButton()
        self.addSubview(view)
        
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        //view.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        view.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.translatesAutoresizingMaskIntoConstraints = false
        //self.addArrangedSubview(view)
        
        //let c1: NSLayoutConstraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 110)
        //view.translatesAutoresizingMaskIntoConstraints = false
        //self.addConstraints([c1])
        
        return view
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
            self.layoutIfNeeded()
        }
    }
    
    var heightConstraint: NSLayoutConstraint? {
        get {
            return constraints.first(where: {
                $0.firstAttribute == .height && $0.relation == .equal
            })
        }
        set { setNeedsLayout() }
    }

    var widthConstraint: NSLayoutConstraint? {
        get {
            return constraints.first(where: {
                $0.firstAttribute == .width && $0.relation == .equal
            })
        }
        set { setNeedsLayout() }
    }
    
    func constraintsPinTo(leading: NSLayoutXAxisAnchor, trailing: NSLayoutXAxisAnchor, top: NSLayoutYAxisAnchor, bottom: NSLayoutYAxisAnchor) {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([self.leadingAnchor.constraint(equalTo: leading),
                                     self.trailingAnchor.constraint(equalTo: trailing),
                                     self.topAnchor.constraint(equalTo: top),
                                     self.bottomAnchor.constraint(equalTo: bottom)])
    }
    
    func showImages(images: [String])-> CGFloat {
        
        var totalHeight: CGFloat = 0
        var upView: UIView = self
        for (idx, image_url) in images.enumerated() {
            let imageView: UIImageView = UIImageView()
            imageView.downloaded(from: image_url)
            self.addSubview(imageView)
            
            let image_h: CGFloat = imageView.heightForUrl(url: image_url, width: self.frame.width)
            var upViewAttribute: NSLayoutConstraint.Attribute = .top
            var upConstant: CGFloat = 8
            if idx > 0 {
                upViewAttribute = .bottom
            } else {
                upConstant = 0
            }
            _setImageConstraint(imageView: imageView, image_h: image_h, upView: upView, upViewAttribute: upViewAttribute, upConstant: upConstant)
            totalHeight = totalHeight + image_h + 8
            upView = imageView
        }
        
        return totalHeight
    }
    
    private func _setImageConstraint(
        imageView: UIImageView,
        image_h: CGFloat,
        upView: UIView,
        upViewAttribute: NSLayoutConstraint.Attribute,
        upConstant: CGFloat) {
        
        var left: NSLayoutConstraint, right: NSLayoutConstraint, top: NSLayoutConstraint, h: NSLayoutConstraint
        
        //左邊
        left = NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: imageView.superview, attribute: .leading, multiplier: 1, constant: 0)
        //右邊
        right = NSLayoutConstraint(item: imageView, attribute: .trailing, relatedBy: .equal, toItem: imageView.superview, attribute: .trailing, multiplier: 1, constant: 0)
        
        //上面
        top = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: upView, attribute: upViewAttribute, multiplier: 1, constant: upConstant)
        
        //高度
        h = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: image_h)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([left, right, top, h])
    }
    
    func setInfo(info: String, topAnchor: UIView)-> SuperLabel {
        
        let label: SuperLabel = SuperLabel()
        label.text = info
        label.setTextGeneral()
        label.textAlignment = .center
        self.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.topAnchor.constraint(equalTo: topAnchor.bottomAnchor, constant: 100).isActive = true
        label.centerXAnchor.constraint(equalTo: label.superview!.centerXAnchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: 200).isActive = true
        label.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        return label
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
    
}

extension UIColor {
    
    convenience init(hex: String, alpha: CGFloat=1.0) {
        // Convert hex string to an integer
        let hexint = Int(UIColor.intFromHexString(hexStr: hex))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat=1.0) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    static func intFromHexString(hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
}

extension UIImageView {
    
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = UIView.ContentMode.scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
            let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
            let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
            let data = data, error == nil,
            let image = UIImage(data: data)
                else {return}
            DispatchQueue.main.async {
                self.image = image
                //print(image.size.height)
            }
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = UIView.ContentMode.scaleAspectFit) {
        //print(link)
        guard let url = URL(string: link) else {return}
        downloaded(from: url, contentMode: mode)
    }
    
    func sizeOfImageAt(_ link: String) -> CGSize? {
        guard let url = URL(string: link) else {return CGSize(width: 0, height: 0)}
        // with CGImageSource we avoid loading the whole image into memory
        guard let source = CGImageSourceCreateWithURL(url as CFURL, nil) else {
            return nil
        }

        let propertiesOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, propertiesOptions) as? [CFString: Any] else {
            return nil
        }

        if let width = properties[kCGImagePropertyPixelWidth] as? CGFloat,
            let height = properties[kCGImagePropertyPixelHeight] as? CGFloat {
            return CGSize(width: width, height: height)
        } else {
            return nil
        }
    }
    
    func heightForUrl(url: String, width: CGFloat)-> CGFloat {
        
        var featured_h: CGFloat = 0
        let featured_size: CGSize? = (self.sizeOfImageAt(url))
        //print("featured height: \(featunred_h)")
        if featured_size != nil && featured_size!.height > 0 {
            if featured_size!.width > 0 && featured_size!.height > 0 {
                let w = featured_size!.width
                let h = featured_size!.height
                let scale: CGFloat
                if w > h {
                    scale = width / w
                } else {
                    scale = width / h
                }
                featured_h = h * scale
            }
        } else {
            featured_h = 300
        }
        
        return featured_h
    }
}

protocol ArrayProtocol{}

extension Array: ArrayProtocol {
    
}

extension UIImage {
    
    // for textfield dropdown menu
    enum Theme {
        case triangle
        
        var name: String {
            switch self {
            case .triangle: return "greater1"
            }
        }
        
        var image: UIImage {
            return UIImage(named: self.name)!
        }
    }
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

enum PropertyTypes: String {
    case OptionalInt = "Optional<Int>"
    case SwiftInt = "Swift.Int"
    case Int = "Int"
    case OptionalString = "Optional<String>"
    case SwiftString = "Swift.String"
    case String = "String"
    case OptionalBool = "Optional<Bool>"
    case SwiftBool = "Swift.Bool"
    case Bool = "Bool"
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

        return prettyPrintedString
    }
}








