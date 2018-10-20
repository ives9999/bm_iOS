//
//  ListVC.swift
//  bm
//
//  Created by ives on 2018/7/29.
//  Copyright © 2018年 bm. All rights reserved.
//

import UIKit

class ListVC: MyTableVC, ListCellDelegate {
    
    var _type: String = "coach"
    var _titleField: String = "name"
    internal(set) public var lists: [SuperData] = [SuperData]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuBtn: UIButton!
    
    
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
    var layerHeight: CGFloat!
    
    var searchRows: [[String: Any]] {
        get {
            return [[String: Any]]()
        }
    }
    
    var keyword: String = ""
    var params: [String: Any] = [String: Any]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setIden(item:_type, titleField: _titleField)
        let cellNibName = UINib(nibName: "ListCell", bundle: nil)
        myTablView.register(cellNibName, forCellReuseIdentifier: "listcell")
        layerHeight = view.frame.height-200
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchTableView.register(TeamSubmitCell.self, forCellReuseIdentifier: "search_cell")
        refresh()
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
                cell.forRow(row: searchRow)
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = lists[indexPath.row]
        performSegue(withIdentifier: "ListShowSegue", sender: data)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ListShowSegue" {
            if let showVC: ShowVC = segue.destination as? ShowVC {
                assert(sender as? SuperData != nil)
                let data: SuperData = sender as! SuperData
                let show_in: Show_IN = Show_IN(type: iden, id: data.id, token: data.token, title: data.title)
                showVC.initShowVC(sin: show_in)
            }
        } else if segue.identifier == "toMap" {
            if let mapVC: ArenaMapVC = segue.destination as? ArenaMapVC {
                let hashMap = sender as! [String: String]
                mapVC.annotationTitle = hashMap["title"]!
                mapVC.address = hashMap["address"]!
            }
        }
    }
    
    func showSearchPanel() {
        mask()
        addLayer()
        animation()
    }
    
    func mask() {
        maskView.backgroundColor = UIColor(white: 1, alpha: 0.8)
        maskView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(unmask)))
        tableView.addSubview(maskView)
        maskView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: view.frame.height)
        maskView.alpha = 0
    }
    
    func addLayer() {
        tableView.addSubview(containerView)
        containerView.frame = CGRect(x:padding, y:tableView.frame.height, width:view.frame.width-(2*padding), height:layerHeight)
        containerView.backgroundColor = UIColor.black
        searchTableView.backgroundColor = UIColor.clear
        containerView.addSubview(self.searchTableView)
        
        containerView.addSubview(searchSubmitBtn)
        let c1: NSLayoutConstraint = NSLayoutConstraint(item: searchSubmitBtn, attribute: .top, relatedBy: .equal, toItem: searchTableView, attribute: .bottom, multiplier: 1, constant: 24)
        let c2: NSLayoutConstraint = NSLayoutConstraint(item: searchSubmitBtn, attribute: .centerX, relatedBy: .equal, toItem: searchSubmitBtn.superview, attribute: .centerX, multiplier: 1, constant: 0)
        searchSubmitBtn.translatesAutoresizingMaskIntoConstraints = false
        containerView.addConstraints([c1,c2])
        searchSubmitBtn.addTarget(self, action: #selector(submit(view:)), for: .touchUpInside)
    }
    
    func animation() {
        let y = tableView.frame.height - layerHeight
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.maskView.alpha = 1
            self.containerView.frame = CGRect(x: self.padding, y: y, width: self.containerView.frame.width, height: self.containerView.frame.height)
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
            self.containerView.frame = CGRect(x:self.padding, y:self.view.frame.height, width:self.searchTableView.frame.width, height:self.searchTableView.frame.height)
        }
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        prev()
    }
    
    @objc func submit(view: UIButton) {
        unmask()
        keyword = "安"
        prepareParams()
        refresh()
    }
}
