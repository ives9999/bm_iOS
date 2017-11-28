//
//  DegreeSelectVC.swift
//  bm
//
//  Created by ives on 2017/11/15.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import SCLAlertView
import UIColor_Hex_Swift

protocol DegreeSelectDelegate: class {
    func setDegreeData(degrees: [String])
}

class DegreeSelectVC: UITableViewController {

    var selectedDegrees: [String]?
    var degrees: [[String: Any]] = [[String: Any]]()
    var delegate: DegreeSelectDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tmps:[[String: String]] = DEGREE.all()
        for item in tmps {
            for (key, value) in item {
                degrees.append(["key": key, "value": value, "checked": false]);
            }
        }
        if selectedDegrees!.count > 0 {
            for selectedDegree in selectedDegrees! {
                for (index, item) in degrees.enumerated() {
                    let key: String = item["key"] as! String
                    if key == selectedDegree {
                        degrees[index]["checked"] = true
                        break
                    }
                }
            }
        }
        print(degrees)
        
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
        var res: [String] = [String]()
        for degree in degrees {
            //print(day)
            if degree["checked"] as! Bool {
                let key: String = degree["key"] as! String
                res.append(key)
                isSelected = true
            }
        }
        if !isSelected {
            SCLAlertView().showWarning("警告", subTitle: "沒有選擇任何的球友程度，或請按取消回上一頁")
        } else {
            self.delegate?.setDegreeData(degrees: res)
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
        return degrees.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let row: [String: Any] = degrees[indexPath.row]
        cell.textLabel!.text = (row["value"] as! String)
        let isChecked: Bool = (row["checked"] as! Bool)
        if isChecked {
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
            degrees[indexPath.row]["checked"] = false
        } else {
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = UIColor(MY_GREEN)
            cell.tintColor = UIColor(MY_GREEN)
            degrees[indexPath.row]["checked"] = true
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
