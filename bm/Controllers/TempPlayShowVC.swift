//
//  TempPlayShowVC.swift
//  bm
//
//  Created by ives on 2017/12/8.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class TempPlayShowVC: MyTableVC {
    
    var token: String!
    var model: Team!
    var featured: UIImageView!
    var cityBtn: SuperButton!
    var arenaBtn: SuperButton!
    var dateLbl: SuperLabel!
    var timeLbl: SuperLabel!
    
    var items: [Any] = [Any]()
    
    let constant: TEAM_TEMP_PLAY_CELL = TEAM_TEMP_PLAY_CELL()

    // outlet
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var bkView: UIImageView!
    
    override func viewDidLoad() {
        model = Team.instance
        myTablView = tableView
        
        super.viewDidLoad()

        Global.instance.addSpinner(superView: self.view)
        TeamService.instance.getOne(type: "team", token: token) { (success) in
            if success {
                Global.instance.removeSpinner(superView: self.view)
                //print(self.model.data)
                self.setPage()
                //self.tableView.reloadData()
            }
        }
        
        //bkView.isUserInteractionEnabled = false
        featured = UIImageView(frame: CGRect.zero)
        self.view.addSubview(featured)
        
        cityBtn = SuperButton(frame: CGRect.zero)
        arenaBtn = SuperButton(frame: CGRect.zero)
        dateLbl = SuperLabel(frame: CGRect.zero)
        timeLbl = SuperLabel(frame: CGRect.zero)
        
        let tmps: [Any] = [cityBtn, arenaBtn, dateLbl, timeLbl]
        items = items + tmps
        
        for (idx, item) in items.enumerated() {
            let last = (idx == 0) ? featured : items[idx-1]
            let c1: NSLayoutConstraint = NSLayoutConstraint(item: item, attribute: .leading, relatedBy: .equal, toItem: bkView, attribute: .leading, multiplier: 1, constant: constant.name_left_padding)
            let c2: NSLayoutConstraint = NSLayoutConstraint(item: item, attribute: .top, relatedBy: .equal, toItem: last, attribute: .bottom, multiplier: 1, constant: constant.name_top_padding)
            if let item1: SuperLabel = item as? SuperLabel {
                item1.translatesAutoresizingMaskIntoConstraints = false
                self.view.addSubview(item1)
                self.view.addConstraint(c1)
                self.view.addConstraint(c2)
            } else if let item1: SuperButton = item as? SuperButton {
                item1.translatesAutoresizingMaskIntoConstraints = false
                self.view.addSubview(item1)
                self.view.addConstraint(c1)
                self.view.addConstraint(c2)
            }
            
        }
        cityBtn.padding(top: 3, left: 22, bottom: 3, right: 22)
        arenaBtn.padding(top: 3, left: 22, bottom: 3, right: 22)
        cityBtn.cornerRadius(18)
        arenaBtn.cornerRadius(18)
        cityBtn.addTarget(self, action: #selector(city), for: UIControlEvents.touchUpInside)
        arenaBtn.addTarget(self, action: #selector(self.arena), for: UIControlEvents.touchUpInside)
        
        
        
        
        

        
//        dateLbl = SuperLabel(frame: CGRect.zero)
//        bkView.addSubview(dateLbl)
//        let dateLblC1: NSLayoutConstraint = NSLayoutConstraint(item: dateLbl, attribute: .leading, relatedBy: .equal, toItem: featured.superview, attribute: .leading, multiplier: 1, constant: constant.name_left_padding)
//        let dateLblC2: NSLayoutConstraint = NSLayoutConstraint(item: dateLbl, attribute: .top, relatedBy: .equal, toItem: arenaBtn, attribute: .bottom, multiplier: 1, constant: constant.name_top_padding)
//        dateLbl.translatesAutoresizingMaskIntoConstraints = false
//        bkView.addConstraint(dateLblC1)
//        bkView.addConstraint(dateLblC2)
//
//        timeLbl = SuperLabel(frame: CGRect.zero)
//        bkView.addSubview(timeLbl)
//        let timeLblC1: NSLayoutConstraint = NSLayoutConstraint(item: timeLbl, attribute: .leading, relatedBy: .equal, toItem: featured.superview, attribute: .leading, multiplier: 1, constant: constant.name_left_padding)
//        let timeLblC2: NSLayoutConstraint = NSLayoutConstraint(item: timeLbl, attribute: .top, relatedBy: .equal, toItem: dateLbl, attribute: .bottom, multiplier: 1, constant: constant.name_top_padding)
//        timeLbl.translatesAutoresizingMaskIntoConstraints = false
//        bkView.addConstraint(timeLblC1)
//        bkView.addConstraint(timeLblC2)
    }
    
    func setPage() {
        titleLbl.text = (model.data[TEAM_NAME_KEY]!["value"] as! String)
        let img: UIImage = (model.data[TEAM_FEATURED_KEY]!["value"] as! UIImage)
        let img_width: CGFloat = img.size.width
        let img_height: CGFloat = img.size.height
        let width: CGFloat = bkView.frame.width
        let height: CGFloat = width * (img_height / img_width)
        featured.frame = CGRect(x: 0, y: 0, width: width, height: height)
        featured.image = img
        featured.contentMode = .scaleAspectFit
        
        var lbl: String! = ""
        var text: String! = ""
        
        lbl = (model.data[TEAM_CITY_KEY]!["ch"] as! String)
        text = (model.data[TEAM_CITY_KEY]!["show"] as! String)
        cityBtn.setTitle(lbl + ": " + text, for: .normal)
        
        lbl = (model.data[TEAM_ARENA_KEY]!["ch"] as! String)
        text = (model.data[TEAM_ARENA_KEY]!["show"] as! String)
        arenaBtn.setTitle(lbl + ": " + text, for: .normal)
        
        lbl = (model.data[TEAM_NEAR_DATE_KEY]!["ch"] as! String)
        text = (model.data[TEAM_NEAR_DATE_KEY]!["show"] as! String)
        dateLbl.text = lbl + ": " + text
        
        lbl = "臨打時段"
        text = (model.data[TEAM_PLAY_START_KEY]!["show"] as! String) + " - " + (model.data[TEAM_PLAY_END_KEY]!["show"] as! String)
        timeLbl.text = lbl + ": " + text
        
        
    }
    
    @objc func city(sender: UIButton) {
        print("city")
    }
    @objc func arena(sender: UIButton) {
        print("arena")
    }

    @IBAction func prevBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}















