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
    private let sections: [String] = ["登入資料","個人資料","通訊資料","設定資料"]
    private let rows: [[String]] = [
        [NICKNAME_KEY, NAME_KEY, EMAIL_KEY],
        [SEX_KEY, DOB_KEY],
        [MOBILE_KEY, TEL_KEY],
        [VALIDATE_KEY, MEMBER_TYPE_KEY]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nicknameLbl.text = Member.instance.nickname
        sexLbl.text = SEX.enumFronString(string: Member.instance.sex).rawValue
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = UIColor.clear
        //tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        //tableView.separatorColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileVC._reloadData), name: NOTIF_MEMBER_UPDATE, object: nil)
    }
    
    @objc func _reloadData() {
        //print("notify member data update")
        self.tableView.reloadData()
        self.nicknameLbl.text = Member.instance.nickname
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UITableViewHeaderFooterView()
        view.layer.backgroundColor = UIColor.clear.cgColor
        
        return view
    }
 
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel!.font = UIFont(name: FONT_NAME, size: FONT_SIZE_TITLE)
        header.textLabel!.textColor = UIColor.white
    }
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let footer = view as! UITableViewHeaderFooterView
        let separator: UIView = UIView(frame: CGRect(x: 15, y: 0, width: footer.frame.width, height: 1))
        separator.layer.backgroundColor = UIColor("#6c6c6e").cgColor
        footer.addSubview(separator)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            //print("cell is nil")
            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "cell")
            cell?.selectionStyle = .none
        }
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let key: String = rows[indexPath.section][indexPath.row]
        let row: [String: String] = Member.instance.info[key]!
        var field: String = ""
        var data: String = ""
        if let tmp: String = row["ch"] {
            field = tmp
        }
        if let tmp: Any = Member.instance.getData(key: key) {
            let type: String = row["type"]!
            if type == "String" {
                data = tmp as! String
                if key == SEX_KEY {
                    data = Member.instance.sexShow(rawValue: data)
                }
                if data.count == 0 {
                    data = "未提供"
                }
            } else if type == "Int" {
                let tmp1 = tmp as! Int
                if key == VALIDATE_KEY {
                    data = Member.instance.validateShow(rawValue: tmp1)
                } else if key == MEMBER_TYPE_KEY {
                    data = Member.instance.typeShow(rawValue: tmp1)
                } else {
                    data = String(tmp1)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let key: String = rows[indexPath.section][indexPath.row]
        performSegue(withIdentifier: TO_EDIT_PROFILE, sender: key)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.backgroundColor = UIColor.clear.cgColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let edit: EditProfileVC = segue.destination as! EditProfileVC {
            edit.key = sender as! String
        }
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
