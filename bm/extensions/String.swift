//
//  String.swift
//  bm
//
//  Created by ives on 2023/4/22.
//  Copyright © 2023 bm. All rights reserved.
//

import Foundation
extension String {
    
    func clacAge()-> Int? {
        let dateFormater: DateFormatter = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        if let birthdayDate: Date = dateFormater.date(from: self) {
            
            if let calendar: NSCalendar = NSCalendar(calendarIdentifier: .gregorian) {
                let now = Date()
                let calcAge = calendar.components(.year, from: birthdayDate, to: now, options: [])
                let age = calcAge.year
                return age
            } else { return nil }
            
        } else { return nil }
    }
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
    
    func toWeekday(format: String = "yyyy-MM-dd HH:mm:ss", locale: Bool = true)-> String? {
        if let d: Date = self.toDateTime(format: format, locale: locale) {
            let weekday_c: String = d.dateToWeekdayForChinese()
            return weekday_c
        } else {
            return nil
        }
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
