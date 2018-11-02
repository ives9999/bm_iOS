//
//  TeamVC.swift
//  bm
//
//  Created by ives on 2017/10/3.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import Device_swift

class TeamVC: ListVC {
    
    //@IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var managerBtn: UIButton!
    
    let _searchRows: [[String: Any]] = [
        ["ch":"關鍵字","atype":UITableViewCellAccessoryType.none,"key":"keyword","show":"","hint":"請輸入球隊名稱關鍵字","text_field":true],
        ["ch":"縣市","atype":UITableViewCellAccessoryType.disclosureIndicator,"key":CITY_KEY,"show":"全部","segue":TO_CITY,"sender":0],
        ["ch":"球館","atype":UITableViewCellAccessoryType.disclosureIndicator,"key":TEAM_ARENA_KEY,"show":"全部","segue":TO_ARENA,"sender":[String:Int]()],
        ["ch":"日期","atype":UITableViewCellAccessoryType.disclosureIndicator,"key":TEAM_DAYS_KEY,"show":"全部","segue":TO_DAY,"sender":[Int]()],
        ["ch":"時段","atype":UITableViewCellAccessoryType.disclosureIndicator,"key":TEAM_PLAY_START_KEY,"show":"全部","segue":TO_SELECT_TIME,"sender":[String: Any]()],
        ["ch":"程度","atype":UITableViewCellAccessoryType.disclosureIndicator,"key":TEAM_DEGREE_KEY,"show":"全部","segue":TO_SELECT_DEGREE,"sender":[String]()]
        ]
    
    override func viewDidLoad() {
        myTablView = tableView
        dataService = TeamService.instance
        _type = "team"
        _titleField = "name"
        searchRows = _searchRows
        Global.instance.setupTabbar(self)
        Global.instance.menuPressedAction(menuBtn, self)
        super.viewDidLoad()
    }
    
    @IBAction func manager(_ sender: Any) {
        if !Member.instance.isLoggedIn {
            SCLAlertView().showError("警告", subTitle: "請先登入為會員")
        } else {
            performSegue(withIdentifier: TO_MANAGER, sender: nil)
        }
    }
    
    @IBAction func searchBtnPressed(_ sender: Any) {
        showSearchPanel()
    }
}
