//
//  CitySelect1VC.swift
//  bm
//
//  Created by ives on 2020/11/24.
//  Copyright © 2020 bm. All rights reserved.
//

import Foundation

class SelectCityVC: SingleSelectVC {
    
    //縣市的類型：all所有的縣市，simple比較簡單的縣市
    var type: String = "all"
    
    //get city data from database
    var citys: [City] = [City]()
    
    override class func awakeFromNib() {
        
    }
    
    override func viewDidLoad() {
        myTablView = tableView
        title = "縣市"
        super.viewDidLoad()
        
        //print(selected)
        tableView.register(
            SuperCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.white
        
        Global.instance.addSpinner(superView: view)
        TeamService.instance.getCitys(type: type) { (success) in
            if success {
                self.citys = TeamService.instance.citys
                //print(self.citys)
                self.tableView.reloadData()
                Global.instance.removeSpinner(superView: self.view)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(citys.count)
        return citys.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SuperCell

        //print(citys[indexPath.row].name)
        cell.backgroundColor = UIColor.clear
        cell.textLabel!.text = citys[indexPath.row].name
        cell.textLabel!.textColor = UIColor.white
        
        if selected != nil && selected!.count > 0 {
            if citys[indexPath.row].id == Int(selected!) {
                setSelectedStyle(cell)
            }
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell: UITableViewCell = tableView.cellForRow(at: indexPath)!
        let city: City = citys[indexPath.row]
        let city_id = city.id
        var cancel: Bool = false
        if selected != nil && selected!.count > 0 {
            if Int(selected!) == city_id {
                cancel = true
                unSetSelectedStyle(cell)
            }
        }
        if !cancel {
            if delegate != nil {
                let _key = ((key == nil) ? "" : key)!
                delegate!.singleSelected(key: _key, selected: String(city.id))
            }
            setSelectedStyle(cell)
            prev()
        }
    }
}
