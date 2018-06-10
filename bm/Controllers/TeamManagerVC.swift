//
//  TeamManagerVC.swift
//  bm
//
//  Created by ives on 2018/5/21.
//  Copyright © 2018年 bm. All rights reserved.
//

import UIKit

class TeamManagerVC: MyTableVC {

    @IBOutlet weak var addTeamBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        myTablView = tableView 
        super.viewDidLoad()

        addTeamBtn.layer.cornerRadius = 12
        tableView.register(MenuCell.self, forCellReuseIdentifier: "cell")
        //refresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refresh()
    }
    
    override func refresh() {
        getTeamManagerList()
    }
    func getTeamManagerList() {
        if Member.instance.isLoggedIn {
            _getTeamManagerList() { (success) in
                if (success) {
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                } else {
                    self.warning(self.msg)
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamManagerLists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("show cell sections: \(indexPath.section), rows: \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuCell
        //print(rows)
        
        let row: List = teamManagerLists[indexPath.row]
        //print(row)
        cell.textLabel!.text = row.title
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row: List = teamManagerLists[indexPath.row]
        let name: String = row.title
        let token: String = row.token
        let sender:[String: String] = ["name": name, "token": token]
        performSegue(withIdentifier: TO_TEAM_MANAGER_FUNCTION, sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == TO_TEAM_MANAGER_FUNCTION {
            let vc: TeamManagerFunctionVC = segue.destination as! TeamManagerFunctionVC
            let row: [String: String] = sender as! [String: String]
            vc.name = row["name"]!
            vc.token = row["token"]!
        }
    }

    @IBAction func prevBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func addTeamBtnPressed(_ sender: Any) {
        if !Member.instance.isLoggedIn {
            SCLAlertView().showError("警告", subTitle: "請先登入為會員")
        } else {
            performSegue(withIdentifier: TO_TEAM_SUBMIT, sender: nil)
        }
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
