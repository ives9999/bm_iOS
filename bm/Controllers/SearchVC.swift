//
//  SearchVC.swift
//  bm
//
//  Created by ives on 2018/9/26.
//  Copyright © 2018年 bm. All rights reserved.
//

import UIKit

class SearchVC: MyTableVC, UINavigationControllerDelegate, CitySelectDelegate, ArenaSelectDelegate, DaysSelectDelegate, TimeSelectDelegate, DegreeSelectDelegate, TeamSubmitCellDelegate {
    
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitBtn: UIButton!
    
    let heightForSection: CGFloat = 34
    //search type: temp_play, coach, team, course
    var type: String!
    var model: Team!
    var _rows: [[String: Any]] = [
        ["ch":"關鍵字","atype":UITableViewCellAccessoryType.none,"key":"keyword","show":"","hint":"請輸入球隊名稱關鍵字"],
        ["ch":"縣市","atype":UITableViewCellAccessoryType.disclosureIndicator,"key":TEAM_CITY_KEY,"show":"全部","segue":TO_CITY,"sender":0],
        //            ["ch": "區域","atype":UITableViewCellAccessoryType.disclosureIndicator,"key":"team_area","show":"全部","segue":TO_ARENA,"sender":0],
        ["ch":"日期","atype":UITableViewCellAccessoryType.disclosureIndicator,"key":TEAM_DAYS_KEY,"show":"全部","segue":TO_DAY,"sender":[Int]()],
        ["ch":"時段","atype":UITableViewCellAccessoryType.disclosureIndicator,"key":TEAM_PLAY_START_KEY,"show":"全部","segue":TO_SELECT_TIME,"sender":[String: Any]()],
//        ["ch":"結束時間","atype":UITableViewCellAccessoryType.disclosureIndicator,"key":TEAM_PLAY_END_KEY,"show":"全部","segue":TO_SELECT_TIME,"sender":[String: Any]()],
        ["ch":"球館","atype":UITableViewCellAccessoryType.disclosureIndicator,"key":TEAM_ARENA_KEY,"show":"全部","segue":TO_ARENA,"sender":[String:Int]()],
        ["ch":"程度","atype":UITableViewCellAccessoryType.disclosureIndicator,"key":TEAM_DEGREE_KEY,"show":"全部","segue":TO_SELECT_DEGREE,"sender":[String]()]
    ]
    
    var tables = [
        ExpandableItems(isExpanded: true, items: ["keyword",TEAM_CITY_KEY,TEAM_DAYS_KEY, TEAM_PLAY_START_KEY]),
        ExpandableItems(isExpanded: false, items: [TEAM_ARENA_KEY,TEAM_DEGREE_KEY])
    ]

    var citys: [City] = [City]()
    var arenas: [Arena] = [Arena]()
    var days: [Int] = [Int]()
    var degrees: [Degree] = [Degree]()
    
    //key has type, play_start_time, play_end_time, time
    var times: [String: Any] = [String: Any]()
    
    override func viewDidLoad() {
        model = Team.instance
        myTablView = tableView
        sections = ["", "更多"]
        Global.instance.setupTabbar(self)
        Global.instance.menuPressedAction(menuBtn, self)
        super.viewDidLoad()
        tableView.register(TeamSubmitCell.self, forCellReuseIdentifier: "cell")
        submitBtn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 20, bottom: 6, right: 20)
        submitBtn.layer.cornerRadius = 12
//        citys.append(City(id: 218, name: ""))
//        citys.append(City(id: 257, name: ""))
    }
    
    @IBAction func submit(_ sender: Any) {
        performSegue(withIdentifier: TO_TEMP_PLAY_LIST, sender: nil)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tables.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !tables[section].isExpanded {
            return 0
        }
        return tables[section].items.count
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //print("section: \(indexPath.section), row: \(indexPath.row)")
        let cell: TeamSubmitCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TeamSubmitCell
        cell.teamSubmitCellDelegate = self
        let row: [String: Any] = getDefinedRow(indexPath.section, indexPath.row)
        cell.forRow(row: row)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row: [String: Any] = getDefinedRow(indexPath.section, indexPath.row)
        let cell = tableView.cellForRow(at: indexPath) as! TeamSubmitCell
        if row["atype"] as! UITableViewCellAccessoryType != UITableViewCellAccessoryType.none {
            if row["segue"] != nil {
                let segue: String = row["segue"] as! String
                //print(iden)
                if segue == TO_ARENA && citys.count == 0 {
                    SCLAlertView().showError("錯誤", subTitle: "請先選擇區域")
                } else if segue == TO_SELECT_TIME {
                    if row["key"] as! String == TEAM_PLAY_START_KEY {
                        times["type"] = SELECT_TIME_TYPE.play_start
                        if times[TEAM_PLAY_START_KEY] != nil {
                            times["time"] = times[TEAM_PLAY_START_KEY]
                        }
                    } else {
                        times["type"] = SELECT_TIME_TYPE.play_end
                        if times[TEAM_PLAY_END_KEY] != nil {
                            times["time"] = times[TEAM_PLAY_END_KEY]
                        }
                    }
                    performSegue(withIdentifier: segue, sender: row["sender"])
                } else {
                    performSegue(withIdentifier: segue, sender: row["sender"])
                }
            }
        } else {
            cell.generalTextField.becomeFirstResponder()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationNavigationController: UINavigationController?
        if segue.identifier == TO_CITY {
            destinationNavigationController = (segue.destination as! UINavigationController)
            let citySelectVC: CitySelectVC = destinationNavigationController!.topViewController as! CitySelectVC
            citySelectVC.delegate = self
            citySelectVC.source = "search"
            citySelectVC.type = "simple"
            citySelectVC.select = "multi"
            citySelectVC.citys = citys
        } else if segue.identifier == TO_ARENA {
            destinationNavigationController = (segue.destination as! UINavigationController)
            let arenaSelectVC: ArenaSelectVC = destinationNavigationController!.topViewController as! ArenaSelectVC
            arenaSelectVC.source = "search"
            arenaSelectVC.select = "multi"
            var _citys: [Int] = [Int]()
            for city in citys {
                _citys.append(city.id)
            }
            arenaSelectVC.citys = _citys
            arenaSelectVC.arenas = arenas
            arenaSelectVC.delegate = self
        } else if segue.identifier == TO_DAY {
            destinationNavigationController = (segue.destination as! UINavigationController)
            let daysSelectVC: DaysSelectVC = destinationNavigationController!.topViewController as! DaysSelectVC
            daysSelectVC.source = "search"
            daysSelectVC.selectedDays = days
            daysSelectVC.delegate = self
        } else if segue.identifier == TO_SELECT_TIME {
            destinationNavigationController = (segue.destination as! UINavigationController)
            let timeSelectVC: TimeSelectVC = destinationNavigationController!.topViewController as! TimeSelectVC
            timeSelectVC.source = "search"
            timeSelectVC.input = times
            timeSelectVC.delegate = self
        } else if segue.identifier == TO_SELECT_DEGREE {
            destinationNavigationController = (segue.destination as! UINavigationController)
            let degreeSelectVC: DegreeSelectVC = destinationNavigationController!.topViewController as! DegreeSelectVC
            degreeSelectVC.source = "search"
            degreeSelectVC.degrees = degrees
            degreeSelectVC.delegate = self
        } else if segue.identifier == TO_TEMP_PLAY_LIST {
            let tempPlayVC: TempPlayVC = segue.destination as! TempPlayVC
            tempPlayVC.citys = citys
            tempPlayVC.arenas = arenas
            tempPlayVC.days = days
            tempPlayVC.times = times
            tempPlayVC.degrees = degrees
        }
    }
    
    func setCityData(id: Int, name: String) {
        //not use
    }
    func setCitysData(res: [City]) {
        //print(res)
        var row = getDefinedRow(TEAM_CITY_KEY)
        var texts: [String] = [String]()
        citys = res
        if citys.count > 0 {
            for city in citys {
                let text = city.name
                texts.append(text)
            }
            row["show"] = texts.joined(separator: ",")
        } else {
            row["show"] = "全部"
        }
        replaceRows(TEAM_CITY_KEY, row)
        tableView.reloadData()
    }
    
    func setArenaData(id: Int, name: String) {
        //not use
    }
    func setArenasData(res: [Arena]) {
        //print(res)
        var row = getDefinedRow(TEAM_ARENA_KEY)
        var texts: [String] = [String]()
        arenas = res
        if arenas.count > 0 {
            for arena in arenas {
                let text = arena.title
                texts.append(text)
            }
            row["show"] = texts.joined(separator: ",")
        } else {
            row["show"] = "全部"
        }
        replaceRows(TEAM_ARENA_KEY, row)
        tableView.reloadData()
    }
    
    func setDaysData(res: [Int]) {
        var row = getDefinedRow(TEAM_DAYS_KEY)
        var texts: [String] = [String]()
        days = res
        if days.count > 0 {
            for day in days {
                for gday in Global.instance.days {
                    if day == gday["value"] as! Int {
                        let text = gday["simple_text"]
                        texts.append(text! as! String)
                        break
                    }
                }
            }
            row["show"] = texts.joined(separator: ",")
        } else {
            row["show"] = "全部"
        }
        replaceRows(TEAM_DAYS_KEY, row)
        tableView.reloadData()
    }
    
    func setTimeData(time: String, type: SELECT_TIME_TYPE) {
        var row: [String: Any]
        var text = ""
        if time == "" {
            text = "全部"
        } else {
            text = time
        }
        switch type {
        case SELECT_TIME_TYPE.play_start:
            times[TEAM_PLAY_START_KEY] = time
            row = getDefinedRow(TEAM_PLAY_START_KEY)
            row["show"] = text
            replaceRows(TEAM_PLAY_START_KEY, row)
            break
        case SELECT_TIME_TYPE.play_end:
            times[TEAM_PLAY_END_KEY] = time
            row = getDefinedRow(TEAM_PLAY_END_KEY)
            row["show"] = text
            replaceRows(TEAM_PLAY_END_KEY, row)
            break
        }
        tableView.reloadData()
    }
    
    func setTextField(iden: String, value: String) {
        
    }
    
    func setDegreeData(res: [Degree]) {
        var row = getDefinedRow(TEAM_DEGREE_KEY)
        var texts: [String] = [String]()
        degrees = res
        if degrees.count > 0 {
            for degree in degrees {
                texts.append(degree.text)
            }
            row["show"] = texts.joined(separator: ",")
        } else {
            row["show"] = "全部"
        }
        replaceRows(TEAM_DEGREE_KEY, row)
        tableView.reloadData()
    }
    
    private func getDefinedRow(_ section: Int, _ row: Int) -> [String: Any] {
        let key = tables[section].items[row]
        return getDefinedRow(key)
    }
    private func getDefinedRow(_ key: String) -> [String: Any] {
        for row in _rows {
            if row["key"] as! String == key {
                return row
            }
        }
        return [String: Any]()
    }
    
    private func replaceRows(_ key: String, _ row: [String: Any]) {
        for (idx, _row) in _rows.enumerated() {
            if _row["key"] as! String == key {
                _rows[idx] = row
                break;
            }
        }
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
        for idx in tables[section].items.indices {
            let indexPath = IndexPath(row: idx, section: section)
            indexPaths.append(indexPath)
        }
        
        let isExpanded = tables[section].isExpanded
        tables[section].isExpanded = !isExpanded
        
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
}

struct ExpandableItems {
    var isExpanded: Bool
    let items: [String]
}
