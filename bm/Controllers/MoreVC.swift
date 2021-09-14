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
        
    var _rows: [[Dictionary<String, Any>]] = [
        [
            ["text": "商品", "icon": "product", "segue": TO_PRODUCT, "color": UIColor(MY_LIGHT_RED)],
            ["text": "教學", "icon": "teach", "segue": TO_TEACH, "color": UIColor(MY_WHITE)],
            ["text": "教練", "icon": "coach", "segue": TO_COACH, "color": UIColor(MY_WHITE)],
            ["text": "體育用品店", "icon": "store", "segue": TO_STORE, "color": UIColor(MY_WHITE)],
            ["text": "推播訊息", "icon": "bell", "segue": TO_PN, "color": UIColor(MY_WHITE)],
            ["text": "版本", "icon": "version", "segue": "", "color": UIColor(MY_WHITE)]
        ]
    ]
    
    override func viewDidLoad() {
        myTablView = tableView
        rows = _rows
        super.viewDidLoad()
        Global.instance.setupTabbar(self)
        //Global.instance.menuPressedAction(menuBtn, self)

        tableView.register(MenuCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("show cell sections: \(indexPath.section), rows: \(indexPath.row)")
        let cell: MenuCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuCell
        //cell.delegate = self

        let row: [String: Any] = rows![indexPath.section][indexPath.row]
        cell.setRow(row: row)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("click cell sections: \(indexPath.section), rows: \(indexPath.row)")
        if (indexPath.row == _rows[0].count-1) {
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
            let row: [String: Any] = rows![indexPath.section][indexPath.row]
            //print(row)
            if row["segue"] != nil {
                let segue = row["segue"] as! String
                //print("segue: \(segue)")
                if segue == TO_PRODUCT {
                    toProduct()
                    
//                    if #available(iOS 13.0, *) {
//                        let storyboard = UIStoryboard(name: "More", bundle: nil)
//                        if let viewController = storyboard.instantiateViewController(identifier: TO_PRODUCT) as? ProductVC {
//                            //self.navigationController?.pushViewController(viewController, animated: true)
//                            //self.present(viewController, animated: true, completion: nil)
//                            viewController.modalPresentationStyle = .fullScreen
//                            show(viewController, sender: nil)
//                            //showDetailViewController(viewController, sender: nil)
//                        }
//                    } else {
//                        let viewController = self.storyboard!.instantiateViewController(withIdentifier: TO_PRODUCT) as! ProductVC
//                        self.navigationController!.pushViewController(viewController, animated: true)
//                    }
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
                    performSegue(withIdentifier: segue, sender: row["sender"])
                }
                
            }
        }
    }
}
