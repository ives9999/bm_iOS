//
//  Team.swift
//  bm
//
//  Created by ives on 2017/10/17.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class SuperData {
    var id: Int
    var title: String
    var featured: UIImage
    var path: String
    var token: String
    var youtube: String
    var vimeo: String
    var data: Dictionary<String, [String: Any]>
    var sections: [String]
    var rows: [[Dictionary<String, String>]]
    
    //temp play
    var temp_play_data:Dictionary<String, [String: Any]> = Dictionary<String, [String: Any]>()
    
    let transferPair: [String: String] = [CITY_KEY:"city_id",ARENA_KEY:"arena_id"]
    
    let none: UITableViewCellAccessoryType = UITableViewCellAccessoryType.none
    let more: UITableViewCellAccessoryType = UITableViewCellAccessoryType.disclosureIndicator
    let defaultPad: UIKeyboardType = UIKeyboardType.default
    let numberPad: UIKeyboardType = UIKeyboardType.numberPad
    let phonePad: UIKeyboardType = UIKeyboardType.phonePad
    let emailPad: UIKeyboardType = UIKeyboardType.emailAddress
    
    init() {
        self.id = -1
        self.title = ""
        self.path = ""
        self.featured = UIImage()
        self.token = ""
        self.vimeo = ""
        self.youtube = ""
        self.data = Dictionary<String, [String: Any]>()
        self.sections = [String]()
        self.rows = [[Dictionary<String, String>]]()
    }
    
    init(id: Int, title: String, path: String, token: String, youtube: String = "", vimeo: String = "") {
        self.id = id
        self.title = title
        self.path = path
        self.featured = UIImage(named: "nophoto")!
        self.token = token
        self.vimeo = vimeo
        self.youtube = youtube
        self.data = Dictionary<String, [String: Any]>()
        self.sections = [String]()
        self.rows = [[Dictionary<String, String>]]()
    }
    
    func neverFill() {
        for (key, _) in data {
            data[key]!["show"] = "未提供"
        }
    }
    
    func updateCity(_ city: City) {
        data[CITY_KEY]!["value"] = city.id
        data[CITY_KEY]!["show"] = city.name
        data[CITY_KEY]!["sender"] = city.id
    }
    
    func updateCharge(_ content: String? = nil) {
        if content != nil {
            data[CHARGE_KEY]!["value"] = content
        }
        chargeShow()
        setChargeSender()
    }
    func updateContent(_ content: String? = nil) {
        if content != nil {
            data[CONTENT_KEY]!["value"] = content
        }
        contentShow()
        setContentSender()
    }
    
    func chargeShow(_ length: Int=15) {
        var text: String = data[CHARGE_KEY]!["value"] as! String
        text = text.truncate(length: length)
        data[CHARGE_KEY]!["show"] = text
    }
    func contentShow(_ length: Int=15) {
        var text: String = data[CONTENT_KEY]!["value"] as! String
        text = text.truncate(length: length)
        data[CONTENT_KEY]!["show"] = text
    }
    
    func mobileShow(_ _mobile: String? = nil) {
        var mobile = _mobile
        if _mobile == nil {
            mobile = (data[MOBILE_KEY]!["value"] as! String)
        }
        mobile = mobile!.mobileShow()
        data[MOBILE_KEY]!["show"] = mobile
    }
    
    func telOrMobileShow(_tel: String? = nil) {
        var tel = _tel
        if _tel == nil {
            tel = (data[TEL_KEY]!["value"] as! String)
        }
        tel = tel!.telOrMobileShow()
        data[TEL_KEY]!["show"] = tel
    }
    
    func setChargeSender() {
        var res: [String: Any] = [String: Any]()
        let text: String = data[CHARGE_KEY]!["value"] as! String
        res["text"] = text
        res["type"] = TEXT_INPUT_TYPE.charge
        data[CHARGE_KEY]!["sender"] = res
    }
    func setContentSender() {}
    
    func listReset() {}
    func initData() {}
    func updateArena(_ arena: Arena) {}
    func updateDays(_ days: [Int]) {}
    func updateDegree(_ degrees: [Degree]) {}
    func updateInterval(_ _startTime: String? = nil, _ _endTime: String? = nil) {}
    func updateOpenTime(_ time: String? = nil) {}
    func updateCloseTime(_ time: String? = nil) {}
    func updatePlayStartTime(_ time: String? = nil) {}
    func updatePlayEndTime(_ time: String? = nil) {}
    func updateTempContent(_ content: String? = nil) {}
    func updateNearDate(_ n1: String? = nil, _ n2: String? = nil) {}
    func feeShow() {}
    func makeSubmitArr() -> [String: Any] {
        return [String: Any]()
    }
    
    func aPrint() {
        let mirror: Mirror? = Mirror(reflecting: self)
        for property in mirror!.children {
            _print(it: property)
        }
    }
    
    func _print(it: Mirror.Child) {
        let key = it.label
        let value = it.label
        print("\(key) => \(value)")
    }
}
