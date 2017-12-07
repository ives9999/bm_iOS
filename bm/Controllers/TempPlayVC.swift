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
    let cell_constant: TEAM_TEMP_PLAY_CELL = TEAM_TEMP_PLAY_CELL()
    
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
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(model.list.count)
        return model.list.count
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cell_constant.height
     }
 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //print("section: \(indexPath.section), row: \(indexPath.row)")
        let cell: TeamTempPlayListCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TeamTempPlayListCell
        let row: Dictionary<String, [String: Any]> = model.list[indexPath.row]
        cell.forRow(row: row)
        
        return cell
    }
}
