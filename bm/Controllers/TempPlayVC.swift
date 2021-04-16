//
//  TempPlayVC.swift
//  bm
//
//  Created by ives on 2017/10/25.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class TempPlayVC: ListVC {

    // outlets
    
    //var model: Team!
    let cell_constant: TEAM_TEMP_PLAY_CELL = TEAM_TEMP_PLAY_CELL()
    
    var days: [Int] = [Int]()
    
    var mysTable: TeamsTable?
    
    //key has type, play_start_time, play_end_time, time
        
    lazy var bannerAd: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        return view
    }()
        
    override func viewDidLoad() {
            
        //model = Team.instance
        //sections = model.temp_play_list_sections
        myTablView = tableView
        dataService = TeamService.instance
        super.viewDidLoad()
        //print(degrees)
        
        
        //NotificationCenter.default.addObserver(self, selector: #selector(memberDidChange(_:)), name: NOTIF_MEMBER_DID_CHANGE, object: nil)
    
        //tableView.register(TeamListCell.self, forCellReuseIdentifier: "cell")
        //tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        let cellNibName = UINib(nibName: "TeamListCell", bundle: nil)
        tableView.register(cellNibName, forCellReuseIdentifier: "listCell")
        
        
//        refreshControl = UIRefreshControl()
//        refreshControl.attributedTitle = NSAttributedString(string: "更新資料")
//        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
//        tableView.addSubview(refreshControl)
        
        //prepareParams()
        //refresh()
        
        //OneSignal.postNotification(["contents": ["en": "hello",PUSH_LANGUAGE: "有人報名臨打"], "include_player_ids": [PUSH_TEST_PLAYID]])
        if !Member.instance.justGetMemberOne && Member.instance.isLoggedIn {
            _updatePlayerIDWhenIsNull()
        }
    }
    
    override func refresh() {
        page = 1
        getDataStart(t: TeamsTable.self)
    }
    
    override func getDataEnd(success: Bool) {
        if success {
            mysTable = (tables as? TeamsTable)
            if mysTable != nil {
                let tmps: [TeamTable] = mysTable!.rows
                
                if page == 1 {
                    lists1 = [TeamTable]()
                }
                lists1 += tmps
                myTablView.reloadData()
            } else {
                warning("轉換Table出錯，請洽管理員")
            }
        }
    }
    
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        print("scroll view will begin dragging")
//    }
//
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        print("scroll view did end decelerating")
//    }
    
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        let offsetY = scrollView.contentOffset.y
//        let contentHeight = scrollView.contentSize.height
//        if offsetY > contentHeight - scrollView.frame.size.height {
//            page += 1
//            //print("current page: \(page)")
//            //print(totalPage)
//            if page <= totalPage {
//                getDataStart(page: page, perPage: PERPAGE)
//            }
//        }
//    }
    
    override func prepareParams(city_type: String="simple") {
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
        return lists1.count
    }
    
//     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return cell_constant.height
//     }
 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //print("section: \(indexPath.section), row: \(indexPath.row)")
        if let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as? TeamListCell {
            
            //cell.cellDelegate = self
            let row = lists1[indexPath.row] as! TeamTable
            row.filterRow()
            //row.printRow()
            
            cell.updateViews(indexPath: indexPath, row: row)
            
            return cell
        } else {
            return ListCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let row: Dictionary<String, [String: Any]> = lists[indexPath.row]
        //let token: String = row[TOKEN_KEY]!["value"] as! String
        if mysTable != nil {
            let teamTable = mysTable!.rows[indexPath.row]
            performSegue(withIdentifier: TO_SHOW_STORE, sender: teamTable.token)
        }
        //performSegue(withIdentifier: TO_TEMP_PLAY_SHOW, sender: token)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == TO_TEMP_PLAY_SHOW {
            let tempPlayShowVC: ShowTempPlayVC = segue.destination as! ShowTempPlayVC
            tempPlayShowVC.token = sender as? String
        }
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







