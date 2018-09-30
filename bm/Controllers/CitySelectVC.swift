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


class CitySelectVC: UITableViewController {
    
    var citys: [City] = [City]()
    var selects: [Int] = [Int]()
    weak var delegate: CitySelectDelegate?
    var city_id: Int = -1
    var type: String = "all"
    var select: String = "just one"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(city_id)
        
        if city_id > 0 {
            selects.append(city_id)
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(back))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        
        if select == "multi" {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "提交", style: .plain, target: self, action: #selector(submit))
            navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        }
        
        Global.instance.addSpinner(superView: self.tableView)
        if type == "all" {
            TeamService.instance.getAllCitys { (success) in
                if success {
                    self.citys = TeamService.instance.citys
                    //print(self.citys)
                    self.tableView.reloadData()
                    Global.instance.removeSpinner(superView: self.tableView)
                }
            }
        } else if type == "simple" {
            TeamService.instance.getCustomCitys { (success) in
                if success {
                    self.citys = TeamService.instance.citys
                    //print(self.citys)
                    self.tableView.reloadData()
                    Global.instance.removeSpinner(superView: self.tableView)
                }
            }
        }
    }
    
    @objc func submit() {
        //print(days)
        var isSelected: Bool = false
        var res: [City] = [City]()
        for city in citys {
            //print(day)
            for id in selects {
                if id == city.id {
                    res.append(city)
                    isSelected = true
                }
            }
        }
        if !isSelected {
            if select == "just one" {
                SCLAlertView().showWarning("警告", subTitle: "沒有選擇星期日期，或請按取消回上一頁")
            } else {
                self.delegate?.setCitysData(res: res)
                back()
            }
        } else {
            self.delegate?.setCitysData(res: res)
            back()
        }
    }
    
    @objc func back() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(citys.count)
        return citys.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        //print(citys[indexPath.row].name)
        cell.textLabel!.text = citys[indexPath.row].name
        cell.textLabel!.textColor = UIColor.white
        
        for id in selects {
            if id == citys[indexPath.row].id {
                setSelectedStyle(cell)
            }
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Global.instance.addSpinner(superView: view)
        let city: City = citys[indexPath.row]
        delegate?.setCityData(id: city.id, name: city.name)
        if select == "just one" {
            back()
        }
        Global.instance.removeSpinner(superView: view)
        let city_id = city.id
        let cell: UITableViewCell = tableView.cellForRow(at: indexPath)!
        if cell.accessoryType == .checkmark {//not select
            unSetSelectedStyle(cell)
            selects = selects.filter {$0 != city_id}
        } else {
            setSelectedStyle(cell)
            selects.append(city_id)
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
