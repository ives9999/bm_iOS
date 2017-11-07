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
    private let sections: [String] = ["登入資料","個人資料","通訊資料"]
    private let rows: [[Dictionary<String, [String: String]>]] = [
        [
            [NICKNAME_KEY: ["text": "暱稱", "type": "String"]],
            [NAME_KEY: ["text": "姓名", "type": "String"]],
            [EMAIL_KEY: ["text": "EMail", "type": "String"]]
        ],
        [
            [SEX_KEY: ["text": "性別", "type": "String"]],
            [DOB_KEY: ["text": "生日", "type": "String"]]
        ],
        [
            [MOBILE_KEY: ["text": "行動電話", "type": "String"]],
            [TEL_KEY: ["text": "市內電話", "type": "String"]]
        ]
    ]
    
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
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*
        guard let items: Dictionary<String, Any> = arrs[section] as? Dictionary else { return 0 }
        var count = 0
        for key in items.keys {
            guard let arrs = items[key] as? NSArray else { return 0 }
            count = arrs.count
        }
 */
        
        
        return rows[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UITableViewHeaderFooterView()
        view.layer.backgroundColor = UIColor.clear.cgColor
        
        return view
    }
 
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel!.font = UIFont(name: FONT_NAME, size: FONT_SIZE_TITLE)
        header.textLabel!.textColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            //print("cell is nil")
            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "cell")
        }
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let row: Dictionary<String, [String: String]> = rows[indexPath.section][indexPath.row]
        var field: String = ""
        var data: String = ""
        for (key, value) in row {
            if let tmp: String = value["text"] {
                field = tmp
            }
            if let tmp: Any = Member.instance.getData(key: key) {
                let type: String = value["type"]!
                if type == "String" {
                    data = tmp as! String
                } else if type == "Int" {
                    data = String(tmp as! Int)
                }
            }
        }
        
        cell!.textLabel!.text = "\(field)"
        cell!.textLabel!.textColor = UIColor.white
        cell!.detailTextLabel!.text = "\(data)"
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
    
    /*
    private func getValues(section: Int) -> NSArray {
        
    }
 */
}
