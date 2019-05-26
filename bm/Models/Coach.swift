//
//  Coach.swift
//  bm
//
//  Created by ives on 2018/7/24.
//  Copyright © 2018年 bm. All rights reserved.
//

import Foundation
class Coach: SuperData {
    static let instance = Coach()
    
    var testData: [String: Any] = [String: Any]()
    let _sections: [String] = ["", "聯絡資訊", "展示資訊", "地區與收費", "其他說明"]
    
    let _rows: [[String]] = [
        [NAME_KEY],
        [MOBILE_KEY,EMAIL_KEY,FB_KEY,LINE_KEY],
        [WEBSITE_KEY,YOUTUBE_KEY],
        [COACH_SENIORITY_KEY,CITY_KEY],
        [CHARGE_KEY,COACH_LICENSE_KEY,COACH_EXP_KEY,COACH_FEAT_KEY,CONTENT_KEY]
    ]
    
    override var textKeys:[String] {
        get { return [COACH_EXP_KEY,COACH_FEAT_KEY,COACH_LICENSE_KEY,CHARGE_KEY,CONTENT_KEY]}
        set{}
    }
    
    override var cat_id: Int{
        get { return 18}
        set {}
    }
    
    override func initData() {
        data = [
            ID_KEY:["ch":"編號","vtype":"Int","value":-1,"show":""],
            NAME_KEY:["ch":"姓名","vtype":"String","atype":none,"value":"","show":"","submit":true,"keyboardType":defaultPad,"text_field":true],
            CHANNEL_KEY:["ch":"頻道","vtype":"String","value":"","show":""],
            WEBSITE_KEY:["ch":"網站","vtype":"String","atype":none,"value":"","show":"","submit":true,"keyboardType":defaultPad,"text_field":true],
            FB_KEY:["ch":"FB","vtype":"String","atype":none,"value":"","show":"","submit":true,"keyboardType":defaultPad,"text_field":true],
            YOUTUBE_KEY:["ch":"youtube","vtype":"String","atype":none,"value":"","show":"","submit":true,"keyboardType":defaultPad,"text_field":true],
            MOBILE_KEY:["ch":"行動電話","vtype":"String","atype":none,"value":"","show":"","submit":true,"keyboardType":numberPad,"text_field":true],
            EMAIL_KEY:["ch":"email","vtype":"String","atype":none,"value":"","show":"","submit":true,"keyboardType":emailPad,"text_field":true],
                LINE_KEY:
                ["ch":"line id","vtype":"String","atype":none,"value":"","show":"","submit":true,"keyboardType":defaultPad,"text_field":true],
            SLUG_KEY:["ch":"插槽","vtype":"String","value":"","show":""],
            CITYS_KEY:["ch":"區域","vtype":"array","atype":more,"value":0,"show":"","segue":TO_CITY,"sender":0,"submit":true],
            COACH_SENIORITY_KEY:["ch":"年資","vtype":"Int","atype":none,"value":-1,"show":"","submit":true,"keyboardType":numberPad,"text_field":true],
            COACH_EXP_KEY:["ch":"經歷","vtype":"String","atype":more,"value":"","show":"","segue":TO_TEXT_INPUT,"sender":[String: Any](),"submit":true],
            COACH_FEAT_KEY:["ch":"比賽成績","vtype":"String","atype":more,"value":"","show":"","segue":TO_TEXT_INPUT,"sender":[String: Any](),"submit":true],
            COACH_LICENSE_KEY:["ch":"證照","vtype":"String","atype":more,"value":"","show":"","segue":TO_TEXT_INPUT,"sender":[String: Any](),"submit":true],
            CHARGE_KEY:["ch":"收費標準","vtype":"String","atype":more,"value":"","show":"","segue":TO_TEXT_INPUT,"sender":[String: Any](),"submit":true],
            CONTENT_KEY:["ch":"詳細說明","vtype":"String","atype":more,"value":"","show":"","segue":TO_TEXT_INPUT,"sender":[String: Any](),"submit":true],
            MANAGER_ID_KEY:["ch":"","vtype":"Int","value":0,"show":""],
            SORT_ORDER_KEY:["ch":"","vtype":"Int","value":0,"show":""],
            PV_KEY:["ch":"瀏覽數","vtype":"Int","value":0,"show":""],
            COLOR_KEY:["ch":"","vtype":"String","value":"","show":""],
            STATUS_KEY:["ch":"狀態","vtype":"String","value":"","show":""],
            TOKEN_KEY:["ch":"","vtype":"String","value":"","show":""],
            CREATED_ID_KEY:["ch":"建立者","vtype":"Int","value":0,"show":""],
            CREATED_AT_KEY:["ch":"建立時間","vtype":"String","value":"","show":""],
            UPDATED_AT_KEY:["ch":"最後一次修改時間","vtype":"String","value":"","show":""],
            FEATURED_KEY:["ch":"代表圖","vtype":"image","value":UIImage(named: "nophoto")!,"path":"","submit":false,"show":""]
            ]
        
        setSectionAndRow()
        for (key, _) in data {
            data[key]!["key"] = key
            data[key]!["change"] = false
        }
        
        initTextData()
        //runTestData()
    }
    
    override init() {
        super.init()
        sections = _sections
        rows = _rows
        initData()
    }
    
    override init(id: Int, title: String, path: String, token: String, youtube: String = "", vimeo: String = "") {
        super.init(id: id, title: title, path: path, token: token, youtube: youtube, vimeo: vimeo)
        sections = _sections
        rows = _rows
        initData()
    }
    
    override func listReset() {
        initData()
    }
    
    func runTestData() {
        testData = [
            NAME_KEY: "王大明",
            MOBILE_KEY: "0911299994",
            EMAIL_KEY: "ives@housetube.tw",
            FB_KEY: "https://www.facebook.com/%E7%BE%BD%E7%90%83%E5%AF%86%E7%A2%BC-317063118695869/",
            LINE_KEY: "ives9999",
            WEBSITE_KEY: "http://bm.sportpassword.com",
            YOUTUBE_KEY: "https://www.youtube.com/channel/UCi9wbhjrZ4nTIHgZ0r31v8g",
            COACH_SENIORITY_KEY: 8,
            CHARGE_KEY: "每小時800元",
            COACH_LICENSE_KEY: "A級教練證照，證照號碼：12345678",
            COACH_EXP_KEY: "大同國小總教練，安安羽球隊客座教練",
            COACH_FEAT_KEY: "全國甲組第二名，清晨盃冠軍",
            CONTENT_KEY: "歡迎報名學習羽球",
            CITY_KEY: City(id:218, name: "台南")
        ]
        if testData.count > 0 {
            for (key1, value) in testData {
                if key1 == CITY_KEY {
                    let city: City = value as! City
                    data[key1]!["value"] = city.id
                    data[key1]!["show"] = city.name
                } else {
                    for (key2, row) in data {
                        if key1 == key2 {
                            data[key2]!["value"] = value
                            let vtype: String = row["vtype"] as! String
                            if vtype != "array" {
                                data[key2]!["show"] = "\(value)"
                            }
                        }
                    }
                }
                data[key1]!["change"] = true
            }
        }
    }
    
    override func updateCity(_ city: City? = nil) {
        if (city != nil) {
            data[CITYS_KEY]!["value"] = city!.id
            data[CITYS_KEY]!["show"] = city!.name
            data[CITYS_KEY]!["sender"] = city!.id
        } else {
            data[CITYS_KEY]!["value"] = 0
            data[CITYS_KEY]!["show"] = ""
            data[CITYS_KEY]!["sender"] = 0
        }
    }
}
