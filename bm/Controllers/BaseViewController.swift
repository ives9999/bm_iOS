//
//  BaseViewController.swift
//  bm
//
//  Created by ives on 2018/4/3.
//  Copyright © 2018年 bm. All rights reserved.
//

import UIKit
import OneSignal
import WebKit
import SCLAlertView
import CryptoSwift

class BaseViewController: UIViewController, List2CellDelegate {
    
    
    //var baseVC: BaseViewController
    
//    var baseVC: BaseViewController {
//        return self
//    }
    
    @IBOutlet weak var top: Top!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomThreeView: BottomThreeView!
    //@IBOutlet weak var searchBtn: UIButton!
    
    //出現在topView的按鈕
    let shoppingCartBtn: UIButton = UIButton()
    let searchBtn: UIButton = UIButton()
    let addBtn: UIButton = UIButton()
    
    var cartItemCount: Int = 0
    
    var msg: String = ""
    var myError: MYERROR = MYERROR.NOERROR
    var dataService: DataService = DataService()
    //var managerLists: [SuperData] = [SuperData]()
    var refreshControl: UIRefreshControl!
    let titleBarHeight: CGFloat = 80
    var workAreaHeight: CGFloat = 600
    
    let session: UserDefaults = UserDefaults.standard
    
    var page: Int = 1
    var perPage: Int = PERPAGE
    var totalCount: Int = 100000
    var totalPage: Int = 1
    
    //layer
    var maskView = UIView()
    var blackView = UIView()
    var stackView = UIStackView()
    var bottomView1 = UIView()
    var panelLeftPadding: CGFloat = 50
    var panelTopPadding: CGFloat = 30
    var panelHeight: CGFloat = 400
    var rowHeight: Int = 44
    
    var containerView = UIView(frame: .zero)
    
    var panelSubmitBtn: SubmitButton = SubmitButton()
    var panelCancelBtn: CancelButton = CancelButton()
    
    var layerDeleteBtn: ClearButton = ClearButton()
    var layerBtnCount: Int = 2
    
    //var staticButtomView: StaticBottomView?
    
    //loading
    var isLoading: Bool = false
    var loadingMask: UIView?
    var loadingSpinner: UIActivityIndicatorView?
    var loadingText: UILabel?
    
    var isNetworkExist: Bool = false
    
    let body_css = "<style>body{background-color:#000;padding-left:8px;padding-right:8px;margin-top:0;padding-top:0;color:#888888;font-size:20px;line-height:30px;}a{color:#a6d903;}img{width:400px;}</style>"
    
    var searchPanel: SearchPanel = SearchPanel()
//    var searchSections: [SearchSection] = [SearchSection]()
    var oneSections: [OneSection] = [OneSection]()
    var params: [String: String] = [String: String]()
    var jsonData: Data? = nil
    
    var able_type: String = "coach"
    
    var screen_width: CGFloat = 0
    
    var popupTableView: UITableView = {
        let cv = UITableView(frame: .zero, style: .plain)
        cv.estimatedRowHeight = 44
        cv.rowHeight = UITableView.automaticDimension
        
        cv.separatorStyle = .singleLine
        cv.separatorColor = UIColor.lightGray
        
        return cv
    }()
    
    func __alert(showCloseButton: Bool=false, buttonTitle: String, buttonAction: @escaping ()->Void) -> SCLAlertView {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: showCloseButton
        )
        let alert = SCLAlertView(appearance: appearance)
        alert.addButton(buttonTitle, action: buttonAction)
        return alert
    }
    
    func __alert()-> SCLAlertView {
        
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alert = SCLAlertView(appearance: appearance)
        
        alert.addButton("關閉", backgroundColor: UIColor(MY_GRAY), textColor: UIColor(MY_WHITE)) {
            alert.hideView()
        }
        
        return alert
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

    func _getPlayerID() -> String {
        
        var playerID: String = ""
        let deviceState = OneSignal.getDeviceState()
        //let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
        
        if let temp: String = deviceState?.userId {
            playerID = temp
        }
        //print(playerID)
        //if userID != nil {
        //let user = PFUser.cu
        //}
        return playerID
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
    
    func addAddBtn() {
        
        topView.addSubview(addBtn)
        addBtn.setImage(UIImage(named: "add"), for: .normal)
        
        var trailing: CGFloat = -50
        if (shoppingCartBtn.visibility == .invisible) {
            //print(searchBtn.visibility)
            trailing = -14
        }
        
        addBtn.translatesAutoresizingMaskIntoConstraints = false
        addBtn.widthAnchor.constraint(equalToConstant: 45).isActive = true
        addBtn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        addBtn.centerYAnchor.constraint(equalTo: searchBtn.superview!.centerYAnchor).isActive = true
        addBtn.trailingAnchor.constraint(equalTo: searchBtn.superview!.trailingAnchor, constant: trailing).isActive = true
        
        addBtn.addTarget(self, action: #selector(addPressed), for: .touchUpInside)
    }
    
    func addBlackList(memberName: String, memberToken: String, teamToken: String) {
        warning(msg:"是否真的要將球友"+memberName+"設為黑名單\n之後可以解除", closeButtonTitle: "取消", buttonTitle: "確定", buttonAction: {
            self.reasonBox(memberToken: memberToken, teamToken: teamToken)
        })
    }
    
    func addPanelBtn() {
        panelCancelBtn = bottomView1.addCancelBtn()
        //panelSubmitBtn = stackView.addSubmitBtn()
        panelCancelBtn.addTarget(self, action: #selector(panelCancelAction), for: .touchUpInside)
    }
    
    @objc func addPressed() {}

    func addSearchBtn() {
        
        //search default is hidden set in viewDidLoad
        topView.addSubview(searchBtn)
        searchBtn.setImage(UIImage(named: "search1"), for: .normal)
        
        searchBtn.translatesAutoresizingMaskIntoConstraints = false
        searchBtn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        searchBtn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        searchBtn.centerYAnchor.constraint(equalTo: searchBtn.superview!.centerYAnchor).isActive = true
        searchBtn.trailingAnchor.constraint(equalTo: searchBtn.superview!.trailingAnchor, constant: -14).isActive = true
        
        searchBtn.addTarget(self, action: #selector(searchPressed), for: .touchUpInside)
    }
    
    func addShoppingCartBtn() {
        
        topView.addSubview(shoppingCartBtn)
        shoppingCartBtn.setImage(UIImage(named: "cart1"), for: .normal)
        
        var trailing: CGFloat = -50
        if (searchBtn.visibility == .invisible) {
            //print(searchBtn.visibility)
            trailing = -14
        }
        
        shoppingCartBtn.translatesAutoresizingMaskIntoConstraints = false
        shoppingCartBtn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        shoppingCartBtn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        shoppingCartBtn.centerYAnchor.constraint(equalTo: shoppingCartBtn.superview!.centerYAnchor).isActive = true
        shoppingCartBtn.trailingAnchor.constraint(equalTo: shoppingCartBtn.superview!.trailingAnchor, constant: trailing).isActive = true
        
        shoppingCartBtn.addTarget(self, action: #selector(cartPressed), for: .touchUpInside)
    }
    
    func alertError(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "確定", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func beginRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "更新資料")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
    }
    
    func cancel() {}

    @objc func cartPressed() {
        toMemberCartList()
    }
    
    func cellCity(row: Table) {
        let key: String = CITY_KEY
        let city_id: Int = row.city_id
        let row = getOneRowFromKey(key)
        row.value = String(city_id)
        //replaceRows(key, row)
        prepareParams()
        refresh()
    }
    
    //must implement for every class
    func cellArea(row: Table) {}
    func cellArena(row: Table) {}
    
    //用這個函式來打行動電話或市內電話，因為icon只有一個
    func cellMobile(row: Table) {
        if (row.mobile_show.count > 0) {
            //print(row.mobile)
            row.mobile.makeCall()
        } else if (row.tel_show.count > 0) {
            row.tel.makeCall()
        }
    }
    
    func cellSignup(row: Table) {}
    func cellTeamMember(row: Table) {}
    
    //暫時沒有作用
    func cellTel(row: Table) {
        if (row.tel_show.count > 0) {
            //print(row.tel)
            row.tel.makeCall()
        }
    }
    
    func cellSexChanged(key: String, sectionIdx: Int, rowIdx: Int, sex: String) {}
    func cellTextChanged(sectionIdx: Int, rowIdx: Int, str: String) {
        let row: OneRow = getOneRowFromIdx(sectionIdx, rowIdx)
        row.value = str
        row.show = str
    }
    func cellPrivacyChanged(sectionIdx: Int, rowIdx: Int, checked: Bool) {}
    func cellSetTag(sectionIdx: Int, rowIdx: Int, value: String, isChecked: Bool) {}
    func cellNumberChanged(sectionIdx: Int, rowIdx: Int, number: Int) {}
    func cellRadioChanged(key: String, sectionIdx: Int, rowIdx: Int, isChecked: Bool) {}
    
    func cellClear(sectionIdx: Int, rowIdx: Int) {
//        if searchSections.count > sectionIdx && searchSections[sectionIdx].items.count > rowIdx {
//            let row: SearchRow = getSearchRowFromIdx(sectionIdx, rowIdx)
//            if (row.key == CITY_KEY) {
//                var row1: SearchRow = getSearchRowFromKey(AREA_KEY)
//                row1.value = ""
//                row1.show = "全部"
//                row1 = getSearchRowFromKey(ARENA_KEY)
//                row1.value = ""
//                row1.show = "全部"
//            }
//            row.value = ""
//            row.show = ""
//        }
        
        if oneSections.count > sectionIdx && oneSections[sectionIdx].items.count > rowIdx {
            let row: OneRow = getOneRowFromIdx(sectionIdx, rowIdx)
            if (row.key == CITY_KEY) {
                var row1: OneRow = getOneRowFromKey(AREA_KEY)
                row1.value = ""
                row1.show = "全部"
                row1 = getOneRowFromKey(ARENA_KEY)
                row1.value = ""
                row1.show = "全部"
            }
            row.value = ""
            row.show = ""
        }
    }
    
    func cellSwitchChanged(key: String, sectionIdx: Int, rowIdx: Int, isSwitch: Bool) {
        
        let row = oneSections[sectionIdx].items[rowIdx]
        if key == ARENA_PARKING_KEY || key == ARENA_BATHROOM_KEY || key == ARENA_AIR_CONDITION_KEY {
            let val: String = (isSwitch) ? "1" : "0"
            row.value = val
        } else {
            let val: String = (isSwitch) ? "online": "offline"
            row.value = val
            row.show = STATUS(status: val).rawValue
        }
    }
    
    func cellMap(row: Table) {
        
        var name: String = ""
        if row.name.count > 0 {
            name = row.name
        } else if row.title.count > 0 {
            name = row.title
        }
        //print(row.address)
        _showMap(title: name, address: row.address)
    }
    
    func cellLike(row: Table) {
        if (!Member.instance.isLoggedIn) {
            toLogin()
        } else {
            dataService.like(token: row.token, able_id: row.id)
        }
    }
    
    func cellEdit(row: Table){}
    
    func cellDelete(row: Table){}
    
    func cellMoreClick(key: String, row: OneRow, delegate: BaseViewController) {
        
        if (key == CITY_KEY) {
            toSelectCity(key: CITY_KEY, selected: row.value, delegate: self)
        } else if (key == AREA_KEY) {
            let row1: OneRow = getOneRowFromKey(CITY_KEY)
            var city_id: Int = 0
            
            if (row1.value.count > 0) {
                if let tmp: Int = Int(row1.value) {
                    city_id = tmp
                }
            }
            if (city_id <= 0) {
                warning("請先選擇縣市")
            } else {
                toSelectArea(key: key, city_id: city_id, selected: row.value, delegate: self)
            }
        } else if (key == WEEKDAY_KEY) {
            var selecteds: [Int] = [Int]()
            if row.value.count > 0 {
                var i: Int = 0
                while (i < 7) {
                    let n = (pow(2, i) as NSDecimalNumber).intValue
                    if Int(row.value)! & n > 0 {
                        selecteds.append(i)
                    }
                    i += 1
                }
            }
                        
            //toSelectWeekday(key: key, selecteds: selecteds, delegate: self)
        } else if (key == WEEKDAYS_KEY) {
            var selecteds: Int = 0

            if row.value.count > 0 {
                var i: Int = 1
                while (i <= 7) {
                    let n = (pow(2, i) as NSDecimalNumber).intValue
                    if Int(row.value)! & n > 0 {
                        selecteds = selecteds | n
                    }
                    i += 1
                }
            }
            
            toSelectWeekdays(key: key, selecteds: selecteds, delegate: self)
        } else if (key == START_TIME_KEY || key == END_TIME_KEY || key == TEAM_PLAY_START_KEY || key == TEAM_PLAY_END_KEY) {
            toSelectTime(key: key, selected: row.value, delegate: self)
        } else if (key == AREA_KEY) {
            let row1: OneRow = getOneRowFromKey(CITY_KEY)
            var city_id: Int = 0
            
            if (row1.value.count > 0) {
                if let tmp: Int = Int(row1.value) {
                    city_id = tmp
                }
            }
            if (city_id <= 0) {
                warning("請先選擇縣市")
            } else {
                toSelectArea(key: key, city_id: city_id, selected: row.value, delegate: self)
            }
        } else if (key == ARENA_KEY) {
            let row1: OneRow = getOneRowFromKey(CITY_KEY)
            var city_id: Int = 0
            
            if (row1.value.count > 0) {
                if let tmp: Int = Int(row1.value) {
                    city_id = tmp
                }
            }
            if (city_id <= 0) {
                warning("請先選擇縣市")
            } else {
                toSelectArena(key: key, city_id: city_id, selected: row.value, delegate: self)
            }
        } else if (key == DEGREE_KEY) {
            let tmps: [String] = valueToArray(t: String.self, value: row.value)
            var selecteds: [DEGREE] = [DEGREE]()
            for tmp in tmps {
                selecteds.append(DEGREE.enumFromString(string: tmp))
            }
            toSelectDegree(selecteds: selecteds, delegate: self)
        } else if (key == PRICE_UNIT_KEY || key == COURSE_KIND_KEY || key == CYCLE_UNIT_KEY) {
            toSelectSingle(key: key, selected: row.value, delegate: self, able_type: able_type)
        } else if (key == START_DATE_KEY || key == END_DATE_KEY || key == TEAM_TEMP_DATE_KEY) {
            toSelectDate(key: key, selected: row.value)
        } else if (key == CONTENT_KEY || key == CHARGE_KEY || key == TEAM_TEMP_CONTENT_KEY) {
            toEditContent(key: key, title: row.title, content: row.value, _delegate: self)
        } else if (key == MANAGER_ID_KEY) {
            if row.value.count == 0 {
                row.value = "0"
            }
            var value: Int = 0
            if let tmp: Int = Int(row.value) {
                value = tmp
            }
            toSelectManager(manager_id: value, manager_token: row.token, delegate: self)
        }
    }
    
    func cellPrompt(sectionIdx: Int, rowIdx: Int){
        let row: OneRow = getOneRowFromIdx(sectionIdx, rowIdx)
        info(row.prompt)
    }
    
    func cellRefresh() {
        params.removeAll()
        refresh()
    }
    
    func cellWarning(msg: String) {
        warning(msg)
    }
    
    func cellToLogin() {
        toLogin()
    }
    
    func checkboxValueChanged(checked: Bool) {}
    
    func dateSelected(key: String, selected: String) {
        
        let row = getOneRowFromKey(key)
        row.value = selected
        row.show = selected
    }
    
    func endRefresh() {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
    
    func didSelect<U>(item: U, at indexPath: IndexPath) {
        //print(item.title + "\(indexPath.row)")
    }
    
    func genericTable() {}
    
    func getAreaByAreaID(_ area_id: Int) -> [String: String] {
        let area = self.session.getAreaByAreaID(area_id)
        
        return area
    }
    func getDataEnd(success: Bool) {}
    func getDataStart(token: String? = nil, page: Int=1, perPage: Int=PERPAGE) {}
    
//    var wheels: Int = 0
//    required init() {}
//    init(wheels: Int) {
//        self.wheels = wheels
//    }

    //override var preferredStatusBarStyle: UIStatusBarStyle { UIColor.green }

//    func getRowFromKey<T>(_ key: String)-> T {
//
//    }
    
//    func getSearchRowFromKey(_ key: String)-> SearchRow {
//
//        for section in searchSections {
//            for row in section.items {
//                if (row.key == key ) {
//                    return row
//                }
//            }
//        }
//        return SearchRow()
//    }
//
//    func getSearchRowFromIdx(_ sectionIdx: Int, _ rowIdx: Int) -> SearchRow {
//        return searchSections[sectionIdx].items[rowIdx]
//    }
//
//    func getSearchRowFromIdx(sectionIdx: Int, rowIdx: Int)-> SearchRow {
//        return searchSections[sectionIdx].items[rowIdx]
//    }
    
    func getOneRowFromIdx(_ sectionIdx: Int, _ rowIdx: Int) -> OneRow {
        return oneSections[sectionIdx].items[rowIdx]
    }
    
    func getOneRowFromKey(_ key: String)-> OneRow {

        for section in oneSections {
            for row in section.items {
                if (row.key == key ) {
                    return row
                }
            }
        }
        return OneRow()
    }
    
    func getOneRowValue(_ rowKey: String)-> String {
        let row = getOneRowFromKey(rowKey)
        return row.value
    }
    
    func getOneRowsFromSectionKey(_ sectionKey: String)-> [OneRow] {
        for section in oneSections {
            if (section.key == sectionKey) {
                return section.items
            }
        }
        
        return [OneRow]()
    }
    
    func getOneSectionFromKey(_ key: String)-> OneSection {
        for oneSection in oneSections {
            if (key == oneSection.key) {
                return oneSection
            }
        }
        
        return OneSection()
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

    func info(msg: String, showCloseButton: Bool=false, buttonTitle: String, buttonAction: @escaping ()->Void) {
        _info(title: "訊息", msg: msg, showCloseButton: showCloseButton, buttonTitle: buttonTitle, buttonAction: buttonAction)
    }
    
    func info(msg: String, closeButtonTitle: String, buttonTitle: String, buttonAction: @escaping ()->Void) {
        _info(title: "訊息", msg: msg, closeButtonTitle: closeButtonTitle, buttonTitle: buttonTitle, buttonAction: buttonAction)
    }
    
    func info(_ msg: String) {
        _info(msg: msg)
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
    
    func makeCalendar(_ _y:Int?, _ _m:Int?)->[String: Any] {
        
        let y: Int = (_y == nil) ? Date().getY() : _y!
        let m: Int = (_m == nil) ? Date().getm() : _m!
        var res: [String: Any] = [String: Any]()
        //取得該月1號的星期幾，日曆才知道從星期幾開始顯示
        let weekday01 = "\(y)-\(m)-01"
        res["weekday01"] = weekday01
        
        var beginWeekday = weekday01.toDateTime(format: "yyyy-MM-dd")!.dateToWeekday()
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
        
        let endWeekday = weekday31.toDateTime(format: "yyyy-MM-dd")!.dateToWeekday()
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

    func multiSelected(key: String, selecteds: [String]) {}
    
    @objc func panelCancelAction(){
        unmask()
    }
    
    func prepareParams(city_type: String="simple") {}
    
    func prev() {
        dismiss(animated: true, completion: nil)
    }

    func reasonBox(memberToken: String, teamToken: String) {
        let alert = SCLAlertView()
        let txt = alert.addTextField()
        alert.addButton("加入", action: {
            self._addBlackList(txt.text!, memberToken: memberToken, teamToken: teamToken)
        })
        alert.showEdit("請輸入理由", subTitle: "")
    }
    
    @objc func refresh() {}
    
    
    func registerPanelCell() {
        let plainNib = UINib(nibName: "PlainCell", bundle: nil)
        popupTableView.register(plainNib, forCellReuseIdentifier: "PlainCell")
    }

    
    func showTableLayer(tableViewHeight: Int) {
        
        maskView = view.mask()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(unmask))
        //gesture.cancelsTouchesInView = false
        maskView.addGestureRecognizer(gesture)
        
        let top: CGFloat = (maskView.frame.height-panelHeight)/2
        
        let layerButtonLayoutHeight: Int = setButtonLayoutHeight()
        let blackViewHeight: CGFloat = CGFloat(tableViewHeight + layerButtonLayoutHeight)
        
        blackView = maskView.blackView(left: panelLeftPadding, top: top, width: maskView.frame.width-2*panelLeftPadding, height: blackViewHeight)
        
        popupTableView.frame = CGRect(x: 0, y: 0, width: Int(blackView.frame.width), height: tableViewHeight)
        //popupTableView.dataSource = self
        //popupTableView.delegate = self
        
        popupTableView.backgroundColor = .clear
        
        blackView.addSubview(popupTableView)
        
        registerPanelCell()
        
        bottomView1 = blackView.addBottomView(height: CGFloat(setButtonLayoutHeight()))
        //stackView = blackView.addStackView(height: CGFloat(setButtonLayoutHeight()))
        
        addPanelBtn()
    }

    @objc func searchPressed() {
        if searchPanel.searchPanelisHidden {
            searchPanel.showSearchPanel(baseVC: self, view: view, newY: 0, oneSections: oneSections)
        } else {
            searchPanel.unmask()
        }
    }

    func selectedManager(selected: Int, show: String, token: String) {
        let row = getOneRowFromKey(MANAGER_ID_KEY)
        row.value = String(selected)
        row.show = show
        row.token = token
    }

    func sexValueChanged(sex: String) {}
    
    func setDegrees(res: [DEGREE]) {
        let row = getOneRowFromKey(DEGREE_KEY)
        var names: [String] = [String]()
        var values: [String] = [String]()
        if res.count > 0 {
            for degree in res {
                names.append(degree.rawValue)
                values.append(DEGREE.DBValue(degree))
            }
            row.show = names.joined(separator: ",")
            row.value = values.joined(separator: ",")
        } else {
            row.show = "全部"
            row.value = ""
        }
        //replaceRows(DEGREE_KEY, row)
        //tableView.reloadData()
    }

    func setBottomTabFocus() {
        
        var idx: Int = 0
        switch (able_type) {
        case "team":
            idx = 0
        case "course":
            idx = 1
        case "member":
            idx = 2
        case "arena":
            idx = 3
        case "more":
            idx = 4
        default:
            idx = 0
        }
        
        if let tmp = tabBarController?.tabBar {
            let bottomTabBar: UITabBar = tmp
            let tabItem: UITabBarItem = bottomTabBar.items![idx]
            tabItem.image = UIImage(named: able_type + "_g")
            //以後準備使用
            //tabItem.badgeValue = "5"
        }
        
    }
    
    func setupBottomThreeView() {
        bottomThreeView.delegate = self
        bottomThreeView.submitButton.setTitle("訂閱")
        bottomThreeView.cancelButton.setTitle("回上一頁")
        bottomThreeView.threeButton.setTitle("退訂")
        bottomThreeView.setBottomButtonPadding(screen_width: screen_width)
    }
    
    func setButtonLayoutHeight()-> Int {
        let buttonViewHeight: Int = 44

        return buttonViewHeight
    }

    func setContent(key: String, content: String) {
        let row = getOneRowFromKey(key)
        row.value = content
        row.show = content
    }
    
    //WeekdaysSelectDelegate
    func setWeekdaysData(selecteds: Int) {
        if searchPanel.baseVC != nil {
            searchPanel.setWeekdaysData(selecteds: selecteds)
        } else {
            let row = getOneRowFromKey(WEEKDAYS_KEY)
            var shows: [String] = [String]()
            if selecteds > 0 {
                var i = 1
                while (i <= 7) {
                    let n: Int = (pow(2, i) as NSDecimalNumber).intValue
                    if selecteds & n > 0 {
                        shows.append(WEEKDAY(weekday: i).toShortString())
                    }
                    i += 1
                }
                
//                for day in selecteds {
//                    value += (pow(2, day) as NSDecimalNumber).intValue
//                    for gday in Global.instance.weekdays {
//                        if day == gday["value"] as! Int {
//                            let text = gday["simple_text"]
//                            texts.append(text! as! String)
//                            break
//                        }
//                    }
//                }
                row.show = shows.joined(separator: ",")
                row.value = String(selecteds)
            } else {
                row.show = ""
            }
        }
    }
    
    func showTableView<T: BaseCell<U, V>, U: Table, V: BaseViewController>(tableView: MyTable2VC<T, U, V>, jsonData: Data)-> [U] {
        
        let b: Bool = tableView.parseJSON(jsonData: jsonData)
        if !b && tableView.msg.count == 0 {
            view.setInfo(info: tableView.msg, topAnchor: top)
        }
        
        return tableView.items
    }
    
    func singleSelected(key: String, selected: String, show: String?=nil) {
        
        if searchPanel.baseVC != nil {
            searchPanel.singleSelected(key: key, selected: selected, show: show)
        } else {
            let row = getOneRowFromKey(key)
            row.value = selected
            var _show = ""
            if key == START_TIME_KEY || key == END_TIME_KEY || key == TEAM_PLAY_START_KEY || key == TEAM_PLAY_END_KEY {
                _show = selected.noSec()
            }
            //在dateSelected
//            else if (key == START_DATE_KEY || key == END_DATE_KEY) {
//                _show = selected
            else if (key == CITY_KEY || key == AREA_KEY) {
                _show = Global.instance.zoneIDToName(Int(selected)!)
            } else if (key == ARENA_KEY) {
                if (show != nil) {
                    _show = show!
                }
            } else if (key == PRICE_UNIT_KEY) {
                _show = PRICE_UNIT.enumFromString(string: row.value).rawValue
            } else if (key == COURSE_KIND_KEY) {
                _show = COURSE_KIND.enumFromString(string: row.value).rawValue
            } else if (key == CYCLE_UNIT_KEY) {
                _show = CYCLE_UNIT.enumFromString(string: row.value).rawValue
            } else if (key == WEEKDAY_KEY) {
//                row.value = String(Global.instance.weekdaysToDBValue(selected))
//
//                var a: [String] = [String]()
//                let weekday_arr = selected.split(separator: ",")
//                for weekday in weekday_arr {
//                    let tmp: String = WEEKDAY.intToString(weekday)
//                    a.append(tmp)
//                }
//                weekdays_show = show.joined(separator: ",")
            }
            
            row.show = _show
            //replaceRows(key, row)
        }
    }
    
    func submit() {}
    func submitBtnPressed() {}
    
    //func tableViewSetSelected(row: Table)-> Bool { return false }
    
    func testNetwork()-> Bool {
        
        var bConnect: Bool = false
        if Connectivity.isConnectedToInternet {
             bConnect = true
        }
        
        return bConnect
    }
    
    func threeBtnPressed() {}

    @objc func unmask() {
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.maskView.frame = CGRect(x:0, y:self.view.frame.height, width:self.view.frame.width, height:self.view.frame.height)
            //self.blackView.frame = CGRect(x:self.panelLeftPadding, y:self.view.frame.height, width:self.view.frame.width-(2*self.panelLeftPadding), height:self.maskView.frame.height-self.panelTopPadding)
        }, completion: { (finished) in
            if finished {
                for view in self.maskView.subviews {
                    view.removeFromSuperview()
                }
                self.maskView.removeFromSuperview()
            }
        })
    }
    
    //存在row的value只是單純的文字，陣列值使用","來區隔，例如"1,2,3"，但當要傳回選擇頁面時，必須轉回陣列[1,2,3]
    func valueToArray<T>(t:T.Type, row: OneRow)-> [T] {

        var selecteds: [T] = [T]()
        //print(t)
        var type: String = "String"
        if (t.self == Int.self) {
            type = "Int"
        }
        if (row.value.count > 0) {
            let values = row.value.components(separatedBy: ",")
            for value in values {
                if (type == "Int") {
                    if let tmp = Int(value) {
                        selecteds.append(tmp as! T)
                    }
                } else {
                    if let tmp = value as? T {
                        selecteds.append(tmp)
                    }
                }
            }
        }

        return selecteds
    }
    
    func valueToArray<T>(t: T.Type, value: String)-> [T] {
        var selecteds: [T] = [T]()
        //print(t)
        var type: String = "String"
        if (t.self == Int.self) {
            type = "Int"
        }
        
        if value.count > 0 {
            let values = value.components(separatedBy: ",")
            for value in values {
                if (type == "Int") {
                    if let tmp = Int(value) {
                        selecteds.append(tmp as! T)
                    }
                } else {
                    if let tmp = value as? T {
                        selecteds.append(tmp)
                    }
                }
            }
        }

        return selecteds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //setNeedsStatusBarAppearanceUpdate()
        let statusBarView = UIView()
        view.addSubview(statusBarView)
        statusBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusBarView.topAnchor.constraint(equalTo: view.topAnchor),
            statusBarView.leftAnchor.constraint(equalTo: view.leftAnchor),
            statusBarView.rightAnchor.constraint(equalTo: view.rightAnchor),
            statusBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        statusBarView.backgroundColor = UIColor(MY_GREEN)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
//        if !Reachability.isConnectedToNetwork(){
//            warning("無法連到網路，請檢查您的網路設定")
//            return
//        }

        //setStatusBar(color: UIColor(STATUS_GREEN))
        workAreaHeight = view.bounds.height - titleBarHeight
        searchBtn.visibility = .invisible
        addBtn.visibility = .invisible
        
        screen_width = UIScreen.main.bounds.width
        
        setBottomTabFocus()
        
        //panelCancelBtn.setTitle("取消")
        //layerDeleteBtn.setTitle("刪除")
    }
    
    override func viewDidAppear(_ animated: Bool) {

        if (!testNetwork()) {
            myError = MYERROR.NONETWORK
            warning(myError.toString())
            return
        }
        
        //當購物車中有商品時，購物車的icon就會出現，如果沒有就不會出現
        //1.AddCartVC中，商品加入購物車時，+1
        //2.MemberCartListVC中，移除購物車中的商品時，-1
        //3.購物車轉成訂單時OrderVC，購物車中的商品數變0
        cartItemCount = session.getInt("cartItemCount")
        shoppingCartBtn.visibility = (Member.instance.isLoggedIn && cartItemCount > 0) ? .visible : .invisible
        
        //show top right button
        if (topView != nil) {
            addSearchBtn()
            addShoppingCartBtn()
            addAddBtn()
        }
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

}

