//
//  SelectArenaVC.swift
//  bm
//
//  Created by ives on 2021/6/13.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class SelectArenaVC: SingleSelectVC {
    
    var city: Int? = nil
    var mysTable: [ArenaTable] = [ArenaTable]()
    
    override func viewDidLoad() {
        
        myTablView = tableView
        title = Global.instance.zoneIDToName(city!)
        super.viewDidLoad()
        
        Global.instance.addSpinner(superView: self.tableView)
        
        TeamService.instance.getArenaByCityID(city_id: city!) { (success) in
            if success {
                
                self.jsonData = TeamService.instance.jsonData
                do {
                    if (self.jsonData != nil) {
                        self.mysTable = try JSONDecoder().decode([ArenaTable].self, from: self.jsonData!)
                    } else {
                        self.warning("無法從伺服器取得正確的json資料，請洽管理員")
                    }
                } catch {
                    self.msg = "解析JSON字串時，得到空值，請洽管理員"
                }
                //self.arenas = TeamService.instance.arenas
                //print(self.citys)
                //self.arenas = TeamService.instance.arenas
                self.rows1Bridge()
                
                self.tableView.reloadData()
                Global.instance.removeSpinner(superView: self.tableView)
            }
        }
    }
    
    func rows1Bridge() {
        
        if rows1 != nil && rows1!.count > 0 {
            rows1!.removeAll()
        } else {
            rows1 = [[String: String]]()
        }
        for arena in mysTable {
            rows1!.append(["title": arena.name, "value": String(arena.id)])
        }
    }
    
    override func submit(_ indexPath: IndexPath) {
        
        let cell: UITableViewCell = tableView.cellForRow(at: indexPath)!
        let row = rows1![indexPath.row]
        
        var cancel: Bool = false
        if selected != nil && selected!.count > 0 {
            if selected! == row["value"] {
                cancel = true
                unSetSelectedStyle(cell)
            }
        }
        if !cancel {
            if delegate != nil {
                let _key = ((key == nil) ? "" : key)!
                if (delegate != nil) {
                    delegate!.singleSelected(key: _key, selected: row["value"]!, show: row["title"])
                } else {
                    warning("沒有傳入代理程式，請洽管理員")
                }
            }
            setSelectedStyle(cell)
            prev()
        }
        
        
        
        
//        selected = (row["value"] == selected) ? "" : row["value"]
//        if delegate != nil {
//            delegate!.singleSelected(key: key!, selected: selected!)
//            prev()
//        } else {
//            alertError("由於傳遞參數不正確，無法做選擇，請回上一頁重新進入")
//        }
    }
}
