//
//  Enum.swift
//  bm
//
//  Created by ives on 2022/12/13.
//  Copyright © 2022 bm. All rights reserved.
//

import Foundation

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
    case logistic = "到達物流中心"
    case store = "到達便利商店"
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
        case .logistic:
            return "logistic"
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
            return .logistic
        case 6:
            return .store
        case 7:
            return .complete
        case 8:
            return .returning
        case 9:
            return .return
        case 10:
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
    case store_pay_hilife = "萊爾富超商取貨付款"
    case store_pay_ok = "OK超商取貨付款"
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
        case "store_pay_hilife":
            return .store_pay_hilife
        case "store_pay_ok":
            return .store_pay_ok
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
    
    func mapToShipping()-> SHIPPING {
        
        switch self {
        case .store_pay_711:
            return SHIPPING.store_711
        case .store_pay_family:
            return SHIPPING.store_family
        case .store_pay_hilife:
            return SHIPPING.store_hilife
        case .store_pay_ok:
            return SHIPPING.store_ok
        default:
            return SHIPPING.store_711
        }
    }
    
    func enumToECPay()-> String {
        switch self {
        case .store_pay_711:
            return "UNIMARTC2C"
        case .store_pay_family:
            return "FAMIC2C"
        case .store_pay_hilife:
            return "HILIFEC2C"
        case .store_pay_ok:
            return "OKMARTC2C"
        default:
            return "UNIMARTC2C"
        }
    }
}

enum SHIPPING: String {
    
    case direct = "宅配"
    case store_711 = "7-11超商取貨"
    case store_family = "全家超商取貨"
    case store_hilife = "萊爾富超商取貨"
    case store_ok = "OK超商取貨"
    case cash = "面交"
    
    static func stringToEnum(_ enumString: String) -> SHIPPING {
        switch enumString {
        case "direct":
            return .direct
        case "store_711":
            return .store_711
        case "store_family":
            return .store_family
        case "store_hilife":
            return .store_hilife
        case "store_ok":
            return .store_ok
        case "cash":
            return .cash
        default:
            return .direct
        }
    }
    
    static func getRawValueFromString(_ string: String)-> String {
        let res: SHIPPING = stringToEnum(string)
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
    case logistic = "已經送到物流中心"
    case store = "商品已到便利商店"
    case complete = "已完成取貨"
    case `return` = "貨物退回"
    
    func enumToString()-> String {
        switch self {
        case .normal:
            return "normal"
        case .shipping:
            return "shipping"
        case .logistic:
            return "logistic"
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
        case "logistic":
            return .logistic
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

enum MEMBER_SUBSCRIPTION_KIND: String {
    
    case diamond = "鑽石"
    case white_gold = "白金"
    case gold = "金牌"
    case silver = "銀牌"
    case copper = "銅牌"
    case steal = "鐵牌"
    case basic = "基本"
    
    func lottery() -> Int {
        switch self {
        case .basic:
            return 0
        case .steal:
            return 0
        case .copper:
            return 1
        case .silver:
            return 2
        case .gold:
            return 3
        case .white_gold:
            return 7
        case .diamond:
            return 12
        }
    }
    
    func enumToEng() -> String {
        switch self {
        case .basic:
            return "basic"
        case .steal:
            return "steal"
        case .copper:
            return "copper"
        case .silver:
            return "steal"
        case .gold:
            return "gold"
        case .white_gold:
            return "white_gold"
        case .diamond:
            return "diamond"
        }
    }
    
    static func stringToEnum(_ enumString: String) -> MEMBER_SUBSCRIPTION_KIND {
        switch enumString {
        case "basic":
            return .basic
        case "steal":
            return .steal
        case "copper":
            return .copper
        case "silver":
            return .silver
        case "gold":
            return .gold
        case "white_gold":
            return .white_gold
        case "diamond":
            return .diamond
        default:
            return .basic
        }
    }
    
    static func getRawValueFromString(_ string: String)-> String {
        let res: MEMBER_SUBSCRIPTION_KIND = stringToEnum(string)
        return res.rawValue
    }
}

let df : DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter
}()
