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
    var scrollView: UIScrollView!
    var bkView: UIImageView!
    var containerView: UIView!
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
    var tableView: UITableView!
    
    var items: [Any] = [Any]()
    
    let constant: TEAM_TEMP_PLAY_CELL = TEAM_TEMP_PLAY_CELL()
    let tableViewHeaderHeight: CGFloat = 40
    let tableViewCellHeight: CGFloat = 40
    
    var tableViewHeightConstraint: NSLayoutConstraint!
    
    var myTitle: String!
    var nearDate: String!
    var featured: UIImage!
    
    //var refreshControl: UIRefreshControl!
    
    

    // outlet
    @IBOutlet weak var titleLbl: UILabel!
    //@IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tempPlayBtn: UIButton!
    
    override func viewDidLoad() {
        model = Team.instance
        tableView = UITableView()
        myTablView = tableView
        
        super.viewDidLoad()
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: headerView.frame.height + STATUSBAR_HEIGHT, width: view.bounds.width, height: view.bounds.height))
        scrollView.backgroundColor = UIColor.black
        scrollView.contentSize = CGSize(width: view.bounds.width, height: 5000)
        view.addSubview(scrollView)
        
        containerView = UIView(frame: CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height))
        containerView.backgroundColor = UIColor.clear
        containerView.isUserInteractionEnabled = true
        
        bkView = UIImageView()
        bkView.image = UIImage(named: "background")
        let height: CGFloat = (bkView.image?.size.height)!
        bkView.frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: height)
        //containerView.contentMode = .scaleAspectFit
        containerView.addSubview(bkView)
        
        scrollView.addSubview(containerView)
        
        featuredView = UIImageView()
        containerView.addSubview(featuredView)
        
        cityBtn = SuperButton(frame:CGRect.zero,textColor:UIColor.black, bkColor:UIColor(MY_GREEN))
        arenaBtn = SuperButton(frame:CGRect.zero,textColor:UIColor.black, bkColor:UIColor(MY_GREEN))
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
        cancelPlusOneBtn = SuperButton(frame: CGRect.zero, textColor: UIColor.black, bkColor: UIColor(MY_GREEN))
        
        containerView.addSubview(cityBtn)
        containerView.addSubview(arenaBtn)
        containerView.addSubview(dateLbl)
        containerView.addSubview(timeLbl)
        containerView.addSubview(quantityLbl)
        containerView.addSubview(signupLbl)
        containerView.addSubview(feeMLbl)
        containerView.addSubview(feeFLbl)
        containerView.addSubview(ballLbl)
        containerView.addSubview(leaderLbl)
        containerView.addSubview(mobileLbl)
        containerView.addSubview(degreeLbl)
        containerView.addSubview(plusOneBtn)
        containerView.addSubview(cancelPlusOneBtn)
        containerView.addSubview(tableView)
        
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
        cancelPlusOneBtn.addTarget(self, action: #selector(cancelPlusOne(_:)), for: UIControlEvents.touchUpInside)
        plusOneBtn.setTitle("我要臨打", for: .normal)
        cancelPlusOneBtn.setTitle("取消臨打", for: .normal)
        plusOneBtn.sizeToFit()
        cancelPlusOneBtn.sizeToFit()
        //spaceView.backgroundColor = UIColor.red
        
        tableView.register(TempPlaySignupCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = UIColor.black
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "更新資料")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        scrollView.addSubview(refreshControl)
        
        tempPlayBtn.contentEdgeInsets = UIEdgeInsets(top: 4, left: 10, bottom: 2, right: 10)
        tempPlayBtn.layer.cornerRadius = 12
        
        //print(view.frame)
        
        _layout()
        refresh()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //print("view did layout subviews")
        
        var count = 0
        if model.data["signups"] != nil {
            let signups: [[String:String]] = model.data["signups"]!["value"] as! [[String:String]]
            count = signups.count
        }
        let tableViewHeight: CGFloat = count > 0 ? tableViewHeaderHeight + CGFloat(count) * tableViewCellHeight : 0
        
        //print(tableViewHeight)
        tableViewHeightConstraint.constant = tableViewHeight
        
        self.view.layoutIfNeeded()
    }
    //override func updateViewConstraints() {
        
    //}
    
    private func _layout() {
        
        var c1: NSLayoutConstraint,c2: NSLayoutConstraint,c3: NSLayoutConstraint,c4: NSLayoutConstraint
        /*
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
        
        
        c1 = NSLayoutConstraint(item: containerView, attribute: .top, relatedBy: .equal, toItem: containerView.superview, attribute: .top, multiplier: 1, constant: 0)
        c2 = NSLayoutConstraint(item: containerView, attribute: .leading, relatedBy: .equal, toItem: containerView.superview, attribute: .leading, multiplier: 1, constant: 0)
        c3 = NSLayoutConstraint(item: containerView, attribute: .trailing, relatedBy: .equal, toItem: containerView.superview, attribute: .trailing, multiplier: 1, constant: 0)
        c4 = NSLayoutConstraint(item: containerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: scrollView.contentSize.height)
        //c4 = NSLayoutConstraint(item: containerView, attribute: .bottom, relatedBy: .equal, toItem: containerView.superview, attribute: .bottom, multiplier: 1, constant: 0)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addConstraint(c1)
        scrollView.addConstraint(c2)
        scrollView.addConstraint(c3)
        scrollView.addConstraint(c4)
 */
        
        //let tmps: [Any] = [cityBtn]
        let tmps: [Any] = [cityBtn,dateLbl,timeLbl,quantityLbl,signupLbl,feeMLbl,feeFLbl,ballLbl,leaderLbl,mobileLbl,degreeLbl,tableView]
        items = items + tmps
        
        for (idx, item) in items.enumerated() {
            let last = (idx == 0) ? featuredView : items[idx-1]
            let c1: NSLayoutConstraint = NSLayoutConstraint(item: item, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1, constant: constant.name_left_padding)
            let c2: NSLayoutConstraint = NSLayoutConstraint(item: item, attribute: .top, relatedBy: .equal, toItem: last, attribute: .bottom, multiplier: 1, constant: constant.name_top_padding)
            if let item1: SuperLabel = item as? SuperLabel {
                item1.translatesAutoresizingMaskIntoConstraints = false
                containerView.addConstraint(c1)
                containerView.addConstraint(c2)
            } else if let item1: SuperButton = item as? SuperButton {
                item1.translatesAutoresizingMaskIntoConstraints = false
                containerView.addConstraint(c1)
                containerView.addConstraint(c2)
            } else if let item1: UITableView = item as? UITableView {
                
            }
            
        }
        
        // tableView
        c1 = NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1, constant: constant.name_left_padding)
        c2 = NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: degreeLbl, attribute: .bottom, multiplier: 1, constant: constant.name_top_padding)
        //c3 = NSLayoutConstraint(item: tableView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)
        c3 = NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1, constant: constant.name_left_padding * -1)
        tableViewHeightConstraint = NSLayoutConstraint(item: tableView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addConstraint(c1)
        containerView.addConstraint(c2)
        containerView.addConstraint(c3)
        containerView.addConstraint(tableViewHeightConstraint)
        
        let arenaBtnC1: NSLayoutConstraint = NSLayoutConstraint(item: arenaBtn, attribute: .leading, relatedBy: .equal, toItem: cityBtn, attribute: .trailing, multiplier: 1, constant: constant.name_left_padding)
        let arenaBtnC2: NSLayoutConstraint = NSLayoutConstraint(item: arenaBtn, attribute: .centerY, relatedBy: .equal, toItem: cityBtn, attribute: .centerY, multiplier: 1, constant: 0)
        arenaBtn.translatesAutoresizingMaskIntoConstraints = false
        containerView.addConstraint(arenaBtnC1)
        containerView.addConstraint(arenaBtnC2)
        
        
        let plusOneBtnC1: NSLayoutConstraint = NSLayoutConstraint(item: plusOneBtn, attribute: .top, relatedBy: .equal, toItem: tableView, attribute: .bottom, multiplier: 1, constant: constant.name_top_padding * 6)
        let allW: CGFloat = view.frame.width / 2
        let w1: CGFloat = plusOneBtn.frame.width
        let plusOneBtnC2: NSLayoutConstraint = NSLayoutConstraint(item: plusOneBtn, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1, constant: allW - w1 - constant.name_left_padding)
        plusOneBtn.translatesAutoresizingMaskIntoConstraints = false
        containerView.addConstraints([plusOneBtnC1,plusOneBtnC2])
        
        let cancelPlusOneBtnC1: NSLayoutConstraint = NSLayoutConstraint(item: cancelPlusOneBtn, attribute: .top, relatedBy: .equal, toItem: tableView, attribute: .bottom, multiplier: 1, constant: constant.name_top_padding * 6)
        let cancelPlusOneBtnC2: NSLayoutConstraint = NSLayoutConstraint(item: cancelPlusOneBtn, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1, constant: allW + constant.name_left_padding)
        cancelPlusOneBtn.translatesAutoresizingMaskIntoConstraints = false
        containerView.addConstraint(cancelPlusOneBtnC1)
        containerView.addConstraint(cancelPlusOneBtnC2)
    }
    
    override func refresh() {
        //_layout()
        Global.instance.addSpinner(superView: self.view)
        TeamService.instance.getOne(type: "team", token: token) { (success) in
            if success {
                Global.instance.removeSpinner(superView: self.view)
                //print(self.model.data)
//                let tmp:[[String:String]] = [["nickname":"ives"]]
//                self.model.data["signups"]!["value"] = [[String:String]]()
//                self.model.data["signups"]!["value"] = tmp
                self.setPage()
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                self.tableView.tableHeaderView?.layoutIfNeeded()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int = 0
        if model.data["signups"] != nil {
            let rows: [[String: String]] = model.data["signups"]!["value"] as! [[String: String]]
            count = rows.count
        }
        //print(count)
        return count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableViewHeaderHeight
    }
    /*
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "報名臨打球友"
    }*/
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: TempPlayTableHeaderView = TempPlayTableHeaderView()

        return headerView
    }
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {

    }
    /*
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
 */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewCellHeight
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //print("section: \(indexPath.section), row: \(indexPath.row)")
        let cell: TempPlaySignupCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TempPlaySignupCell
        let rows: [[String: String]] = model.data["signups"]!["value"] as! [[String: String]]
        let row: Dictionary<String, String> = rows[indexPath.row]
        cell.forRow(row: row)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rows: [[String: String]] = model.data["signups"]!["value"] as! [[String: String]]
        let row: Dictionary<String, String> = rows[indexPath.row]
        //print(row)
        let id: Int = model.data[TEAM_ID_KEY]!["value"] as! Int
        let sender:[String:Any] = ["token":row["token"]!,"title":myTitle,"near_date":nearDate,"id":id]
        performSegue(withIdentifier: TO_MEMBER_ONE, sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if sender != nil {
            if segue.identifier == TO_VALIDATE {
                let vc: ValidateVC = segue.destination as! ValidateVC
                vc.type = sender as! String
            } else if segue.identifier == TO_MEMBER_ONE {
                let row:[String:Any] = sender as! [String:Any]
                let vc: MemberOneVC = segue.destination as! MemberOneVC
                vc.memberToken = row["token"]! as! String
                vc.team_name = row["title"]! as! String
                vc.near_date = row["near_date"]! as! String
                vc.team_id = row["id"]! as! Int
                vc.type = "temp play"
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
        //containerView.transform = containerView.transform.rotated(by: .pi/2)
        scrollView.frame = CGRect(x: 0, y: 80, width: view.bounds.width, height: view.bounds.height)
        containerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
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
        if (Member.instance.validate & MOBILE_VALIDATE) == 0 {
            warning(msg: "要使用臨打功能，須先通過手機認證", showCloseButton:true, buttonTitle: "手機認證", buttonAction: {
                self.performSegue(withIdentifier: TO_VALIDATE, sender: "mobile")
            })

            return
        }
        if (Member.instance.name.count == 0) {
            warning(msg: "要使用臨打功能，請先輸入真實姓名", showCloseButton: true, buttonTitle: "輸入姓名", buttonAction: {
                self.performSegue(withIdentifier: TO_PROFILE, sender: nil)
            })
        }

        warning(msg: "報名臨打後，將會公開您的姓名與手機號碼給球隊管理員，方便球隊管理員跟您連絡\n是否真的要參加此球隊的臨打？", closeButtonTitle: "取消報名", buttonTitle: "確定臨打") {
                self._plusOne()
        }
    }
    func _plusOne() {
        Global.instance.addSpinner(superView: self.view)
        TeamService.instance.plusOne(title: myTitle, near_date: nearDate, token: Member.instance.token) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if success {
                if TeamService.instance.success {
                    SCLAlertView().showSuccess("成功", subTitle: "報名臨打成功")
                    
                } else {
                    SCLAlertView().showWarning("警告", subTitle: TeamService.instance.msg)
                }
                self.refresh()
            } else {
                SCLAlertView().showWarning("警告", subTitle: TeamService.instance.msg)
            }
        }
    }
    @objc func cancelPlusOne(_ sender:Any) {
        if !Member.instance.isLoggedIn {
            SCLAlertView().showWarning("警告", subTitle: "請先登入為會員")
            return
        }
        Global.instance.addSpinner(superView: self.view)
        TeamService.instance.cancelPlusOne(title: myTitle, near_date: nearDate, token: Member.instance.token) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if success {
                if TeamService.instance.success {
                    SCLAlertView().showSuccess("成功", subTitle: "取消報名臨打成功")
                    
                } else {
                    SCLAlertView().showWarning("警告", subTitle: TeamService.instance.msg)
                }
                self.refresh()
            } else {
                SCLAlertView().showWarning("警告", subTitle: TeamService.instance.msg)
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















