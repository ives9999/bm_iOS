//
//  AreaSelectVCTableViewController.swift
//  bm
//
//  Created by ives on 2018/10/22.
//  Copyright © 2018 bm. All rights reserved.
//

import UIKit

protocol AreaSelectDelegate: class {
    func setAreasData(res: [Area])
}

class AreaSelectVC: MyTableVC {

    @IBOutlet weak var submitBtn: UIButton!
    weak var delegate: AreaSelectDelegate?
    
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
        myTablView = tableView
        super.viewDidLoad()

        submitBtn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 20, bottom: 6, right: 20)
        submitBtn.layer.cornerRadius = 12
        
        tableView.register(
            SuperCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.white
        
        let citys1: String = Global.instance.intsToStringComma(citys)
        
        Global.instance.addSpinner(superView: self.tableView)
        
        TeamService.instance.getAreaByCityIDs(city_ids: citys1,city_type: type) { (success) in
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
                //print(self.citysandareas)
                
                self.tableView.reloadData()
                Global.instance.removeSpinner(superView: self.tableView)
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return citysandareas.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.white
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: 100, height: 34))
        label.textColor = UIColor.black
        let city_id = citys[section]
        let item: [String: Any] = (citysandareas[city_id] as? [String: Any])!
        label.text = item["name"] as? String
        view.addSubview(label)
        
        return view
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let city_id = citys[section]
        let rows = citysandareas[city_id]!["rows"] as! [[String:Any]]
        return rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SuperCell
        let area = getArea(indexPath)
        
        cell.textLabel!.text = area.name
        
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Global.instance.addSpinner(superView: view)
        let area: Area = getArea(indexPath)
        //delegate?.setArenaData(id: arena.id, name: arena.title)
        if select == "just one" {
            back()
        }
        Global.instance.removeSpinner(superView: view)
        let cell: SuperCell = tableView.cellForRow(at: indexPath)! as! SuperCell
        if cell.accessoryType == .checkmark {//not select
            unSetSelectedStyle(cell)
            areas = areas.filter {$0.id != area.id}
        } else {
            setSelectedStyle(cell)
            areas.append(area)
        }
    }
    
    private func getArea(_ indexPath: IndexPath)-> Area {
        let city_id = citys[indexPath.section]
        let rows = citysandareas[city_id]!["rows"] as! [[String: Any]]
        let row = rows[indexPath.row]
        
        return Area(id: row["id"] as! Int, name: row["name"] as! String)
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
        delegate?.setAreasData(res: areas)
        back()
    }
    @IBAction func back() {
        prev()
    }
}
