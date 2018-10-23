//
//  ArenaVC.swift
//  bm
//
//  Created by ives on 2017/11/13.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

protocol ArenaSelectDelegate: class {
    func setArenaData(id: Int, name: String)
    func setArenasData(res: [Arena])
}

class ArenaSelectVC: UITableViewController {
    
    var arenas: [Arena] = [Arena]()
    
    //要顯示球館的縣市編號
    var citys: [Int] = [Int]()
    /*
     city_id:
        id:218, name:台南市, rows:
            id:1, name:a羽球館
            id:2, name:b羽球館
    */
    var citysandarenas:[Int:[String:Any]] = [Int:[String:Any]]()
    
    weak var delegate: ArenaSelectDelegate?
    
    //來源的程式：目前有team的setup跟search
    var source: String = "setup"
    //縣市的類型：all所有的縣市，simple比較簡單的縣市
    var type: String = "all"
    //選擇的類型：just one單選，multi複選
    var select: String = "just one"

    override func viewDidLoad() {
        super.viewDidLoad()
        //print(citys)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(back))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        
        if select == "multi" {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "提交", style: .plain, target: self, action: #selector(submit))
            navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        }
        
        //print(citys)
        Global.instance.addSpinner(superView: self.tableView)
        
        TeamService.instance.getArenaByCityIDs(city_ids: citys,city_type: type) { (success) in
            if success {
                //self.arenas = TeamService.instance.arenas
                //print(self.citys)
                let tmp = TeamService.instance.citysandarenas
                
                self.citys = [Int]()
                for (city_id, _) in tmp {
                    self.citys.append(city_id)
                }
                for city_id in self.citys {
                    for (id, item) in tmp {
                        if id == city_id {
                            self.citysandarenas[id] = item
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
    
    @objc func submit() {
        delegate?.setArenasData(res: arenas)
        back()
    }
    
    @objc func back() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return citysandarenas.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let city_id = citys[section]
        let rows = citysandarenas[city_id]!["rows"] as! [[String:Any]]
        return rows.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let city_id = citys[section]
        let item = citysandarenas[city_id] as! [String: Any]
        return (item["name"] as! String)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let arena = getArena(indexPath)
    
        cell.textLabel!.text = arena.title
        var isSelected = false
        for _arena in arenas {
            if _arena.id == arena.id {
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
        let arena: Arena = getArena(indexPath)
        delegate?.setArenaData(id: arena.id, name: arena.title)
        if select == "just one" {
            back()
        }
        Global.instance.removeSpinner(superView: view)
        let cell: UITableViewCell = tableView.cellForRow(at: indexPath)!
        if cell.accessoryType == .checkmark {//not select
            unSetSelectedStyle(cell)
            arenas = arenas.filter {$0.id != arena.id}
        } else {
            setSelectedStyle(cell)
            arenas.append(arena)
        }
    }
    
    private func getArena(_ indexPath: IndexPath)-> Arena {
        let city_id = citys[indexPath.section]
        let rows = citysandarenas[city_id]!["rows"] as! [[String: Any]]
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
