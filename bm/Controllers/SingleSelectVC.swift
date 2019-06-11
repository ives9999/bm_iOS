//
//  SingleSelectVC.swift
//  bm
//
//  Created by ives on 2019/5/31.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit

protocol SingleSelectDelegate: class {
    func singleSelected(key: String, selected: String)
}

class SingleSelectVC: MyTableVC {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    
    var key: String? = nil
    var rows1: [[String: String]]?
    var selected: String? = nil
    
    var delegate: SingleSelectDelegate?

    override func viewDidLoad() {
        
        myTablView = tableView
        super.viewDidLoad()

        titleLbl.text = title
        let cellNib = UINib(nibName: "SingleSelectCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "cell")
//        view.layoutIfNeeded()
//        if key == nil {
//            alertError()
//        } else {
//
//
//        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if rows1 != nil {
            return rows1!.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //var cell: UITableViewCell = UITableViewCell()
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SingleSelectCell
        cell.titleLbl.text = rows1![indexPath.row]["title"]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        submit(indexPath)
    }
    

    func submit(_ indexPath: IndexPath) {
        
        let row = rows1![indexPath.row]
        let selected = row["value"]
        if delegate != nil {
            delegate!.singleSelected(key: key!, selected: selected!)
            prev()
        } else {
            alertError("由於傳遞參數不正確，無法做選擇，請回上一頁重新進入")
        }
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        prev()
    }

    func alertError(_ msg: String) {
        
        warning(msg: msg, buttonTitle: "回上一頁", buttonAction: {
            self.prev()})
    }
}
