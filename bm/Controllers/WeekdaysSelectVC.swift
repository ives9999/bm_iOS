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
    func setWeekdaysData(res: [Int], indexPath: IndexPath?)
}

class WeekdaysSelectVC: UITableViewController {

    weak var delegate: WeekdaysSelectDelegate?
    var selecteds: [Int] = [Int]()
    var weekdays: [[String: Any]] = Global.instance.weekdays
    
    //來源的程式：目前有team的setup跟search
    var source: String = "setup"
    //選擇的類型：just one單選，multi複選
    var select: String = "multi"
    var indexPath: IndexPath?
    
    override func viewDidLoad() {
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

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(back))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        
        if select == "multi" {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "提交", style: .plain, target: self, action: #selector(submit))
            navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        }
    }
    
    @objc func back() {
        dismiss(animated: true, completion: nil)
    }
    @objc func submit() {
        //print(days)
//        var isSelected: Bool = false
//        var res: [Int] = [Int]()
//        for weekday in weekdays {
//            //print(day)
//            if weekday["checked"] as! Bool {
//                let idx: Int = weekday["value"] as! Int
//                res.append(idx)
//                isSelected = true
//            }
//        }
        self.delegate?.setWeekdaysData(res: selecteds, indexPath: indexPath)
        back()
        /*
        if !isSelected {
            if source == "setup" {
                SCLAlertView().showWarning("警告", subTitle: "沒有選擇星期日期，或請按取消回上一頁")
            } else {
                self.delegate?.setWeekdaysData(res: res, indexPath: indexPath)
                back()
            }
        } else {
            self.delegate?.setWeekdaysData(res: res, indexPath: indexPath)
            back()
        }
 */
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return weekdays.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
