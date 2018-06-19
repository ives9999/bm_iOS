//
//  BlackListVC.swift
//  bm
//
//  Created by ives on 2018/6/17.
//  Copyright © 2018年 bm. All rights reserved.
//

import UIKit

class BlackListVC: MyTableVC {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var memberToken: String = ""
    
    override func viewDidLoad() {
        myTablView = tableView
        super.viewDidLoad()

        memberToken = Member.instance.token
        refresh()
    }
    
    override func refresh() {
        MemberService.instance.blacklist(token: memberToken) { (success) in
            
        }
    }

    @IBAction func prevBtnPressed(_ sender: Any) {
        prev()
    }
    

}
