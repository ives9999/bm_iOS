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
        ["text": "編輯", "icon": "edit1", "segue": TO_TEAM_SUBMIT],
        ["text": "臨打編輯", "icon": "tempplayedit", "segue": TO_TEAM_TEMP_PLAY],
        ["text": "每次臨打名單", "icon": "tempplaylist", "segue": TO_TEAM_TEMP_PLAY],
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var iden: String = ""
        if indexPath.row == 0 {
            iden = TO_TEAM_SUBMIT
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
                self._deleteTeam(token: self.token)
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
        if segue.identifier == TO_TEAM_SUBMIT {
            let vc: TeamSubmitVC = segue.destination as! TeamSubmitVC
            vc.token = token
        } else if segue.identifier == TO_TEAM_TEMP_PLAY {
            let vc: TeamTempPlayEditVC = segue.destination as! TeamTempPlayEditVC
            vc.token = token
        } else if segue.identifier == TO_TEMP_PLAY_DATE {
            let vc: TempPlayDateVC = segue.destination as! TempPlayDateVC
            vc.token = token
            vc.name = name
        }
    }
    
    private func _deleteTeam(token: String) {
        Global.instance.addSpinner(superView: self.view)
        DataService.instance.delete(token: token, type: "team") { (success) in
            if success {
                Global.instance.removeSpinner(superView: self.view)
                if (!DataService.instance.success) {
                    SCLAlertView().showError("錯誤", subTitle: "無法刪除球隊，請稍後再試")
                }
                NotificationCenter.default.post(name: NOTIF_TEAM_UPDATE, object: nil)
            } else {
                SCLAlertView().showError("錯誤", subTitle: "無法刪除球隊，請稍後再試")
            }
        }
    }

    @IBAction func prevBtnPressed(_ sender: Any) {
        prev()
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
