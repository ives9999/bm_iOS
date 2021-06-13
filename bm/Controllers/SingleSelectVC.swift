//
//  SingleSelectVC.swift
//  bm
//
//  Created by ives on 2019/5/31.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit

protocol SingleSelectDelegate: SelectDelegate {
    func singleSelected(key: String, selected: String, show: String?)
}

class SingleSelectVC: SelectVC {
    
    var selected: String? = nil
    var delegate: SingleSelectDelegate?

    override func viewDidLoad() {
        
        myTablView = tableView

        titleLbl.text = title
        let cellNib = UINib(nibName: "SingleSelectCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "cell")
        super.viewDidLoad()
//        view.layoutIfNeeded()
//        if key == nil {
//            alertError()
//        } else {
//
//
//        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //var cell: UITableViewCell = UITableViewCell()
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SingleSelectCell
        cell.titleLbl.text = rows1![indexPath.row]["title"]
        
        var checked: Bool = false
        let row = rows1![indexPath.row]
        if row["value"] == selected {
            checked = true
        }
        if checked {
            setSelectedStyle(cell)
        } else {
            unSetSelectedStyle(cell)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        submit(indexPath)
    }
    
    func submit(_ indexPath: IndexPath) {
        
        let cell: UITableViewCell = tableView.cellForRow(at: indexPath)!
        let row = rows1![indexPath.row]
        
        var cancel: Bool = false
        if selected != nil && selected!.count > 0 {
            if selected! == row["value"] {
                cancel = true
                unSetSelectedStyle(cell)
            }
        }
        if !cancel {
            if delegate != nil {
                let _key = ((key == nil) ? "" : key)!
                if (delegate != nil) {
                    delegate!.singleSelected(key: _key, selected: row["value"]!, show: nil)
                } else {
                    warning("沒有傳入代理程式，請洽管理員")
                }
            }
            setSelectedStyle(cell)
            prev()
        }
        
        
        
        
//        selected = (row["value"] == selected) ? "" : row["value"]
//        if delegate != nil {
//            delegate!.singleSelected(key: key!, selected: selected!)
//            prev()
//        } else {
//            alertError("由於傳遞參數不正確，無法做選擇，請回上一頁重新進入")
//        }
    }
    
    override func setDelegate(_ delegate: SelectDelegate) {
        self.delegate = (delegate as! SingleSelectDelegate)
    }
}
