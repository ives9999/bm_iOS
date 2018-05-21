//
//  TeamManagerFunctionVC.swift
//  bm
//
//  Created by ives on 2018/5/21.
//  Copyright © 2018年 bm. All rights reserved.
//

import UIKit

class TeamManagerFunctionVC: MyTableVC {

    var name: String = ""
    var token: String = ""
    var _rows: [Dictionary<String, Any>] = [
        ["text": "編輯", "icon": "edit", "segue": TO_TEAM_SUBMIT],
        ["text": "臨打", "icon": "tempPlay", "segue": TO_TEAM_TEMP_PLAY],
        ["text": "刪除", "icon": "clear"]
    ]
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        myTablView = tableView
        super.viewDidLoad()
        titleLbl.text = name

        tableView.register(MenuCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _rows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("show cell sections: \(indexPath.section), rows: \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuCell
        
        let row: [String: Any] = _rows[indexPath.row]
        cell.setRow(row: row)
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        return cell
    }

    @IBAction func prevBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
