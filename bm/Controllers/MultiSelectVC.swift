//
//  MultiSelectVC.swift
//  bm
//
//  Created by ives on 2019/6/8.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit

//protocol MultiSelectDelegate: SelectDelegate {
//    func multiSelected(key: String, selecteds: [String])
//}

class MultiSelectVC: SelectVC {
    
    var selecteds: [String] = [String]()
    var delegate: BaseViewController?
    

    override func viewDidLoad() {
        
        myTablView = tableView
        tableView.register(
            SuperCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.white
        super.viewDidLoad()

        titleLbl.text = title
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
    
    @IBAction func submit(_ sender: Any) {
        if delegate != nil {
            delegate!.multiSelected(key: key!, selecteds: selecteds)
            prev()
        } else {
            //alertError("由於傳遞參數不正確，無法做選擇，請回上一頁重新進入")
        }
    }
    
//    override func setDelegate(_ delegate: SelectDelegate) {
//        self.delegate = (delegate as! MultiSelectDelegate)
//    }
}
