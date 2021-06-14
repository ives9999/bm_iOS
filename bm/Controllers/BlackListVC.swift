//
//  BlackListVC.swift
//  bm
//
//  Created by ives on 2018/6/17.
//  Copyright © 2018年 bm. All rights reserved.
//

import UIKit

class BlackListVC: MyTableVC, BlackListCellDelegate {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var emptyLbl: SuperLabel!
    @IBOutlet weak var emptyCons: NSLayoutConstraint!
    
    var memberToken: String = ""
    var blacklists: Array<Dictionary<String, Any>> = Array()
    
    override func viewDidLoad() {
        myTablView = tableView
        super.viewDidLoad()

        memberToken = Member.instance.token
        tableView.register(BlackListCell.self, forCellReuseIdentifier: "cell")
        refresh()
    }
    
    override func refresh() {
        Global.instance.addSpinner(superView: self.view)
        MemberService.instance.blacklist(token: memberToken) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if (success) {
                self.blacklists = MemberService.instance.blacklists
                if (self.blacklists.count == 0) {
                    self.emptyLbl.isHidden = false
                    self.emptyCons.constant = 20
                    self.view.layoutIfNeeded()
                } else {
                    self.emptyLbl.isHidden = true
                    self.emptyCons.constant = 0
                    self.view.layoutIfNeeded()
                    self.tableView.reloadData()
                }
            } else {
                self.warning(MemberService.instance.msg)
            }
            self.endRefresh()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blacklists.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BlackListCell
        cell.blacklistCellDelegate = self
        let row = blacklists[indexPath.row]
        cell.setRow(row: row, position: indexPath.row)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = blacklists[indexPath.row]
        let memo:String = row["memo"]! as! String
        info(memo)
    }
    
    func cancel(position: Int) {
        //print(position)
        warning(msg: "是否真的要將此球友移出黑名單？", closeButtonTitle: "取消", buttonTitle: "確定") {
            self._cancel(position: position)
        }
    }
    func _cancel(position: Int) {
        let row = blacklists[position]
        let memberToken = (row["memberToken"] as! String)
        let teamToken = (row["teamToken"] as! String)
        Global.instance.addSpinner(superView: self.view)
        TeamService.instance.removeBlackList(teamToken: teamToken, playerToken: memberToken, managerToken: Member.instance.token) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if (success) {
                self.info("移除黑名單成功")
                self.refresh()
            } else {
                self.warning(TeamService.instance.msg)
            }
        }
    }
    func call(position: Int) {
        //print(position)
        let row = blacklists[position]
        let mobile: String = (row["memberMobile"] as! String)
        mobile.makeCall()
    }
}
