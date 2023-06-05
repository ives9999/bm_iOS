//
//  ManagerMatchTeamPlayerVC.swift
//  bm
//
//  Created by ives on 2023/6/5.
//  Copyright © 2023 bm. All rights reserved.
//

import Foundation

class ManagerMatchTeamPlayerVC: BaseViewController {
    
    var match_team_token: String? = nil
    
//    lazy var tableView: MyTable2VC<ManagerMatchPlayerCell, MatchPlayerTable, ManagerMatchTeamPlayerVC> = {
//        let tableView = MyTable2VC<ManagerMatchPlayerCell, MatchPlayerTable, ManagerMatchTeamPlayerVC>(selectedClosure: tableViewSetSelected(row:), getDataClosure: getDataFromServer(page:), myDelegate: self)
//        return tableView
//    }()
    
    var showTop: ShowTop2?
    
    var matchPlayerTables: [MatchPlayerTable] = [MatchPlayerTable]()
    
    var rows: [MatchPlayerTable] = [MatchPlayerTable]()
    
    var infoLbl: SuperLabel?
}
