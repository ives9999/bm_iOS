//
//  MultiSelectVC.swift
//  bm
//
//  Created by ives on 2019/6/8.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit

protocol MultiSelectDelegate: class {
    func multiSelected(key: String, selecteds: [String])
}

class MultiSelectVC: MyTableVC {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    
    var key: String? = nil
    var rows1: [[String: String]]?
    var selecteds: [String] = [String]()
    
    var delegate: MultiSelectDelegate?

    override func viewDidLoad() {
        
        myTablView = tableView
        super.viewDidLoad()

        titleLbl.text = title
        tableView.register(
            SuperCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.white
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if rows1 != nil {
            return rows1!.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = rows1![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SuperCell
        cell.textLabel!.text = row["title"]
        var checked: Bool = false
        for selected in selecteds {
            if row["value"] == selected {
                checked = true
                break
            }
        }
        if checked {
            setSelectedStyle(cell)
        } else {
           unSetSelectedStyle(cell)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell: UITableViewCell = tableView.cellForRow(at: indexPath)!
        
        let row = rows1![indexPath.row]
        var isExist = false
        var at = 0
        for (idx, str) in selecteds.enumerated() {
            if row["value"] == str {
                isExist = true
                at = idx
                break
            }
        }
        if isExist {
            selecteds.remove(at: at)
        } else {
            selecteds.append(row["value"]!)
        }
        
        if cell.accessoryType == .checkmark {
            unSetSelectedStyle(cell)
        } else {
            setSelectedStyle(cell)
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
    
    @IBAction func submit(_ sender: Any) {
        if delegate != nil {
            delegate!.multiSelected(key: key!, selecteds: selecteds)
            prev()
        } else {
            //alertError("由於傳遞參數不正確，無法做選擇，請回上一頁重新進入")
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        prev()
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        prev()
    }

}
