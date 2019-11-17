//
//  SelectVC.swift
//  bm
//
//  Created by ives on 2019/6/21.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit

protocol SelectDelegate: class {}

class SelectVC: MyTableVC {
    
    @IBOutlet weak var titleLbl: UILabel!
    
    var key: String? = nil
    var rows1: [[String: String]]?
    let session: UserDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if key != nil && key == CITY_KEY {
            getCitys()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if rows1 != nil {
            return rows1!.count
        } else {
            return 0
        }
    }
    
    func setSelectedStyle(_ cell: UITableViewCell) {
        cell.accessoryType = .checkmark
        cell.textLabel?.textColor = UIColor(MY_GREEN)
        cell.tintColor = UIColor(MY_GREEN)
    }
    
    func unSetSelectedStyle(_ cell: UITableViewCell) {
        cell.accessoryType = .none
        cell.textLabel?.textColor = UIColor.white
        cell.tintColor = UIColor.white
    }

    func getCitys() {
        Global.instance.addSpinner(superView: view)
        DataService.instance1.getCitys() { (success) in
            if success {
                let citys = DataService.instance1.citys
                self.rows1 = [[String: String]]()
                for city in citys {
                    self.rows1!.append(["title": city.name, "value": String(city.id)])
                }
                self.session.set(self.rows1, forKey: "citys")
                self.tableView.reloadData()
            }
            Global.instance.removeSpinner(superView: self.view)
        }
    }
    
    func setDelegate(_ delegate: SelectDelegate) {}
    
    @IBAction func cancel(_ sender: Any) {
        prev()
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        prev()
    }
    
    func alertError(_ msg: String) {
        
        warning(msg: msg, buttonTitle: "回上一頁", buttonAction: {
            self.prev()})
    }
}
