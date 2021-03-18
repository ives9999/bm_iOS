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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateTeachViews(indexPath: IndexPath, data: TeachTable) {
        listTitleTxt.text = data.title
        if data.featured_path.count > 0 {
            //print(data.featured_path)
            listFeatured.downloaded(from: data.featured_path)
        }
        listMarker.padding(top: 0, left: 0, bottom: 0, right: 0)
        listCityBtn.setTextSize(14)
        listCityBtn.alignH = UIControl.ContentHorizontalAlignment.center
        
        accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
    }
    
    func updateCourseViews(indexPath: IndexPath, data: CourseTable) {
        listTitleTxt.text = data.title
        if data.featured_path.count > 0 {
            //print(data.featured_path)
            listFeatured.downloaded(from: data.featured_path)
        }
        
        if data.city_show.count > 0 {
            listCityBtn.isHidden = false
            listCityBtn.setTextSize(14)
            listCityBtn.alignH = UIControl.ContentHorizontalAlignment.center
            listCityBtn.setTitle(data.city_show)
        } else {
            listCityBtn.isHidden = true
        }
        listArenaTxt.text = data.price_desc
        listDayTxt.text = data.weekday_text
        listIntervalTxt.text = data.start_time_show + "~" + data.end_time_show
        
        listBallTxt.isHidden = true
        listMarker.isHidden = true
        
        accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
    }
    
//    func updateStoreViews(indexPath: IndexPath, data: SuperStore) {
//        listTitleTxt.text = data.name
//        if data.featured_path.count > 0 {
//            //print(data.featured_path)
//            listFeatured.downloaded(from: data.featured_path)
//        }
//
//        listCityBtn.setTextSize(14)
//        listCityBtn.alignH = UIControl.ContentHorizontalAlignment.center
//
//        listCityBtn.setTitle(data.city)
//        listArenaTxt.text = data.address
//        listDayTxt.text = data.tel_text
//        listIntervalTxt.text = data.open_time_text + "~" + data.close_time_text
//
//        var showManager = false;
//        if data.managers.count > 0 {
//            let member_id = Member.instance.id
//            for manager in data.managers {
//                //print(manager)
//                if let tmp = manager["id"] as? String {
//                    let manager_id = Int(tmp)
//                    if member_id == manager_id {
//                        showManager = true
//                        break
//                    }
//                }
//            }
//        }
//        if showManager {
//            listMarker.isHidden = false
//            //listMarker.text = "管理"
//        } else {
//            listMarker.isHidden = true
//        }
//        listBallTxt.isHidden = true
//
//        accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
//    }
    
    func updateTeam(indexPath: IndexPath, data: TeamTable) {
        
        listTitleTxt.text = data.name
        
        if data.featured_path.count > 0 {
            //print(data.featured_path)
            listFeatured.downloaded(from: data.featured_path)
        }
        
        if data.city_show.count > 0 {
            listCityBtn.isHidden = false
            listCityBtn.setTextSize(14)
            listCityBtn.alignH = UIControl.ContentHorizontalAlignment.center
            listCityBtn.setTitle(data.city_show)
        } else {
            listCityBtn.isHidden = true
        }
        
        listArenaTxt.text = data.arena_name
        listBallTxt.text = data.ball
        listDayTxt.text = data.weekdays_show
        listIntervalTxt.text = data.interval_show
        listMarker.isHidden = true
    }
    
    func updateCoach(indexPath: IndexPath, data: CoachTable) {
        
        listTitleTxt.text = data.name
        
        if data.featured_path.count > 0 {
            //print(data.featured_path)
            listFeatured.downloaded(from: data.featured_path)
        }
        
        if data.city_show.count > 0 {
            listCityBtn.isHidden = false
            listCityBtn.setTextSize(14)
            listCityBtn.alignH = UIControl.ContentHorizontalAlignment.center
            listCityBtn.setTitle(data.city_show)
        } else {
            listCityBtn.isHidden = true
        }
        
        listArenaTxt.text = data.mobile_show
        if data.seniority > 0 {
            listBallTxt.text = "年資: " + String(data.seniority) + "年"
        } else {
            listBallTxt.text = "年資未提供"
        }
        if data.line.count > 0 {
            listDayTxt.text = "line id: " + data.line
        } else {
            listDayTxt.text = "line 未提供"
        }

        listIntervalTxt.text = ""
        listMarker.isHidden = true
    }
    
    func updateArena(indexPath: IndexPath, data: ArenaTable) {
        
        listTitleTxt.text = data.name
        
        if data.featured_path.count > 0 {
            listFeatured.downloaded(from: data.featured_path)
        }
        
        if data.city_show.count > 0 {
            listCityBtn.isHidden = false
            listCityBtn.setTextSize(14)
            listCityBtn.alignH = UIControl.ContentHorizontalAlignment.center
            listCityBtn.setTitle(data.city_show)
        } else {
            listCityBtn.isHidden = true
        }
        
        listArenaTxt.text = data.tel_show

        if data.area_show.count > 0 {
            listBallTxt.text = data.area_show
            listMarker.isHidden = false
            listMarker.indexPath = indexPath
        } else {
            listBallTxt.text = "未提供"
            listMarker.isHidden = true
        }
        listDayTxt.text = data.interval_show
        listIntervalTxt.text = data.air_condition_show
    }
    
    //在CollectionCell中
//    func updateTeach(indexPath: IndexPath, data: TeachTable) {
//
//    }
    
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
