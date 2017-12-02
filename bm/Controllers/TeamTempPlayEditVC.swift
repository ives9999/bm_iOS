//
//  TeamTempPlayEditVC.swift
//  bm
//
//  Created by ives on 2017/11/30.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class TeamTempPlayEditVC: MyTableVC, TeamTempPlayCellDelegate {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var data: Dictionary<String, Any>?
    var token: String = ""
    var model: TeamTempPlay!
    
    override func viewDidLoad() {

        model = TeamTempPlay.instance
        sections = TeamTempPlay.instance.sections
        myTablView = tableView
        super.viewDidLoad()

        tableView.register(TeamTempPlayCell.self, forCellReuseIdentifier: "cell")
        //print(token)
        
        hideKeyboardWhenTappedAround()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int = 0
        for (_, value) in model.data! {
            if value["section"] != nil {
                let _section: Int = value["section"] as! Int
                if section == _section {
                    if value["row"] != nil {
                        count += 1
                    }
                }
            }
        }
        //print("section: \(section), count: \(count)")
        return count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //print("section: \(indexPath.section), row: \(indexPath.row)")
        let cell: TeamTempPlayCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TeamTempPlayCell
        cell.teamTempPlayCellDelegate = self
        let row: [String: Any] = _getRowByindexPath(indexPath: indexPath)
        cell.forRow(row: row)
        
        return cell
    }
    
    func _getRowByindexPath(indexPath: IndexPath) -> [String: Any] {
        var section: Int = -1
        var row: Int = -1
        var res: [String: Any]?
        for (_, value) in model.data! {
            if value["section"] != nil {
                section = value["section"] as! Int
            }
            if value["row"] != nil {
                row = value["row"] as! Int
            }
            if section == indexPath.section && row == indexPath.row {
                res = value
                break
            }
        }
        return res!
    }

    @IBAction func prevBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setTextField(iden: String, value: String) {
        for (key, _) in model.data! {
            if key == iden {
                let item: [String: Any] = model.data![key]!
                let oldValue: Any = item["value"] as Any
                let vtype: String = item["vtype"] as! String
                if vtype == "String" {
                    model.data![key]!["value"] = value
                    if oldValue as! String != value {
                        model.data![key]!["change"] = true
                    }
                } else if vtype == "Int" {
                    let value1: Int = Int(value)!
                    model.data![key]!["value"] = value1
                    if oldValue as! Int != value1 {
                        model.data![key]!["change"] = true
                    }
                } else if vtype == "Bool" {
                    let value1: Bool = Bool(value)!
                    model.data![key]!["value"] = value1
                    if oldValue as! Bool != value1 {
                        model.data![key]!["change"] = true
                    }
                }
                model.data![key]!["show"] = value
            }
        }
    }
    
    func setSwitch(iden: String, value: Bool) {
        if iden == TEAM_TEMP_STATUS_KEY {
            
        }
    }
}
