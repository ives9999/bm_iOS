//
//  DayVC.swift
//  bm
//
//  Created by ives on 2017/11/14.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift
import SCLAlertView

protocol DaysSelectDelegate: class {
    func setDaysData(res: [Int])
}

class DaysSelectVC: UITableViewController {

    weak var delegate: DaysSelectDelegate?
    var selectedDays: [Int]?
    var days: [[String: Any]] = Global.instance.days
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(selectedDays)
        
        if selectedDays!.count > 0 {
            for day in selectedDays! {
                for (index, item) in days.enumerated() {
                    let value: Int = item["value"] as! Int
                    if day == value {
                        days[index]["checked"] = true
                        break
                    }
                }
            }
        }
        //print(days)

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(back))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "提交", style: .plain, target: self, action: #selector(submit))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black
    }
    
    @objc func back() {
        dismiss(animated: true, completion: nil)
    }
    @objc func submit() {
        //print(days)
        var isSelected: Bool = false
        var res: [Int] = [Int]()
        for day in days {
            //print(day)
            if day["checked"] as! Bool {
                let idx: Int = day["value"] as! Int
                res.append(idx)
                isSelected = true
            }
        }
        if !isSelected {
            SCLAlertView().showWarning("警告", subTitle: "沒有選擇星期日期，或請按取消回上一頁")
        } else {
            self.delegate?.setDaysData(res: res)
            back()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return days.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let item: [String: Any] = days[indexPath.row]
        
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
            days[indexPath.row]["checked"] = false
        } else {
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = UIColor(MY_GREEN)
            cell.tintColor = UIColor(MY_GREEN)
            days[indexPath.row]["checked"] = true
        }
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
