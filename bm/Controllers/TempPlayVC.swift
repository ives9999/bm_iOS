//
//  TempPlayVC.swift
//  bm
//
//  Created by ives on 2017/10/25.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class TempPlayVC: MyTableVC, TeamTempPlayListCellDelegate {

    // outlets
    @IBOutlet weak var tableView: UITableView!
    
    var model: Team!
    let cell_constant: TEAM_TEMP_PLAY_CELL = TEAM_TEMP_PLAY_CELL()
    internal(set) public var lists: [DATA] = [DATA]()
    
    var citys: [City] = [City]()
    var arenas: [Arena] = [Arena]()
    var days: [Int] = [Int]()
    var degrees: [Degree] = [Degree]()
    
    //key has type, play_start_time, play_end_time, time
    var times: [String: Any] = [String: Any]()
    var keyword: String = ""
    
    var params: [String: Any] = [String: Any]()
    
    override func viewDidLoad() {
            
        model = Team.instance
        sections = model.temp_play_list_sections
        myTablView = tableView
        super.viewDidLoad()
        //print(degrees)
        
        NotificationCenter.default.addObserver(self, selector: #selector(memberDidChange(_:)), name: NOTIF_MEMBER_DID_CHANGE, object: nil)
    
        tableView.register(TeamTempPlayListCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
//        refreshControl = UIRefreshControl()
//        refreshControl.attributedTitle = NSAttributedString(string: "更新資料")
//        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
//        tableView.addSubview(refreshControl)
        
        prepareParams()
        refresh()
        
        //OneSignal.postNotification(["contents": ["en": "hello",PUSH_LANGUAGE: "有人報名臨打"], "include_player_ids": [PUSH_TEST_PLAYID]])
        if !Member.instance.justGetMemberOne && Member.instance.isLoggedIn {
            _updatePlayerIDWhenIsNull()
        }
    }
    
    func prepareParams(city_type: String="simple") {
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
        
        if keyword.count > 0 {
            params["k"] = keyword
        }
    }
    
    func resetParams() {
        citys.removeAll()
        arenas.removeAll()
        days.removeAll()
        degrees.removeAll()
        times.removeAll()
        keyword = ""
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cell_constant.height
     }
 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //print("section: \(indexPath.section), row: \(indexPath.row)")
        let cell: TeamTempPlayListCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TeamTempPlayListCell
        cell.cellDelegate = self
        let row: Dictionary<String, [String: Any]> = lists[indexPath.row]
        cell.forRow(row: row)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row: Dictionary<String, [String: Any]> = lists[indexPath.row]
        let token: String = row[TEAM_TOKEN_KEY]!["value"] as! String
        performSegue(withIdentifier: TO_TEMP_PLAY_SHOW, sender: token)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == TO_TEMP_PLAY_SHOW {
            let tempPlayShowVC: TempPlayShowVC = segue.destination as! TempPlayShowVC
            tempPlayShowVC.token = sender as! String
        }
    }
    
    override func refresh() {
        page = 1
        getDataStart()
    }
    
    override func getDataStart(page: Int=1, perPage: Int=PERPAGE) {
        Global.instance.addSpinner(superView: self.view)
        TeamService.instance.tempPlay_list(params:params,page: page, perPage: perPage) { (success) in
            if success {
                self.getDataEnd(success: success)
                Global.instance.removeSpinner(superView: self.view)
            }
        }
    }
    override func getDataEnd(success: Bool) {
        if success {
            let tmps = TeamService.instance.tempPlayList
            if page == 1 {
                lists = [DATA]()
            }
            lists += tmps
            //print(self.lists)
            totalCount = TeamService.instance.totalCount
            if totalCount > 0 {
                perPage = TeamService.instance.perPage
                page = TeamService.instance.page
                if page == 1 {
                    let _pageCount: Int = totalCount / perPage
                    totalPage = (totalCount % perPage > 0) ? _pageCount + 1 : _pageCount
                    if refreshControl.isRefreshing {
                        refreshControl.endRefreshing()
                    }
                }
                tableView.reloadData()
                //self.page = self.page + 1 in CollectionView
            }
        }
    }
    @IBAction func prevBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func cityBtnPressed(sender: UIButton) {
        //print(sender.tag)
        resetParams()
        citys.append(City(id: sender.tag, name: ""))
        prepareParams(city_type: "all")
        refresh()
    }
    
    @objc func arenaBtnPressed(sender: UIButton) {
        //print(sender.tag)
        resetParams()
        arenas.append(Arena(id: sender.tag, name: ""))
        prepareParams()
        refresh()
    }
}







