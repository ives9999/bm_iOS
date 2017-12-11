//
//  TempPlayShowVC.swift
//  bm
//
//  Created by ives on 2017/12/8.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import SCLAlertView

class TempPlayShowVC: UIViewController {
    
    var token: String!
    var model: Team!
    var scrollView: UIScrollView!
    var bkView: UIImageView!
    var featured: UIImageView!
    var cityBtn: SuperButton!
    var arenaBtn: SuperButton!
    var dateLbl: SuperLabel!
    var timeLbl: SuperLabel!
    var quantityLbl: SuperLabel!
    var signupLbl: SuperLabel!
    var feeMLbl: SuperLabel!
    var feeFLbl: SuperLabel!
    var ballLbl: SuperLabel!
    var leaderLbl: SuperLabel!
    var mobileLbl: SuperLabel!
    var degreeLbl: SuperLabel!
    
    var items: [Any] = [Any]()
    
    let constant: TEAM_TEMP_PLAY_CELL = TEAM_TEMP_PLAY_CELL()
    
    var myTitle: String!
    var nearDate: String!

    // outlet
    @IBOutlet weak var titleLbl: UILabel!
    //@IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    //@IBOutlet weak var bkView: UIImageView!
    //@IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        model = Team.instance
        //myTablView = tableView
        
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
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 80, width: view.bounds.width, height: view.bounds.height))
        scrollView.backgroundColor = UIColor.black
        scrollView.contentSize = CGSize(width: view.bounds.width, height: 5000)
        self.view.addSubview(scrollView)
        
        featured = UIImageView(frame: CGRect.zero)
        scrollView.addSubview(featured)
        
        bkView = UIImageView(frame: CGRect.zero)
        bkView.image = UIImage(named: "background")
        scrollView.addSubview(bkView)
        
        let c1: NSLayoutConstraint = NSLayoutConstraint(item: bkView, attribute: .top, relatedBy: .equal, toItem: featured, attribute: .bottom, multiplier: 1, constant: 0)
        let c2: NSLayoutConstraint = NSLayoutConstraint(item: bkView, attribute: .leading, relatedBy: .equal, toItem: bkView.superview, attribute: .leading, multiplier: 1, constant: 0)
        let c3: NSLayoutConstraint = NSLayoutConstraint(item: bkView, attribute: .trailing, relatedBy: .equal, toItem: bkView.superview, attribute: .trailing, multiplier: 1, constant: 0)
        let c4: NSLayoutConstraint = NSLayoutConstraint(item: bkView, attribute: .bottom, relatedBy: .equal, toItem: bkView.superview, attribute: .bottom, multiplier: 1, constant: 0)
        bkView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addConstraint(c1)
        scrollView.addConstraint(c2)
        scrollView.addConstraint(c3)
        scrollView.addConstraint(c4)        
        
        cityBtn = SuperButton(frame: CGRect.zero)
        arenaBtn = SuperButton(frame: CGRect.zero)
        dateLbl = SuperLabel(frame: CGRect.zero)
        timeLbl = SuperLabel(frame: CGRect.zero)
        quantityLbl = SuperLabel(frame: CGRect.zero)
        signupLbl = SuperLabel(frame: CGRect.zero)
        feeMLbl = SuperLabel(frame: CGRect.zero)
        feeFLbl = SuperLabel(frame: CGRect.zero)
        ballLbl = SuperLabel(frame: CGRect.zero)
        leaderLbl = SuperLabel(frame: CGRect.zero)
        mobileLbl = SuperLabel(frame: CGRect.zero)
        degreeLbl = SuperLabel(frame: CGRect.zero)
        
        let tmps: [Any] = [cityBtn,dateLbl,timeLbl,quantityLbl,signupLbl,feeMLbl,feeFLbl,ballLbl,leaderLbl,mobileLbl,degreeLbl]
        items = items + tmps
        
        for (idx, item) in items.enumerated() {
            let last = (idx == 0) ? featured : items[idx-1]
            let c1: NSLayoutConstraint = NSLayoutConstraint(item: item, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leading, multiplier: 1, constant: constant.name_left_padding)
            let c2: NSLayoutConstraint = NSLayoutConstraint(item: item, attribute: .top, relatedBy: .equal, toItem: last, attribute: .bottom, multiplier: 1, constant: constant.name_top_padding)
            if let item1: SuperLabel = item as? SuperLabel {
                item1.translatesAutoresizingMaskIntoConstraints = false
                scrollView.addSubview(item1)
                scrollView.addConstraint(c1)
                scrollView.addConstraint(c2)
            } else if let item1: SuperButton = item as? SuperButton {
                item1.translatesAutoresizingMaskIntoConstraints = false
                scrollView.addSubview(item1)
                scrollView.addConstraint(c1)
                scrollView.addConstraint(c2)
            }
            
        }
        
        let arenaBtnC1: NSLayoutConstraint = NSLayoutConstraint(item: arenaBtn, attribute: .leading, relatedBy: .equal, toItem: cityBtn, attribute: .trailing, multiplier: 1, constant: constant.name_left_padding)
        let arenaBtnC2: NSLayoutConstraint = NSLayoutConstraint(item: arenaBtn, attribute: .centerY, relatedBy: .equal, toItem: cityBtn, attribute: .centerY, multiplier: 1, constant: 0)
        arenaBtn.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(arenaBtn)
        scrollView.addConstraint(arenaBtnC1)
        scrollView.addConstraint(arenaBtnC2)
        
        cityBtn.padding(top: 3, left: 22, bottom: 3, right: 22)
        arenaBtn.padding(top: 3, left: 22, bottom: 3, right: 22)
        cityBtn.cornerRadius(18)
        arenaBtn.cornerRadius(18)
        cityBtn.addTarget(self, action: #selector(city), for: UIControlEvents.touchUpInside)
        arenaBtn.addTarget(self, action: #selector(self.arena), for: UIControlEvents.touchUpInside)
        
    }
    
    func setPage() {
        myTitle = (model.data[TEAM_NAME_KEY]!["value"] as! String)
        titleLbl.text = myTitle
        let img: UIImage = (model.data[TEAM_FEATURED_KEY]!["value"] as! UIImage)
        let img_width: CGFloat = img.size.width
        let img_height: CGFloat = img.size.height
        let width: CGFloat = view.frame.width
        let height: CGFloat = width * (img_height / img_width)
        featured.frame = CGRect(x: 0, y: 0, width: width, height: height)
        featured.image = img
        featured.contentMode = .scaleAspectFit
        
        var lbl: String! = ""
        var text: String! = ""
        var key: String! = ""
        
        key = TEAM_CITY_KEY
        text = (model.data[key]!["show"] as! String)
        cityBtn.setTitle(text, for: .normal)
        
        key = TEAM_ARENA_KEY
        text = (model.data[key]!["show"] as! String)
        arenaBtn.setTitle(text, for: .normal)
        
        key = TEAM_NEAR_DATE_KEY
        lbl = (model.data[key]!["ch"] as! String)
        text = (model.data[key]!["show"] as! String)
        nearDate = (model.data[key]!["value"] as! String)
        dateLbl.text = lbl + ": " + text
        
        lbl = "臨打時段"
        text = (model.data[TEAM_PLAY_START_KEY]!["show"] as! String) + " - " + (model.data[TEAM_PLAY_END_KEY]!["show"] as! String)
        timeLbl.text = lbl + ": " + text
        
        key = TEAM_TEMP_QUANTITY_KEY
        lbl = (model.data[key]!["ch"] as! String)
        text = (model.data[key]!["show"] as! String)
        quantityLbl.text = lbl + ": " + text
        
        key = TEAM_TEMP_SIGNUP_KEY
        lbl = (model.data[key]!["ch"] as! String)
        text = (model.data[key]!["value"] as! String)
        signupLbl.text = lbl + ": " + text
        
        key = TEAM_TEMP_FEE_M_KEY
        lbl = (model.data[key]!["ch"] as! String)
        text = (model.data[key]!["show"] as! String)
        feeMLbl.text = lbl + ": " + text
        
        key = TEAM_TEMP_FEE_F_KEY
        lbl = (model.data[key]!["ch"] as! String)
        text = (model.data[key]!["show"] as! String)
        feeFLbl.text = lbl + ": " + text
        
        key = TEAM_BALL_KEY
        lbl = (model.data[key]!["ch"] as! String)
        text = (model.data[key]!["show"] as! String)
        ballLbl.text = lbl + ": " + text
        
        key = TEAM_LEADER_KEY
        lbl = (model.data[key]!["ch"] as! String)
        text = (model.data[key]!["show"] as! String)
        leaderLbl.text = lbl + ": " + text
        
        key = TEAM_MOBILE_KEY
        lbl = (model.data[key]!["ch"] as! String)
        text = (model.data[key]!["show"] as! String)
        mobileLbl.text = lbl + ": " + text
        
        key = TEAM_DEGREE_KEY
        lbl = (model.data[key]!["ch"] as! String)
        text = (model.data[key]!["show"] as! String)
        degreeLbl.text = lbl + ": " + text
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

    @IBAction func plusOne(_ sender: Any) {
        if !Member.instance.isLoggedIn {
            SCLAlertView().showWarning("警告", subTitle: "請先登入為會員")
            return
        }
        TeamService.instance.plusOne(title: myTitle, near_date: nearDate, token: Member.instance.token) { (success) in
            if success {
                if TeamService.instance.success {
                    SCLAlertView().showSuccess("成功", subTitle: "報名臨打成功")
                } else {
                    SCLAlertView().showWarning("警告", subTitle: TeamService.instance.msg)
                }
            }
        }
    }
}















