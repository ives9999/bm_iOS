//
//  ManagerSignup.swift
//  bm
//
//  Created by ives on 2021/12/19.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class ManagerSignupVC: MyTableVC {
    
    var managerRows: [MemberRow] = [MemberRow]()
    var able_token: String = ""
    
    override func viewDidLoad() {
        myTablView = tableView
        //rows = _rows
        super.viewDidLoad()
        //Global.instance.setupTabbar(self)
        //Global.instance.menuPressedAction(menuBtn, self)

        tableView.register(MenuCell.self, forCellReuseIdentifier: "cell")
        
        managerRows = initRows()
    }
    
    func initRows()-> [MemberRow] {
        
        var rows: [MemberRow] = [MemberRow]()
        
        return rows
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return managerRows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("show cell sections: \(indexPath.section), rows: \(indexPath.row)")
        let cell: MenuCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuCell
        //cell.delegate = self

        let row: MemberRow = managerRows[indexPath.row]
        
        //let row: [String: Any] = rows![indexPath.section][indexPath.row]
        cell.setRow(row: row)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("click cell sections: \(indexPath.section), rows: \(indexPath.row)")
        let row: MemberRow = managerRows[indexPath.row]
        let segue = row.segue
        
        if segue == TO_MANAGER_SIGNUPLIST {
            toSignupList(able_type: able_type, able_token: able_token, isLast: true)
        } else if segue == TO_TEACH {
            toTeach()
            //toShowTeach(token: "")
        }else if segue == TO_COACH {
            toCoach()
        }else if segue == TO_STORE {
            toStore()
        } else {
            //performSegue(withIdentifier: segue, sender: row["sender"])
        }
    }
}
