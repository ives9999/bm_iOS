//
//  TempPlayDateVC.swift
//  bm
//
//  Created by ives on 2018/6/22.
//  Copyright © 2018年 bm. All rights reserved.
//

import UIKit

class TempPlayDateVC: MyTableVC {

    @IBOutlet weak var titleLbl: UILabel!
    
    var token: String = ""
    var name: String = ""
    var tempPlayDates: Array<String> = Array()
    
    override func viewDidLoad() {
        myTablView = tableView
        super.viewDidLoad()

        titleLbl.text = name + "開放臨打日期"
        tableView.register(SuperCell.self, forCellReuseIdentifier: "cell")
        refresh()
    }
    
    override func refresh() {
        Global.instance.addSpinner(superView: self.view)
        TeamService.instance.tempPlay_date(token: token) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            self.endRefresh()
            if success {
                self.tempPlayDates = TeamService.instance.tempPlayDates
                //print(self.tempPlayDates)
                self.tableView.reloadData()
            } else {
                self.warning(TeamService.instance.msg)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempPlayDates.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let date: String = tempPlayDates[indexPath.row]
        cell.textLabel?.text = date
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let date = tempPlayDates[indexPath.row]
        let sender: [String: String] = ["token":token,"date":date]
        performSegue(withIdentifier: TO_TEMP_PLAY_DATE_PLAYER, sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc: TempPlayDatePlayerVC = segue.destination as! TempPlayDatePlayerVC
        let row: [String: String] = sender as! [String: String]
        vc.teamToken = row["token"]!
        vc.date = row["date"]!
        vc.teamName = name
    }

    @IBAction func prevBtnPressed(_ sender: Any) {
        prev()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
