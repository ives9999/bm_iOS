//
//  SearchVC.swift
//  bm
//
//  Created by ives on 2018/9/26.
//  Copyright © 2018年 bm. All rights reserved.
//

import UIKit
import SCLAlertView
import CryptoSwift

class SearchVC: MyTableVC, UINavigationControllerDelegate {
    
    @IBOutlet weak var submitBtn: SubmitButton!
//    @IBOutlet weak var likeTab: Tag!
//    @IBOutlet weak var searchTab: Tag!
//    @IBOutlet weak var allTab: Tag!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewContainer: UIView!
    @IBOutlet weak var tableViewContainerleading: NSLayoutConstraint!
    @IBOutlet weak var tableViewContainertrailing: NSLayoutConstraint!
    @IBOutlet weak var tableViewContainerBottom: NSLayoutConstraint!
    //@IBOutlet weak var bottomView: BottomView!
    @IBOutlet weak var topTabContainer: UIStackView!
        
    var searchTabs: [[String: Any]] = [[String: Any]]()
    var focusTabIdx: Int = 0
    let heightForSection: CGFloat = 34
    
    var mysTable: TeamsTable?
        
    var firstTimeLoading: Bool = false
    //var firstTimeLoading: Bool = true
    
    //當按下球館搜尋時，必須把球館名稱記錄到oneRow的球館show上
    
    override func viewDidLoad() {
        
        //Global.instance.setupTabbar(self)
        
        myTablView = tableView
        dataService = TeamService.instance
        able_type = "team"

        
        
//        searchRows = [
//            ["ch":"關鍵字","atype":UITableViewCell.AccessoryType.none,"key":"keyword","show":"","hint":"請輸入球隊名稱關鍵字","text_field":true,"value":""],
//            ["ch":"縣市","atype":UITableViewCell.AccessoryType.disclosureIndicator,"key":CITY_KEY,"show":"全部","segue":TO_CITY,"sender":0,"value":""],
//            //            ["ch": "區域","atype":UITableViewCellAccessoryType.disclosureIndicator,"key":"team_area","show":"全部","segue":TO_ARENA,"sender":0],
//            ["ch":"星期幾","atype":UITableViewCell.AccessoryType.disclosureIndicator,"key":WEEKDAY_KEY,"show":"全部","segue":TO_SELECT_WEEKDAY,"sender":[Int](),"value":""],
//            ["ch":"時段","atype":UITableViewCell.AccessoryType.disclosureIndicator,"key":START_TIME_KEY,"show":"全部","segue":TO_SELECT_TIME,"sender":[String: Any](),"value":""],
//            ["ch":"球館","atype":UITableViewCell.AccessoryType.disclosureIndicator,"key":ARENA_KEY,"show":"全部","segue":TO_ARENA,"sender":[String:Int](),"value":""],
//            ["ch":"程度","atype":UITableViewCell.AccessoryType.disclosureIndicator,"key":DEGREE_KEY,"show":"全部","segue":TO_SELECT_DEGREE,"sender":[String](),"value":""]
//        ]
//
//        searchSections = [
//            ExpandableItems(isExpanded: true, items: ["keyword",CITY_KEY,WEEKDAY_KEY, START_TIME_KEY]),
//            ExpandableItems(isExpanded: false, items: [ARENA_KEY,DEGREE_KEY])
//        ]
        
        super.viewDidLoad()
        
//        let cellNib = UINib(nibName: "EditCell", bundle: nil)
//        tableView.register(cellNib, forCellReuseIdentifier: "cell")
        
        if (tableViewContainer != nil) {
            tableViewContainer.layer.cornerRadius = CORNER_RADIUS
            tableViewContainer.clipsToBounds = true
        }
        
        let textFieldNib = UINib(nibName: "TextFieldCell", bundle: nil)
        tableView.register(textFieldNib, forCellReuseIdentifier: "textFieldCell")
        
        let moreCellNib = UINib(nibName: "MoreCell", bundle: nil)
        tableView.register(moreCellNib, forCellReuseIdentifier: "moreCell")

        let cellNibName = UINib(nibName: "TeamListCell", bundle: nil)
        tableView.register(cellNibName, forCellReuseIdentifier: "listCell")

        searchTabs = [
            ["key": "like", "icon": "like", "text": "喜歡", "focus": true, "tag": 0, "class": ""],
            ["key": "search", "icon": "search_w", "text": "搜尋", "focus": false, "tag": 1, "class": ""],
            ["key": "all", "icon": "all_list", "text": "全部", "focus": false, "tag": 2, "class": ""]
        ]

        //print(searchTags)
        
        oneSections = initSectionRows1()
        
        initTabTop()

        //bottomView.visibility = .invisible
        tableViewBottomConstraint.constant = 0
        tableViewContainer.backgroundColor = UIColor.clear

        member_like = true
        refresh()
    }
    
    func initSectionRows1()-> [OneSection] {

        var sections: [OneSection] = [OneSection]()

        sections.append(makeSection0Row1())
        sections.append(makeSection1Row1(false))

        return sections
    }
    
    func initTabTop() {
        
        let count: Int = 3
        let tab_width: Int = 80
        
        let padding: Int = (Int(screen_width) - count * tab_width) / (count+1)
        
        for (idx, searchTab) in searchTabs.enumerated() {
            let x: Int = idx * tab_width + (idx + 1)*padding
            let rect: CGRect = CGRect(x: x, y: 0, width: 80, height: 50)
            
            let tab = TabTop(frame: rect)
            if let tmp: Int = searchTab["tag"] as? Int {
                tab.tag = tmp
            }
            
            var icon: String = "like"
            if let tmp: String = searchTab["icon"] as? String {
                icon = tmp
            }
            
            var text: String = "喜歡"
            if let tmp: String = searchTab["text"] as? String {
                text = tmp
            }
            
            tab.setData(iconStr: icon, text: text)
            
            var isSelected: Bool = false
            if let tmp: Bool = searchTab["focus"] as? Bool {
                isSelected = tmp
            }
            tab.isFocus(isSelected)
            
            let tabTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tabPressed))
            tab.addGestureRecognizer(tabTap)
            
            searchTabs[idx]["class"] = tab
            
            topTabContainer.addSubview(tab)
        }
    }
    
    func makeSection0Row1(_ isExpanded: Bool=true)-> OneSection {
        var rows: [OneRow] = [OneRow]()
        let r1: OneRow = OneRow(title: "關鍵字", key: KEYWORD_KEY, cell: "textField")
        rows.append(r1)
        let r2: OneRow = OneRow(title: "縣市", show: "全部", key: CITY_KEY, cell: "more", accessory: UITableViewCell.AccessoryType.disclosureIndicator)
        rows.append(r2)
        let r3: OneRow = OneRow(title: "星期幾", show: "全部", key: WEEKDAYS_KEY, cell: "more", accessory: UITableViewCell.AccessoryType.disclosureIndicator)
        rows.append(r3)
        let r4: OneRow = OneRow(title: "時段", show: "全部", key: START_TIME_KEY, cell: "more", accessory: UITableViewCell.AccessoryType.disclosureIndicator)
        rows.append(r4)

        let s: OneSection = OneSection(title: "一般", key: "general", isExpanded: isExpanded)
        s.items.append(contentsOf: rows)
        return s
    }
    
    private func makeSection1Row1(_ isExpanded: Bool=true)-> OneSection {
        var rows: [OneRow] = [OneRow]()
        let r1: OneRow = OneRow(title: "球館", show: "全部", key: ARENA_KEY, cell: "more", accessory: UITableViewCell.AccessoryType.disclosureIndicator)
        rows.append(r1)
        let r2: OneRow = OneRow(title: "程度", show: "全部", key: DEGREE_KEY, cell:"more", accessory: UITableViewCell.AccessoryType.disclosureIndicator)
        rows.append(r2)

        let s: OneSection = OneSection(title: "更多", key: "more", isExpanded: isExpanded)
        s.items.append(contentsOf: rows)
        return s
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
    
//    override func viewDidAppear(_ animated: Bool) {
//
//        super.viewDidAppear(animated)
//
//        if (firstTimeLoading) {
//            if #available(iOS 13.0, *) {
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                if let viewController = storyboard.instantiateViewController(identifier: "banner")  as? HomeTotalAdVC {
//                    viewController.modalPresentationStyle = .overCurrentContext
//                    present(viewController, animated: true, completion: nil)
//                }
//            } else {
//                let viewController = self.storyboard!.instantiateViewController(withIdentifier: "banner") as! HomeTotalAdVC
//                self.navigationController!.pushViewController(viewController, animated: true)
//            }
//            firstTimeLoading = false
//        }
//    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        gReset = Session.shared.loginReset
//        if !gReset {
//            info("因為更新APP系統，請重新登出再登入，方能正常使用會員功能")
//        }
//    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if (focusTabIdx == 1) {
            return oneSections.count
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count: Int = 0
        
        switch focusTabIdx {
            
        case 0:
            count = lists1.count
        case 1:
            if !oneSections[section].isExpanded {
                count = 0
            } else {
                count = oneSections[section].items.count
            }
        case 2:
            count = lists1.count
        default:
            count = oneSections.count
        
        }
        return count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if (focusTabIdx == 1) {
            return heightForSection
        } else {
            return 0
        }
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        if (selectedTagIdx == 1) {
//            let headerView = UIView()
//            headerView.backgroundColor = UIColor.white
//            headerView.tag = section
//
//            let titleLabel = UILabel()
//            titleLabel.text = oneSections[section].title
//            titleLabel.textColor = UIColor.black
//            titleLabel.sizeToFit()
//            titleLabel.frame = CGRect(x: 10, y: 0, width: 100, height: heightForSection)
//            headerView.addSubview(titleLabel)
//
//            let mark = UIImageView(image: UIImage(named: "to_right"))
//            mark.frame = CGRect(x: view.frame.width-10-20, y: (heightForSection-20)/2, width: 20, height: 20)
//            headerView.addSubview(mark)
//
//            let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleExpandClose))
//            headerView.addGestureRecognizer(gesture)
//
//            return headerView
//        } else {
//            return UIView()
//        }
//    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 60
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch focusTabIdx {
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
                return UITableViewCell()
            }
        case 1:
            //print("section: \(indexPath.section), row: \(indexPath.row)")
            
            let row: OneRow = getOneRowFromIdx(indexPath.section, indexPath.row)
            let cell_type: String = row.cell
            if (cell_type == "more") {
                
                let cell: MoreCell = tableView.dequeueReusableCell(withIdentifier: "moreCell", for: indexPath) as! MoreCell
                cell.cellDelegate = self
                cell.update(sectionIdx: indexPath.section, rowIdx: indexPath.row, row: row)
                return cell
                
            } else if (row.cell == "textField") {
                
                let cell: TextFieldCell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as! TextFieldCell
                    
                //let cell: TextFieldCell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as! TextFieldCell
                cell.cellDelegate = self
                cell.update(sectionIdx: indexPath.section, rowIdx: indexPath.row, row: row)
                
                return cell
            } else {
//
//                let cell: EditCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EditCell
//                //print(searchRow)
//                cell.forRow(indexPath: indexPath, row: row, isClear: true)
//                cell.editCellDelegate = self
                return UITableViewCell()
            }
            
            
    //        let row: [String: Any] = getDefinedRow(indexPath.section, indexPath.row)
    //        cell.forRow(indexPath: indexPath, row: row, isClear: true)
            
            //return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Global.instance.addSpinner(superView: view)
        //Global.instance.removeSpinner(superView: view)
        if (focusTabIdx == 1) {
            
            let row: OneRow = getOneRowFromIdx(indexPath.section, indexPath.row)
            //let cell = tableView.cellForRow(at: indexPath) as! EditCell
            
            if row.accessory != UITableViewCell.AccessoryType.none {
                
                let key: String = row.key
                let cell_type: String = row.cell
                
                if (cell_type == "more") {
                    cellMoreClick(key: key, row: row, delegate: self)
                } else {
                    //performSegue(withIdentifier: segue, sender: indexPath)
                }
            } else {
                //cell.editText.becomeFirstResponder()
            }
        } else if (focusTabIdx == 0 || focusTabIdx == 2) {
            //if mysTable != nil {
                //let myTable = mysTable!.rows[indexPath.row]
            let row = lists1[indexPath.row]
            toShowTeam(token: row.token)
            //}
        }
    }
    
    //move to MyTableVC
//    func getDefinedRow(_ section: Int, _ row: Int) -> [String: Any] {
//        let key = searchSections[section].items[row]
//        return getDefinedRow(key)
//    }
    
    override func singleSelected(key: String, selected: String, show: String?=nil) {
        
        let row = getOneRowFromKey(key)
        var _show = ""
        if key == START_TIME_KEY || key == END_TIME_KEY {
            row.value = selected
            _show = selected.noSec()
        } else if (key == CITY_KEY || key == AREA_KEY) {
            row.value = selected
            _show = Global.instance.zoneIDToName(Int(selected)!)
        } else if (key == ARENA_KEY) {
            row.value = selected
            if (show != nil) {
                _show = show!
            }
        }
        row.show = _show
        //replaceRows(key, row)
        tableView.reloadData()
    }
    
    override func setWeekdaysData(selecteds: Int) {
        
//        let row = getOneRowFromKey(WEEKDAY_KEY)
//        var texts: [String] = [String]()
//        var values: [String] = [String]()
//        if selecteds.count > 0 {
//            for day in selecteds {
//                values.append(String(day))
//                for gday in Global.instance.weekdays {
//                    if day == gday["value"] as! Int {
//                        let text = gday["simple_text"]
//                        texts.append(text! as! String)
//                        break
//                    }
//                }
//            }
//            row.show = texts.joined(separator: ",")
//
//            row.value = values.joined(separator: ",")
//        } else {
//            row.show = "全部"
//        }
        //replaceRows(WEEKDAY_KEY, row)
        super.setWeekdaysData(selecteds: selecteds)
        tableView.reloadData()
    }
    
    override func setDegrees(res: [DEGREE]) {

        super.setDegrees(res: res)
        tableView.reloadData()
    }
    
//    override func setTextField(key: String, value: String) {
//
//        let row = getOneRowFromKey(key)
//        row.value = value
//        //replaceRows(key, row)
//    }
    
//    override func clear(indexPath: IndexPath) {
//
//        let sectionIdx = indexPath.section
//        var idx: Int = 0
//        for i in 0...sectionIdx-1 {
//            idx += oneSections[i].items.count
//        }
//        let rowIdx = indexPath.row
//        idx += rowIdx
//        let row = oneSections[sectionIdx].items[idx]
//        //let key = row.key
//        //var row1 = getDefinedRow(key)
//        row.show = "全部"
//        row.value = ""
//        //replaceRows(key, row1)
//    }
    
    override func cellCity(row: Table) {
        let _row: TeamTable = row as! TeamTable
        let arenaTable = _row.arena

        if (arenaTable != nil) {
            let key: String = CITY_KEY
            let city_id: Int = arenaTable!.city_id
            let row = getOneRowFromKey(key)
            row.value = String(city_id)
            row.show = Global.instance.zoneIDToName(city_id)
            //replaceRows(key, row)
            prepareParams()
            refresh()
        }
    }

    override func cellArena(row: Table) {

        let _row: TeamTable = row as! TeamTable
        let arenaTable = _row.arena

        if (arenaTable != nil) {
            let key: String = ARENA_KEY
            
            let arena_id: Int = arenaTable!.id
            let row2 = getOneRowFromKey(key)
            
            row2.value = String(arena_id)
            row2.show = arenaTable!.name
            
            let row3: OneRow = getOneRowFromKey(CITY_KEY)
            row3.value = String(arenaTable!.city_id)
            row3.show = Global.instance.zoneIDToName(arenaTable!.city_id)

            prepareParams()
            refresh()
        }
    }
    
    override func cellMap(row: Table) {
        
        let _row: TeamTable = row as! TeamTable
        let arenaTable = _row.arena
        _showMap(title: _row.name, address: arenaTable!.address)
    }
    
    @objc override func handleExpandClose(gesture : UITapGestureRecognizer) {
        
        let headerView = gesture.view!
        let section = headerView.tag
        let tmp = headerView.subviews.filter({$0 is UIImageView})
        var mark: UIImageView?
        if tmp.count > 0 {
            mark = tmp[0] as? UIImageView
        }
        
        var indexPaths: [IndexPath] = [IndexPath]()
        
//        let key: String = getSectionKey(idx: section)
        let oneSection: OneSection = oneSections[section]
        var isExpanded = oneSection.isExpanded
        oneSections[section].isExpanded = !isExpanded
        
        let items: [OneRow] = oneSection.items
        //let rows: [[String: String]] = getRowRowsFromMyRowsByKey(key: key)
        //indexPaths.append(IndexPath(row: 0, section: 1))
        //indexPaths.append(IndexPath(row: 1, section: 1))
        for (idx, _) in items.enumerated() {
            indexPaths.append(IndexPath(row: idx, section: section))
        }
        
        if isExpanded {
            tableView.deleteRows(at: indexPaths, with: .fade)
        } else {
            tableView.insertRows(at: indexPaths, with: .fade)
        }
        
        isExpanded = !isExpanded
        if mark != nil {
            toggleMark(mark: mark!, isExpanded: isExpanded)
        }
    }
    
    @objc func tabPressed(sender: UITapGestureRecognizer) {
                
        if let idx: Int = sender.view?.tag {
            
            let selectedTag: [String: Any] = searchTabs[idx]
            if let focus: Bool = selectedTag["focus"] as? Bool {

                //按了其他頁面的按鈕
                if (!focus) {
                    updateTabSelected(idx: idx)
                    focusTabIdx = idx
                    switch focusTabIdx {
                    case 1:
                        setFilterView()
                        tableView.reloadData()
                    case 0:
                        member_like = true
                        params.removeAll()
                        setListView()
                        refresh()
                    case 2:
                        member_like = false
                        params.removeAll()
                        setListView()
                        refresh()
                    default:
                        refresh()
                    }
                }
            }
        }
    }
    
    private func setFilterView() {
        //bottomView.visibility = .visible
        submitBtn.visibility = .visible
        //submitBtn.setColor(textColor: UIColor(MY_BLACK), bkColor: UIColor(MY_GREEN))
        submitBtn.backgroundColor = UIColor(MY_GREEN)
        submitBtn.titleLabel?.textColor = UIColor(MY_BLACK)
        //submitBtn.setTitleColor(.red, for: .normal)
        
        tableViewBottomConstraint.constant = 100
        tableViewContainer.backgroundColor = UIColor(SEARCH_BACKGROUND)
        tableViewContainerleading.constant = 4
        tableViewContainertrailing.constant = 4
        tableViewContainerBottom.constant = 100
    }
    
    private func setListView() {
        //bottomView.visibility = .invisible
        submitBtn.visibility = .invisible
        
        tableViewBottomConstraint.constant = 0
        tableViewContainer.backgroundColor = UIColor.clear
        tableViewContainerleading.constant = 0
        tableViewContainertrailing.constant = 0
        tableViewContainerBottom.constant = 0
    }
    
    private func updateTabSelected(idx: Int) {
        
        // set user click which tag, set tag selected is true
        for (i, var searchTab) in searchTabs.enumerated() {
            
            if (i == idx) {
                searchTab["focus"] = true
            } else {
                searchTab["focus"] = false
            }
            searchTabs[i] = searchTab
        }
        setTabSelectedStyle()
    }
    
    private func setTabSelectedStyle() {
        
        for searchTab in searchTabs {
            
            if (searchTab.keyExist(key: "class")) {
                
                let tab: TabTop = (searchTab["class"] as? TabTop)!
                
                var isFocus: Bool = false
                if let tmp: Bool = searchTab["focus"] as? Bool {
                    isFocus = tmp
                }
                
                tab.isFocus(isFocus)
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
