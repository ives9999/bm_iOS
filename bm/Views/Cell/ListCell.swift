//
//  ListCell.swift
//  bm
//
//  Created by ives on 2018/7/24.
//  Copyright © 2018年 bm. All rights reserved.
//

import UIKit

class ListCell: SuperCell {

    @IBOutlet weak var listFeatured: UIImageView!
    @IBOutlet weak var listTitleTxt: UILabel!
    @IBOutlet weak var listCityTxt: UILabel!
    @IBOutlet weak var listArenaTxt: UILabel!
    @IBOutlet weak var listBallTxt: UILabel!
    @IBOutlet weak var listDayTxt: UILabel!
    @IBOutlet weak var listIntervalTxt: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.value1, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateViews(data: SuperData, iden: String = "team") {
        listTitleTxt.text = data.title
        listFeatured.image = data.featured
        if iden == "team" {
            updateTeam(data: data)
        } else if iden == "coach" {
            updateCoach(data: data)
        } else if iden == "arena" {
            updateArena(data: data)
        }
        //accessoryType = UITableViewCellAccessoryType.disclosureIndicator
    }
    
    func updateTeam(data: SuperData) {
        if let item = data.data[CITY_KEY] {
            listCityTxt.text = (item["show"] as! String)
        }
        if let item = data.data[TEAM_ARENA_KEY] {
            listArenaTxt.text = (item["show"] as! String)
        }
        if let item = data.data[TEAM_BALL_KEY] {
            listBallTxt.text = (item["show"] as! String)
        }
        if let item = data.data[TEAM_DAYS_KEY] {
            listDayTxt.text = (item["show"] as! String)
        }
        if let item = data.data[TEAM_INTERVAL_KEY] {
            listIntervalTxt.text = (item["show"] as! String)
        }
    }
    func updateCoach(data: SuperData) {
        if let item = data.data[CITY_KEY] {
            listCityTxt.text = (item["show"] as! String)
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
    func updateArena(data: SuperData) {
        if let item = data.data[CITY_KEY] {
            listCityTxt.text = (item["show"] as! String)
        }
        if let item = data.data[TEL_KEY] {
            listArenaTxt.text = (item["show"] as! String)
        }
        if let item = data.data[AREA_KEY] {
            listBallTxt.text = (item["show"] as! String)
        }
        if let item = data.data[ARENA_INTERVAL_KEY] {
            listDayTxt.text = (item["show"] as! String)
        }
        if let item = data.data[ARENA_AIR_CONDITION_KEY] {
            listIntervalTxt.text = "空調: " + (item["show"] as! String)
        }
    }
    
}
