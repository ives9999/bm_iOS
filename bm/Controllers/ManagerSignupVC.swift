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
    
    override func viewDidLoad() {
        myTablView = tableView
        //rows = _rows
        super.viewDidLoad()
        Global.instance.setupTabbar(self)
        //Global.instance.menuPressedAction(menuBtn, self)

        tableView.register(MenuCell.self, forCellReuseIdentifier: "cell")
        
        managerRows = initRows()
    }
    
    func initRows()-> [MemberRow] {
        
        var rows: [MemberRow] = [MemberRow]()
        
        let r1: MemberRow = MemberRow(title: "商品", icon: "product", segue: TO_PRODUCT)
        r1.color = UIColor(MY_LIGHT_RED)
        rows.append(r1)
        
        let r2: MemberRow = MemberRow(title: "教學", icon: "teach", segue: TO_TEACH)
        rows.append(r2)
        
        let r3: MemberRow = MemberRow(title: "教練", icon: "coach", segue: TO_COACH)
        rows.append(r3)
        
        let r4: MemberRow = MemberRow(title: "體育用品店", icon: "store", segue: TO_STORE)
        rows.append(r4)
        
        let r5: MemberRow = MemberRow(title: "推播訊息", icon: "bell", segue: TO_PN)
        rows.append(r5)
        
        let r6: MemberRow = MemberRow(title: "版本", icon: "version")
        rows.append(r6)
        
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
}
