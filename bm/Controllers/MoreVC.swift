//
//  MoreVC.swift
//  bm
//
//  Created by ives on 2017/12/23.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class MoreVC: MyTableVC {
    
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var _rows: [[Dictionary<String, Any>]] = [
        [
            ["text": "球館", "icon": "arena", "segue": TO_ARENA],
            ["text": "教學", "icon": "coach", "segue": TO_COURSE],
            ["text": "版本", "icon": "version", "segue": ""]
        ]
    ]
    
    override func viewDidLoad() {
        myTablView = tableView
        rows = _rows
        super.viewDidLoad()
        Global.instance.setupTabbar(self)
        Global.instance.menuPressedAction(menuBtn, self)

        tableView.register(MenuCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("show cell sections: \(indexPath.section), rows: \(indexPath.row)")
        let cell: MenuCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuCell
        //cell.delegate = self
        
        let row: [String: Any] = rows![indexPath.section][indexPath.row]
        cell.setRow(row: row)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("click cell sections: \(indexPath.section), rows: \(indexPath.row)")
        if (indexPath.row == _rows[0].count-1) {
            //First get the nsObject by defining as an optional anyObject
            let nsObject: Any? = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
            
            //Then just cast the object as a String, but be careful, you may want to double check for nil
            let version = nsObject as! String
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: true
            )
            let alert = SCLAlertView(appearance: appearance)
            alert.showInfo(version)
        } else {
            let row: [String: Any] = rows![indexPath.section][indexPath.row]
            //print(row)
            if row["segue"] != nil {
                let segue = row["segue"] as! String
                //print("segue: \(segue)")
                performSegue(withIdentifier: segue, sender: row["sender"])
                
            }
        }
    }
    @IBAction func prevBtnPressed(_ sender: Any) {
    }
    
}
