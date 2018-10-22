//
//  ArenaVC.swift
//  bm
//
//  Created by ives on 2018/7/28.
//  Copyright © 2018年 bm. All rights reserved.
//

import UIKit

class ArenaVC: ListVC {
    
    let _searchRows: [[String: Any]] = [
        ["ch":"關鍵字","atype":UITableViewCellAccessoryType.none,"key":"keyword","show":"","hint":"請輸入球隊名稱關鍵字"],
    ["ch":"縣市","atype":UITableViewCellAccessoryType.disclosureIndicator,"key":CITY_KEY,"show":"全部","segue":TO_CITY,"sender":0],
    ["ch":"區域","atype":UITableViewCellAccessoryType.disclosureIndicator,"key":AREA_KEY,"show":"全部","segue":TO_AREA,"sender":0]
    ]
    
    
    override func viewDidLoad() {
        myTablView = tableView
        dataService = ArenaService.instance
        searchRows = _searchRows
        _type = "arena"
        _titleField = "name"
        super.viewDidLoad()
    }
    
    @objc func mapPrepare(sender: UITapGestureRecognizer) {
        let label = sender.view as! UILabel
        let idx = label.tag
        let row = lists[idx]
        let address = row.data[ADDRESS_KEY]!["value"] as! String
        let title = row.title
        let sender: [String: String] = [
            "title": title,
            "address": address
        ]
        performSegue(withIdentifier: TO_MAP, sender: sender)
    }

    @IBAction func searchBtnPressed(_ sender: Any) {
        showSearchPanel()
    }
}
