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
}


class CitySelectVC: UITableViewController {
    
    var citys: [City] = [City]()
    weak var delegate: CitySelectDelegate?
    var city_id: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(city_id)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(back))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        
        Global.instance.addSpinner(superView: self.tableView)
        DataService.instance.getAllCitys { (success) in
            if success {
                self.citys = DataService.instance.citys
                //print(self.citys)
                self.tableView.reloadData()
                Global.instance.removeSpinner(superView: self.tableView)
            }
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
        if city_id == citys[indexPath.row].id {
            cell.textLabel?.textColor = UIColor(MY_GREEN)
        } else {
            cell.textLabel!.textColor = UIColor.white
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city: City = citys[indexPath.row]
        delegate?.setCityData(id: city.id, name: city.name)
        back()
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
