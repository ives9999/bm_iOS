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
    
    @IBOutlet weak var submitBtn: UIButton!
    
    var data: Dictionary<String, Any>?
    var token: String = ""
    var model: Team!
    var cellHeight: CGFloat = 55
    
    override func viewDidLoad() {
        model = Team.instance
        
        if token.count > 0 {
            Global.instance.addSpinner(superView: self.view)
            TeamService.instance.tempPlay_onoff(token: token, completion: { (success) in
                if success {
                    Global.instance.removeSpinner(superView: self.view)
                    self.sections = self.model.temp_play_edit_sections
                    self.model.hideOrShowTempPlayData()
                    //print(self.model.temp_play_data)
                    let name: String = self.model.temp_play_data[TEAM_NAME_KEY]!["value"] as! String
                    self.titleLbl.text = name + self.titleLbl.text!
                    self.tableView.reloadData()
                }
            })
        }
        
        myTablView = tableView
        super.viewDidLoad()

        tableView.register(TeamTempPlayCell.self, forCellReuseIdentifier: "cell")
        //print(token)
        submitBtn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 20, bottom: 6, right: 20)
        submitBtn.layer.cornerRadius = 12
        
        hideKeyboardWhenTappedAround()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int = 0
        if (sections != nil) {
            for (_, value) in model.temp_play_data {
                if value["section"] != nil {
                    let _section: Int = value["section"] as! Int
                    if section == _section {
                        if value["row"] != nil {
                            count += 1
                        }
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
        //cell.generalTextField.becomeFirstResponder()
        if row["hidden"] != nil {
            let b: Bool = row["hidden"] as! Bool
            if b {
                cell.isHidden = b
            }
        }
        
        return cell
    }
    /*
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 0
        let row: [String: Any] = _getRowByindexPath(indexPath: indexPath)
        if row["hidden"] != nil {
            let b: Bool = row["hidden"] as! Bool
            if b {
                height = 0
            } else {
                height = cellHeight
            }
        }
        
        return height
    }
 */
    
    func _getRowByindexPath(indexPath: IndexPath) -> [String: Any] {
        var section: Int = -1
        var row: Int = -1
        var res: [String: Any]?
        for (_, value) in model.temp_play_data {
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
    
    @IBAction func submit(_ sender: Any) {
        var params:[String: Any]!
        params = model.makeTempPlaySubmitArr()
        if params.count == 0 {
            SCLAlertView().showWarning("提示", subTitle: " 沒有修改任何資料")
        } else {
            //print(params)
            Global.instance.addSpinner(superView: self.view)
            
            //print(isFeaturedChange)
            TeamService.instance.update(params: params, nil, key: "file", filename: "test.jpg", mimeType: "image/jpeg") { (success) in
                Global.instance.removeSpinner(superView: self.view)
                if success {
                    if TeamService.instance.success {
                        let id: Int = TeamService.instance.id
                        self.model.temp_play_data[TEAM_ID_KEY]!["value"] = id
                        self.model.temp_play_data[TEAM_ID_KEY]!["show"] = id
                        //print(self.id)
                        //if self.id > 0 {
                        SCLAlertView().showSuccess("成功", subTitle: "修改臨打成功")
                    } else {
                        SCLAlertView().showWarning("錯誤", subTitle: TeamService.instance.msg)
                    }
                } else {
                    SCLAlertView().showWarning("錯誤", subTitle: "修改臨打失敗，伺服器無法修改成功，請稍後再試")
                }
            }
        }
    }
    func setTextField(iden: String, value: String) {
        for (key, _) in model.temp_play_data {
            if key == iden {
                let item: [String: Any] = model.temp_play_data[key]!
                let oldValue: Any = item["value"] as Any
                let vtype: String = item["vtype"] as! String
                if vtype == "String" {
                    model.temp_play_data[key]!["value"] = value
                    if oldValue as! String != value {
                        model.temp_play_data[key]!["change"] = true
                    }
                } else if vtype == "Int" {
                    let value1: Int = Int(value)!
                    model.temp_play_data[key]!["value"] = value1
                    if oldValue as! Int != value1 {
                        model.temp_play_data[key]!["change"] = true
                    }
                } else if vtype == "Bool" {
                    let value1: Bool = Bool(value)!
                    model.temp_play_data[key]!["value"] = value1
                    if oldValue as! Bool != value1 {
                        model.temp_play_data[key]!["change"] = true
                    }
                }
                model.temp_play_data[key]!["show"] = value
            }
        }
    }
    
    func setSwitch(iden: String, value: Bool) {
        if iden == TEAM_TEMP_STATUS_KEY {
            let res: String = value ? "on" : "off"
            model.temp_play_data[TEAM_TEMP_STATUS_KEY]!["value"] = res
            model.temp_play_data[TEAM_TEMP_STATUS_KEY]!["change"] = true
            model.hideOrShowTempPlayData()
            //print(model.temp_play_data)
            tableView.reloadData()
        }
    }
}
