//
//  ProfileVC.swift
//  bm
//
//  Created by ives on 2017/11/6.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class ProfileVC: MyTableVC {

    @IBOutlet weak var nicknameLbl: UILabel!
    @IBOutlet weak var sexLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    let _sections: [String]? = ["登入資料","個人資料","通訊資料","設定資料"]
    let _rows: [[String]] = [
        [NICKNAME_KEY, NAME_KEY, EMAIL_KEY],
        [SEX_KEY, DOB_KEY],
        [MOBILE_KEY, TEL_KEY],
        [VALIDATE_KEY, MEMBER_TYPE_KEY]
    ]
    
    override func viewDidLoad() {
        sections = _sections
        myTablView = tableView
        super.viewDidLoad()

//        nicknameLbl.text = Member.instance.nickname
//        sexLbl.text = SEX.enumFromString(string: Member.instance.sex).rawValue
        
        //Global.instance.addSpinner(superView: view)
        //Global.instance.removeSpinner(superView: view)
    }
    override func viewDidAppear(_ animated: Bool) {
        refresh()
    }
    
    override func refresh() {
        //print("notify member data update")
        self.tableView.reloadData()
        self.nicknameLbl.text = Member.instance.nickname
        sexLbl.text = SEX.enumFromString(string: Member.instance.sex).rawValue
        if self.refreshControl.isRefreshing {
            self.refreshControl.endRefreshing()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int?
        count = _rows[section].count
        return count!
    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        print(sections![section])
//        return sections![section]
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            //print("cell is nil")
            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "cell")
            cell?.selectionStyle = .none
        }
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let key: String = _rows[indexPath.section][indexPath.row]
        let row: [String: String] = Member.instance.info[key]!
        //print(key)
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
                } else if key == MOBILE_KEY {
                    if Member.instance.mobile.count > 0 {
                        data = Member.instance.mobile.mobileShow()
                    }
                } else if key == TEL_KEY {
                    if Member.instance.tel.count > 0 {
                        data = Member.instance.tel.telShow()
                    }
                }
                if data.count == 0 {
                    data = "未提供"
                }
            } else if type == "Int" {
                let tmp1 = tmp as! Int
                if key == VALIDATE_KEY {
                    let res: [String] = Member.instance.validateShow(rawValue: tmp1)
                    data = res.joined(separator: ",")
                } else if key == MEMBER_TYPE_KEY {
                    data = Member.instance.typeShow(rawValue: tmp1)
                } else {
                    data = String(tmp1)
                }
            }
        }
        cell!.textLabel!.text = "\(field)"
        cell!.detailTextLabel!.text = "\(data)"
        if key == "validate" || key == "type" {
            cell?.accessoryType = UITableViewCellAccessoryType.none
        } else {
            cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        return cell!
       
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let key: String = _rows[indexPath.section][indexPath.row]
        if key != "validate" && key != "type" {
            performSegue(withIdentifier: TO_EDIT_PROFILE, sender: key)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.backgroundColor = UIColor.clear.cgColor
        cell.textLabel!.textColor = UIColor.white
        cell.detailTextLabel!.textColor = UIColor.white
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc: EditProfileVC = segue.destination as! EditProfileVC
        vc.key = sender as! String
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
