//
//  AreaSelectVCTableViewController.swift
//  bm
//
//  Created by ives on 2018/10/22.
//  Copyright © 2018 bm. All rights reserved.
//

import UIKit

class AreaSelectVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var areas: [Area] = [Area]()
    //要顯示區域的縣市編號
    var citys: [Int] = [Int]()
    /*
     city_id:
     id:218, name:台南市, rows:
     id:1, name:a區域
     id:2, name:b區域
     */
    var citysandareas:[Int:[String:Any]] = [Int:[String:Any]]()
    
    //來源的程式：目前有team的setup跟search
    var source: String = "setup"
    //縣市的類型：all所有的縣市，simple比較簡單的縣市
    var type: String = "all"
    //選擇的類型：just one單選，multi複選
    var select: String = "just one"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        Global.instance.addSpinner(superView: self.tableView)
        
        TeamService.instance.getAreaByCityIDs(city_ids: citys,city_type: type) { (success) in
            if success {
                //print(self.citys)
                let tmp = TeamService.instance.citysandareas
                
                self.citys = [Int]()
                for (city_id, _) in tmp {
                    self.citys.append(city_id)
                }
                for city_id in self.citys {
                    for (id, item) in tmp {
                        if id == city_id {
                            self.citysandareas[id] = item
                            break
                        }
                    }
                }
                //print(self.citysandarenas)
                
                self.tableView.reloadData()
                Global.instance.removeSpinner(superView: self.tableView)
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return citysandareas.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let city_id = citys[section]
        let rows = citysandareas[city_id]!["rows"] as! [[String:Any]]
        return rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let area = getArea(indexPath)
        
        cell.textLabel!.text = "aaa"
        
        var isSelected = false
        for _area in areas {
            if _area.id == area.id {
                isSelected = true
                break
            }
        }
        if isSelected {
            setSelectedStyle(cell)
        } else {
            unSetSelectedStyle(cell)
        }
        
        return cell
    }
    
    private func getArea(_ indexPath: IndexPath)-> Arena {
        let city_id = citys[indexPath.section]
        let rows = citysandareas[city_id]!["rows"] as! [[String: Any]]
        let row = rows[indexPath.row]
        
        return Arena(id: row["id"] as! Int, name: row["name"] as! String)
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

    @IBAction func submit(_ sender: Any) {
    }
    @IBAction func prevBtnPressed(_ sender: Any) {
        prev()
    }
}
