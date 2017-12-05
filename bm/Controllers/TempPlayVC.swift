//
//  TempPlayVC.swift
//  bm
//
//  Created by ives on 2017/10/25.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class TempPlayVC: MyTableVC {

    // outlets
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var model: Team!
    
    override func viewDidLoad() {
        model = Team.instance
        sections = model.temp_play_list_sections
        myTablView = tableView
        super.viewDidLoad()
        
        Global.instance.setupTabbar(self)
        Global.instance.menuPressedAction(menuBtn, self)
        
        if Member.instance.isLoggedIn {
            NotificationCenter.default.post(name: NOTIF_MEMBER_DID_CHANGE, object: nil)
        }
        
        Global.instance.addSpinner(superView: self.view)
        TeamService.instance.tempPlay_list { (success) in
            if success {
                Global.instance.removeSpinner(superView: self.view)
                //print(self.model.list)
                self.tableView.reloadData()
            }
        }
        tableView.register(TeamTempPlayListCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(model.list.count)
        return model.list.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //print("section: \(indexPath.section), row: \(indexPath.row)")
        let cell: TeamTempPlayListCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TeamTempPlayListCell
        let row: Dictionary<String, [String: Any]> = model.list[indexPath.row]
        cell.forRow(row: row)
        
        return cell
    }
}
