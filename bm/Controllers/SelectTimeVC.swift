//
//  SelectTimeVC.swift
//  bm
//
//  Created by ives on 2021/6/13.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class SelectTimeVC: SingleSelectVC {
    
    var start: String = "07:00"
    var end: String = "23:00"
    
    var interval: Int = 30
    var allTimes: [String] = [String]()
    
    override func viewDidLoad() {
        myTablView = tableView
        title = "縣市"
        super.viewDidLoad()
        
        var s = start.toDateTime(format: "HH:mm")
        let e = end.toDateTime(format: "HH:mm")
        allTimes.append(s.toString(format: "HH:mm"))
        while s < e {
            s = s.addingTimeInterval(TimeInterval(Double(interval)*60.0))
            allTimes.append(s.toString(format: "HH:mm"))
        }
        
        rows1Bridge()
    }
    
    func rows1Bridge() {
        
        if rows1 != nil && rows1!.count > 0 {
            rows1!.removeAll()
        } else {
            rows1 = [[String: String]]()
        }
        for time in allTimes {
            rows1!.append(["title": time, "value": time])
        }
    }
}
