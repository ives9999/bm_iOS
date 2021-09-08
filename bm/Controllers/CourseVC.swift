//
//  CourseVC.swift
//  bm
//
//  Created by ives on 2019/6/18.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit
import SCLAlertView

class CourseVC: MyTableVC {
    
    @IBOutlet weak var managerBtn: UIButton!
    
    //let _searchRows: [[String: Any]] =
    
    var mysTable: CoursesTable?
    
    override func viewDidLoad() {
        
        myTablView = tableView
        able_type = "course"
        dataService = CourseService.instance
        //_type = "course"
        //_titleField = "title"
        searchRows = [
            ["title":"關鍵字","atype":UITableViewCell.AccessoryType.none,"key":"keyword","show":"","hint":"請輸入課程名稱關鍵字","text_field":true,"value":"","value_type":"String"],
            ["title":"縣市","atype":UITableViewCell.AccessoryType.disclosureIndicator,"key":CITY_KEY,"show":"全部","segue":TO_CITY,"sender":0,"value":"","value_type":"Array"],
            ["title":"星期幾","atype":UITableViewCell.AccessoryType.disclosureIndicator,"key":WEEKDAY_KEY,"show":"全部","segue":TO_SELECT_WEEKDAY,"sender":[Int](),"value":"","value_type":"Array"],
            ["title":"開始時間","atype":UITableViewCell.AccessoryType.disclosureIndicator,"key":START_TIME_KEY,"show":"不限","segue":TO_SELECT_TIME,"sender":[String: Any](),"value":"","value_type":"String"],
            ["title":"結束時間","atype":UITableViewCell.AccessoryType.disclosureIndicator,"key":END_TIME_KEY,"show":"不限","segue":TO_SELECT_TIME,"sender":[String: Any](),"value":"","value_type":"String"]
        ]
        Global.instance.setupTabbar(self)
        //Global.instance.menuPressedAction(menuBtn, self)
        super.viewDidLoad()
        
        let cellNibName = UINib(nibName: "CourseListCell", bundle: nil)
        tableView.register(cellNibName, forCellReuseIdentifier: "listCell")
        
        // this page show search icon in top
        searchBtn.visibility = .visible
        
        refresh()
    }
    
//    override func refresh() {
//        page = 1
//        getDataStart(page: page, perPage: PERPAGE)
//    }
    
    override func genericTable() {
        
        do {
            if (jsonData != nil) {
                mysTable = try JSONDecoder().decode(CoursesTable.self, from: jsonData!)
            } else {
                warning("無法從伺服器取得正確的json資料，請洽管理員")
            }
        } catch {
            msg = "解析JSON字串時，得到空值，請洽管理員"
        }
        if (mysTable != nil) {
            tables = mysTable!
            if (page == 1) {
                lists1 = [CourseTable]()
            }
            lists1 += mysTable!.rows
        }
    }
    
//    override func getDataEnd(success: Bool) {
//        if success {
//
//            mysTable = (tables as? CoursesTable)
//            if mysTable != nil {
//                let tmps: [CourseTable] = mysTable!.rows
//
//                if page == 1 {
//                    lists1 = [CourseTable]()
//                }
//                lists1 += tmps
//                myTablView.reloadData()
//            } else {
//                warning("轉換Table出錯，請洽管理員")
//            }
//        }
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists1.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as? CourseListCell {
            
            cell.cellDelegate = self
            let row = lists1[indexPath.row] as? CourseTable
            if row != nil {
                row!.filterRow()
                //row!.printRow()
                //print(row!.like);
                cell.updateViews(row!)
            }
            
            return cell
        } else {
            return ListCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = lists1[indexPath.row]
        toShowCourse(token: row.token)
    }

    @IBAction func manager(_ sender: Any) {
        if !Member.instance.isLoggedIn {
            warning("請先登入為會員")
        } else {
            performSegue(withIdentifier: TO_MANAGER_COURSE, sender: nil)
        }
    }
}

