//
//  StatusSelectVC.swift
//  bm
//
//  Created by ives on 2018/12/7.
//  Copyright © 2018 bm. All rights reserved.
//

import UIKit

protocol StatusSelectDelegate: class {
    func setStatusData(res: STATUS, indexPath: IndexPath?)
}

class StatusSelectVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    
    var selected: STATUS?
    var delegate: StatusSelectDelegate?
    
    var indexPath: IndexPath?
    var allStatuses: [[String: Any]] = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "狀態"
        
        allStatuses = STATUS.all()
        
        let cellNib = UINib(nibName: "StatusSelectCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "cell")
    }
    
    @objc func submit() {
        
        self.delegate?.setStatusData(res: selected!, indexPath: indexPath)
        prev()
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        prev()
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allStatuses.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StatusSelectCell
        
        let statusDict = allStatuses[indexPath.row]
        
        var thisStatusType: STATUS?
        if statusDict["value"] != nil {
            thisStatusType = (statusDict["value"] as! STATUS)
        }
        if statusDict["ch"] != nil {
            cell.statusLbl.text = (statusDict["ch"] as! String)
        }
        
        if thisStatusType == selected {
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = UIColor(MY_GREEN)
            cell.tintColor = UIColor(MY_GREEN)
        } else {
            cell.accessoryType = .none
            cell.textLabel?.textColor = UIColor.white
            cell.tintColor = UIColor.white
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)!
        if cell.accessoryType == .checkmark {
            cell.accessoryType = .none
            cell.textLabel?.textColor = UIColor.white
            cell.tintColor = UIColor.white
        } else {
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = UIColor(MY_GREEN)
            cell.tintColor = UIColor(MY_GREEN)
        }
        
        let statusDict = allStatuses[indexPath.row]
        var statusType: STATUS?
        if statusDict["value"] != nil {
            statusType = (statusDict["value"] as! STATUS)
        }
        if statusType == selected {
            selected = nil
        } else {
            selected = statusType
        }
        submit()
    }
}
