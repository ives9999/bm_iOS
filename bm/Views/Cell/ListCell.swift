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
    
    func updateViews(list: SuperData, iden: String = "team") {
        listTitleTxt.text = list.title
        listFeatured.image = list.featured
        if iden == "team" {
            if let item = list.data[CITY_KEY] {
                listCityTxt.text = (item["show"] as! String)
            }
            if let item = list.data[TEAM_ARENA_KEY] {
                listArenaTxt.text = (item["show"] as! String)
            }
            if let item = list.data[TEAM_BALL_KEY] {
                listBallTxt.text = (item["show"] as! String)
            }
            if let item = list.data[TEAM_DAYS_KEY] {
                listDayTxt.text = (item["show"] as! String)
            }
            if let item = list.data[TEAM_INTERVAL_KEY] {
                listIntervalTxt.text = (item["show"] as! String)
            }
        } else if iden == "coach" {
            if let item = list.data[CITY_KEY] {
                listCityTxt.text = (item["show"] as! String)
            }
            if let item = list.data[MOBILE_KEY] {
                listArenaTxt.text = (item["show"] as! String)
            }
            if let item = list.data[COACH_SENIORITY_KEY] {
                listBallTxt.text = "年資: " + (item["show"] as! String)
            }
            if let item = list.data[LINE_KEY] {
                listDayTxt.text = "line id: " + (item["show"] as! String)
            }
            listIntervalTxt.text = ""
        }
        accessoryType = UITableViewCellAccessoryType.disclosureIndicator
    }
    
}
