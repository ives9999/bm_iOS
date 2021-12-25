//
//  ManagerTeamSignupLostVC.swift
//  bm
//
//  Created by ives on 2021/12/23.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class ManagerSignupListVC: MyTableVC {
    
    var able_token: String?
    
    var signupNormalTables: [SignupNormalTable] = [SignupNormalTable]()
    
    override func viewDidLoad() {
        
        myTablView = tableView
        if (able_type == "team") {
            dataService = TeamService.instance
        } else if (able_type == "course") {
            dataService = CourseService.instance
        }
        
        super.viewDidLoad()

        let cellNibName = UINib(nibName: "ManagerSignupListCell", bundle: nil)
        tableView.register(cellNibName, forCellReuseIdentifier: "managerSignupListCell")
        
        refresh()
    }
    
    override func refresh() {
        
        page = 1
        getDataStart(page: page, perPage: PERPAGE)
    }
    
    override func getDataStart(token: String? = nil, page: Int=1, perPage: Int=PERPAGE) {
        Global.instance.addSpinner(superView: self.view)
        
        if (able_token != nil) {
            dataService.managerSignupList(able_type: able_type, able_token: able_token!) { (success) in
                
                Global.instance.removeSpinner(superView: self.view)
                if (success) {
                    self.jsonData = self.dataService.jsonData
                    self.getDataEnd(success: success)
                }
            }
        } else {
            warning("沒有傳送管理者金鑰錯誤，請洽管理員")
        }
    }
    
    override func getDataEnd(success: Bool) {
        
        if (jsonData != nil) {
            genericTable()
            if page == 1 {
                if (tables != nil) {
                    totalCount = tables!.totalCount
                    perPage = tables!.perPage
                    let _pageCount: Int = totalCount / perPage
                    totalPage = (totalCount % perPage > 0) ? _pageCount + 1 : _pageCount
                    //print(totalPage)
                }
            }
            if refreshControl.isRefreshing {
                refreshControl.endRefreshing()
            }
            myTablView.reloadData()
            //self.page = self.page + 1 in CollectionView
        } else {
            warning("沒有取得回傳的json字串，請洽管理員")
        }
        Global.instance.removeSpinner(superView: view)
    }
    
    override func genericTable() {
        
        do {
            if (jsonData != nil) {
//                let str = String(decoding: jsonData!, as: UTF8.self)
//                print(str)
                let SignupListResultTable = try JSONDecoder().decode(SignupListResultTable.self, from: jsonData!)
                if (SignupListResultTable.success) {
                    self.signupNormalTables = SignupListResultTable.rows
                } else {
                    warning(SignupListResultTable.msg)
                }
            } else {
                warning("無法從伺服器取得正確的json資料，請洽管理員")
            }
        } catch {
            msg = "解析JSON字串時，得到空值，請洽管理員"
        }
        
        if (page == 1) {
            lists1 = [SignupNormalTable]()
        }
        lists1 += signupNormalTables
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "managerSignupListCell", for: indexPath) as? ManagerSignupListCell {
            
            let signupNormalTable: SignupNormalTable = signupNormalTables[indexPath.row]
            signupNormalTable.filterRow()
            cell.update(_row: signupNormalTable)
            
            return cell
        }
        
        return UITableViewCell()
    }
}

class SignupListResultTable: Codable {
    
    var success: Bool = false
    var msg: String = ""
    var rows: [SignupNormalTable] = [SignupNormalTable]()
    
    init(){}
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        msg = try container.decodeIfPresent(String.self, forKey: .msg) ?? ""
        rows = try container.decodeIfPresent([SignupNormalTable].self, forKey: .rows) ?? [SignupNormalTable]()
    }
}
