//
//  ListVC.swift
//  bm
//
//  Created by ives on 2018/7/29.
//  Copyright © 2018年 bm. All rights reserved.
//

import UIKit

class ListVC: MyTableVC, ListCellDelegate, TeamSubmitCellDelegate, CitySelectDelegate, AreaSelectDelegate, ArenaSelectDelegate, DaysSelectDelegate, TimeSelectDelegate, DegreeSelectDelegate {

    var _type: String = "coach"
    var _titleField: String = "name"
    internal(set) public var lists: [SuperData] = [SuperData]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuBtn: UIButton!
    
    var newY: CGFloat = 0
    
    let maskView = UIView()
    let containerView = UIView(frame: .zero)
    let searchTableView: UITableView = {
        let cv = UITableView(frame: .zero, style: .plain)
        cv.backgroundColor = UIColor.black
        return cv
    }()
    let searchSubmitBtn: SubmitButton = SubmitButton()
    
    let padding: CGFloat = 20
    let headerHeight: CGFloat = 84
    var tableViewBoundHeight: CGFloat = 0
    var layerHeight: CGFloat = 0
    
    var searchRows: [[String: Any]] = [[String: Any]]()
    
    var keyword: String = ""
    var citys: [City] = [City]()
    var areas: [Area] = [Area]()
    var air_condition: Bool = false
    var bathroom: Bool = false
    var parking: Bool = false
    var arenas: [Arena] = [Arena]()
    var days: [Int] = [Int]()
    var degrees: [Degree] = [Degree]()
    
    //key has type, play_start_time, play_end_time, time
    var times: [String: Any] = [String: Any]()
    
    var params: [String: Any] = [String: Any]()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setIden(item:_type, titleField: _titleField)
        let cellNibName = UINib(nibName: "ListCell", bundle: nil)
        myTablView.register(cellNibName, forCellReuseIdentifier: "listcell")
        tableViewBoundHeight = view.bounds.height - 64
        layerHeight = tableViewBoundHeight - 100
        
        searchTableView.dataSource = self
        searchTableView.delegate = self
        
        searchTableView.register(TeamSubmitCell.self, forCellReuseIdentifier: "search_cell")
        
        
        refresh()
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
        if keyword.count > 0 {
            params["k"] = keyword
        }
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
        
        if days.count > 0 {
            params["play_days"] = days
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

    override func refresh() {
        page = 1
        getDataStart()
    }
    
    override func getDataStart(page: Int=1, perPage: Int=PERPAGE) {
        //print(page)
        Global.instance.addSpinner(superView: self.view)
        
        dataService.getList(type: iden, titleField: titleField, params: params, page: page, perPage: perPage, filter: nil) { (success) in
            if (success) {
                self.getDataEnd(success: success)
                Global.instance.removeSpinner(superView: self.view)
            }
        }
    }
    
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
                if refreshControl.isRefreshing {
                    refreshControl.endRefreshing()
                }
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tableView {
            return 120
        } else {
            return 60
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "listcell", for: indexPath) as? ListCell {
                
                cell.cellDelegate = self
                let row = lists[indexPath.row]
                cell.updateViews(indexPath: indexPath, data: row, iden: _type)
                
                return cell
            } else {
                return ListCell()
            }
        } else if tableView == searchTableView {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "search_cell", for: indexPath) as? TeamSubmitCell {
                cell.teamSubmitCellDelegate = self
                let searchRow = searchRows[indexPath.row]
                //print(searchRow)
                cell.forRow(indexPath: indexPath, row: searchRow)
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Global.instance.addSpinner(superView: tableView)
        Global.instance.removeSpinner(superView: tableView)
        if tableView == self.tableView {
            let data = lists[indexPath.row]
            performSegue(withIdentifier: "ListShowSegue", sender: data)
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
        var destinationNavigationController: UINavigationController?
        if segue.identifier == "ListShowSegue" {
            if let showVC: ShowVC = segue.destination as? ShowVC {
                assert(sender as? SuperData != nil)
                let data: SuperData = sender as! SuperData
                let show_in: Show_IN = Show_IN(type: iden, id: data.id, token: data.token, title: data.title)
                showVC.initShowVC(sin: show_in)
            }
        } else if segue.identifier == TO_MAP {
            if let mapVC: ArenaMapVC = segue.destination as? ArenaMapVC {
                let hashMap = sender as! [String: String]
                mapVC.annotationTitle = hashMap["title"]!
                mapVC.address = hashMap["address"]!
            }
        } else if segue.identifier == TO_CITY {
            destinationNavigationController = (segue.destination as! UINavigationController)
            let citySelectVC: CitySelectVC = destinationNavigationController!.topViewController as! CitySelectVC
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
            destinationNavigationController = (segue.destination as! UINavigationController)
            let arenaSelectVC: ArenaSelectVC = destinationNavigationController!.topViewController as! ArenaSelectVC
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
            tempPlayVC.keyword = keyword
        }
    }
    
    func showSearchPanel() {
        tableView.isScrollEnabled = false
        mask()
        addLayer()
        animation()
    }
    
    func mask() {
        maskView.backgroundColor = UIColor(white: 1, alpha: 0.8)
        maskView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(unmask)))
        tableView.addSubview(maskView)
        
        maskView.frame = CGRect(x: 0, y: newY, width: tableView.frame.width, height: tableViewBoundHeight)
        maskView.alpha = 0
    }
    
    func addLayer() {
        tableView.addSubview(containerView)
        containerView.frame = CGRect(x:padding, y:tableViewBoundHeight + newY, width:view.frame.width-(2*padding), height:layerHeight)
        containerView.backgroundColor = UIColor.black
        
        searchTableView.backgroundColor = UIColor.clear
        containerView.addSubview(self.searchTableView)
        
        containerView.addSubview(searchSubmitBtn)
        let c1: NSLayoutConstraint = NSLayoutConstraint(item: searchSubmitBtn, attribute: .top, relatedBy: .equal, toItem: searchTableView, attribute: .bottom, multiplier: 1, constant: 24)
        let c2: NSLayoutConstraint = NSLayoutConstraint(item: searchSubmitBtn, attribute: .centerX, relatedBy: .equal, toItem: searchSubmitBtn.superview, attribute: .centerX, multiplier: 1, constant: 0)
        searchSubmitBtn.translatesAutoresizingMaskIntoConstraints = false
        containerView.addConstraints([c1,c2])
        searchSubmitBtn.addTarget(self, action: #selector(submit(view:)), for: .touchUpInside)
        self.searchTableView.isHidden = false
        self.searchSubmitBtn.isHidden = false
    }
    
    func animation() {
        let y = newY + 100
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.maskView.alpha = 1
            self.containerView.frame = CGRect(x: self.padding, y: y, width: self.containerView.frame.width, height: self.layerHeight)
        }, completion: { (finished) in
            if finished {
                let frame = self.containerView.frame
                self.searchTableView.frame = CGRect(x: 0, y: 0, width: frame.width, height: 400)
                
            }
        })
    }
    
    @objc func unmask() {
        UIView.animate(withDuration: 0.5) {
            self.maskView.alpha = 0
            self.searchTableView.isHidden = true
            self.searchSubmitBtn.isHidden = true
            self.containerView.frame = CGRect(x:self.padding, y:self.newY+self.tableViewBoundHeight, width:self.containerView.frame.width, height:0)
        }
        tableView.isScrollEnabled = true
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        prev()
    }
    
    @objc func submit(view: UIButton) {
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
        replaceRows(TEAM_CITY_KEY, row)
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
        searchTableView.reloadData()
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
        searchTableView.reloadData()
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
}
