//
//  ListCell.swift
//  bm
//
//  Created by ives on 2018/7/24.
//  Copyright © 2018年 bm. All rights reserved.
//

import UIKit

protocol ListCellDelegate {
    func searchCity(indexPath: IndexPath)
    func showMap(indexPath: IndexPath)
}

class ListCell: SuperCell {

    @IBOutlet weak var listFeatured: UIImageView!
    @IBOutlet weak var listTitleTxt: UILabel!
    @IBOutlet weak var listCityBtn: CityButton!
    @IBOutlet weak var listArenaTxt: UILabel!
    @IBOutlet weak var listBallTxt: UILabel!
    @IBOutlet weak var listDayTxt: UILabel!
    @IBOutlet weak var listIntervalTxt: UILabel!
    @IBOutlet weak var listMarker: SuperButton!
    
    var cellDelegate: ListCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.value1, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateViews(indexPath: IndexPath, data: SuperData, iden: String = "team") {
        listTitleTxt.text = data.title
        listFeatured.image = data.featured
        listMarker.padding(top: 0, left: 0, bottom: 0, right: 0)
        listCityBtn.setTextSize(14)
        listCityBtn.alignH = UIControlContentHorizontalAlignment.center
        
        if iden == "team" {
            listMarker.isHidden = true
            updateTeam(indexPath: indexPath, data: data)
        } else if iden == "coach" {
            listMarker.isHidden = true
            updateCoach(indexPath: indexPath, data: data)
        } else if iden == "arena" {
            updateArena(indexPath: indexPath, data: data)
        }
        accessoryType = UITableViewCellAccessoryType.disclosureIndicator
    }
    
    func updateCourseViews(indexPath: IndexPath, data: SuperCourse) {
        listTitleTxt.text = data.title
        if data.featured_path.count > 0 {
            //print(data.featured_path)
            listFeatured.downloaded(from: data.featured_path)
        }
        
        listCityBtn.setTextSize(14)
        listCityBtn.alignH = UIControlContentHorizontalAlignment.center
        
        let citys = data.coach.citys
        if (citys.count > 0) {
            listCityBtn.setTitle(citys[0].name)
        }
        listArenaTxt.text = data.price_text_short
        listDayTxt.text = data.weekday_text
        listIntervalTxt.text = data.start_time_text + "~" + data.end_time_text
        
        listBallTxt.isHidden = true
        listMarker.isHidden = true
        
        accessoryType = UITableViewCellAccessoryType.disclosureIndicator
    }
    
    func updateStoreViews(indexPath: IndexPath, data: SuperStore) {
        listTitleTxt.text = data.name
        if data.featured_path.count > 0 {
            //print(data.featured_path)
            listFeatured.downloaded(from: data.featured_path)
        }
        
        listCityBtn.setTextSize(14)
        listCityBtn.alignH = UIControlContentHorizontalAlignment.center
        
        listCityBtn.setTitle(data.city)
        listArenaTxt.text = data.address
        listDayTxt.text = data.tel_text
        listIntervalTxt.text = data.open_time_text + "~" + data.close_time_text
        
        var showManager = false;
        if data.managers.count > 0 {
            let member_id = Member.instance.id
            for manager in data.managers {
                //print(manager)
                if let tmp = manager["id"] as? String {
                    let manager_id = Int(tmp)
                    if member_id == manager_id {
                        showManager = true
                        break
                    }
                }
            }
        }
        if showManager {
            listMarker.isHidden = false
            //listMarker.text = "管理"
        } else {
            listMarker.isHidden = true
        }
        listBallTxt.isHidden = true
        
        accessoryType = UITableViewCellAccessoryType.disclosureIndicator
    }
    
    func updateTeam(indexPath: IndexPath, data: SuperData) {
        if let item = data.data[CITY_KEY] {
            let city = item["show"] as! String
            if city.count > 0 {
                listCityBtn.setTitle(emptyToSpace(item["show"] as! String))
                listCityBtn.indexPath = indexPath
            } else {
                listCityBtn.isHidden = true
            }
        }
        if let item = data.data[ARENA_KEY] {
            listArenaTxt.text = (emptyToSpace(item["show"] as! String))
        }
        if let item = data.data[TEAM_BALL_KEY] {
            listBallTxt.text = (item["show"] as! String)
        }
        if let item = data.data[TEAM_WEEKDAYS_KEY] {
            listDayTxt.text = (emptyToSpace(item["show"] as! String))
        }
        if let item = data.data[TEAM_INTERVAL_KEY] {
            listIntervalTxt.text = (item["show"] as! String)
        }
    }
    func updateCoach(indexPath: IndexPath, data: SuperData) {
        if let item = data.data[CITYS_KEY] {
            let city = item["show"] as! String
            if city.count > 0 {
                listCityBtn.setTitle(emptyToSpace(item["show"] as! String))
                listCityBtn.indexPath = indexPath
            } else {
                listCityBtn.isHidden = true
            }
        }
        if let item = data.data[MOBILE_KEY] {
            listArenaTxt.text = (item["show"] as! String)
        }
        if let item = data.data[COACH_SENIORITY_KEY] {
            listBallTxt.text = "年資: " + (item["show"] as! String)
        }
        if let item = data.data[LINE_KEY] {
            listDayTxt.text = "line id: " + (item["show"] as! String)
        }
        listIntervalTxt.text = ""
    }
    func updateArena(indexPath: IndexPath, data: SuperData) {
        if let item = data.data[CITY_KEY] {
            listCityBtn.setTitle(emptyToSpace(item["show"] as! String))
            listCityBtn.indexPath = indexPath
        }
        if let item = data.data[TEL_KEY] {
            listArenaTxt.text = (item["show"] as! String)
        }
        if let item = data.data[AREA_KEY] {
            let area = item["show"] as! String
            listBallTxt.text = area
            if (area == "未提供") {
                listMarker.isHidden = true
            } else {
                listMarker.isHidden = false
                listMarker.indexPath = indexPath
            }
        }
        if let item = data.data[ARENA_INTERVAL_KEY] {
            listDayTxt.text = (item["show"] as! String)
        }
        if let item = data.data[ARENA_AIR_CONDITION_KEY] {
            listIntervalTxt.text = "空調: " + (item["show"] as! String)
        }
    }
    
    @IBAction func cityPressed(sender: UIButton) {
        let cityBtn = sender as! CityButton
        cellDelegate?.searchCity(indexPath: cityBtn.indexPath!)
    }
    
    @IBAction func markerBtnPressed(sender: UIButton) {
        let _sender = sender as! SuperButton
        let indexPath = _sender.indexPath!
        cellDelegate?.showMap(indexPath: indexPath)
    }
    
    private func emptyToSpace(_ text: String)-> String {
        var res = text
        if text.count == 0 {
            res = "     "
        }
        
        return res
    }
}
