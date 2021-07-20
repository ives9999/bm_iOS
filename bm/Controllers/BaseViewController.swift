//
//  BaseViewController.swift
//  bm
//
//  Created by ives on 2018/4/3.
//  Copyright © 2018年 bm. All rights reserved.
//

import UIKit
import OneSignal
import Reachability
import WebKit
import SCLAlertView

class BaseViewController: UIViewController, MultiSelectDelegate, SingleSelectDelegate, SelectManagersDelegate, DateSelectDelegate, FormItemDelegate, WeekdaysSelectDelegate, TimeSelectDelegate, ArenaSelectDelegate, DegreeSelectDelegate, EditCellDelegate, ContentEditDelegate {
    
    //var baseVC: BaseViewController
    
//    var baseVC: BaseViewController {
//        return self
//    }
    
    var msg: String = ""
    var dataService: DataService = DataService()
    //var managerLists: [SuperData] = [SuperData]()
    var refreshControl: UIRefreshControl!
    let titleBarHeight: CGFloat = 80
    var workAreaHeight: CGFloat = 600
    
    let session: UserDefaults = UserDefaults.standard
    
    //layer
    let maskView = UIView()
    var containerView = UIView(frame: .zero)
    let layerSubmitBtn: SubmitButton = SubmitButton()
    let layerCancelBtn: CancelButton = CancelButton()
    let layerDeleteBtn: ClearButton = ClearButton()
    var layerBtnCount: Int = 2
    
    var staticButtomView: StaticBottomView?
    
    //loading
    var isLoading: Bool = false
    var loadingMask: UIView?
    var loadingSpinner: UIActivityIndicatorView?
    var loadingText: UILabel?
    
    let body_css = "<style>body{background-color:#000;padding-left:8px;padding-right:8px;margin-top:0;padding-top:0;color:#888888;font-size:18px;}a{color:#a6d903;}</style>"
    
    var searchPanel: SearchPanel = SearchPanel()
    var searchRows: [[String: Any]] = [[String: Any]]()
    
    //WeekdaysSelectDelegate
    func setWeekdaysData(selecteds: [Int]){}
    //TimeSelectDelegate
    func setTimeData(res: [String], type: SELECT_TIME_TYPE, indexPath: IndexPath?){}
    //ArenaSelectDelegate
    func setArenaData(res: [ArenaTable]){}
    //DegreeSelectDelegate
    func setDegreeData(res: [DEGREE]){}
    //EditCellDeldgate
    func setTextField(key: String, value: String) {}
    func setSwitch(indexPath: IndexPath, value: Bool) {}
    func clear(indexPath: IndexPath) {}
    //ContentEditDelegate
    func setContent(key: String, content: String) {}
    
    //for tag delegate
    func setTag(sectionKey: String, rowKey: String, attribute: String, selected: Bool){}
    //for NumberCell delegate
    func stepperValueChanged(sectionKey: String, rowKey: String, number: Int){}
    //for TextFieldCell delegate
    func textFieldDidChange(sectionKey: String, rowKey: String, text: String){}
    
//    var wheels: Int = 0
//    required init() {}
//    init(wheels: Int) {
//        self.wheels = wheels
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //setStatusBar(color: UIColor(STATUS_GREEN))
        workAreaHeight = view.bounds.height - titleBarHeight
        layerCancelBtn.setTitle("取消")
        layerDeleteBtn.setTitle("刪除")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let reachability = try! Reachability()
        
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                //print("WiFi")
            } else {
                //print("Cellular")
            }
        }
        reachability.whenUnreachable = { _ in
            self.warning(msg: "沒有連接網路，所以無法使用此app", buttonTitle: "確定", buttonAction: {
                exit(0)
            })
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            warning("無法開啟測試連結網路警告視窗，請稍後再使用!!")
        }
    }
    
    func mask(y: CGFloat, superView: UIView? = nil, height: CGFloat? = nil) {
        maskView.backgroundColor = UIColor(white: 1, alpha: 0.8)
        maskView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(unmask)))
        var _view = view
        if superView != nil {
            _view = superView
        }
        _view?.addSubview(maskView)
        
        var _height = view.bounds.height - titleBarHeight
        if height != nil {
            _height = height!
        }
        maskView.frame = CGRect(x: 0, y: y, width: (_view?.frame.width)!, height: _height)
        maskView.alpha = 0
    }
    
//    func addLayer(superView: UIView, frame: CGRect) {
//        superView.addSubview(containerView)
//        containerView.frame = frame
//        containerView.backgroundColor = UIColor.black
//        _addLayer()
//    }
    
//    func _addLayer() {}
    
//    func layerAddSubmitBtn(upView: UIView) {
//        containerView.addSubview(layerSubmitBtn)
//        let c1: NSLayoutConstraint = NSLayoutConstraint(item: layerSubmitBtn, attribute: .top, relatedBy: .equal, toItem: upView, attribute: .bottom, multiplier: 1, constant: 12)
//        var offset:CGFloat = 0
//        if layerBtnCount == 2 {
//            offset = -60
//        } else if layerBtnCount == 3 {
//            offset = -120
//        }
//        let c2: NSLayoutConstraint = NSLayoutConstraint(item: layerSubmitBtn, attribute: .centerX, relatedBy: .equal, toItem: layerSubmitBtn.superview, attribute: .centerX, multiplier: 1, constant: offset)
//        layerSubmitBtn.translatesAutoresizingMaskIntoConstraints = false
//        containerView.addConstraints([c1,c2])
//        layerSubmitBtn.addTarget(self, action: #selector(layerSubmit(view:)), for: .touchUpInside)
//        self.layerSubmitBtn.isHidden = false
//    }
//    func layerAddCancelBtn(upView: UIView) {
//        containerView.addSubview(layerCancelBtn)
//        let c1: NSLayoutConstraint = NSLayoutConstraint(item: layerCancelBtn, attribute: .top, relatedBy: .equal, toItem: upView, attribute: .bottom, multiplier: 1, constant: 12)
//        var offset:CGFloat = 0
//        if layerBtnCount == 2 {
//            offset = 60
//        }
//        let c2: NSLayoutConstraint = NSLayoutConstraint(item: layerCancelBtn, attribute: .centerX, relatedBy: .equal, toItem: layerCancelBtn.superview, attribute: .centerX, multiplier: 1, constant: offset)
//        layerCancelBtn.translatesAutoresizingMaskIntoConstraints = false
//        containerView.addConstraints([c1,c2])
//        layerCancelBtn.addTarget(self, action: #selector(layerCancel(view:)), for: .touchUpInside)
//        self.layerCancelBtn.isHidden = false
//    }
//    func layerAddDeleteBtn(upView: UIView) {
//        containerView.addSubview(layerDeleteBtn)
//        let c1: NSLayoutConstraint = NSLayoutConstraint(item: layerDeleteBtn, attribute: .top, relatedBy: .equal, toItem: upView, attribute: .bottom, multiplier: 1, constant: 12)
//        var offset:CGFloat = 0
//        if layerBtnCount == 2 {
//            offset = 60
//        } else if layerBtnCount == 3 {
//            offset = 120
//        }
//        let c2: NSLayoutConstraint = NSLayoutConstraint(item: layerDeleteBtn, attribute: .centerX, relatedBy: .equal, toItem: layerDeleteBtn.superview, attribute: .centerX, multiplier: 1, constant: offset)
//        layerDeleteBtn.translatesAutoresizingMaskIntoConstraints = false
//        containerView.addConstraints([c1,c2])
//        layerDeleteBtn.addTarget(self, action: #selector(layerDelete(view:)), for: .touchUpInside)
//        self.layerDeleteBtn.isHidden = false
//    }
//    func animation(frame: CGRect) {
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//            self.maskView.alpha = 1
//            self.containerView.frame = frame
//        }, completion: { (finished) in
//            if finished {
//                self.otherAnimation()
//            }
//        })
//    }
//    func otherAnimation(){}
//
//
    @objc func unmask(){}
//    @objc func layerSubmit(view: UIButton){}
//    @objc func layerDelete(view: UIButton){}
//    @objc func layerCancel(view: UIButton){unmask()}
    
    func prepareParams(city_type: String="simple") {}
    
    func prev() {
        dismiss(animated: true, completion: nil)
    }
    
    func goHome() {
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    func goHomeThen(completion: @escaping (_ baseViewController: BaseViewController)-> Void) {
        
        let tabBarController = self.view.window!.rootViewController as! UITabBarController
        let idx: Int = tabBarController.selectedIndex
        let vc: BaseViewController = TAB.idxToController(idx, tabBarController: tabBarController)
        self.view.window!.rootViewController?.dismiss(animated: true) {
            completion(vc)
        }
    }
    
    func beginRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "更新資料")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
    }
    func endRefresh() {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
    
    @objc func memberDidChange(_ notif: Notification) {
        //print("notify")
        refreshMember { (success) in
            
        }
    }
    func _getMemberOne(token: String, completion: @escaping CompletionHandler) {
        MemberService.instance.getOne(token: token, completion: completion)
    }
    func refreshMember(completion: @escaping CompletionHandler) {
        Global.instance.addSpinner(superView: self.view)
        MemberService.instance.getOne(token: Member.instance.token) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if (success) {
                completion(true)
            } else {
                SCLAlertView().showWarning("警告", subTitle: MemberService.instance.msg)
                completion(false)
            }
        }
    }
    
    func makeCalendar(_ _y:Int?, _ _m:Int?)->[String: Any] {
        
        let y: Int = (_y == nil) ? Date().getY() : _y!
        let m: Int = (_m == nil) ? Date().getm() : _m!
        var res: [String: Any] = [String: Any]()
        //取得該月1號的星期幾，日曆才知道從星期幾開始顯示
        let weekday01 = "\(y)-\(m)-01"
        res["weekday01"] = weekday01
        
        var beginWeekday = weekday01.toDate().dateToWeekday()
        beginWeekday = beginWeekday == 0 ? 7 : beginWeekday;
        res["beginWeekday"] = beginWeekday

        //取得該月最後一天的日期，30, 31或28，日曆才知道顯示到那一天
        let monthLastDay = Date().getMonthDays(y, m)
        res["monthLastDay"] = monthLastDay
        let monthLastDay_add_begin = monthLastDay + beginWeekday - 1
        res["monthLastDay_add_begin"] = monthLastDay_add_begin

        //取得該月最後一天的星期幾，計算月曆有幾列需要用到的數字
        let weekday31 = "\(y)-\(m)-\(monthLastDay)"
        res["weekday31"] = weekday31
        
        let endWeekday = weekday31.toDate().dateToWeekday()
        res["endWeekday"] = endWeekday

        //算出共需幾個日曆的格子
        let allMonthGrid = monthLastDay + (beginWeekday-1) + (7-endWeekday);
        res["allMonthGrid"] = allMonthGrid

        //算出月曆列數，日曆才知道顯示幾列
        let monthRow = allMonthGrid/7
        res["monthRow"] = monthRow

        //建立下個月的連結
        let next_month = m == 12 ? 1 : m+1
        res["next_month"] = next_month
        let next_year = m == 12 ? y+1 : y
        res["next_year"] = next_year
        
        return res
    }
    
    func _updatePlayerIDWhenIsNull() {
        let token = Member.instance.token
        //print(token)
        MemberService.instance.getOne(token: token) { (success) in
            if (success) {
                Member.instance.justGetMemberOne = true
                //print(Member.instance.type)
                if Member.instance.player_id.count == 0 {
                    self._updatePlayerID()
                }
            }
        }
    }
    func _updatePlayerID() {
        var player_id = _getPlayerID()
        //print(player_id)
        MemberService.instance.update(id: Member.instance.id, field: PLAYERID_KEY, value: &player_id, completion: { (success) in
            if success {
                Member.instance.player_id = player_id
            }
        })
    }
    func _getPlayerID() -> String {
        let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
        var playerID: String = ""
        if let temp: String = status.subscriptionStatus.userId {
            playerID = temp
        }
        //print(playerID)
        //if userID != nil {
        //let user = PFUser.cu
        //}
        return playerID
    }
    
    //直接在LoginVC執行
//    func _loginFB() {
//        //print(Facebook.instance.uid)
//        //print(Facebook.instance.email)
//        let playerID: String = self._getPlayerID()
//        Global.instance.addSpinner(superView: self.view)
//        MemberService.instance.login_fb(playerID: playerID, completion: { (success1) in
//            Global.instance.removeSpinner(superView: self.view)
//            if success1 {
//                if MemberService.instance.success {
//                    //self.performSegue(withIdentifier: UNWIND, sender: "refresh_team")
//                } else {
//                    //print("login failed by error email or password")
//                    self.warning(MemberService.instance.msg)
//                }
//            } else {
//                self.warning("使用FB登入，但無法新增至資料庫，請洽管理員")
//                //print("login failed by fb")
//            }
//        })
//    }
    
//    func _getManagerList(source: String, titleField: String, completion: @escaping CompletionHandler) {
//        Global.instance.addSpinner(superView: self.view)
//        let filter: [[Any]] = [
//            ["channel", "=", CHANNEL],
//            ["manager_id", "=", Member.instance.id]
//        ]
//        let params: Dictionary<String, Any> = [String: Any]()
//        dataService.getList(type: source, titleField: titleField, params:params, page: 1, perPage: 100, filter: filter) { (success) in
//            Global.instance.removeSpinner(superView: self.view)
//            if success {
//                self.managerLists = self.dataService.dataLists
//
//                completion(true)
//            } else {
//                self.msg = self.dataService.msg
//                completion(false)
//            }
//        }
//    }
    
    func addBlackList(memberName: String, memberToken: String, teamToken: String) {
        warning(msg:"是否真的要將球友"+memberName+"設為黑名單\n之後可以解除", closeButtonTitle: "取消", buttonTitle: "確定", buttonAction: {
            self.reasonBox(memberToken: memberToken, teamToken: teamToken)
        })
    }
    func reasonBox(memberToken: String, teamToken: String) {
        let alert = SCLAlertView()
        let txt = alert.addTextField()
        alert.addButton("加入", action: {
            self._addBlackList(txt.text!, memberToken: memberToken, teamToken: teamToken)
        })
        alert.showEdit("請輸入理由", subTitle: "")
    }
    func _addBlackList(_ reason: String, memberToken: String, teamToken: String) {
        Global.instance.addSpinner(superView: self.view)
        TeamService.instance.addBlackList(teamToken: teamToken, playerToken: memberToken,managerToken:Member.instance.token, reason: reason) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if (success) {
                self.info("加入黑名單成功")
            } else {
                self.warning(TeamService.instance.msg)
            }
        }
    }
    
    func _showMap(title: String, address: String) {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: "UIViewController-nQN-QD-w9o") as? ArenaMapVC {
                viewController.annotationTitle = title
                viewController.address = address
                show(viewController, sender: nil)
            }
        } else {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "UIViewController-nQN-QD-w9o") as! ArenaMapVC
            viewController.annotationTitle = title
            viewController.address = address
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func loadingShow() {
        if loadingMask == nil {
            loadingMask = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
            loadingMask!.backgroundColor = UIColor(white: 0, alpha: 0.8) //you can modify this to whatever you need
            
            let center: CGPoint = loadingMask!.center
            loadingSpinner = UIActivityIndicatorView()
            loadingSpinner!.center = center
            loadingSpinner!.style = .whiteLarge
            loadingSpinner!.color = #colorLiteral(red: 0.6862745098, green: 0.9882352941, blue: 0.4823529412, alpha: 1)
            loadingSpinner!.startAnimating()
            loadingMask!.addSubview(loadingSpinner!)
            
            loadingText = UILabel(frame: CGRect(x: Int(center.x)-LOADING_WIDTH/2, y: Int(center.y)+LOADING_HEIGHT/2, width: LOADING_WIDTH, height: LOADING_HEIGHT))
            loadingText!.font = UIFont(name: "Avenir Next", size: 18)
            loadingText!.textColor = #colorLiteral(red: 0.6862745098, green: 0.9882352941, blue: 0.4823529412, alpha: 1)
            loadingText!.textAlignment = .center
            loadingText!.text = LOADING
            loadingMask!.addSubview(loadingText!)
        } else {
            loadingMask!.isHidden = false
        }
        view.addSubview(loadingMask!)
    }
    
    func loadingHide() {
        if loadingMask != nil {
            loadingMask!.removeFromSuperview()
            //loadingMask! = nil
            loadingMask!.isHidden = true
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated {
            if let url = navigationAction.request.url {
                //print(url)
                if UIApplication.shared.canOpenURL(url) {
                    decisionHandler(.cancel)
                    UIApplication.shared.openURL(url)
                } else {
                    decisionHandler(.allow)
                }
            } else {
                decisionHandler(.allow)
            }
        } else {
            decisionHandler(.allow)
        }
    }
    
    @objc func refresh() {}
    
    
    
    // return is [
    //             ["id": "5", "name": "新北市"],
    //             ["id": "6", "name": "台北市"]
    //           ]
    func getCitys(completion1: @escaping (_ rows: [[String: String]]) -> Void) -> [[String: String]] {
        
        //session.removeObject(forKey: "citys")
        let rows = session.getArrayDictionary("citys")
        if rows.count == 0 {
            Global.instance.addSpinner(superView: view)
            DataService.instance1.getCitys() { (success) in
                if success {
                    let rows = DataService.instance1.citys
                    //print(rows)
                    var citys = [[String: String]]()
                    for row in rows { // row is City object
                        citys.append(["name": row.name, "id": String(row.id)])
                    }
                    self.session.set(citys, forKey: "citys")
                    //self.tableView.reloadData()
                    completion1(citys)
                }
                Global.instance.removeSpinner(superView: self.view)
            }
        }
        return rows
    }
    
    // return is [
    //             "52": [
    //                     "id": "52",
    //                     "name": ["新北市"],
    //                     "rows": [
    //                          ["id": "5", "name": "中和"],
    //                          ["id": "6", "name": "永和"]
    //                     ]
    //                  ]
    //           ]
    func getAreasFromCity(_ city_id: Int, completion1: @escaping (_ rows: [[String: String]]) -> Void) -> [[String: String]] {
        
        //session.removeObject(forKey: "areas")
        let rows = session.getAreasByCity(city_id)
        //print(rows)
        if rows.count == 0 {
            let city_ids: [Int] = [city_id]
            Global.instance.addSpinner(superView: view)
            DataService.instance1.getAreaByCityIDs(city_ids: city_ids,city_type: "") { (success) in
                if success {
                    
                    let city = DataService.instance1.citysandareas
                    var city_name = ""
                    if city[city_id] != nil {
                        city_name = city[city_id]!["name"] as! String
                    }
                    
                    var areas: [[String: String]] = [[String: String]]()
                    for row in (city[city_id]!["rows"] as! Array<[String: Any]>) {
                        var area_id: String = ""
                        var area_name: String = ""
                        for (key, value) in row {
                            if key == "id" {
                                area_id = String(value as! Int)
                            }
                            if key == "name" {
                                area_name = value as! String
                            }
                        }
                        if area_id.count > 0 && area_name.count > 0 {
                            areas.append(["id":area_id,"name":area_name])
                        }
                    }
                    //print(areas)
                    let area_s: [String: Any] = ["id": String(city_id), "name": city_name, "rows": areas]
                    let city_s: [String: [String: Any]] = [String(city_id): area_s]
                    
                    var allAreas: [String: [String: Any]] = self.session.getAllAreas()
                    if allAreas.count > 0 {
                        allAreas[String(city_id)] = area_s
                        self.session.set(allAreas, forKey: "areas")
                    } else {
                        self.session.set(city_s, forKey: "areas")
                    }
                    completion1(areas)
                    
                    Global.instance.removeSpinner(superView: self.view)
                }
            }
        }
        return rows
    }
    
    func getAreasFromCitys(_ city_ids: [Int], completion1: @escaping (_ rows: [String: [String: Any]]) -> Void) -> [String: [String: Any]] {
        
        //session.removeObject(forKey: "areas")
        let rows = session.getAreasByCitys(city_ids)
        //print(rows)
        if rows.count < city_ids.count {
            //let city_ids: [Int] = [city_id]
            Global.instance.addSpinner(superView: view)
            DataService.instance1.getAreaByCityIDs(city_ids: city_ids,city_type: "") { (success) in
                if success {
                    
                    var res: [String: [String: Any]] = [String: [String: Any]]()
                    let city = DataService.instance1.citysandareas
                    for (city_id, _) in city {
                        var city_name = ""
                        if city[city_id] != nil {
                            city_name = city[city_id]!["name"] as! String
                        }
                        
                        var areas: [[String: String]] = [[String: String]]()
                        for row in (city[city_id]!["rows"] as! Array<[String: Any]>) {
                            var area_id: String = ""
                            var area_name: String = ""
                            for (key, value) in row {
                                if key == "id" {
                                    area_id = String(value as! Int)
                                }
                                if key == "name" {
                                    area_name = value as! String
                                }
                            }
                            if area_id.count > 0 && area_name.count > 0 {
                                areas.append(["id":area_id,"name":area_name])
                            }
                        }
                        //print(areas)
                        let area_s: [String: Any] = ["id": String(city_id), "name": city_name, "rows": areas]
                        let city_s: [String: [String: Any]] = [String(city_id): area_s]
                        
                        var allAreas: [String: [String: Any]] = self.session.getAllAreas()
                        if allAreas.count > 0 {
                            allAreas[String(city_id)] = area_s
                            self.session.set(allAreas, forKey: "areas")
                        } else {
                            self.session.set(city_s, forKey: "areas")
                        }
                        res[String(city_id)] = area_s
                    }
                    completion1(res)
                    
                    Global.instance.removeSpinner(superView: self.view)
                }
            }
        }
        return rows
    }
    
    func getAreaByAreaID(_ area_id: Int) -> [String: String] {
        let area = self.session.getAreaByAreaID(area_id)
        
        return area
    }
    
    func multiSelected(key: String, selecteds: [String]) {}
    func singleSelected(key: String, selected: String, show: String?=nil) {}
    func selectedManagers(selecteds: [String]) {}
    func dateSelected(key: String, selected: String) {}
    func checkboxValueChanged(checked: Bool) {}
    func sexValueChanged(sex: String) {}
    
    func alertError(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "確定", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func __alert(showCloseButton: Bool=false, buttonTitle: String, buttonAction: @escaping ()->Void) -> SCLAlertView {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: showCloseButton
        )
        let alert = SCLAlertView(appearance: appearance)
        alert.addButton(buttonTitle, action: buttonAction)
        return alert
    }
    
    func __alert()-> SCLAlertView {
        
        let appearance = SCLAlertView.SCLAppearance()
        let alert = SCLAlertView(appearance: appearance)
        return alert
    }
    
    func _warning(title: String, msg: String, showCloseButton: Bool=false, buttonTitle: String, buttonAction: @escaping ()->Void) {
        let alert = __alert(showCloseButton: showCloseButton, buttonTitle: buttonTitle, buttonAction: buttonAction)
        alert.showWarning(title, subTitle: msg)
    }
    
    func _warning(title: String, msg: String, closeButtonTitle: String, buttonTitle: String, buttonAction: @escaping ()->Void) {
        let alert = __alert(showCloseButton: true, buttonTitle: buttonTitle, buttonAction: buttonAction)
        alert.showWarning(title, subTitle: msg, closeButtonTitle: closeButtonTitle)
    }
    
    func _warning(msg: String) {
        let alert = __alert()
        alert.showWarning("警告", subTitle: msg)
    }
    
    func warning(_ msg: String) {
        _warning(msg: msg)
    }
    
    func warning(msg: String, showCloseButton: Bool=false, buttonTitle: String, buttonAction: @escaping ()->Void) {
        _warning(title: "警告", msg: msg, showCloseButton: showCloseButton, buttonTitle: buttonTitle, buttonAction: buttonAction)
    }
    func warning(msg: String, closeButtonTitle: String, buttonTitle: String, buttonAction: @escaping ()->Void) {
        _warning(title: "警告", msg: msg, closeButtonTitle: closeButtonTitle, buttonTitle: buttonTitle, buttonAction: buttonAction)
    }
    
    func _info(title: String, msg: String, showCloseButton: Bool=false, buttonTitle: String, buttonAction: @escaping ()->Void) {
        let alert = __alert(showCloseButton: showCloseButton, buttonTitle: buttonTitle, buttonAction: buttonAction)
        alert.showInfo(title, subTitle: msg)
    }
    func _info(title: String, msg: String, closeButtonTitle: String, buttonTitle: String, buttonAction: @escaping ()->Void) {
        let alert = __alert(showCloseButton: true, buttonTitle: buttonTitle, buttonAction: buttonAction)
        alert.showInfo(title, subTitle: msg, closeButtonTitle: closeButtonTitle)
    }
    
    func _info(msg: String) {
        let alert = __alert()
        alert.showInfo("訊息", subTitle: msg)
    }
    
    func info(msg: String, showCloseButton: Bool=false, buttonTitle: String, buttonAction: @escaping ()->Void) {
        _info(title: "訊息", msg: msg, showCloseButton: showCloseButton, buttonTitle: buttonTitle, buttonAction: buttonAction)
    }
    func info(msg: String, closeButtonTitle: String, buttonTitle: String, buttonAction: @escaping ()->Void) {
        _info(title: "訊息", msg: msg, closeButtonTitle: closeButtonTitle, buttonTitle: buttonTitle, buttonAction: buttonAction)
    }
    func info(_ msg: String) {
        _info(msg: msg)
    }
}

