//
//  DayVC.swift
//  bm
//
//  Created by ives on 2017/11/14.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift
import SwiftyJSON

//protocol WeekdaysSelectDelegate: class {
//    func setWeekdaysData(selecteds: [Int])
//}

//extension WeekdaysSelectDelegate {
//    func setWeekdaysData(res: [Int], indexPath: IndexPath?){
//        let i = 6
//    }
//}

class WeekdaysSelectVC: MyTableVC {

    weak var delegate: BaseViewController?
    var key: String? = nil
    var selecteds: Int = 0
    //var weekdays: [[String: Any]] = Global.instance.weekdays
    var selected_weekdays: [WEEKDAY] = [WEEKDAY]()
    let weekdays: [WEEKDAY] = [
                WEEKDAY.mon, WEEKDAY.tue, WEEKDAY.wed, WEEKDAY.thu, WEEKDAY.fri, WEEKDAY.sat, WEEKDAY.sun
            ]
    
    //來源的程式：目前有team的setup跟search
    var source: String = "setup"
    //選擇的類型：just one單選，multi複選
    var select: String = "multi"
    var indexPath: IndexPath?
    
    override func viewDidLoad() {
        myTablView = tableView
        super.viewDidLoad()
        //print(selectedDays)
        
        if selecteds > 0 {
            
            var i: Int = 1
            while (i <= 7) {
                let n = Int(pow(2.0, Double(i)))
                if selecteds & n > 0 {
                    let w: WEEKDAY = WEEKDAY(weekday: i)
                    selected_weekdays.append(w)
                }
                i += 1
            }
        }
        //print(days)
        
        tableView.register(
            SuperCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.white
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return weekdays.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SuperCell

        //let item: [String: Any] = weekdays[indexPath.row]
        
        cell.textLabel!.text = weekdays[indexPath.row].toString()
        
        var checked: Bool = false
        for selected_weekday in selected_weekdays {
            if selected_weekday == weekdays[indexPath.row] {
                checked = true
                break
            }
        }
        
        if checked {
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = UIColor(MY_GREEN)
            cell.tintColor = UIColor(MY_GREEN)
        } else {
            cell.accessoryType = .none
            cell.textLabel?.textColor = UIColor.white
            cell.tintColor = UIColor.white
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: UITableViewCell = tableView.cellForRow(at: indexPath)!
        
        let n: Int = (pow(2, indexPath.row + 1) as NSDecimalNumber).intValue
        if cell.accessoryType == .checkmark {
            cell.accessoryType = .none
            cell.textLabel?.textColor = UIColor.white
            cell.tintColor = UIColor.white
            
            selecteds = selecteds ^ n
            //weekdays[indexPath.row]["checked"] = false
        } else {
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = UIColor(MY_GREEN)
            cell.tintColor = UIColor(MY_GREEN)
            //weekdays[indexPath.row]["checked"] = true
            selecteds = selecteds | n
        }
        
//        let weekday = indexPath.row
//        var isExist = false
//        var at = 0
//        for (idx, selectWeekday) in selecteds.enumerated() {
//            if selectWeekday == weekday {
//                isExist = true
//                at = idx
//                break
//            }
//        }
//
//        if isExist {
//            selecteds.remove(at: at)
//        } else {
//            if select == "just one" {
//                selecteds.removeAll()
//            }
//            selecteds.append(weekday)
//        }
//        if select == "just one" && selecteds.count > 0 {
//            submit()
//        }
    }
    
    func resetSelect() {
        
    }
    
    @IBAction func back() {
        prev()
    }
    @IBAction func cancel() {
        prev()
    }
    @IBAction func submit() {
        self.delegate?.setWeekdaysData(selecteds: selecteds)
        prev()
    }
}
