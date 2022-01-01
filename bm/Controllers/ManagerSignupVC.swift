//
//  ManagerSignup.swift
//  bm
//
//  Created by ives on 2021/12/19.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class ManagerSignupVC: MyTableVC {
    
    @IBOutlet weak var titleLbl: UILabel!
    
    var managerRows: [MemberRow] = [MemberRow]()
    var able_token: String = ""
    var able_title: String = ""
    
    override func viewDidLoad() {
        myTablView = tableView
        //rows = _rows
        super.viewDidLoad()
        
        titleLbl.text = able_title + "報名管理"
//        titleLbl.font = UIFont(name: FONT_BOLD_NAME, size: FONT_SIZE_TITLE)
//        titleLbl.setTextColor(UIColor.black)

        tableView.register(MenuCell.self, forCellReuseIdentifier: "cell")
        
        managerRows = initRows()
        //print(able_token)
    }
    
    func initRows()-> [MemberRow] {
        
        var rows: [MemberRow] = [MemberRow]()
        
        var tmp: String = "臨打報名列表"
        if (able_type == "course") {
            tmp = "課程報名管理"
        }
        let r1: MemberRow = MemberRow(title: tmp, icon: "signup", segue: TO_MANAGER_SIGNUPLIST)
        r1.color = UIColor(MY_WEIGHT_RED)
        rows.append(r1)
        
        let r2: MemberRow = MemberRow(title: "黑名單", icon: "blacklist", segue: TO_BLACKLIST)
        r2.color = UIColor(MY_LIGHT_WHITE)
        rows.append(r2)
        
        return rows
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
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
            toManagerSignupList(able_type: able_type, able_token: able_token, able_title: able_title)
        }
    }
}
