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
    //var bkView: UIView!
    var featuredView: UIImageView!
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
    var plusOneBtn: SuperButton!
    var cancelPlusOneBtn: SuperButton!
    
    var items: [Any] = [Any]()
    
    let constant: TEAM_TEMP_PLAY_CELL = TEAM_TEMP_PLAY_CELL()
    
    var myTitle: String!
    var nearDate: String!
    var featured: UIImage!
    
    var refreshControl: UIRefreshControl!

    // outlet
    @IBOutlet weak var titleLbl: UILabel!
    //@IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    
    override func viewDidLoad() {
        model = Team.instance
        //myTablView = tableView
        
        super.viewDidLoad()
        
        
        //scrollView = UIScrollView(frame: CGRect(x: 0, y: 80, width: view.bounds.width, height: view.bounds.height))
        scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.black
        view.addSubview(scrollView)
        //scrollView.contentSize = CGSize(width: view.bounds.width, height: 5000)
        
        //bkView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        //bkView.backgroundColor = UIColor.red
        bkView = UIImageView()
        bkView.image = UIImage(named: "background")
        //bkView.contentMode = .scaleAspectFit
        
        scrollView.addSubview(bkView)
        //bkView.bringSubview(toFront: scrollView)
        
        featuredView = UIImageView()
        scrollView.addSubview(featuredView)
        
        cityBtn = SuperButton()
        arenaBtn = SuperButton()
        dateLbl = SuperLabel()
        timeLbl = SuperLabel()
        quantityLbl = SuperLabel()
        signupLbl = SuperLabel()
        feeMLbl = SuperLabel()
        feeFLbl = SuperLabel()
        ballLbl = SuperLabel()
        leaderLbl = SuperLabel()
        mobileLbl = SuperLabel()
        degreeLbl = SuperLabel()
        plusOneBtn = SuperButton()
        cancelPlusOneBtn = SuperButton(frame: CGRect.zero, textColor: UIColor.black, bkColor: UIColor(MY_RED))
        
        scrollView.addSubview(cityBtn)
        scrollView.addSubview(arenaBtn)
        scrollView.addSubview(dateLbl)
        scrollView.addSubview(timeLbl)
        scrollView.addSubview(quantityLbl)
        scrollView.addSubview(signupLbl)
        scrollView.addSubview(feeMLbl)
        scrollView.addSubview(feeFLbl)
        scrollView.addSubview(ballLbl)
        scrollView.addSubview(leaderLbl)
        scrollView.addSubview(mobileLbl)
        scrollView.addSubview(degreeLbl)
        scrollView.addSubview(plusOneBtn)
        scrollView.addSubview(cancelPlusOneBtn)
        
        cityBtn.padding(top: 3, left: 22, bottom: 3, right: 22)
        arenaBtn.padding(top: 3, left: 22, bottom: 3, right: 22)
        cityBtn.cornerRadius(18)
        arenaBtn.cornerRadius(18)
        cityBtn.addTarget(self, action: #selector(city), for: UIControlEvents.touchUpInside)
        arenaBtn.addTarget(self, action: #selector(self.arena), for: UIControlEvents.touchUpInside)
        
        plusOneBtn.padding(top: 3, left: 22, bottom: 3, right: 22)
        cancelPlusOneBtn.padding(top: 3, left: 22, bottom: 3, right: 22)
        plusOneBtn.cornerRadius(18)
        cancelPlusOneBtn.cornerRadius(18)
        plusOneBtn.addTarget(self, action: #selector(plusOne(_:)), for: UIControlEvents.touchUpInside)
        cancelPlusOneBtn.addTarget(self, action: #selector(self.arena), for: UIControlEvents.touchUpInside)
        plusOneBtn.setTitle("我要臨打", for: .normal)
        cancelPlusOneBtn.setTitle("取消臨打", for: .normal)
        plusOneBtn.sizeToFit()
        cancelPlusOneBtn.sizeToFit()
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "更新資料")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        scrollView.addSubview(refreshControl)
        
        //print(view.frame)
        //bkView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        _layout()
        refresh()
        
        //NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        //print("view did load")
    }
    
    private func _layout() {
        var c1: NSLayoutConstraint,c2: NSLayoutConstraint,c3: NSLayoutConstraint,c4: NSLayoutConstraint
        
        c1 = NSLayoutConstraint(item: scrollView, attribute: .top, relatedBy: .equal, toItem: headerView, attribute: .bottom, multiplier: 1, constant: 0)
        c2 = NSLayoutConstraint(item: scrollView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        c3 = NSLayoutConstraint(item: scrollView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        c4 = NSLayoutConstraint(item: scrollView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(c1)
        view.addConstraint(c2)
        view.addConstraint(c3)
        view.addConstraint(c4)
        
        //print(headerView.frame)
        
        
        c1 = NSLayoutConstraint(item: bkView, attribute: .top, relatedBy: .equal, toItem: bkView.superview, attribute: .top, multiplier: 1, constant: 0)
        c2 = NSLayoutConstraint(item: bkView, attribute: .leading, relatedBy: .equal, toItem: bkView.superview, attribute: .leading, multiplier: 1, constant: 0)
        c3 = NSLayoutConstraint(item: bkView, attribute: .trailing, relatedBy: .equal, toItem: bkView.superview, attribute: .trailing, multiplier: 1, constant: 0)
        c4 = NSLayoutConstraint(item: bkView, attribute: .bottom, relatedBy: .equal, toItem: bkView.superview, attribute: .bottom, multiplier: 1, constant: 0)
        bkView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addConstraint(c1)
        scrollView.addConstraint(c2)
        scrollView.addConstraint(c3)
        scrollView.addConstraint(c4)
        
        let tmps: [Any] = [cityBtn,dateLbl,timeLbl,quantityLbl,signupLbl,feeMLbl,feeFLbl,ballLbl,leaderLbl,mobileLbl,degreeLbl]
        items = items + tmps
        
        for (idx, item) in items.enumerated() {
            let last = (idx == 0) ? featuredView : items[idx-1]
            let c1: NSLayoutConstraint = NSLayoutConstraint(item: item, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leading, multiplier: 1, constant: constant.name_left_padding)
            let c2: NSLayoutConstraint = NSLayoutConstraint(item: item, attribute: .top, relatedBy: .equal, toItem: last, attribute: .bottom, multiplier: 1, constant: constant.name_top_padding)
            if let item1: SuperLabel = item as? SuperLabel {
                item1.translatesAutoresizingMaskIntoConstraints = false
                scrollView.addConstraint(c1)
                scrollView.addConstraint(c2)
            } else if let item1: SuperButton = item as? SuperButton {
                item1.translatesAutoresizingMaskIntoConstraints = false
                scrollView.addConstraint(c1)
                scrollView.addConstraint(c2)
            }
            
        }
        
        let arenaBtnC1: NSLayoutConstraint = NSLayoutConstraint(item: arenaBtn, attribute: .leading, relatedBy: .equal, toItem: cityBtn, attribute: .trailing, multiplier: 1, constant: constant.name_left_padding)
        let arenaBtnC2: NSLayoutConstraint = NSLayoutConstraint(item: arenaBtn, attribute: .centerY, relatedBy: .equal, toItem: cityBtn, attribute: .centerY, multiplier: 1, constant: 0)
        arenaBtn.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addConstraint(arenaBtnC1)
        scrollView.addConstraint(arenaBtnC2)
        
        let plusOneBtnC1: NSLayoutConstraint = NSLayoutConstraint(item: plusOneBtn, attribute: .top, relatedBy: .equal, toItem: degreeLbl, attribute: .bottom, multiplier: 1, constant: constant.name_top_padding)
        let allW: CGFloat = view.frame.width / 2
        let w1: CGFloat = plusOneBtn.frame.width
        let plusOneBtnC2: NSLayoutConstraint = NSLayoutConstraint(item: plusOneBtn, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leading, multiplier: 1, constant: allW - w1 - constant.name_left_padding)
        plusOneBtn.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addConstraint(plusOneBtnC1)
        scrollView.addConstraint(plusOneBtnC2)
        
        let cancelPlusOneBtnC1: NSLayoutConstraint = NSLayoutConstraint(item: cancelPlusOneBtn, attribute: .top, relatedBy: .equal, toItem: degreeLbl, attribute: .bottom, multiplier: 1, constant: constant.name_top_padding)
        let cancelPlusOneBtnC2: NSLayoutConstraint = NSLayoutConstraint(item: cancelPlusOneBtn, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leading, multiplier: 1, constant: allW + constant.name_left_padding)
        cancelPlusOneBtn.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addConstraint(cancelPlusOneBtnC1)
        scrollView.addConstraint(cancelPlusOneBtnC2)
    }
    
    @objc func refresh() {
        //_layout()
        Global.instance.addSpinner(superView: self.view)
        TeamService.instance.getOne(type: "team", token: token) { (success) in
            if success {
                Global.instance.removeSpinner(superView: self.view)
                //print(self.model.data)
                self.setPage()
                //self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    /*
    @objc func rotated() {
        //print("rotate")
        //_layout()
        print(view.frame)
        print(headerView.frame)
        //featuredLayout()
        //bkView.transform = bkView.transform.rotated(by: .pi/2)
        scrollView.frame = CGRect(x: 0, y: 80, width: view.bounds.width, height: view.bounds.height)
        bkView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
    }
 
 */
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
                self.refresh()
            }
        }
    }
    private func setPage() {
        myTitle = (model.data[TEAM_NAME_KEY]!["value"] as! String)
        titleLbl.text = myTitle
        featured = (model.data[TEAM_FEATURED_KEY]!["value"] as! UIImage)
        featuredLayout()
        featuredView.image = featured
        featuredView.contentMode = .scaleAspectFit
        
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
    private func featuredLayout() {
        let img_width: CGFloat = featured.size.width
        let img_height: CGFloat = featured.size.height
        let width: CGFloat = view.frame.width
        let height: CGFloat = width * (img_height / img_width)
        featuredView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        //print(featuredView.frame)
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}















