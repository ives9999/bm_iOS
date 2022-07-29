//
//  TeamManagerVC.swift
//  bm
//
//  Created by ives on 2018/5/21.
//  Copyright © 2018年 bm. All rights reserved.
//

import UIKit
import SCLAlertView

class ManagerVC: MyTableVC {

    @IBOutlet weak var titleLbl: UILabel!
    
    var name: String? = nil
    var token: String? = nil
    var manager_token: String? = nil
    
    override func viewDidLoad() {
        myTablView = tableView
        if (manager_token != nil) {
            params["manager_token"] = manager_token!
        }
        //必須指定status，預設是只會出現上線的
        params["status"] = "online,offline"
        
        super.viewDidLoad()
        
        addBtn.visibility = .visible
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return lists1.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    override func cellDelete(row: Table) {
        
        warning(msg: "是否確定要刪除此筆資料？", closeButtonTitle: "取消", buttonTitle: "刪除", buttonAction: {
            self._delete(token: row.token)
        })
    }
    
    func _delete(token: String) {
        Global.instance.addSpinner(superView: self.view)
        dataService.delete(token: token, type: able_type) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if success {
//                if (!self.dataService.success) {
//                    self.warning("無法刪除，請稍後再試")
//                }
//                NotificationCenter.default.post(name: NOTIF_TEAM_UPDATE, object: nil)
                self.refresh()
            } else {
                self.warning(self.dataService.msg)
            }
        }
    }
    
    override func cellRefresh() {
        refresh()
    }
}
