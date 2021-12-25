//
//  MemberSignuListVC.swift
//  bm
//
//  Created by ives on 2020/2/28.
//  Copyright © 2020 bm. All rights reserved.
//

import UIKit
import Foundation

class MemberSignupListVC: MyTableVC, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var yearLbl: SuperLabel!
    @IBOutlet weak var monthLbl: SuperLabel!
    @IBOutlet weak var yearPick: UIPickerView!
    @IBOutlet weak var monthPick: UIPickerView!
    
    var y: Int?
    var m: Int?
    
    var years: [Int] = [Int]()
    var months: [Int] = [Int]()
    
    var calendarParams: [String: Any] = [String: Any]()
    
    var signupNormalTables: [SignupNormalTable] = [SignupNormalTable]()
    
    override func viewDidLoad() {
        
        myTablView = tableView
        super.viewDidLoad()

        m = Date().getm()
        y = Date().getY()
        
        for i in (y!-2...y!).reversed() {
            years.append(i)
        }
        for i in 1...12 {
            months.append(i)
        }
        monthPick.selectRow(m!-1, inComponent: 0, animated: true)
        
        calendarParams = makeCalendar()
        
        let cellNibName = UINib(nibName: "SignupListCell", bundle: nil)
        tableView.register(cellNibName, forCellReuseIdentifier: "signupListCell")
        
        refresh()
    }
    
    override func refresh() {
        
        page = 1
        getDataStart(page: page, perPage: PERPAGE)
    }
    
    override func getDataStart(token: String? = nil, page: Int=1, perPage: Int=PERPAGE) {
        Global.instance.addSpinner(superView: self.view)
        
        MemberService.instance.memberSignupCalendar(year: 0, month: 0, member_token: Member.instance.token, able_type: able_type) { (success) in
            if (success) {
                self.jsonData = MemberService.instance.jsonData
                self.getDataEnd(success: success)
            }
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
                let signupResultTable = try JSONDecoder().decode(SignupResultTable.self, from: jsonData!)
                if (signupResultTable.success) {
                    self.signupNormalTables = signupResultTable.rows
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      var count: Int = 0
      if pickerView == yearPick {
        count = years.count
      } else if pickerView == monthPick {
        count = months.count
      }
      
      return count
    }
    
    //func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        //return 40
    //}
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var title: String?
        if pickerView == yearPick {
            title = String(years[row])
        } else if pickerView == monthPick {
            title = String(months[row])
            if row == m!-1 {
                //monthPick.selectRow(m!-1, inComponent: 1, animated: true)
            }
        } else {
            title = "nothing"
        }
        
        return title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        if pickerView == monthPick {
//            if pickerView.tag == 0 {
//                monthPick.selectRow(m!-1, inComponent: 1, animated: true)
//            }
//        }
    }
    
    func makeCalendar()->[String: Any] {
        
        var res: [String: Any] = [String: Any]()
        //取得該月1號的星期幾，日曆才知道從星期幾開始顯示
        let weekday01 = "\(y!)-\(m!)-01"
        res["weekday01"] = weekday01
        
        var beginWeekday = weekday01.toDateTime(format: "yyyy-MM-dd")!.dateToWeekday()
        beginWeekday = beginWeekday == 0 ? 7 : beginWeekday;
        res["beginWeekday"] = beginWeekday

        //取得該月最後一天的日期，30, 31或28，日曆才知道顯示到那一天
        let monthLastDay = Date().getMonthDays(y!, m!)
        res["monthLastDay"] = monthLastDay
        let monthLastDay_add_begin = monthLastDay + beginWeekday - 1
        res["monthLastDay_add_begin"] = monthLastDay_add_begin

        //取得該月最後一天的星期幾，計算月曆有幾列需要用到的數字
        let weekday31 = "\(y!)-\(m!)-\(monthLastDay)"
        res["weekday31"] = weekday31
        
        let endWeekday = weekday31.toDateTime(format: "yyyy-MM-dd")!.dateToWeekday()
        res["endWeekday"] = endWeekday

        //算出共需幾個日曆的格子
        let allMonthGrid = monthLastDay + (beginWeekday-1) + (7-endWeekday);
        res["allMonthGrid"] = allMonthGrid

        //算出月曆列數，日曆才知道顯示幾列
        let monthRow = allMonthGrid/7
        res["monthRow"] = monthRow

        //建立下個月的連結
        let next_month = m! == 12 ? 1 : m!+1
        res["next_month"] = next_month
        let next_year = m! == 12 ? y!+1 : y!
        res["next_year"] = next_year
        
        return res
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "signupListCell", for: indexPath) as? SignupListCell {
            
            let signupNormalTable: SignupNormalTable = signupNormalTables[indexPath.row]
            signupNormalTable.filterRow()
            cell.update(_row: signupNormalTable)
            
            return cell
        }
        
        return UITableViewCell()
    }
}

class SignupResultTable: Codable {
    
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
