//
//  SingleSelectVC.swift
//  bm
//
//  Created by ives on 2019/5/31.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit

protocol SingleSelectDelegate: SelectDelegate {
    func singleSelected(key: String, selected: String, show: String?)
}

class SingleSelectVC: SelectVC {
    
    var selected: String? = nil
    var delegate: SingleSelectDelegate?
    
    var rawRows: [String] = [String]()

    override func viewDidLoad() {
        
        myTablView = tableView

        let cellNib = UINib(nibName: "SingleSelectCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "cell")
        super.viewDidLoad()

        if rows1 != nil && rows1!.count > 0 {
            rows1!.removeAll()
        } else {
            rows1 = [[String: String]]()
        }
        
        if (key == PRICE_UNIT_KEY) {
            
            title = "收費週期"
            rows1 = PRICE_UNIT.makeSelect()
        } else if (key == CYCLE_UNIT_KEY) {
            
            title = "週期"
            rows1 = CYCLE_UNIT.makeSelect()
        } else if (key == COURSE_KIND_KEY) {
            
            title = "課程種類"
            rows1 = COURSE_KIND.makeSelect()
        } else if (key == START_TIME_KEY || key == END_TIME_KEY) {
            
            if (key == START_TIME_KEY) {
                title = "開始時間"
            } else {
                title = "結束時間"
            }
            
            let start: String = "07:00"
            let end: String = "23:00"
            let interval: Int = 30
            
            var s = start.toDateTime(format: "HH:mm")
            let e = end.toDateTime(format: "HH:mm")
            //rawRows.append(s.toString(format: "HH:mm"))
            var t: String = s.toString(format: "HH:mm")
            rows1!.append(["title": t, "value": t])
            while s < e {
                s = s.addingTimeInterval(TimeInterval(Double(interval)*60.0))
                t = s.toString(format: "HH:mm")
                rows1!.append(["title": t, "value": t])
                //rawRows.append(s.toString(format: "HH:mm"))
            }
        } else if (key == CITY_KEY) {
            
            let citys: [City] = Global.instance.getCitys()
            for city in citys {
                let name = city.name
                let id = city.id
                rows1!.append(["title": name, "value": String(id)])
            }
        }
        //由於需要city_id，所以使用SelectAreaVC來代替
        //else if (key == AREA_KEY) {}
        
        titleLbl.text = title
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //var cell: UITableViewCell = UITableViewCell()
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SingleSelectCell
        cell.titleLbl.text = rows1![indexPath.row]["title"]
        
        var checked: Bool = false
        let row = rows1![indexPath.row]
        if row["value"] == selected {
            checked = true
        }
        if checked {
            setSelectedStyle(cell)
        } else {
            unSetSelectedStyle(cell)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        submit(indexPath)
    }
    
    func submit(_ indexPath: IndexPath) {
        
        let cell: UITableViewCell = tableView.cellForRow(at: indexPath)!
        let row = rows1![indexPath.row]
        
        var cancel: Bool = false
        if selected != nil && selected!.count > 0 {
            if selected! == row["value"] {
                cancel = true
                unSetSelectedStyle(cell)
            }
        }
        if !cancel {
            if delegate != nil {
                let _key = ((key == nil) ? "" : key)!
                if (delegate != nil) {
                    delegate!.singleSelected(key: _key, selected: row["value"]!, show: nil)
                } else {
                    warning("沒有傳入代理程式，請洽管理員")
                }
            }
            setSelectedStyle(cell)
            prev()
        }
        
        
        
        
//        selected = (row["value"] == selected) ? "" : row["value"]
//        if delegate != nil {
//            delegate!.singleSelected(key: key!, selected: selected!)
//            prev()
//        } else {
//            alertError("由於傳遞參數不正確，無法做選擇，請回上一頁重新進入")
//        }
    }
    
    override func setDelegate(_ delegate: SelectDelegate) {
        self.delegate = (delegate as! SingleSelectDelegate)
    }
    
    func setSelectedStyle(_ cell: SingleSelectCell) {
        cell.accessoryType = .checkmark
        cell.titleLbl?.textColor = UIColor(MY_GREEN)
        cell.tintColor = UIColor(MY_GREEN)
    }
    
    func unSetSelectedStyle(_ cell: SingleSelectCell) {
        cell.accessoryType = .none
        cell.titleLbl?.textColor = UIColor.white
        cell.tintColor = UIColor.white
    }
}
