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

class ListVC: MyTableVC, EditCellDelegate, CitySelectDelegate, AreaSelectDelegate, BackDelegate, List1CellDelegate {
    
    func setBack(params: [String: Any]) {
        //self.params = params
    }
    
    var able_type: String = "coach"
    //var _titleField: String = "name"
    //internal(set) public var lists: [SuperData] = [SuperData]()
    
    var newY: CGFloat = 0
    
    var searchTableView: UITableView = {
        let cv = UITableView(frame: .zero, style: .plain)
        cv.backgroundColor = UIColor.black
        return cv
    }()
    
    let padding: CGFloat = 20
    let headerHeight: CGFloat = 84
    var layerHeight: CGFloat = 0
    
    var searchRows: [[String: Any]] = [[String: Any]]()
        
    var searchPanelisHidden = true
    
    internal(set) public var lists1: [Table] = [Table]()
    var params: [String: Any]?
    
    var jsonData: Data? = nil
    var tables: Tables?
    
    var member_like: Bool = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //setIden(item:_type, titleField: _titleField)
        //let cellNibName = UINib(nibName: "ListCell", bundle: nil)
        //myTablView.register(cellNibName, forCellReuseIdentifier: "listcell")
        
        layerHeight = workAreaHeight - 100
        
        searchTableView.dataSource = self
        searchTableView.delegate = self
        
        let cellNibName = UINib(nibName: "List2Cell", bundle: nil)
        tableView.register(cellNibName, forCellReuseIdentifier: "lis2Cell")
        
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
        
        //會員喜歡列表也一並使用此程式
        if (member_like) {
            MemberService.instance.likelist(able_type: able_type) { (success) in
                self.jsonData = MemberService.instance.jsonData
                self._dataToTable(t: t, success)
            }
        } else {
            dataService.getList(token: nil, _filter: params, page: page, perPage: perPage) { (success) in
                self.jsonData = self.dataService.jsonData
                self._dataToTable(t: t, success)
            }
        }
    }
    
    func _dataToTable<T: Tables>(t: T.Type, _ success: Bool) {
        if (success) {
            var s: T? = nil
            do {
                if (jsonData != nil) {
                    s = try JSONDecoder().decode(t, from: jsonData!)
                } else {
                    warning("無法從伺服器取得正確的json資料，請洽管理員")
                }
            } catch {
                msg = "解析JSON字串時，得到空值，請洽管理員"
            }
            if (s != nil) {
                tables = s!
                getDataEnd(success: success)
            }
            Global.instance.removeSpinner(superView: view)
        } else {
            Global.instance.removeSpinner(superView: view)
            warning(dataService.msg)
        }
    }
    
    override func getDataEnd(success: Bool) {
        
        if page == 1 {
            //lists = [SuperData]()
        }
        //lists += tmps
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
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height: CGFloat = 0
        if tableView == searchTableView {
            height = 50
        }
        return height
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return lists1.count
        } else {
            return searchRows.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "Listcell", for: indexPath) as? List2Cell {
                
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
        //Global.instance.addSpinner(superView: tableView)
        //Global.instance.removeSpinner(superView: tableView)
        if tableView == self.tableView {
            let data = lists1[indexPath.row]
            let iden = TO_SHOW
            
            performSegue(withIdentifier: iden, sender: data)
        } else if tableView == searchTableView {
//            let row = searchRows[indexPath.row]
//            let segue: String = row["segue"] as! String
//            if segue.count > 0 {
//                if segue == TO_AREA {
//                    SCLAlertView().showError("錯誤", subTitle: "請先選擇縣市")
//                } else if segue == TO_ARENA {
//                    SCLAlertView().showError("錯誤", subTitle: "請先選擇縣市")
//                } else if segue == TO_SELECT_TIME {
//                    if row["key"] as! String == START_TIME_KEY {
//                        times["type"] = SELECT_TIME_TYPE.play_start
//                        if times[START_TIME_KEY] != nil {
//                            times["time"] = times[START_TIME_KEY]
//                        }
//                    } else {
//                        times["type"] = SELECT_TIME_TYPE.play_end
//                        if times[END_TIME_KEY] != nil {
//                            times["time"] = times[END_TIME_KEY]
//                        }
//                    }
//                    performSegue(withIdentifier: segue, sender: row["sender"])
//                } else {
//                    performSegue(withIdentifier: segue, sender: row["sender"])
//                }
//            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == TO_SHOW {
            if let showVC: ShowVC = segue.destination as? ShowVC {
                //assert(sender as? SuperData != nil)
                let data: TeachTable = sender as! TeachTable
                let show_in: Show_IN = Show_IN(type: iden, id: data.id, token: data.token, title: data.title)
                showVC.initShowVC(sin: show_in)
            }
        } else if segue.identifier == TO_SHOW_COACH {
            if let showCoachVC: ShowCoachVC = segue.destination as? ShowCoachVC {
                //assert(sender as? SuperData != nil)
                //let data: SuperData = sender as! SuperData
                //let show_in: Show_IN = Show_IN(type: iden, id: data.id, token: data.token, title: data.title)
                //showCoachVC.initShowVC(sin: show_in)
                showCoachVC.backDelegate = self
            }
        } else if segue.identifier == TO_MAP {
            if let mapVC: ArenaMapVC = segue.destination as? ArenaMapVC {
                let hashMap = sender as! [String: String]
                mapVC.annotationTitle = hashMap["title"]!
                mapVC.address = hashMap["address"]!
            }
        } else if segue.identifier == TO_SELECT_DEGREE {
//            let degreeSelectVC: DegreeSelectVC = segue.destination as! DegreeSelectVC
//            degreeSelectVC.source = "search"
//            degreeSelectVC.degrees = degrees
//            degreeSelectVC.delegate = self
        } else if segue.identifier == TO_TEMP_PLAY_LIST {
            //let tempPlayVC: TempPlayVC = segue.destination as! TempPlayVC
            //tempPlayVC.citys = citys
            //tempPlayVC.arenas = arenas
            //tempPlayVC.days = weekdays
            //tempPlayVC.times = times
            //tempPlayVC.degrees = degrees
            //.keyword = keyword
        } else if segue.identifier == TO_MANAGER {
//            let managerVC: ManagerVC = segue.destination as! ManagerVC
//            managerVC.source = _type
//            managerVC.titleField = _titleField
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
        params = [String: Any]()
        for row in searchRows {
            
            if let key: String = row["key"] as? String {
                if let value: String = row["value"] as? String {
                    if value.count == 0 {
                        continue
                    }
                    params![key] = value
                }
                
            }
        }
        //print(params)
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        prev()
    }
    
    @IBAction func searchBtnPressed(_ sender: Any) {
        if searchPanelisHidden {
            showSearchPanel()
        } else {
            searchPanelisHidden = true
            unmask()
        }
    }
    
    @objc override func layerSubmit(view: UIButton) {
        
        searchPanelisHidden = true
        unmask()
        prepareParams()
        refresh()
    }
    
    func setSwitch(indexPath: IndexPath, value: Bool) {
        var row = searchRows[indexPath.row]
        let key = row["key"] as! String
        row["value"] = (value) ? "1" : ""
        replaceRows(key, row)
//        if (key == ARENA_AIR_CONDITION_KEY) {
//            air_condition = value
//        } else if (key == ARENA_BATHROOM_KEY) {
//            bathroom = value
//        } else if (key == ARENA_PARKING_KEY) {
//            parking = value
//        }
    }
    
    func setTextField(key: String, value: String) {
        
        var row = getDefinedRow(key)
        row["value"] = value
        replaceRows(key, row)
        //keyword = value
    }
    
    func clear(indexPath: IndexPath) {
        var row = searchRows[indexPath.row]
        //print(row)
        
        let key = row["key"] as! String
//        switch key {
//        case CITY_KEY:
//            citys.removeAll()
//        case AREA_KEY:
//            areas.removeAll()
//        case WEEKDAY_KEY:
//            weekdays.removeAll()
//        case START_TIME_KEY:
//            times.removeAll()
//        case END_TIME_KEY:
//            times.removeAll()
//        case ARENA_KEY:
//            arenas.removeAll()
//        case TEAM_DEGREE_KEY:
//            degrees.removeAll()
//        default:
//            _ = 1
//        }
        row["show"] = "全部"
        row["value"] = ""
        replaceRows(key, row)
    }
    
    func setCityData(id: Int, name: String) {}
    
    func setCitysData(res: [City]) {
        //print(res)
        var row = getDefinedRow(CITY_KEY)
        var texts: [String] = [String]()
        //citys = res
        if res.count > 0 {
            for city in res {
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
        var names: [String] = [String]()
        var ids: [String] = [String]()
        //areas = res
        if res.count > 0 {
            for area in res {
                names.append(area.name)
                ids.append(String(area.id))
            }
            row["show"] = names.joined(separator: ",")
            row["value"] = ids.joined(separator: ",")
        } else {
            row["show"] = "全部"
            row["value"] = ""
        }
        replaceRows(AREA_KEY, row)
        searchTableView.reloadData()
    }
    
    //選擇球館後
    override func setArenaData(res: [ArenaTable]) {
        var row = getDefinedRow(ARENA_KEY)
        var names: [String] = [String]()
        var ids: [String] = [String]()
        //areas = res
        if res.count > 0 {
            for arenaTable in res {
                names.append(arenaTable.name)
                ids.append(String(arenaTable.id))
            }
            row["show"] = names.joined(separator: ",")
            row["value"] = ids.joined(separator: ",")
        } else {
            row["show"] = "全部"
            row["value"] = ""
        }
        replaceRows(ARENA_KEY, row)
        searchTableView.reloadData()
    }
    
//    func setArenasData(res: [Arena]) {
//        //print(res)
//        var row = getDefinedRow(ARENA_KEY)
//        var texts: [String] = [String]()
//        arenas = res
//        if arenas.count > 0 {
//            for arena in arenas {
//                let text = arena.title
//                texts.append(text)
//            }
//            row["show"] = texts.joined(separator: ",")
//        } else {
//            row["show"] = "全部"
//        }
//        replaceRows(ARENA_KEY, row)
//        searchTableView.reloadData()
//    }
    
    //city select return this
    override func singleSelected(key: String, selected: String) {
        var row = getDefinedRow(key)
        var show = ""
        if key == START_TIME_KEY || key == END_TIME_KEY {
            row["value"] = selected
            show = selected.noSec()
        } else if (key == CITY_KEY || key == AREA_KEY) {
            row["value"] = selected
            show = Global.instance.zoneIDToName(Int(selected)!)
        }
        row["show"] = show
        replaceRows(key, row)
        searchTableView.reloadData()
    }
    
    override func setWeekdaysData(res: [Int], indexPath: IndexPath?) {
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
        searchTableView.reloadData()
    }
    
    override func setTimeData(res: [String], type: SELECT_TIME_TYPE, indexPath: IndexPath?) {
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
            //times[START_TIME_KEY] = time
            row = getDefinedRow(START_TIME_KEY)
            row["show"] = text
            row["value"] = text
            replaceRows(START_TIME_KEY, row)
            break
        case SELECT_TIME_TYPE.play_end:
            //times[END_TIME_KEY] = time
            row = getDefinedRow(END_TIME_KEY)
            row["show"] = text
            row["value"] = text
            replaceRows(END_TIME_KEY, row)
            break
        }
        searchTableView.reloadData()
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
        searchTableView.reloadData()
    }
    
    func showMap(indexPath: IndexPath) {}
    
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
    
    //存在row的value只是單純的文字，陣列值使用","來區隔，例如"1,2,3"，但當要傳回選擇頁面時，必須轉回陣列[1,2,3]
    func valueToArray<T>(t:T.Type, row: [String: Any])-> [T] {
        
        var selecteds: [T] = [T]()
        //print(t)
        var type: String = "String"
        if (t.self == Int.self) {
            type = "Int"
        }
        if let value: String = row["value"] as? String {
            if (value.count > 0) {
                let values = value.components(separatedBy: ",")
                for value in values {
                    if (type == "Int") {
                        if let tmp = Int(value) {
                            selecteds.append(tmp as! T)
                        }
                    } else {
                        if let tmp = value as? T {
                            selecteds.append(tmp)
                        }
                    }
                }
            }
        }
        
        return selecteds
    }
    
    //目前暫時沒有用到
    func arrayToValue<T>(t: T.Type, res: [T])-> String {
        
        var value: String = ""
        
        var type: String = "String"
        if (t.self == Int.self) {
            type = "Int"
        }
        
        var values: [String] = [String]()
        if (res.count > 0) {
            for one in res {
                if (type == "Int") {
                    if let tmp: Int = one as? Int {
                        values.append(String(tmp))
                    }
                } else if (type == "String") {
                    values.append(one as! String)
                }
            }
            value = values.joined(separator: ",")
        } else {
            value = ""
        }
        
        return value
    }
    
    func cellRefresh() {
        if params != nil && !params!.isEmpty {
            params!.removeAll()
        }
        self.refresh()
    }
    
    func cellMobile(row: Table) {
        if (row.mobile_show.count > 0) {
            print(row.mobile)
        } else if (row.tel_show.count > 0) {
            print(row.tel)
        }
        //row.mobile.makeCall()
    }
    
    func cellShowMap(row: Table) {
        
        var name: String = ""
        if row.name.count > 0 {
            name = row.name
        } else if row.title.count > 0 {
            name = row.title
        }
        print(row.address)
       // _showMap(title: name, address: row.address)
        
//        if indexPath != nil {
//            let row = lists1[indexPath!.row] as! TeamTable
//            if row.arena != nil {
//                //print(row.arena!.address)
//                _showMap(title: row.name, address: row.arena!.address)
//            } else {
//                warning("球隊沒有輸入球館位置")
//            }
//        } else {
//            warning("index path 為空值，請洽管理員")
//        }
    }
    
    func cellCity(row: Table) {
        let key: String = CITY_KEY
        let city_id: Int = row.city_id
        var row = getDefinedRow(key)
        row["value"] = city_id
        replaceRows(key, row)
        prepareParams()
        refresh()
    }
    
    func cellLike(row: Table) {
        if (!Member.instance.isLoggedIn) {
            toLogin()
        } else {
            dataService.like(token: row.token, able_id: row.id)
        }
    }
    
    func cellWarning(msg: String) {
        warning(msg)
    }
    
    func cellToLogin() {
        toLogin()
    }
}
