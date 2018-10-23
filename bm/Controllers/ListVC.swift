//
//  ListVC.swift
//  bm
//
//  Created by ives on 2018/7/29.
//  Copyright © 2018年 bm. All rights reserved.
//

import UIKit

class ListVC: MyTableVC, ListCellDelegate, TeamSubmitCellDelegate, CitySelectDelegate, AreaSelectDelegate {

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
        /*
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
         */
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
                let searchRow = searchRows[indexPath.row]
                //print(searchRow)
                cell.forRow(row: searchRow)
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
            if segue == TO_AREA && citys.count == 0 {
                SCLAlertView().showError("錯誤", subTitle: "請先選擇縣市")
            } else {
                performSegue(withIdentifier: segue, sender: row["sender"])
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
                self.searchTableView.frame = CGRect(x: 0, y: 0, width: frame.width, height: 200)
                
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
