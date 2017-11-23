//
//  MenuVC.swift
//  bm
//
//  Created by ives on 2017/10/25.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class MenuVC: MyTableVC {

    // outlets
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var registerIcon: UIImageView!
    @IBOutlet weak var forgetPasswordIcon: UIImageView!
    @IBOutlet weak var forgetPasswordBtn: UIButton!
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){}
    @IBOutlet weak var nicknameLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var myTeamLists: [List] = [List]()
    let _sections: [String] = ["帳戶", "登錄"]
    var _rows: [[Dictionary<String, Any>]] = [
        [
            ["text": "帳戶資料", "icon": "account", "segue": TO_PROFILE],
            ["text": "更改密碼", "icon": "password"],
            ["text": "手機認證", "icon": "mobile_validate"],
        ],
        [
            ["text": "球隊登錄", "icon": "team", "segue": TO_TEAM_SUBMIT]
        ]
    ]
    
    override func viewDidLoad() {
        myTablView = tableView
        setData(sections: _sections, rows: _rows)
        super.viewDidLoad()
        
        tableView.register(FormCell.self, forCellReuseIdentifier: "cell")

        if Member.instance.isLoggedIn {
            let filter: [[Any]] = [
                ["channel", "=", CHANNEL],
                ["manager_id", "=", Member.instance.id]
            ]
            DataService.instance.getList(type: "team", titleField: "name", page: 1, perPage: 100, filter: filter) { (success) in
                if success {
                    self.myTeamLists = DataService.instance.lists
                    //print(self.myTeamLists)
                    for team in self.myTeamLists {
                        let row: [String: Any] = ["text": team.title, "id": team.id]
                        self._rows[1].append(row)
                    }
                    //print(self._rows)
                    self.setData(sections: self._sections, rows: self._rows)
                    self.tableView.reloadData()
                }
            }
        }
        
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        NotificationCenter.default.addObserver(self, selector: #selector(MenuVC.memberDidChange(_:)), name: NOTIF_MEMBER_DID_CHANGE, object: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("show cell sections: \(indexPath.section), rows: \(indexPath.row)")
        let cell: FormCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FormCell
        
        var x: CGFloat = 30
        let y: CGFloat = 10
        let iconWidth: CGFloat = 24
        let iconHeight: CGFloat = 24
        let iconView: UIImageView = UIImageView(frame: CGRect(x: x, y: y, width: iconWidth, height: iconHeight))
        cell.contentView.addSubview(iconView)
        iconView.isHidden = true
        
        x = x + iconWidth + 30
        let titleLbl: MyLabel = MyLabel(frame: CGRect(x: x, y: y, width: 200, height: cell.bounds.height))
        titleLbl.text = ""
        cell.contentView.addSubview(titleLbl)
        titleLbl.isHidden = true
        
        
//        var cell: FormCell? = tableView.dequeueReusableCell(withIdentifier: "cell") as? FormCell
//        if cell == nil {
//            //print("cell is nil")
//            cell = FormCell(style: UITableViewCellStyle.value1, reuseIdentifier: "cell")
//            cell!.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
//            cell!.selectionStyle = UITableViewCellSelectionStyle.none
//
//
//            iconView = UIImageView(frame: CGRect(x: x, y: y, width: iconWidth, height: iconHeight))
//
//            titleLbl = MyLabel(frame: CGRect(x: x, y: y, width: 200, height: cell!.bounds.height))
//            cell!.addSubview(iconView!)
//            cell!.addSubview(titleLbl!)
//        }
//        else {
//            //print("cell exist sections: \(indexPath.section), rows: \(indexPath.row)")
//            if cell!.subviews.contains(iconView) {
//                print("iconView exist sections: \(indexPath.section), rows: \(indexPath.row)")
//                iconView.removeFromSuperview()
//            }
//            if cell!.subviews.contains(titleLbl) {
//                print("titleLbl exist sections: \(indexPath.section), rows: \(indexPath.row)")
//                titleLbl.removeFromSuperview()
//            }
//        }
        
        let row: [String: Any] = rows![indexPath.section][indexPath.row]
        
        if row["icon"] != nil {
            iconView.isHidden = false
            iconView.image = UIImage(named: row["icon"] as! String)
        } else {
            iconView.isHidden = true
        }
        if row["text"] != nil {
            titleLbl.isHidden = false
            titleLbl.text = (row["text"] as! String)
            titleLbl.setupView()
            print(titleLbl.text)
        } else {
            titleLbl.isHidden = true
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row: [String: Any] = rows![indexPath.section][indexPath.row]
        if row["segue"] != nil {
            performSegue(withIdentifier: row["segue"] as! String, sender: nil)
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        _loginout()
    }
    
    @objc func memberDidChange(_ notif: Notification) {
        //print("notify")
        _loginout()
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        if Member.instance.isLoggedIn { // logout
            MemberService.instance.logout()
        } else {
            performSegue(withIdentifier: TO_LOGIN, sender: nil)
        }
    }
    
    @IBAction func registerBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_REGISTER, sender: nil)
    }
    
    private func _loginout() {
        //print(Member.instance.isLoggedIn)
        if Member.instance.isLoggedIn   { // login
            _loginBlock()
        } else {
            _logoutBlock()
        }
    }
    
    private func _loginBlock() {
        nicknameLbl.text = Member.instance.nickname
        loginBtn.setTitle("登出", for: .normal)
        registerBtn.isHidden = true
        registerIcon.isHidden = true
        forgetPasswordBtn.isHidden = true
        forgetPasswordIcon.isHidden = true
        tableView.isHidden = false
    }
    private func _logoutBlock() {
        nicknameLbl.text = "未登入"
        loginBtn.setTitle("登入", for: .normal)
        registerBtn.isHidden = false
        registerIcon.isHidden = false
        forgetPasswordBtn.isHidden = false
        forgetPasswordIcon.isHidden = false
        tableView.isHidden = true
    }
}
