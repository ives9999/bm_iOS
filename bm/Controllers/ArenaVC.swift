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
        ["ch":"關鍵字","atype":UITableViewCellAccessoryType.none,"key":"keyword","show":"","hint":"請輸入球場名稱關鍵字","text_field":true],
        ["ch":"縣市","atype":UITableViewCellAccessoryType.disclosureIndicator,"key":CITY_KEY,"show":"全部","segue":TO_CITY,"sender":0],
        ["ch":"區域","atype":UITableViewCellAccessoryType.disclosureIndicator,"key":AREA_KEY,"show":"全部","segue":TO_AREA,"sender":0],
        ["ch":"空調","atype":UITableViewCellAccessoryType.none,"key":ARENA_AIR_CONDITION_KEY,"show":"全部","segue":"","sender":0,"switch":true],
        ["ch":"盥洗室","atype":UITableViewCellAccessoryType.none,"key":ARENA_BATHROOM_KEY,"show":"全部","segue":"","sender":0,"switch":true],
        ["ch":"停車場","atype":UITableViewCellAccessoryType.none,"key":ARENA_PARKING_KEY,"show":"全部","segue":"","sender":0,"switch":true]
    ]
    
    
    override func viewDidLoad() {
        myTablView = tableView
        dataService = ArenaService.instance
        searchRows = _searchRows
        _type = "arena"
        _titleField = "name"
        super.viewDidLoad()
    }
    
    override func showMap(indexPath: IndexPath) {
        let row = lists[indexPath.row]
        let address = row.data[ADDRESS_KEY]!["value"] as! String
        let title = row.title
        let sender: [String: String] = [
            "title": title,
            "address": address
        ]
        performSegue(withIdentifier: TO_MAP, sender: sender)
    }
    
    override func searchCity(indexPath: IndexPath) {
        let row = lists[indexPath.row]
        let city_id = row.data[CITY_KEY]!["value"] as! Int
        citys.removeAll()
        citys.append(City(id: city_id, name: ""))
        prepareParams(city_type: "all")
        refresh()
    }

    @IBAction func searchBtnPressed(_ sender: Any) {
        showSearchPanel()
    }
}
