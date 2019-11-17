//
//  TempPlayLIstVC.swift
//  bm
//
//  Created by ives on 2018/6/22.
//  Copyright © 2018年 bm. All rights reserved.
//

import UIKit

class TempPlayDatePlayerVC: MyTableVC, TempPlayDatePlayerCellDelegate {

    @IBOutlet weak var titleLbl: UILabel!
    
    var date: String = ""
    var teamToken: String = ""
    var teamName: String = ""
    var tempPlayDatePlayer: TempPlayDatePlayer = TempPlayDatePlayer()
    
    override func viewDidLoad() {
        myTablView = tableView
        super.viewDidLoad()

        //print(token)
        //print(date)
        titleLbl.text = teamName + date + "臨打"
        tableView.register(TempPlayDatePlayerCell.self, forCellReuseIdentifier: "cell")
        refresh()
    }
    
    override func refresh() {
        Global.instance.addSpinner(superView: self.view)
        TeamService.instance.tempPlay_datePlayer(date: date, token: teamToken) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            self.endRefresh()
            if success {
                self.tempPlayDatePlayer = TeamService.instance.tempPlayDatePlayer
                //print(self.tempPlayDatePlayer.rows)
                self.tableView.reloadData()
            } else {
                self.warning(TeamService.instance.msg)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempPlayDatePlayer.rows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TempPlayDatePlayerCell
        let row = tempPlayDatePlayer.rows[indexPath.row]
        cell.setRow(row: row, position: indexPath.row)
        cell.tempPlayDatePlayerCellDelegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = tempPlayDatePlayer.rows[indexPath.row]
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: true
        )
        let alert = SCLAlertView(appearance: appearance)
        alert.addButton("加入黑名單", action: {
            self.addBlackList(memberName: row.name, memberToken: row.token, teamToken: self.teamToken)
        })
        alert.showInfo("動作")
    }
    
    func call(position: Int) {
        //print(position)
        let row = tempPlayDatePlayer.rows[position]
        let mobile: String = row.mobile
        mobile.makeCall()
    }
    @IBAction func prevBtnPressed(_ sender: Any) {
        prev()
    }
}
