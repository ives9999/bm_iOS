//
//  ListVC.swift
//  bm
//
//  Created by ives on 2018/7/29.
//  Copyright © 2018年 bm. All rights reserved.
//

import UIKit
import SCLAlertView

protocol BackDelegate {
    func setBack(params: [String: Any])
}

class ListVC: MyTableVC, ListCellDelegate, EditCellDelegate, CitySelectDelegate, AreaSelectDelegate, ArenaSelectDelegate, WeekdaysSelectDelegate, TimeSelectDelegate, DegreeSelectDelegate, BackDelegate {
    func setBack(params: [String: Any]) {
        self.params = params
    }
    
    var _type: String = "coach"
    var _titleField: String = "name"
    internal(set) public var lists: [SuperData] = [SuperData]()
    
    var newY: CGFloat = 0
    
    let searchTableView: UITableView = {
        let cv = UITableView(frame: .zero, style: .plain)
        cv.backgroundColor = UIColor.black
        return cv
    }()
    
    let padding: CGFloat = 20
    let headerHeight: CGFloat = 84
    var layerHeight: CGFloat = 0
    
    var searchRows: [[String: Any]] = [[String: Any]]()
    
    var keyword: String = ""
    var citys: [City] = [City]()
    var areas: [Area] = [Area]()
    var air_condition: Bool = false
    var bathroom: Bool = false
    var parking: Bool = false
    var arenas: [Arena] = [Arena]()
    var weekdays: [Int] = [Int]()
    var degrees: [Degree] = [Degree]()
    
    //key has type, play_start_time, play_end_time, time
    var times: [String: Any] = [String: Any]()
    
    var params: [String: Any] = [String: Any]()
    
    var searchPanelisHidden = true
    
    internal(set) public var lists1: [Table] = [Table]()
    var params1: [String: Any]?
    var tables: Tables?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setIden(item:_type, titleField: _titleField)
        //let cellNibName = UINib(nibName: "ListCell", bundle: nil)
        //myTablView.register(cellNibName, forCellReuseIdentifier: "listcell")
        
        layerHeight = workAreaHeight - 100
        
        searchTableView.dataSource = self
        searchTableView.delegate = self
        
        let cellNibName = UINib(nibName: "List1Cell", bundle: nil)
        tableView.register(cellNibName, forCellReuseIdentifier: "listCell")
        
        let editCellNib = UINib(nibName: "EditCell", bundle: nil)
        searchTableView.register(editCellNib, forCellReuseIdentifier: "search_cell")
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.lightGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //print(params)
        if searchPanelisHidden {
            refresh()
        }
    }
    
    override func refresh() {
        page = 1
        getDataStart()
    }
    
    func getDataStart<T: Tables>(t: T.Type, page: Int = 1, perPage: Int = PERPAGE) {
        
        Global.instance.addSpinner(superView: self.view)

        dataService.getList(t: t, token: nil, _filter: params1, page: page, perPage: perPage) { (success) in
            if (success) {
                self.tables = self.dataService.tables!
                self.page = self.tables!.page
                if self.page == 1 {
                    self.totalCount = self.tables!.totalCount
                    self.perPage = self.tables!.perPage
                    let _pageCount: Int = self.totalCount / self.perPage
                    self.totalPage = (self.totalCount % self.perPage > 0) ? _pageCount + 1 : _pageCount
                    //print(self.totalPage)
                    if self.refreshControl.isRefreshing {
                        self.refreshControl.endRefreshing()
                    }
                }
                self.getDataEnd(success: success)
                Global.instance.removeSpinner(superView: self.view)
            } else {
                Global.instance.removeSpinner(superView: self.view)
                self.warning(self.dataService.msg)
            }
        }
    }
    
//    override func getDataStart(page: Int=1, perPage: Int=PERPAGE) {
//        //print(page)
//        Global.instance.addSpinner(superView: self.view)
//
//        dataService.getList(type: iden, titleField: titleField, params: params, page: page, perPage: perPage, filter: nil) { (success) in
//            Global.instance.removeSpinner(superView: self.view)
//            if (success) {
//                self.getDataEnd(success: success)
//            } else {
//                self.warning(self.dataService.msg)
//            }
//        }
//    }
    
    override func getDataEnd(success: Bool) {
        if success {
            let tmps: [SuperData] = dataService.dataLists
            //print(tmps)
            //print("===============")
            if page == 1 {
                lists = [SuperData]()
            }
            lists += tmps
            //print(self.lists)
            page = dataService.page
            if page == 1 {
                totalCount = dataService.totalCount
                perPage = dataService.perPage
                let _pageCount: Int = totalCount / perPage
                totalPage = (totalCount % perPage > 0) ? _pageCount + 1 : _pageCount
                //print(self.totalPage)
            }
            if refreshControl.isRefreshing {
                refreshControl.endRefreshing()
            }
            myTablView.reloadData()
            //self.page = self.page + 1 in CollectionView
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height: CGFloat = 0
        if tableView == searchTableView {
            height = 30
        }
        return height
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return lists.count
        } else {
            return searchRows.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "listcell", for: indexPath) as? ListCell {
                
                cell.cellDelegate = self
                //let row = lists[indexPath.row]
                //cell.updateViews(indexPath: indexPath, data: row, iden: _type)
                
                return cell
            } else {
                return ListCell()
            }
        } else if tableView == searchTableView {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "search_cell", for: indexPath) as? EditCell {
                cell.editCellDelegate = self
                let searchRow = searchRows[indexPath.row]
                //print(searchRow)
                cell.forRow(indexPath: indexPath, row: searchRow, isClear: true)
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Global.instance.addSpinner(superView: tableView)
        Global.instance.removeSpinner(superView: tableView)
        if tableView == self.tableView {
            let data = lists1[indexPath.row]
            var iden = TO_SHOW
            if _type == "coach" {
                iden = TO_SHOW_COACh
            }
            performSegue(withIdentifier: iden, sender: data)
        } else if tableView == searchTableView {
            let row = searchRows[indexPath.row]
            let segue: String = row["segue"] as! String
            if segue.count > 0 {
                if segue == TO_AREA && citys.count == 0 {
                    SCLAlertView().showError("錯誤", subTitle: "請先選擇縣市")
                } else if segue == TO_ARENA && citys.count == 0 {
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
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == TO_SHOW {
            if let showVC: ShowVC = segue.destination as? ShowVC {
                assert(sender as? SuperData != nil)
                let data: SuperData = sender as! SuperData
                let show_in: Show_IN = Show_IN(type: iden, id: data.id, token: data.token, title: data.title)
                showVC.initShowVC(sin: show_in)
            }
        } else if segue.identifier == TO_SHOW_COACh {
            if let showCoachVC: ShowCoachVC = segue.destination as? ShowCoachVC {
                assert(sender as? SuperData != nil)
                let data: SuperData = sender as! SuperData
                let show_in: Show_IN = Show_IN(type: iden, id: data.id, token: data.token, title: data.title)
                showCoachVC.initShowVC(sin: show_in)
                showCoachVC.backDelegate = self
            }
        } else if segue.identifier == TO_MAP {
            if let mapVC: ArenaMapVC = segue.destination as? ArenaMapVC {
                let hashMap = sender as! [String: String]
                mapVC.annotationTitle = hashMap["title"]!
                mapVC.address = hashMap["address"]!
            }
        } else if segue.identifier == TO_CITY {
            let citySelectVC: CitySelectVC = segue.destination as! CitySelectVC
            citySelectVC.delegate = self
            citySelectVC.source = "search"
            citySelectVC.type = "simple"
            citySelectVC.select = "multi"
            citySelectVC.citys = citys
        } else if segue.identifier == TO_AREA {
            if let areaSelectVC = segue.destination as? AreaSelectVC {
                var _citys: [Int] = [Int]()
                //citys.append(City(id: 10, name: ""))
                for city in citys {
                    _citys.append(city.id)
                }
                areaSelectVC.delegate = self
                areaSelectVC.source = "search"
                areaSelectVC.type = "simple"
                areaSelectVC.select = "multi"
                areaSelectVC.citys = _citys
                areaSelectVC.areas = areas
            }
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
        } else if segue.identifier == TO_MANAGER {
            let managerVC: ManagerVC = segue.destination as! ManagerVC
            managerVC.source = _type
            managerVC.titleField = _titleField
        }
    }
    
    func showSearchPanel() {
        searchPanelisHidden = false
        tableView.isScrollEnabled = false
        mask(y: titleBarHeight, superView: view)
        var frame = CGRect(x:padding, y:workAreaHeight + newY, width:view.frame.width-(2*padding), height:layerHeight)
        addLayer(superView: view, frame: frame)
        let y = titleBarHeight + 50
        frame = CGRect(x: self.padding, y: y, width: self.containerView.frame.width, height: self.layerHeight)
        animation(frame: frame)
    }
    
    override func _addLayer() {
        searchTableView.backgroundColor = UIColor.clear
        searchTableView.isHidden = false
        containerView.addSubview(self.searchTableView)
    
        layerAddSubmitBtn(upView: searchTableView)
        layerAddCancelBtn(upView: searchTableView)
    }
    
    override func otherAnimation() {
        let frame = self.containerView.frame
        self.searchTableView.frame = CGRect(x: 0, y: 0, width: frame.width, height: 400)
    }
    
    @objc override func unmask() {
        UIView.animate(withDuration: 0.5) {
            self.maskView.alpha = 0
            self.searchTableView.isHidden = true
            self.layerSubmitBtn.isHidden = true
            self.layerCancelBtn.isHidden = true
            self.containerView.frame = CGRect(x:self.padding, y:self.newY+self.workAreaHeight, width:self.containerView.frame.width, height:0)
        }
        tableView.isScrollEnabled = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        newY = scrollView.contentOffset.y
        if newY < 0 { newY = 0 }
        //print(newY)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        newY = scrollView.contentOffset.y
        if newY < 0 { newY = 0 }
        //print(scrollView.contentOffset.y)
    }
    
    func prepareParams(city_type: String="simple") {
        params.removeAll()
        params["k"] = keyword
        var city_ids:[Int] = [Int]()
        if citys.count > 0 {
            for city in citys {
                city_ids.append(city.id)
            }
        }
        if city_ids.count > 0 {
            params["city_id"] = city_ids
            params["city_type"] = city_type
        }
        var area_ids:[Int] = [Int]()
        if areas.count > 0 {
            for area in areas {
                area_ids.append(area.id)
            }
        }
        if area_ids.count > 0 {
            params["area_id"] = area_ids
        }
        params["air_condition"] = (air_condition) ? 1 : 0
        params["bathroom"] = (bathroom) ? 1 : 0
        params["parking"] = (parking) ? 1 : 0
        
        if weekdays.count > 0 {
            params["play_days"] = weekdays
        }
        if times.count > 0 {
            params["use_date_range"] = 1
            let play_start = times[TEAM_PLAY_START_KEY] as! String
            let time = play_start + ":00 - 24:00:00"
            params["play_time"] = time
        }
        
        var arena_ids:[Int] = [Int]()
        if arenas.count > 0 {
            for arena in arenas {
                arena_ids.append(arena.id)
            }
        }
        if arena_ids.count > 0 {
            params["arena_id"] = arena_ids
        }
        
        var _degrees:[String] = [String]()
        if degrees.count > 0 {
            for degree in degrees {
                let value = degree.value
                _degrees.append(DEGREE.DBValue(value))
            }
        }
        if _degrees.count > 0 {
            params["degree"] = _degrees
        }
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        prev()
    }
    
    @objc override func layerSubmit(view: UIButton) {
        
        searchPanelisHidden = true
        unmask()
        prepareParams()
        refresh()
    }
    
    func setSwitch(indexPath: IndexPath, value: Bool) {
        let row = searchRows[indexPath.row]
        let key = row["key"] as! String
        if (key == ARENA_AIR_CONDITION_KEY) {
            air_condition = value
        } else if (key == ARENA_BATHROOM_KEY) {
            bathroom = value
        } else if (key == ARENA_PARKING_KEY) {
            parking = value
        }
    }
    
    func setTextField(iden: String, value: String) {
        keyword = value
    }
    
    func clear(indexPath: IndexPath) {
        var row = searchRows[indexPath.row]
        //print(row)
        
        let key = row["key"] as! String
        switch key {
        case CITY_KEY:
            citys.removeAll()
        case AREA_KEY:
            areas.removeAll()
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
    
    func setCityData(id: Int, name: String) {
        
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
        searchTableView.reloadData()
    }
    
    func setAreasData(res: [Area]) {
        //print(res)
        var row = getDefinedRow(AREA_KEY)
        var texts: [String] = [String]()
        areas = res
        if areas.count > 0 {
            for area in areas {
                let text = area.name
                texts.append(text)
            }
            row["show"] = texts.joined(separator: ",")
        } else {
            row["show"] = "全部"
        }
        replaceRows(AREA_KEY, row)
        searchTableView.reloadData()
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
        searchTableView.reloadData()
    }
    
    func setWeekdaysData(res: [Int], indexPath: IndexPath?) {
        var row = getDefinedRow(TEAM_WEEKDAYS_KEY)
        var texts: [String] = [String]()
        weekdays = res
        if weekdays.count > 0 {
            for day in weekdays {
                for gday in Global.instance.weekdays {
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
        replaceRows(TEAM_WEEKDAYS_KEY, row)
        searchTableView.reloadData()
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
        searchTableView.reloadData()
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
        searchTableView.reloadData()
    }
    
    func showMap(indexPath: IndexPath) {
    }
    
    func searchCity(indexPath: IndexPath) {
        let row = lists[indexPath.row]
        var key = CITY_KEY
        if _type == "coach" {
            key = CITYS_KEY
        }
        let city_id = row.data[key]!["value"] as! Int
        citys.removeAll()
        citys.append(City(id: city_id, name: ""))
        prepareParams(city_type: "all")
        refresh()
    }
    
    func getDefinedRow(_ key: String) -> [String: Any] {
        for row in searchRows {
            if row["key"] as! String == key {
                return row
            }
        }
        return [String: Any]()
    }
    
    func replaceRows(_ key: String, _ row: [String: Any]) {
        for (idx, _row) in searchRows.enumerated() {
            if _row["key"] as! String == key {
                searchRows[idx] = row
                break;
            }
        }
    }
    
    func cellRefresh<T: Table>(row: T) {
        if params1 != nil && !params1!.isEmpty {
            params1!.removeAll()
        }
        self.refresh()
    }
}
