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
    func setTimeData(time: String, type: SELECT_TIME_TYPE)
}

class TimeSelectVC: UITableViewController {
    
    var input: [String: Any]?
    let times: [String] = ["07:00","07:30","08:00","08:30","09:00","09:30","10:00","10:30","11:00","11:30","12:00",
                           "12:30","13:00","13:30","14:00","14:30","15:00","15:30","16:00","16:30","17:00","17:30",
                           "18:00","18:30","19:00","19:30","20:00","20:30","21:00","21:30","22:00","22:30","23:00"
                        ]
    var delegate: TimeSelectDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        var title: String = ""
        let type: SELECT_TIME_TYPE = input!["type"] as! SELECT_TIME_TYPE
        switch type {
        case .play_start:
            title = "開始時間"
            break
        case .play_end:
            title = "結束時間"
            break
        }
        self.title = title
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(back))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
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
        return times.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let time: String = times[indexPath.row]
        cell.textLabel?.text = time
        let selectedTime: String = input!["time"] as! String
        if time == selectedTime {
            cell.textLabel?.textColor = UIColor(MY_GREEN)
        } else {
            cell.textLabel?.textColor = UIColor.white
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let time: String = times[indexPath.row]
        let type: SELECT_TIME_TYPE = input!["type"] as! SELECT_TIME_TYPE
        delegate?.setTimeData(time: time, type: type)
        dismiss(animated: true, completion: nil)
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
