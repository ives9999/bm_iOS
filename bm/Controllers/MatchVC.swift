//
//  MatchVC.swift
//  bm
//
//  Created by ives on 2023/4/18.
//  Copyright © 2023 bm. All rights reserved.
//

import Foundation

class MatchVC: BaseViewController {
    
    var showTop2: ShowTop2?
    
    lazy var tableView: MyTable2VC<MatchCell, MatchTable, MatchVC> = {
        let tableView = MyTable2VC<MatchCell, MatchTable, MatchVC>(selectedClosure: tableViewSetSelected(row:), getDataClosure: getDataFromServer(page:), myDelegate: self)
        return tableView
    }()
    
    var rows: [MatchTable] = [MatchTable]()
    
    var infoLbl: SuperLabel?
    
    override func viewDidLoad() {
        
        dataService = MatchService.instance
        super.viewDidLoad()
        
        showTop2 = ShowTop2(delegate: self)
        showTop2!.anchor(parent: self.view)
        showTop2!.setTitle("賽事列表")
        
        refresh()
    }
    
    override func refresh() {
        
        page = 1
        tableView.getDataFromServer(page: page)
        //getDataStart(page: page, perPage: PERPAGE)
    }
    
    func getDataFromServer(page: Int) {
        Global.instance.addSpinner(superView: self.view)
        
        dataService.getList(token: nil, _filter: params, page: page, perPage: tableView.perPage) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if (success) {
                self.dataService.jsonData?.prettyPrintedJSONString
                let b: Bool = self.tableView.parseJSON(jsonData: self.dataService.jsonData)
                if !b && self.tableView.msg.count == 0 {
                    self.infoLbl = self.view.setInfo(info: "目前尚無資料！！", topAnchor: self.showTop2!)
                } else {
                    self.infoLbl?.removeFromSuperview()
                    self.rows = self.tableView.items
                }
                //self.showTableView(tableView: self.tableView, jsonData: TeamService.instance.jsonData!)
            }
        }
    }
    
    func tableViewSetSelected(row: MatchTable)-> Bool {
        return false
    }
}

class MatchCell: BaseCell<MatchTable, MatchVC> {
    
}
