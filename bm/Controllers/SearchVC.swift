//
//  SearchVC.swift
//  bm
//
//  Created by ives on 2018/9/26.
//  Copyright © 2018年 bm. All rights reserved.
//

import UIKit
import SCLAlertView

class SearchVC: MyTableVC, UINavigationControllerDelegate {
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var likeTab: Tag!
    @IBOutlet weak var searchTab: Tag!
    @IBOutlet weak var allTab: Tag!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomView: StaticBottomView!
    
    var searchTags: [[String: Any]] = [[String: Any]]()
    var selectedTagIdx: Int = 0
    let heightForSection: CGFloat = 34
    
    var mysTable: TeamsTable?
    
    var searchSections: [ExpandableItems] = [ExpandableItems]()
    
    var firstTimeLoading: Bool = false
    //var firstTimeLoading: Bool = true
    
    override func viewDidLoad() {
        
        //model = Team.instance
        myTablView = tableView
        dataService = TeamService.instance
        able_type = "team"
        sections = ["", "更多"]
        Global.instance.setupTabbar(self)
        //Global.instance.menuPressedAction(menuBtn, self)
        
        //likeTab.topInset = 20
        
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
            ExpandableItems(isExpanded: false, items: [ARENA_KEY,DEGREE_KEY])
        ]
        
        super.viewDidLoad()
        
        //searchTableView = tableView
        let cellNib = UINib(nibName: "EditCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "cell")
        
        let cellNibName = UINib(nibName: "TeamListCell", bundle: nil)
        tableView.register(cellNibName, forCellReuseIdentifier: "listCell")
        
        searchTags = [
            ["key": "like", "selected": true, "tag": 0, "class": likeTab],
            ["key": "search", "selected": false, "tag": 1, "class": searchTab],
            ["key": "all", "selected": false, "tag": 2, "class": allTab]
        ]
        
        //print(searchTags)
        
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(tabPressed))
        likeTab.addGestureRecognizer(likeTap)
        let searchTap = UITapGestureRecognizer(target: self, action: #selector(tabPressed))
        searchTab.addGestureRecognizer(searchTap)
        let allTap = UITapGestureRecognizer(target: self, action: #selector(tabPressed))
        allTab.addGestureRecognizer(allTap)
        
        updateTabSelected(idx: selectedTagIdx)
        //submitBtn.visibility = .invisible
        bottomView.visibility = .invisible
        tableViewBottomConstraint.constant = 0
        
        member_like = true
        refresh()
        
        //submitBtn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 20, bottom: 6, right: 20)
        //submitBtn.layer.cornerRadius = 12
//        citys.append(City(id: 218, name: ""))
//        citys.append(City(id: 257, name: ""))
        //Session.shared.clear(key: Session.shared.loginResetKey)
//        if !Session.shared.exist(key: Session.shared.loginResetKey) {
//            Session.shared.loginReset = gReset
//        }
    }
    
//    override func refresh() {
//
//        //member like team list
//        switch selectedTagIdx {
//        case 0:
//            member_like = true
//            page = 1
//            getDataStart(page: page, perPage: PERPAGE)
//        case 2:
//            member_like = false
//            page = 1
//            getDataStart(page: page, perPage: PERPAGE)
//        default:
//            let i = 6
//
//        }
//    }
    
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
    
    override func genericTable() {
        
        do {
            if (jsonData != nil) {
                mysTable = try JSONDecoder().decode(TeamsTable.self, from: jsonData!)
            } else {
                warning("無法從伺服器取得正確的json資料，請洽管理員")
            }
        } catch {
            msg = "解析JSON字串時，得到空值，請洽管理員"
        }
        if (mysTable != nil) {
            tables = mysTable!
            if (page == 1) {
                lists1 = [TeamTable]()
            }
            lists1 += mysTable!.rows
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if (selectedTagIdx == 1) {
            return searchSections.count
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count: Int = 0
        
        switch selectedTagIdx {
            
        case 0:
            count = lists1.count
        case 1:
            if !searchSections[section].isExpanded {
                count = 0
            } else {
                count = searchSections[section].items.count
            }
        case 2:
            count = lists1.count
        default:
            count = searchSections.count
        
        }
        return count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if (selectedTagIdx == 1) {
            if section == 0 {
                return 0
            }
            return heightForSection
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if (selectedTagIdx == 1) {
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
        } else {
            return UIView()
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 60
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch selectedTagIdx {
        case 0, 2:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as? TeamListCell {
                
                cell.cellDelegate = self
                let row = lists1[indexPath.row] as? TeamTable
                if row != nil {
                    row!.filterRow()
                    //row!.printRow()
                    cell.updateViews(row!)
                }
                
                return cell
            } else {
                return ListCell()
            }
        case 1:
            //print("section: \(indexPath.section), row: \(indexPath.row)")
            let cell: EditCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EditCell
            cell.editCellDelegate = self
            
            let searchRow = getDefinedRow(indexPath.section, indexPath.row)
            //print(searchRow)
            cell.forRow(indexPath: indexPath, row: searchRow, isClear: true)
    //        let row: [String: Any] = getDefinedRow(indexPath.section, indexPath.row)
    //        cell.forRow(indexPath: indexPath, row: row, isClear: true)
            
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Global.instance.addSpinner(superView: view)
        //Global.instance.removeSpinner(superView: view)
        if (selectedTagIdx == 1) {
            
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
                        
    //                    var type: SELECT_TIME_TYPE = SELECT_TIME_TYPE.play_start
    //                    if (key == END_TIME_KEY) {
    //                        type = SELECT_TIME_TYPE.play_end
    //                    }
                        
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
                            toSelectArena(key: key, city: city!, selected: selected, delegate: self)
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
        } else if (selectedTagIdx == 0 || selectedTagIdx == 2) {
            if mysTable != nil {
                let myTable = mysTable!.rows[indexPath.row]
                toShowTeam(token: myTable.token)
            }
        }
    }
    
    func getDefinedRow(_ section: Int, _ row: Int) -> [String: Any] {
        let key = searchSections[section].items[row]
        return getDefinedRow(key)
    }
    
    override func singleSelected(key: String, selected: String, show: String?=nil) {
        
        var row = getDefinedRow(key)
        var _show = ""
        if key == START_TIME_KEY || key == END_TIME_KEY {
            row["value"] = selected
            _show = selected.noSec()
        } else if (key == CITY_KEY || key == AREA_KEY) {
            row["value"] = selected
            _show = Global.instance.zoneIDToName(Int(selected)!)
        } else if (key == ARENA_KEY) {
            row["value"] = selected
            if (show != nil) {
                _show = show!
            }
        }
        row["show"] = _show
        replaceRows(key, row)
        tableView.reloadData()
    }
    
    override func setWeekdaysData(res: [Int]) {
        var row = getDefinedRow(WEEKDAY_KEY)
        var texts: [String] = [String]()
        var values: [String] = [String]()
        if res.count > 0 {
            for day in res {
                values.append(String(day))
                for gday in Global.instance.weekdays {
                    if day == gday["value"] as! Int {
                        let text = gday["simple_text"]
                        texts.append(text! as! String)
                        break
                    }
                }
            }
            row["show"] = texts.joined(separator: ",")
        
            row["value"] = values.joined(separator: ",")
        } else {
            row["show"] = "全部"
        }
        replaceRows(WEEKDAY_KEY, row)
        tableView.reloadData()
    }
    
    override func setDegreeData(res: [DEGREE]) {
        
        var row = getDefinedRow(DEGREE_KEY)
        var names: [String] = [String]()
        var values: [String] = [String]()
        if res.count > 0 {
            for degree in res {
                names.append(degree.rawValue)
                values.append(DEGREE.DBValue(degree))
            }
            row["show"] = names.joined(separator: ",")
            row["value"] = values.joined(separator: ",")
        } else {
            row["show"] = "全部"
            row["value"] = ""
        }
        replaceRows(DEGREE_KEY, row)
        tableView.reloadData()
    }
    
    @objc func tabPressed(sender: UITapGestureRecognizer) {
                
        if let idx: Int = sender.view?.tag {
            
            let selectedTag: [String: Any] = searchTags[idx]
            if let selected: Bool = selectedTag["selected"] as? Bool {

                //按了其他頁面的按鈕
                if (!selected) {
                    updateTabSelected(idx: idx)
                    selectedTagIdx = idx
                    switch selectedTagIdx {
                    case 1:
                        //submitBtn.visibility = .visible
                        bottomView.visibility = .visible
                        tableViewBottomConstraint.constant = 100
                        tableView.reloadData()
                    case 0:
                        member_like = true
                        //submitBtn.visibility = .invisible
                        bottomView.visibility = .invisible
                        tableViewBottomConstraint.constant = 0
                        refresh()
                    case 2:
                        member_like = false
                        //submitBtn.visibility = .invisible
                        bottomView.visibility = .invisible
                        tableViewBottomConstraint.constant = 0
                        refresh()
                    default:
                        refresh()
                    }
                }
            }
        }
    }
    
    private func updateTabSelected(idx: Int) {
        
        // set user click which tag, set tag selected is true
        for (i, var searchTag) in searchTags.enumerated() {
            
            if (i == idx) {
                searchTag["selected"] = true
            } else {
                searchTag["selected"] = false
            }
            searchTags[i] = searchTag
        }
        setTabSelectedStyle()
    }
    
    private func setTabSelectedStyle() {
        
        for searchTag in searchTags {
            if (searchTag.keyExist(key: "class")) {
                let tag: Tag = (searchTag["class"] as? Tag)!
                tag.selected = searchTag["selected"] as! Bool
                tag.setSelectedStyle()
            }
        }
    }
    
    @objc func handleExpandClose(gesture: UITapGestureRecognizer) {
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
