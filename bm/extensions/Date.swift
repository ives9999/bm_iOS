//
//  Date.swift
//  bm
//
//  Created by ives on 2023/4/29.
//  Copyright © 2023 bm. All rights reserved.
//

import Foundation

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
