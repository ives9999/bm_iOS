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
    
    var input: [String: Any] = [String: Any]()
    let times: [String] = ["07:00","08:00","09:00","10:00","11:00","12:00",
"13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00","23:00"
                        ]
    var delegate: TimeSelectDelegate?
    
    //來源的程式：目前有team的setup跟search
    var source: String = "setup"

    override func viewDidLoad() {
        super.viewDidLoad()

        var title: String = ""
        //print(input)
        
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
        var selectedTime: String = ""
        if input["time"] != nil {
            selectedTime = input["time"] as! String
        }
        if time == selectedTime {
            cell.textLabel?.textColor = UIColor(MY_GREEN)
        } else {
            cell.textLabel?.textColor = UIColor.white
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var time: String = times[indexPath.row]
        let type: SELECT_TIME_TYPE = input["type"] as! SELECT_TIME_TYPE
        if input["time"] != nil {
            if time == input["time"] as! String {
                time = ""
            }
        }
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
