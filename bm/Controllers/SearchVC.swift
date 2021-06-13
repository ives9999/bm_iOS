//
//  SearchVC.swift
//  bm
//
//  Created by ives on 2018/9/26.
//  Copyright © 2018年 bm. All rights reserved.
//

import UIKit
import SCLAlertView

class SearchVC: ListVC, UINavigationControllerDelegate {
    
    @IBOutlet weak var submitBtn: UIButton!
    
    let heightForSection: CGFloat = 34
    
    var mysTable: TeamsTable?
    //search type: temp_play, coach, team, teach
    var type: String!
    var model: Team!
    
    var searchSections: [ExpandableItems] = [ExpandableItems]()

//    var citys: [City] = [City]()
//    var arenas: [Arena] = [Arena]()
//    var weekdays: [Int] = [Int]()
//    var degrees: [Degree] = [Degree]()
    
    //key has type, play_start_time, play_end_time, time
    var times: [String: Any] = [String: Any]()
    var keyword: String = ""
    
    var firstTimeLoading: Bool = false
    //var firstTimeLoading: Bool = true
    
    override func viewDidLoad() {
        
        //model = Team.instance
        myTablView = tableView
        able_type = "team"
        sections = ["", "更多"]
        Global.instance.setupTabbar(self)
        //Global.instance.menuPressedAction(menuBtn, self)
        
        searchRows = [
            ["ch":"關鍵字","atype":UITableViewCell.AccessoryType.none,"key":"keyword","show":"","hint":"請輸入球隊名稱關鍵字","text_field":true,"value":""],
            ["ch":"縣市","atype":UITableViewCell.AccessoryType.disclosureIndicator,"key":CITY_KEY,"show":"全部","segue":TO_CITY,"sender":0,"value":""],
            //            ["ch": "區域","atype":UITableViewCellAccessoryType.disclosureIndicator,"key":"team_area","show":"全部","segue":TO_ARENA,"sender":0],
            ["ch":"星期幾","atype":UITableViewCell.AccessoryType.disclosureIndicator,"key":WEEKDAY_KEY,"show":"全部","segue":TO_SELECT_WEEKDAY,"sender":[Int](),"value":""],
            ["ch":"時段","atype":UITableViewCell.AccessoryType.disclosureIndicator,"key":START_TIME_KEY,"show":"全部","segue":TO_SELECT_TIME,"sender":[String: Any](),"value":""],
    //        ["ch":"結束時間","atype":UITableViewCellAccessoryType.disclosureIndicator,"key":TEAM_PLAY_END_KEY,"show":"全部","segue":TO_SELECT_TIME,"sender":[String: Any]()],
            ["ch":"球館","atype":UITableViewCell.AccessoryType.disclosureIndicator,"key":ARENA_KEY,"show":"全部","segue":TO_ARENA,"sender":[String:Int](),"value":""],
            ["ch":"程度","atype":UITableViewCell.AccessoryType.disclosureIndicator,"key":DEGREE_KEY,"show":"全部","segue":TO_SELECT_DEGREE,"sender":[String](),"value":""]
        ]
        
        searchSections = [
            ExpandableItems(isExpanded: true, items: ["keyword",CITY_KEY,WEEKDAY_KEY, START_TIME_KEY]),
            ExpandableItems(isExpanded: true, items: [ARENA_KEY,DEGREE_KEY])
        ]
        
        super.viewDidLoad()
        
        searchTableView = tableView
        let cellNib = UINib(nibName: "EditCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "cell")
        //submitBtn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 20, bottom: 6, right: 20)
        //submitBtn.layer.cornerRadius = 12
//        citys.append(City(id: 218, name: ""))
//        citys.append(City(id: 257, name: ""))
        //Session.shared.clear(key: Session.shared.loginResetKey)
//        if !Session.shared.exist(key: Session.shared.loginResetKey) {
//            Session.shared.loginReset = gReset
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (firstTimeLoading) {
            if #available(iOS 13.0, *) {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let viewController = storyboard.instantiateViewController(identifier: "banner")  as? HomeTotalAdVC {
                    viewController.modalPresentationStyle = .overCurrentContext
                    present(viewController, animated: true, completion: nil)
                }
            } else {
                let viewController = self.storyboard!.instantiateViewController(withIdentifier: "banner") as! HomeTotalAdVC
                self.navigationController!.pushViewController(viewController, animated: true)
            }
            firstTimeLoading = false
        }
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        gReset = Session.shared.loginReset
//        if !gReset {
//            info("因為更新APP系統，請重新登出再登入，方能正常使用會員功能")
//        }
//    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return searchSections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !searchSections[section].isExpanded {
            return 0
        }
        return searchSections[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return heightForSection
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.white
        headerView.tag = section
        
        let titleLabel = UILabel()
        titleLabel.text = sections?[section]
        titleLabel.textColor = UIColor.black
        titleLabel.sizeToFit()
        titleLabel.frame = CGRect(x: 10, y: 0, width: 100, height: heightForSection)
        headerView.addSubview(titleLabel)
        
        let mark = UIImageView(image: UIImage(named: "to_right"))
        mark.frame = CGRect(x: view.frame.width-10-20, y: (heightForSection-20)/2, width: 20, height: 20)
        headerView.addSubview(mark)
        
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleExpandClose))
        headerView.addGestureRecognizer(gesture)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //print("section: \(indexPath.section), row: \(indexPath.row)")
        let cell: EditCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EditCell
        cell.editCellDelegate = self
        
        let searchRow = getDefinedRow(indexPath.section, indexPath.row)
        //print(searchRow)
        cell.forRow(indexPath: indexPath, row: searchRow, isClear: true)
//        let row: [String: Any] = getDefinedRow(indexPath.section, indexPath.row)
//        cell.forRow(indexPath: indexPath, row: row, isClear: true)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Global.instance.addSpinner(superView: view)
        Global.instance.removeSpinner(superView: view)
        let row: [String: Any] = getDefinedRow(indexPath.section, indexPath.row)
        let cell = tableView.cellForRow(at: indexPath) as! EditCell
        
        if row["atype"] as! UITableViewCell.AccessoryType != UITableViewCell.AccessoryType.none {
            
            var key: String? = nil
            if (row.keyExist(key: "key") && row["key"] != nil) {
                key = row["key"] as? String
            }
            
            if let segue: String = row["segue"] as? String {
                if (segue == TO_CITY) {
                    var selected: String? = nil
                    if (row.keyExist(key: "value") && row["value"] != nil) {
                        selected = row["value"] as? String
                    }
                    toSelectCity(key: key, selected: selected, delegate: self)
                } else if (segue == TO_SELECT_WEEKDAY) {
                    
                    let selecteds: [Int] = valueToArray(t: Int.self, row: row)
                    toSelectWeekday(key: key, selecteds: selecteds, delegate: self)
                } else if (segue == TO_SELECT_TIME) {
                    
                    var type: SELECT_TIME_TYPE = SELECT_TIME_TYPE.play_start
                    if (key == END_TIME_KEY) {
                        type = SELECT_TIME_TYPE.play_end
                    }
                    
                    var selected: String? = nil
                    if (row.keyExist(key: "value") && row["value"] != nil) {
                        selected = row["value"] as? String
                    }
                    toSelectTime(key: key, selected: selected, delegate: self)
                } else if segue == TO_ARENA {
        
                    var city: Int? = nil
                    var row = getDefinedRow(CITY_KEY)
                    if let value: String = row["value"] as? String {
                        city = Int(value)
    //                    if (city != nil) {
    //                        citys.append(city!)
    //                    }
                    }
                    
                    if (city == nil) {
                        warning("請先選擇縣市")
                    } else {
                    
                        //取得選擇球館的代號
                        row = getDefinedRow(ARENA_KEY)
                        let selected: String = row["value"] as! String
                        toSelectArena(city: city!, selected: selected, delegate: self)
                    }
                } else if (segue == TO_SELECT_DEGREE) {
                    
                    let tmps: [String] = valueToArray(t: String.self, row: row)
                    var selecteds: [DEGREE] = [DEGREE]()
                    for tmp in tmps {
                        selecteds.append(DEGREE.enumFromString(string: tmp))
                    }
                    toSelectDegree(selecteds: selecteds, delegate: self)
                } else {
                    //performSegue(withIdentifier: segue, sender: indexPath)
                }
            }
        } else {
            cell.editText.becomeFirstResponder()
        }
    }
    
    func getDefinedRow(_ section: Int, _ row: Int) -> [String: Any] {
        let key = searchSections[section].items[row]
        return getDefinedRow(key)
    }
    
    @objc func handleExpandClose(gesture : UITapGestureRecognizer) {
        let headerView = gesture.view!
        let section = headerView.tag
        let tmp = headerView.subviews.filter({$0 is UIImageView})
        var mark: UIImageView?
        if tmp.count > 0 {
            mark = tmp[0] as? UIImageView
        }
        
        var indexPaths = [IndexPath]()
        for idx in searchSections[section].items.indices {
            let indexPath = IndexPath(row: idx, section: section)
            indexPaths.append(indexPath)
        }
        
        let isExpanded = searchSections[section].isExpanded
        searchSections[section].isExpanded = !isExpanded
        
        if isExpanded {
            tableView.deleteRows(at: indexPaths, with: .fade)
            if mark != nil {
                mark?.image = UIImage(named: "to_right")
            }
        } else {
            tableView.insertRows(at: indexPaths, with: .fade)
            if mark != nil {
                mark?.image = UIImage(named: "to_down")
            }
        }
    }
    
    @IBAction func submit(_ sender: Any) {
        
        prepareParams()
        toTeam(params: params)
        //refresh()
    }
    
    //    @IBAction func submit(_ sender: Any) {
    //        toTeam()
    //        //performSegue(withIdentifier: TO_TEMP_PLAY_LIST, sender: nil)
    //    }
}

struct ExpandableItems {
    var isExpanded: Bool
    let items: [String]
}
