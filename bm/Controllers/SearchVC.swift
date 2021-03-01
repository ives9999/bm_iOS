//
//  SearchVC.swift
//  bm
//
//  Created by ives on 2018/9/26.
//  Copyright © 2018年 bm. All rights reserved.
//

import UIKit

class SearchVC: MyTableVC, UINavigationControllerDelegate, CitySelectDelegate, ArenaSelectDelegate, WeekdaysSelectDelegate, TimeSelectDelegate, DegreeSelectDelegate, EditCellDelegate {
    
    @IBOutlet weak var submitBtn: UIButton!
    
    let heightForSection: CGFloat = 34
    //search type: temp_play, coach, team, teach
    var type: String!
    var model: Team!
    var _rows: [[String: Any]] = [
        ["ch":"關鍵字","atype":UITableViewCellAccessoryType.none,"key":"keyword","show":"","hint":"請輸入球隊名稱關鍵字","text_field":true],
        ["ch":"縣市","atype":UITableViewCellAccessoryType.disclosureIndicator,"key":CITY_KEY,"show":"全部","segue":TO_CITY,"sender":0],
        //            ["ch": "區域","atype":UITableViewCellAccessoryType.disclosureIndicator,"key":"team_area","show":"全部","segue":TO_ARENA,"sender":0],
        ["ch":"日期","atype":UITableViewCellAccessoryType.disclosureIndicator,"key":TEAM_WEEKDAYS_KEY,"show":"全部","segue":TO_SELECT_WEEKDAY,"sender":[Int]()],
        ["ch":"時段","atype":UITableViewCellAccessoryType.disclosureIndicator,"key":TEAM_PLAY_START_KEY,"show":"全部","segue":TO_SELECT_TIME,"sender":[String: Any]()],
//        ["ch":"結束時間","atype":UITableViewCellAccessoryType.disclosureIndicator,"key":TEAM_PLAY_END_KEY,"show":"全部","segue":TO_SELECT_TIME,"sender":[String: Any]()],
        ["ch":"球館","atype":UITableViewCellAccessoryType.disclosureIndicator,"key":ARENA_KEY,"show":"全部","segue":TO_ARENA,"sender":[String:Int]()],
        ["ch":"程度","atype":UITableViewCellAccessoryType.disclosureIndicator,"key":TEAM_DEGREE_KEY,"show":"全部","segue":TO_SELECT_DEGREE,"sender":[String]()]
    ]
    
    var tables = [
        ExpandableItems(isExpanded: true, items: ["keyword",CITY_KEY,TEAM_WEEKDAYS_KEY, TEAM_PLAY_START_KEY]),
        ExpandableItems(isExpanded: false, items: [ARENA_KEY,TEAM_DEGREE_KEY])
    ]

    var citys: [City] = [City]()
    var arenas: [Arena] = [Arena]()
    var weekdays: [Int] = [Int]()
    var degrees: [Degree] = [Degree]()
    
    //key has type, play_start_time, play_end_time, time
    var times: [String: Any] = [String: Any]()
    var keyword: String = ""
    
    var firstTimeLoading: Bool = false
    //var firstTimeLoading: Bool = true
    
    override func viewDidLoad() {
        
        model = Team.instance
        myTablView = tableView
        sections = ["", "更多"]
        Global.instance.setupTabbar(self)
        //Global.instance.menuPressedAction(menuBtn, self)
        super.viewDidLoad()
        let cellNib = UINib(nibName: "EditCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "cell")
        submitBtn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 20, bottom: 6, right: 20)
        submitBtn.layer.cornerRadius = 12
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //print("section: \(indexPath.section), row: \(indexPath.row)")
        let cell: EditCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EditCell
        cell.editCellDelegate = self
        let row: [String: Any] = getDefinedRow(indexPath.section, indexPath.row)
        cell.forRow(indexPath: indexPath, row: row, isClear: true)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Global.instance.addSpinner(superView: view)
        Global.instance.removeSpinner(superView: view)
        let row: [String: Any] = getDefinedRow(indexPath.section, indexPath.row)
        let cell = tableView.cellForRow(at: indexPath) as! EditCell
        if row["atype"] as! UITableViewCellAccessoryType != UITableViewCellAccessoryType.none {
            if row["segue"] != nil {
                let segue: String = row["segue"] as! String
                //print(iden)
                if segue == TO_ARENA && citys.count == 0 {
                    SCLAlertView().showError("錯誤", subTitle: "請先選擇縣市")
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
            cell.editText.becomeFirstResponder()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationNavigationController: UINavigationController?
        if segue.identifier == TO_CITY {
            let citySelectVC: CitySelectVC = segue.destination as! CitySelectVC
            
            citySelectVC.delegate = self
            citySelectVC.source = "search"
            citySelectVC.type = "simple"
            citySelectVC.select = "multi"
            citySelectVC.citys = citys
        } else if segue.identifier == TO_ARENA {
            let arenaSelectVC: ArenaSelectVC = segue.destination as! ArenaSelectVC
            arenaSelectVC.source = "search"
            arenaSelectVC.type = "simple"
            arenaSelectVC.select = "multi"
            var _citys: [Int] = [Int]()
            for city in citys {
                _citys.append(city.id)
            }
            arenaSelectVC.citys = _citys
            arenaSelectVC.arenas = arenas
            arenaSelectVC.delegate = self
        } else if segue.identifier == TO_SELECT_WEEKDAY {
            let weekdaysSelectVC: WeekdaysSelectVC = segue.destination as! WeekdaysSelectVC
            weekdaysSelectVC.source = "search"
            weekdaysSelectVC.selecteds = weekdays
            weekdaysSelectVC.delegate = self
        } else if segue.identifier == TO_SELECT_TIME {
            let timeSelectVC: TimeSelectVC = segue.destination as! TimeSelectVC
            timeSelectVC.source = "search"
            timeSelectVC.input = times
            timeSelectVC.delegate = self
        } else if segue.identifier == TO_SELECT_DEGREE {
            let degreeSelectVC: DegreeSelectVC = segue.destination as! DegreeSelectVC
            degreeSelectVC.source = "search"
            degreeSelectVC.degrees = degrees
            degreeSelectVC.delegate = self
        } else if segue.identifier == TO_TEMP_PLAY_LIST {
            let tempPlayVC: TempPlayVC = segue.destination as! TempPlayVC
            tempPlayVC.citys = citys
            tempPlayVC.arenas = arenas
            tempPlayVC.days = weekdays
            tempPlayVC.times = times
            tempPlayVC.degrees = degrees
            tempPlayVC.keyword = keyword
        }
    }
    
    func setCityData(id: Int, name: String) {
        //not use
    }
    func setCitysData(res: [City]) {
        //print(res)
        var row = getDefinedRow(CITY_KEY)
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
        replaceRows(CITY_KEY, row)
        tableView.reloadData()
    }
    
    func setArenaData(id: Int, name: String) {
        //not use
    }
    func setArenasData(res: [Arena]) {
        //print(res)
        var row = getDefinedRow(ARENA_KEY)
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
        replaceRows(ARENA_KEY, row)
        tableView.reloadData()
    }
    
    func setWeekdaysData(res: [Int], indexPath: IndexPath?) {
        var row = getDefinedRow(TEAM_WEEKDAYS_KEY)
        var texts: [String] = [String]()
        weekdays = res
        if weekdays.count > 0 {
            for weekday in weekdays {
                for gweekday in Global.instance.weekdays {
                    if weekday == gweekday["value"] as! Int {
                        let text = gweekday["simple_text"]
                        texts.append(text! as! String)
                        break
                    }
                }
            }
            row["show"] = texts.joined(separator: ",")
        } else {
            row["show"] = "全部"
        }
        replaceRows(TEAM_WEEKDAYS_KEY, row)
        tableView.reloadData()
    }
    
    func setTimeData(res: [String], type: SELECT_TIME_TYPE, indexPath: IndexPath?) {
        let time = res[0]
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
    
    func setTextField(iden: String, value: String) {
        keyword = value
    }
    func setSwitch(indexPath: IndexPath, value: Bool) {
    }
    func clear(indexPath: IndexPath) {
        var row = getDefinedRow(indexPath.section, indexPath.row)
        //print(row)
        let key = row["key"] as! String
        switch key {
        case CITY_KEY:
            citys.removeAll()
        case TEAM_WEEKDAYS_KEY:
            weekdays.removeAll()
        case TEAM_PLAY_START_KEY:
            times.removeAll()
        case ARENA_KEY:
            arenas.removeAll()
        case TEAM_DEGREE_KEY:
            degrees.removeAll()
        default:
            _ = 1
        }
        row["show"] = "全部"
        replaceRows(key, row)
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
