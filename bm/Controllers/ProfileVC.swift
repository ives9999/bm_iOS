//
//  ProfileVC.swift
//  bm
//
//  Created by ives on 2017/11/6.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var nicknameLbl: UILabel!
    @IBOutlet weak var sexLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    private let arrs = [
    ["基本資料" : ["帳號","姓名","EMmal"]
    ]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nicknameLbl.text = Member.instance.nickname
        sexLbl.text = SEX.enumFronString(string: Member.instance.sex).rawValue
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrs.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items: Dictionary<String, Any> = arrs[section] as? Dictionary else { return 0 }
        var count = 0
        for key in items.keys {
            guard let arrs = items[key] as? NSArray else { return 0 }
            count = arrs.count
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            //print("cell is nil")
            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "cell")
        }
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell!.textLabel!.text = "\(arrs[indexPath.row])"
        cell!.textLabel!.textColor = UIColor.white
        cell!.detailTextLabel!.text = "test"
        cell!.detailTextLabel!.textColor = UIColor.white
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        return cell!
       
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.backgroundColor = UIColor.clear.cgColor
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func getValues(section: Int) -> NSArray {
        
    }
}
