//
//  DayVC.swift
//  bm
//
//  Created by ives on 2017/11/14.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

protocol WeekdaysSelectDelegate: class {
    func setWeekdaysData(res: [Int])
}

//extension WeekdaysSelectDelegate {
//    func setWeekdaysData(res: [Int], indexPath: IndexPath?){
//        let i = 6
//    }
//}

class WeekdaysSelectVC: MyTableVC {

    weak var delegate: WeekdaysSelectDelegate?
    var key: String? = nil
    var selecteds: [Int] = [Int]()
    var weekdays: [[String: Any]] = Global.instance.weekdays
    
    //來源的程式：目前有team的setup跟search
    var source: String = "setup"
    //選擇的類型：just one單選，multi複選
    var select: String = "multi"
    var indexPath: IndexPath?
    
    override func viewDidLoad() {
        myTablView = tableView
        super.viewDidLoad()
        //print(selectedDays)
        
        if selecteds.count > 0 {
            for weekday in selecteds {
                for (index, item) in weekdays.enumerated() {
                    let value: Int = item["value"] as! Int
                    if weekday == value {
                        weekdays[index]["checked"] = true
                        break
                    }
                }
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

        let item: [String: Any] = weekdays[indexPath.row]
        
        cell.textLabel!.text = (item["text"] as! String)
        let checked: Bool = item["checked"] as! Bool
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
        
        if cell.accessoryType == .checkmark {
            cell.accessoryType = .none
            cell.textLabel?.textColor = UIColor.white
            cell.tintColor = UIColor.white
            weekdays[indexPath.row]["checked"] = false
        } else {
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = UIColor(MY_GREEN)
            cell.tintColor = UIColor(MY_GREEN)
            weekdays[indexPath.row]["checked"] = true
        }
        let weekday = indexPath.row + 1
        var isExist = false
        var at = 0
        for (idx, selectWeekday) in selecteds.enumerated() {
            if selectWeekday == weekday {
                isExist = true
                at = idx
                break
            }
        }
        if isExist {
            selecteds.remove(at: at)
        } else {
            if select == "just one" {
                selecteds.removeAll()
            }
            selecteds.append(weekday)
        }
        if select == "just one" && selecteds.count > 0 {
            submit()
        }
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
        self.delegate?.setWeekdaysData(res: selecteds)
        prev()
    }
}
