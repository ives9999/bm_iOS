//
//  SuperModel.swift
//  bm
//
//  Created by ives on 2018/6/24.
//  Copyright © 2018年 bm. All rights reserved.
//

import Foundation
import SwiftyJSON

/// Defines a protocol that must be conform by every model class which can be parsed by `JSONParserSwift`.
public protocol JSONParsable: NSObjectProtocol {
    /// This method will be used to initialize the model with the data in dictionary.
    ///
    /// - Parameter dictionary: `Dictionary` object to be parsed.
    init(dict: [String: Any])
}

class SuperModel: NSObject, JSONParsable {
    
    override init() {
        super.init()
    }
    public required init(dict: [String: Any]) {
        super.init()
        let mirror: Mirror? = Mirror(reflecting: self)
        for property in mirror!.children {
            initialize(for: property, dict: dict)
        }
    }
    
    func getRows<T: SuperModel>()-> [T]? {
        return nil
    }
    
    func getRowFromIdx<T: SuperModel>(_ idx: Int)-> T? {
        return nil
    }
    
    func getFeaturedPath()-> String {
        return ""
    }
    
    func setFeatured(_ image: UIImage) {}
    
    private func initialize(for property: Mirror.Child, dict: [String: Any]) {
        let key: String = property.label!
        if key == "featured" {
            return
        }
        //print(key)
        if let value = dict[key] as? JSON {
            let type = value.type
            if type == Type.array {
                let arrayValue = value.arrayValue
                if key == "weekday_arr" {
                    let parseArray = parseInt(arrayValue)
                    setValue(parseArray, forKey: key)
                } else if key == "signup_normal_models" {
                    let parseArray: [SuperSignupNormal] = parse(property: property, array: arrayValue) as! [SuperSignupNormal]
                    setValue(parseArray, forKey: key)
                } else if key == "signup_normal_models" {
                    let parseArray: [SuperSignupNormal] = parse(property: property, array: arrayValue) as! [SuperSignupNormal]
                    setValue(parseArray, forKey: key)
                } else {
                    let parsedArray = parse(property: property, array: arrayValue)
                    setValue(parsedArray, forKey: key)
                }
                
            } else if type == Type.dictionary {
                //let dictValue = value.dictionary
                
                if key == "city" {
                    let city: SuperCity = JSONParse.parse(data: value)
                    setValue(city, forKey: key)
                } else if key == "coach" {
                    let coach: SuperCoach = JSONParse.parse(data: value)
                    setValue(coach, forKey: key)
                } else if key == "date_model" {
                    let superDate: SuperDate = JSONParse.parse(data: value)
                    setValue(superDate, forKey: key)
                } else if key == "nextCourseTime" {
                    
                    setValue(value, on: property, forKey: key)
                }
                
//                var a = [String: Any]()
//                for (key1, value1) in dictValue! {
//                    a[key1] = value1
//                }
                
//                if let dynamicClass = getDynamicClassType(value: property.value) {
//                    //print(dynamicClass)
//                    let dynamicObj = dynamicClass.init(dict: dictValue!)
//                    setValue(dynamicObj, forKey: key)
//                }
            } else {
                setValue(value, on: property, forKey: key)
            }
        }
    }
    
    private func parse(property: Mirror.Child, array: [JSON]) -> [Any] {
        var resultingArray = [Any]()
        for json in array {
            var d:[String: Any] = [String: Any]()
            for (key, value) in json {
                d[key] = value
            }
            if let dynamicClass = getDynamicClassType(value: property.value) {
                let dynamicObject = dynamicClass.init(dict: d)
                //dynamicObject.filterRow()
                resultingArray.append(dynamicObject)
            }
        }
        
        return resultingArray
    }
    
    private func parseInt(_ array: [JSON]) -> [Int] {
        var resultingArray = [Int]()
        for json in array {
            let i = json.intValue
            resultingArray.append(i)
        }
        
        return resultingArray
    }
    
    private func setValue(_ value: Any, on property: Mirror.Child, forKey propertyName: String) {
        let jsonValue = value as! JSON
        let type: String = getClassType(value: property.value)
        //print(type)
        if type.contains("Dictionary") {
            //print(jsonValue)
            var d: [String: String] = [String: String]()
            
            for (key1, value1) in jsonValue {
                //print(value1)
                if value1 == JSON.null {
                } else {
                    d[key1] = jsonValue[key1].stringValue
                }
            }
            setValue(d, forKey: propertyName)
        }  else if type.contains("String") {
            setValue(jsonValue.stringValue, forKey: propertyName)
        } else if type.contains("Bool") {
            setValue(jsonValue.boolValue, forKey: propertyName)
        } else if type.contains("Int") {
            let i = jsonValue.intValue
            setValue(i, forKey: propertyName)
        } else if type.contains("Float") {
            setValue(jsonValue.floatValue, forKey: propertyName)
        } else if type.contains("Double") {
            setValue(jsonValue.doubleValue, forKey: propertyName)
        }
    }
    
    private func getDynamicClassType(value: Any) -> JSONParsable.Type? {
        var dynamicType = getClassType(value: value)
        if dynamicType.hasPrefix("Array") {
            dynamicType = getInnerClassType(of: dynamicType)
        }
//        guard let dynamicClass: SuperCoach.Type = "SuperCoach".convertToClass() else {
//            return nil
//        }
//        return dynamicClass
        
        
        
        if let dynamicClass = NSClassFromString(dynamicType) as? JSONParsable.Type {
            //print(dynamicClass)
            return dynamicClass
        }
        return nil
    }
    
    private func getClassType(value: Any) -> String {
        var dynamicType = String(reflecting: type(of: value))
        dynamicType = dynamicType.replacingOccurrences(of: "Swift.", with: "")
        
        return dynamicType
    }
    
    public func printRow() {
        let mirror: Mirror? = Mirror(reflecting: self)
        for property in mirror!.children {
            print("\(property.label)=>\(property.value)")
        }
    }
    public func printRows() {}
    
    public func filterRow(){}
    
    /*
    func parse1(data: JSON) {
        var d: Dictionary<String, Any> = Dictionary()
        for (key, value) in data {
            d[key] = value
        }
        print(d)
    }
    
    func parse(data: JSON) {
        
        for (key, value) in data {
            //print("\(key) -> \(value)")
            let mirror: Mirror? = Mirror(reflecting: self)
            let property = getProperty(key: key, mirror: mirror)
            if property != nil {
                let v = property!.value
                let t = getClassType(value: v)
                if t == "Bool" {
                    setValue(value.boolValue, forKey: key)
                } else if t == "Int" {
                    setValue(value.intValue, forKey: key)
                } else if t == "Float" {
                    setValue(value.floatValue, forKey: key)
                } else if t == "Double" {
                    setValue(value.double, forKey: key)
                } else if t == "String" {
                    setValue(value.stringValue, forKey: key)
                } else if t.hasPrefix("Array") {
                    //parseArray(arrays: value.arrayValue)
                    //print(t)
                    let c = getInnerClassType(of: t)
                    //print(c)
                    let dynamicClass = NSClassFromString(c) as! bm.TempPlayDatePlayer.Rows
                    let mir = Mirror(reflecting: dynamicClass)
                    for (_, attr) in mir.children.enumerated() {
                        print(attr.label)
                    }
                }
            }
        }
        //print(self.success)
    }
    
    fileprivate func parseArray(arrays: [JSON]) {
        for array in arrays {
            //parse(data: array)
        }
    }
 */
    
    fileprivate func getProperty(key: String, mirror: Mirror?=nil) -> Mirror.Child? {
        var child: Mirror.Child? = nil
        for (_, attr) in mirror!.children.enumerated() {
            if key == attr.label {
                //print(key)
                child = attr
                break
            }
        }
        return child
    }
    
    
    
    fileprivate func getInnerClassType(of: String) -> String {
        let start = of.indexDistance(of: "<")!+1
        let end = of.indexDistance(of: ">")!
        let s = of.index(of.startIndex, offsetBy: start)
        let e = of.index(of.startIndex, offsetBy: end)
        let c = String(of[s..<e])
        let arr = c.components(separatedBy: ".")
        let res = arr[arr.count-1]
        
        return res
    }
    
//    fileprivate func keyExist(key: String) -> Bool {
//        var isExist: Bool = false
//        for (_, attr) in mirror!.children.enumerated() {
//            if let name = attr.label {
//                //print(name)
//                if name == key {
//                    isExist = true
//                    break
//                }
//            }
//        }
//
//        return isExist
//    }
}

extension String {
    
    func convertToClass<T>() -> T.Type? {
        return StringClassConverter<T>.convert(string: self)
    }
    
}

class StringClassConverter<T> {
    
    static func convert(string className: String) -> T.Type? {
        guard let nameSpace = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String else {
            return nil
        }
        guard let aClass: T.Type = NSClassFromString("\(nameSpace).\(className)") as? T.Type else {
            return nil
        }
        return aClass
        
    }
    
}

