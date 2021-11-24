//
//  DegreeSelectVC.swift
//  bm
//
//  Created by ives on 2017/11/15.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

class DegreeSelectVC: MyTableVC {

    //var degrees: [Degree] = [Degree]()
    //var degrees: [[String: Any]] = [[String: Any]]()
    //var allDegrees: [Degree] = [Degree]()
    var rows1: [DEGREE] = [DEGREE.high, DEGREE.soso, DEGREE.new]
    var delegate: BaseViewController?
    var selecteds: [DEGREE] = [DEGREE]()
    //var degrees: [DEGREE] = [DEGREE]()
    
    var source: String = "setup"
    //縣市的類型：all所有的縣市，simple比較簡單的縣市
    
    override func viewDidLoad() {
        myTablView = tableView
        super.viewDidLoad()

        //[DEGREE.new: "新手"], [DEGREE.soso: "普通"], [DEGREE.high: "高手"]
        //let tmp = DEGREE.all()
        //print(tmp)
//        for (_, item) in tmp.enumerated() {
//            allDegrees.append(Degree(value: item.key, text: item.value))
//        }
        
        tableView.register(
            SuperCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.white
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rows1.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SuperCell

        let row = rows1[indexPath.row]
        cell.textLabel!.text = row.rawValue
        
        var isChecked: Bool = false
        for selected in selecteds {
            if selected == row {
                isChecked = true
                break
            }
        }
        
        if isChecked {
            setSelectedStyle(cell)
        } else {
            unSetSelectedStyle(cell)
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell: UITableViewCell = tableView.cellForRow(at: indexPath)!
        let row = rows1[indexPath.row]
        
        if cell.accessoryType == .checkmark {
            unSetSelectedStyle(cell)
            selecteds = selecteds.filter{$0 != row}
        } else {
            setSelectedStyle(cell)
            selecteds.append(row)
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

    @IBAction func back() {
        prev()
    }
    @IBAction func cancel() {
        prev()
    }
    @IBAction func submit() {
        self.delegate?.setDegrees(res: selecteds)
        prev()
    }
}
