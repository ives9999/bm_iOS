//
//  MoreVC.swift
//  bm
//
//  Created by ives on 2017/12/23.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import SCLAlertView

class MoreVC: MyTableVC {
    
    var moreRows: [MemberRow] = [MemberRow]()
        
//    var _rows: [[Dictionary<String, Any>]] = [
//        [
//            ["text": "商品", "icon": "product", "segue": TO_PRODUCT, "color": UIColor(MY_LIGHT_RED)],
//            ["text": "教學", "icon": "teach", "segue": TO_TEACH, "color": UIColor(MY_WHITE)],
//            ["text": "教練", "icon": "coach", "segue": TO_COACH, "color": UIColor(MY_WHITE)],
//            ["text": "體育用品店", "icon": "store", "segue": TO_STORE, "color": UIColor(MY_WHITE)],
//            ["text": "推播訊息", "icon": "bell", "segue": TO_PN, "color": UIColor(MY_WHITE)],
//            ["text": "版本", "icon": "version", "segue": "", "color": UIColor(MY_WHITE)]
//        ]
//    ]
    
    override func viewDidLoad() {
        myTablView = tableView
        //rows = _rows
        super.viewDidLoad()
        Global.instance.setupTabbar(self)
        //Global.instance.menuPressedAction(menuBtn, self)

        tableView.register(MenuCell.self, forCellReuseIdentifier: "cell")
        
        moreRows = initMoreRows()
    }
    
    func initMoreRows()-> [MemberRow] {
        
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
        
        return moreRows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("show cell sections: \(indexPath.section), rows: \(indexPath.row)")
        let cell: MenuCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuCell
        //cell.delegate = self

        let row: MemberRow = moreRows[indexPath.row]
        
        //let row: [String: Any] = rows![indexPath.section][indexPath.row]
        cell.setRow(row: row)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("click cell sections: \(indexPath.section), rows: \(indexPath.row)")
        if (indexPath.row == moreRows.count-1) {
            //First get the nsObject by defining as an optional anyObject
            let nsObject: Any? = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
            
            //Then just cast the object as a String, but be careful, you may want to double check for nil
            let version = nsObject as! String
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: true
            )
            let alert = SCLAlertView(appearance: appearance)
            alert.showInfo(version, subTitle: "")
        } else {
            let row: MemberRow = moreRows[indexPath.row]
            let segue = row.segue
            if segue == TO_PRODUCT {
                toProduct()
            } else if segue == TO_PN {
                toShowPNVC()
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
}
