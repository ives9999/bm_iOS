//
//  TempPLaySignupListVC.swift
//  bm
//
//  Created by ives on 2018/6/8.
//  Copyright © 2018年 bm. All rights reserved.
//

import UIKit
import SwiftyJSON

class TempPlaySignupOneVC: MyTableVC {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var memberToken: String = ""
    var team_name: String = ""
    var team_id: Int = -1
    var near_date: String = ""
    var isTeamManager: Bool = false
    var memberMobile: String = ""
    var memberName: String = ""
    var memberOne: [Dictionary<String, Dictionary<String, Any>>] = [Dictionary<String, Dictionary<String, Any>>]()
    var keys: [String] = ["team", NAME_KEY, MOBILE_KEY, "black_list"]
    
    override func viewDidLoad() {
        myTablView = tableView
        super.viewDidLoad()
        //print(memberToken)
//        print(team)
//        print(near_date)
//        print(type)
//        print(team_id)
        
        tableView.register(MemberOneCell.self, forCellReuseIdentifier: "cell")
        refresh()
    }
    
    override func refresh() {
        Global.instance.addSpinner(superView: self.view)
        _getTeamManagerList() { (success) in
            if success {
                //print(self.teamManagerLists)
                for i in 0 ..< self.teamManagerLists.count {
                    let list: List = self.teamManagerLists[i]
                    if list.id == self.team_id {
                        self.isTeamManager = true
                        break
                    }
                }
            }
        }
        _getMemberOne(token: memberToken) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if (success) {
                guard let one = MemberService.instance.one else {
                    self.warning("無法取得該會員資訊，請稍後再試")
                    return
                }
                //print(MemberService.instance.one!)
                self.initMemberOne()
                for (idx, key) in self.keys.enumerated() {
                    for (key1, _) in one {
                        if (key == key1) {
                            self.memberOne[idx][key]!["value"] = one[key].stringValue
                            break
                        }
                    }
                }
                //print(self.memberOne)
                self.memberName = one["name"].stringValue
                self.titleLbl.text = self.memberName
                self.tableView.reloadData()
            } else {
                self.warning(MemberService.instance.msg)
            }
        }
    }
    
    func initMemberOne() {
        memberOne.removeAll()
        memberOne.append(["team":["title":team_name,"value":near_date,"more":false]])
        for key in keys {
            var title: String = ""
            var icon: String = ""
            var existMember: Bool = false // only if key exist member array add to member one
            for (key1, value1) in MEMBER_ARRAY {
                if key1 == key {
                    title = value1["text"]!
                    icon = value1["icon"]!
                    existMember = true
                }
            }
            if existMember {
                var _tmp: [String: Any] = ["icon": icon, "title": title, "value": "","more":false]
                if key == MOBILE_KEY {
                    _tmp["more"] = true
                }
                let tmp:Dictionary<String,[String: Any]> = [key:_tmp]
                memberOne.append(tmp)
            }
        }
        if isTeamManager {
            memberOne.append(["black_list":["title":"加入黑名單","more":true]])
        }
        //print(memberOne)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberOne.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MemberOneCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MemberOneCell
        
        let key: String = keys[indexPath.row]
        var row: [String: Any] = memberOne[indexPath.row][key]!
        if key == MOBILE_KEY {
            var value = row["value"] as! String
            memberMobile = value
            value = value.truncate(length: 6, trailing: "****")
            row["value"] = value
        }
        cell.setRow(row: row)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let key: String = keys[indexPath.row]
        var row: [String: Any] = memberOne[indexPath.row][key]!
        //print(row)
        let more: Bool = row["more"] as! Bool
        //print(more)
        if more {
            if key == MOBILE_KEY {
                //print(self.isTeamManager)
                if !isTeamManager {
                    warning("您不是此球隊管理員，所以無法檢視並撥打球友的電話")
                } else {
                    info(msg: "球友電話是："+memberMobile, closeButtonTitle: "取消", buttonTitle: "撥打電話", buttonAction: {self.memberMobile.makeCall()})
                }
            } else if key == "black_list" {
                warning(msg:"是否真的要將球友"+memberName+"設為黑名單\n之後可以解除", closeButtonTitle: "取消", buttonTitle: "確定", buttonAction: {
                    self.reasonBox()
                })
            }
        }
    }
    
    private func reasonBox() {
        let alert = SCLAlertView()
        let txt = alert.addTextField()
        alert.addButton("加入", action: {
            self.addBlackList(txt.text!)
        })
        alert.showEdit("請輸入理由") 
    }
    
    private func addBlackList(_ reason: String) {
        print(reason)
    }

    @IBAction func prevBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}











