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
    @IBOutlet weak var listCityTxt: SuperLabel!
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
        if iden == "team" {
            listMarker.isHidden = true
            updateTeam(indexPath: indexPath, data: data)
        } else if iden == "coach" {
            listMarker.isHidden = true
            updateCoach(indexPath: indexPath, data: data)
        } else if iden == "arena" {
            updateArena(indexPath: indexPath, data: data)
        }
        //accessoryType = UITableViewCellAccessoryType.disclosureIndicator
    }
    
    func updateTeam(indexPath: IndexPath, data: SuperData) {
        if let item = data.data[CITY_KEY] {
            listCityTxt.text = (emptyToSpace(item["show"] as! String))
        }
        if let item = data.data[TEAM_ARENA_KEY] {
            listArenaTxt.text = (emptyToSpace(item["show"] as! String))
        }
        if let item = data.data[TEAM_BALL_KEY] {
            listBallTxt.text = (item["show"] as! String)
        }
        if let item = data.data[TEAM_DAYS_KEY] {
            listDayTxt.text = (emptyToSpace(item["show"] as! String))
        }
        if let item = data.data[TEAM_INTERVAL_KEY] {
            listIntervalTxt.text = (item["show"] as! String)
        }
    }
    func updateCoach(indexPath: IndexPath, data: SuperData) {
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
    func updateArena(indexPath: IndexPath, data: SuperData) {
        if let item = data.data[CITY_KEY] {
            //print(item)
            listCityTxt.text = (item["show"] as! String)
            listCityTxt.indexPath = indexPath
            listCityTxt.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(cityPressed))
            listCityTxt.addGestureRecognizer(tap)
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
    
    @objc func cityPressed(sender: UITapGestureRecognizer) {
        let label = sender.view as! SuperLabel
        cellDelegate?.searchCity(indexPath: label.indexPath!)
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
