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
    var able_title: String = ""
    
    @IBOutlet weak var titleLbl: UILabel!
    
    var signupListResultTable: SignupListResultTable?
    var signupNormalTables: [SignupNormalTable] = [SignupNormalTable]()
    
    override func viewDidLoad() {
        
        myTablView = tableView
        if (able_type == "team") {
            dataService = TeamService.instance
        } else if (able_type == "course") {
            dataService = CourseService.instance
        }
        
        titleLbl.text = able_title + "報名會員列表"
        
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
            dataService.managerSignupList(able_type: able_type, able_token: able_token!, page: page, perPage: perPage) { (success) in
                
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
                if (signupListResultTable != nil) {
                    totalCount = signupListResultTable!.totalCount
                    perPage = signupListResultTable!.perPage
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
                self.signupListResultTable = try JSONDecoder().decode(SignupListResultTable.self, from: jsonData!)
                if (self.signupListResultTable != nil) {
                    if (self.signupListResultTable!.success) {
                        self.signupNormalTables = self.signupListResultTable!.rows
                    } else {
                        warning(self.signupListResultTable!.msg)
                    }
                } else {
                    warning("解析JSON字串失敗，請洽管理員")
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
            
            if let tmp: SignupNormalTable = lists1[indexPath.row] as? SignupNormalTable {
                tmp.filterRow()
                cell.update(_row: tmp)
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

class SignupListResultTable: Codable {
    
    var success: Bool = false
    var page: Int = -1
    var totalCount: Int = -1
    var perPage: Int = -1
    var msg: String = ""
    var rows: [SignupNormalTable] = [SignupNormalTable]()
    
    init(){}
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        page = try container.decode(Int.self, forKey: .page)
        totalCount = try container.decode(Int.self, forKey: .totalCount)
        perPage = try container.decode(Int.self, forKey: .perPage)
        msg = try container.decodeIfPresent(String.self, forKey: .msg) ?? ""
        rows = try container.decodeIfPresent([SignupNormalTable].self, forKey: .rows) ?? [SignupNormalTable]()
    }
}
