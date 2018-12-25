//
//  TimeSelectVC.swift
//  bm
//
//  Created by ives on 2017/11/14.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

protocol TimeSelectDelegate: class {
    func setTimeData(res: [String], type: SELECT_TIME_TYPE, indexPath: IndexPath?)
}

class TimeSelectVC: UITableViewController {
    
    //input["type":PLAY_START,"time":time]
    var input: [String: Any] = [String: Any]()
    var selecteds: [String] = [String]()
    
    var start: String = "07:00"
    var end: String = "23:00"
    //minute
    var interval: Int = 60
    var allTimes: [String] = [String]()
    
    var delegate: TimeSelectDelegate?
    
    //來源的程式：目前有team的setup跟search
    var source: String = "setup"
    //選擇的類型：just one單選，multi複選
    var select: String = "just one"
    var indexPath: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()

        var title: String = ""
        //print(input)
        var s = start.toDateTime(format: "HH:mm")
        let e = end.toDateTime(format: "HH:mm")
        allTimes.append(s.toString(format: "HH:mm"))
        while s < e {
            s = s.addingTimeInterval(TimeInterval(Double(interval)*60.0))
            allTimes.append(s.toString(format: "HH:mm"))
        }
        
        if input["type"] != nil {
            let type: SELECT_TIME_TYPE = input["type"] as! SELECT_TIME_TYPE
            switch type {
            case .play_start:
                title = "開始時間"
                break
            case .play_end:
                title = "結束時間"
                break
            }
        } else {
            title = "時間"
        }
        if input["time"] != nil {
            if input["time"]! is ArrayProtocol {
                selecteds = input["time"] as! [String]
            } else {
                selecteds.append(input["time"] as! String)
            }
        }
        
        self.title = title
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(back))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        if select == "multi" {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "提交", style: .plain, target: self, action: #selector(submit))
            navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        }
    }
    
    @objc func submit() {
        
        self.delegate?.setTimeData(res: selecteds, type: input["type"] as! SELECT_TIME_TYPE, indexPath: indexPath)
        back()
    }
    
    @objc func back() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allTimes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let time: String = allTimes[indexPath.row]
        cell.textLabel?.text = time
        var selectedTime: String = ""
        if input["time"] != nil {
            selectedTime = input["time"] as! String
        }
        if time == selectedTime {
            cell.textLabel?.textColor = UIColor(MY_GREEN)
            cell.accessoryType = .checkmark
            cell.tintColor = UIColor(MY_GREEN)
        } else {
            cell.textLabel?.textColor = UIColor.white
            cell.accessoryType = .none
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
        } else {
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = UIColor(MY_GREEN)
            cell.tintColor = UIColor(MY_GREEN)
        }
        let time: String = allTimes[indexPath.row]
        var isExist = false
        var at = 0
        for (idx, selectTime) in selecteds.enumerated() {
            if selectTime == time {
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
            selecteds.append(time)
        }
        if select == "just one" && selecteds.count > 0 {
            submit()
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
