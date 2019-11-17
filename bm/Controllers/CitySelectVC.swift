//
//  CityVC.swift
//  bm
//
//  Created by ives on 2017/11/13.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

protocol CitySelectDelegate: class {
    func setCityData(id: Int, name: String)
    func setCitysData(res: [City])
}


class CitySelectVC: MyTableVC {
        
    weak var delegate: CitySelectDelegate?
    var citys: [City] = [City]()
    //var selects: [Int] = [Int]()
    
    //get city data from database
    var allCitys: [City] = [City]()
    //from source
    var city_id: Int = -1
    
    //來源的程式：目前有team的setup跟search
    var source: String = "setup"
    //縣市的類型：all所有的縣市，simple比較簡單的縣市
    var type: String = "all"
    //選擇的類型：just one單選，multi複選
    var select: String = "just one"
    
    override func viewDidLoad() {
        myTablView = tableView
        super.viewDidLoad()
        //print(city_id)
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(back))
//        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
//
//        if select == "multi" {
//            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "提交", style: .plain, target: self, action: #selector(submit))
//            navigationItem.rightBarButtonItem?.tintColor = UIColor.black
//        }
        
        tableView.register(
            SuperCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.white
        
        Global.instance.addSpinner(superView: view)
        TeamService.instance.getCitys(type: type) { (success) in
            if success {
                self.allCitys = TeamService.instance.citys
                //print(self.citys)
                self.tableView.reloadData()
                Global.instance.removeSpinner(superView: self.view)
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(citys.count)
        return allCitys.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SuperCell

        //print(citys[indexPath.row].name)
        cell.backgroundColor = UIColor.clear
        cell.textLabel!.text = allCitys[indexPath.row].name
        cell.textLabel!.textColor = UIColor.white
        
        for city in citys {
            if city.id == allCitys[indexPath.row].id {
                setSelectedStyle(cell)
            }
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Global.instance.addSpinner(superView: view)
        let city: City = allCitys[indexPath.row]
        delegate?.setCityData(id: city.id, name: city.name)
        if select == "just one" {
            prev()
        }
        Global.instance.removeSpinner(superView: view)
        let city_id = city.id
        let cell: UITableViewCell = tableView.cellForRow(at: indexPath)!
        if cell.accessoryType == .checkmark {//not select
            unSetSelectedStyle(cell)
            citys = citys.filter {$0.id != city_id}
        } else {
            setSelectedStyle(cell)
            citys.append(city)
        }
        //print(selects)
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
    
    @IBAction func submit(sender: UIButton) {
        self.delegate?.setCitysData(res: citys)
        prev()
    }
    
    @IBAction func cancel(_ sender: Any) {
        prev()
    }
    
    @IBAction func back(_ sender: Any) {
        prev()
    }
}
