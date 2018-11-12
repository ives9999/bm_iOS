//
//  TeamManagerFunctionVC.swift
//  bm
//
//  Created by ives on 2018/5/21.
//  Copyright © 2018年 bm. All rights reserved.
//

import UIKit

class ManagerFunctionVC: MyTableVC {

    var source: String = ""
    var name: String = ""
    var token: String = ""
    var _rows: [Dictionary<String, Any>] = [Dictionary<String, Any>]()

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        myTablView = tableView
        super.viewDidLoad()
        titleLbl.text = name
        
        if source == "team" {
            _rows = [
                ["text": "編輯", "icon": "edit1", "segue": TO_EDIT],
                ["text": "臨打編輯", "icon": "tempplayedit", "segue": TO_TEAM_TEMP_PLAY],
                ["text": "每次臨打名單", "icon": "tempplaylist", "segue": TO_TEAM_TEMP_PLAY],
                ["text": "刪除", "icon": "clear"]
            ]
        } else if source == "coach" {
            _rows = [
                ["text": "編輯", "icon": "edit1", "segue": TO_EDIT],
                ["text": "教球時段編輯", "icon": "tempplayedit", "segue": TO_TEAM_TEMP_PLAY],
                ["text": "報名學員名單", "icon": "tempplaylist", "segue": TO_TEAM_TEMP_PLAY],
                ["text": "刪除", "icon": "clear"]
            ]
        } else if source == "arena" {
            _rows = [
                ["text": "編輯", "icon": "edit1", "segue": TO_EDIT],
                ["text": "時段編輯", "icon": "tempplayedit", "segue": TO_TEAM_TEMP_PLAY],
                ["text": "報名球隊名單", "icon": "tempplaylist", "segue": TO_TEAM_TEMP_PLAY],
                ["text": "刪除", "icon": "clear"]
            ]
        }

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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var iden: String = ""
        if indexPath.row == 0 {
            iden = TO_EDIT
        } else if indexPath.row == 1 {
            iden = TO_TEAM_TEMP_PLAY
        } else if indexPath.row == 2 {
            iden = TO_TEMP_PLAY_DATE
        } else if indexPath.row == 3 {
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let alert = SCLAlertView(appearance: appearance)
            alert.addButton("確定", action: {
                self._delete(token: self.token)
                self.prevBtnPressed("")
            })
            alert.addButton("取消", action: {
            })
            alert.showWarning("警告", subTitle: "是否確定要刪除此球隊")
        }
        if iden.count > 0 {
            performSegue(withIdentifier: iden, sender: token)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == TO_EDIT {
            let vc: EditVC = segue.destination as! EditVC
            vc.token = token
            vc.source = source
        } else if segue.identifier == TO_TEAM_TEMP_PLAY {
            let vc: TeamTempPlayEditVC = segue.destination as! TeamTempPlayEditVC
            vc.token = token
        } else if segue.identifier == TO_TEMP_PLAY_DATE {
            let vc: TempPlayDateVC = segue.destination as! TempPlayDateVC
            vc.token = token
            vc.name = name
        }
    }
    
    private func _delete(token: String) {
        Global.instance.addSpinner(superView: self.view)
        dataService.delete(token: token, type: "team") { (success) in
            if success {
                Global.instance.removeSpinner(superView: self.view)
                if (!self.dataService.success) {
                    SCLAlertView().showError("錯誤", subTitle: "無法刪除，請稍後再試")
                }
                NotificationCenter.default.post(name: NOTIF_TEAM_UPDATE, object: nil)
            } else {
                SCLAlertView().showError("錯誤", subTitle: "無法刪除，請稍後再試")
            }
        }
    }

    @IBAction func prevBtnPressed(_ sender: Any) {
        prev()
    }
}