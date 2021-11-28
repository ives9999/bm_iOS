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
import CryptoSwift

class BaseViewController: UIViewController, List2CellDelegate {
    
    
    //var baseVC: BaseViewController
    
//    var baseVC: BaseViewController {
//        return self
//    }
    
    @IBOutlet weak var topView: UIView!
    //@IBOutlet weak var searchBtn: UIButton!
    
    //出現在topView的按鈕
    let shoppingCartBtn: UIButton = UIButton()
    let searchBtn: UIButton = UIButton()
    let addBtn: UIButton = UIButton()
    
    var cartItemCount: Int = 0
    
    var msg: String = ""
    var dataService: DataService = DataService()
    //var managerLists: [SuperData] = [SuperData]()
    var refreshControl: UIRefreshControl!
    let titleBarHeight: CGFloat = 80
    var workAreaHeight: CGFloat = 600
    
    let session: UserDefaults = UserDefaults.standard
    
    //layer
    var maskView = UIView()
    var blackView = UIView()
    var stackView = UIStackView()
    var panelLeftPadding: CGFloat = 50
    var panelTopPadding: CGFloat = 30
    var panelHeight: CGFloat = 400
    
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
    
    let body_css = "<style>body{background-color:#000;padding-left:8px;padding-right:8px;margin-top:0;padding-top:0;color:#888888;font-size:18px;}a{color:#a6d903;}</style>"
    
    var searchPanel: SearchPanel = SearchPanel()
//    var searchSections: [SearchSection] = [SearchSection]()
    var oneSections: [OneSection] = [OneSection]()
    var params: [String: String] = [String: String]()
    var jsonData: Data? = nil
    
    var able_type: String = "coach"
    
    //TimeSelectDelegate
    //func setTimeData(res: [String], type: SELECT_TIME_TYPE, indexPath: IndexPath?){}
    //ArenaSelectDelegate
    //func setArenaData(res: [ArenaTable]){}
    //DegreeSelectDelegate
    //func setDegreeData(res: [DEGREE]){}
    //EditCellDeldgate
    //func setTextField(key: String, value: String) {}
    //func setSwitch(indexPath: IndexPath, value: Bool) {}
    //func clear(indexPath: IndexPath) {}
    //ContentEditDelegate
    //func setContent(key: String, content: String) {}
    
    //for tag delegate
    //func setTag(sectionKey: String, rowKey: String, attribute: String, selected: Bool){}
    //for NumberCell delegate
    //func stepperValueChanged(sectionKey: String, rowKey: String, number: Int){}
    //for TextFieldCell delegate
    //func textFieldDidChange(sectionIdx: Int, rowIdx: Int, str: String){}
    //for RadioCell delegate
    //func radioDidChange(sectionKey: String, rowKey: String, checked: Bool){}
    
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
        let val: String = (isSwitch) ? "1" : "0"
        row.value = val
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
    
//    var wheels: Int = 0
//    required init() {}
//    init(wheels: Int) {
//        self.wheels = wheels
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //setStatusBar(color: UIColor(STATUS_GREEN))
        workAreaHeight = view.bounds.height - titleBarHeight
        searchBtn.visibility = .invisible
        addBtn.visibility = .invisible
        
        //panelCancelBtn.setTitle("取消")
        //layerDeleteBtn.setTitle("刪除")
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
    
    @objc func cartPressed() {
        toMemberCartList()
    }
    
    func addSearchBtn() {
        
        topView.addSubview(searchBtn)
        searchBtn.setImage(UIImage(named: "search1"), for: .normal)
        
        searchBtn.translatesAutoresizingMaskIntoConstraints = false
        searchBtn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        searchBtn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        searchBtn.centerYAnchor.constraint(equalTo: searchBtn.superview!.centerYAnchor).isActive = true
        searchBtn.trailingAnchor.constraint(equalTo: searchBtn.superview!.trailingAnchor, constant: -14).isActive = true
        
        searchBtn.addTarget(self, action: #selector(searchPressed), for: .touchUpInside)
    }
    
    @objc func searchPressed() {
        searchPanel.showSearchPanel(baseVC: self, view: view, newY: 0, oneSections: oneSections)
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
    
    @objc func addPressed() {}
    
    func moreClickForOne(key: String, row: OneRow, delegate: BaseViewController) {
        
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
            //let selecteds: [Int] = valueToArray(t: Int.self, value: row.value)
            
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
            
            
            toSelectWeekday(key: key, selecteds: selecteds, delegate: self)
        } else if (key == START_TIME_KEY || key == END_TIME_KEY) {
            toSelectTime(key: key, selected: row.value, delegate: self)
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
        } else if (key == START_DATE_KEY || key == END_DATE_KEY) {
            toSelectDate(key: key, selected: row.value)
        } else if (key == CONTENT_KEY || key == CHARGE_KEY) {
            toEditContent(key: key, title: row.title, content: row.value, _delegate: self)
        } else if (key == MANAGER_ID_KEY) {
            toSelectManager(manager_id: Int(row.value)!, manager_token: row.token, delegate: self)
        }
    }
    
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
    
//    func mask(y: CGFloat, superView: UIView? = nil, height: CGFloat? = nil) {
//        maskView.backgroundColor = UIColor(white: 1, alpha: 0.8)
//        maskView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(unmask)))
//        var _view = view
//        if superView != nil {
//            _view = superView
//        }
//        _view?.addSubview(maskView)
//        
//        var _height = view.bounds.height - titleBarHeight
//        if height != nil {
//            _height = height!
//        }
//        maskView.frame = CGRect(x: 0, y: y, width: (_view?.frame.width)!, height: _height)
//        maskView.alpha = 0
//    }
    
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
//    @objc func unmask(){}
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
    
//    @objc func memberDidChange(_ notif: Notification) {
//        //print("notify")
//        refreshMember { (success) in
//
//        }
//    }
//    func _getMemberOne(token: String, completion: @escaping CompletionHandler) {
//        MemberService.instance.getOne(token: token, completion: completion)
//    }
//    func refreshMember(completion: @escaping CompletionHandler) {
//        Global.instance.addSpinner(superView: self.view)
//        MemberService.instance.getOne(token: Member.instance.token) { (success) in
//            Global.instance.removeSpinner(superView: self.view)
//            if (success) {
//                completion(true)
//            } else {
//                SCLAlertView().showWarning("警告", subTitle: MemberService.instance.msg)
//                completion(false)
//            }
//        }
//    }
    
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
    
//    func _updatePlayerIDWhenIsNull() {
//        let token = Member.instance.token
//        //print(token)
//        MemberService.instance.getOne(token: token) { (success) in
//            if (success) {
//                Member.instance.justGetMemberOne = true
//                //print(Member.instance.type)
//                if Member.instance.player_id.count == 0 {
//                    self._updatePlayerID()
//                }
//            }
//        }
//    }
//    func _updatePlayerID() {
//        var player_id = _getPlayerID()
//        //print(player_id)
//        MemberService.instance.update(id: Member.instance.id, field: PLAYERID_KEY, value: &player_id, completion: { (success) in
//            if success {
//                Member.instance.player_id = player_id
//            }
//        })
//    }
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
//    func getCitys(completion1: @escaping (_ rows: [[String: String]]) -> Void) -> [[String: String]] {
//
//        //session.removeObject(forKey: "citys")
//        let rows = session.getArrayDictionary("citys")
//        if rows.count == 0 {
//            Global.instance.addSpinner(superView: view)
//            DataService.instance1.getCitys() { (success) in
//                if success {
//                    let rows = DataService.instance1.citys
//                    //print(rows)
//                    var citys = [[String: String]]()
//                    for row in rows { // row is City object
//                        citys.append(["name": row.name, "id": String(row.id)])
//                    }
//                    self.session.set(citys, forKey: "citys")
//                    //self.tableView.reloadData()
//                    completion1(citys)
//                }
//                Global.instance.removeSpinner(superView: self.view)
//            }
//        }
//        return rows
//    }
    
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
//    func getAreasFromCity(_ city_id: Int, completion1: @escaping (_ rows: [[String: String]]) -> Void) -> [[String: String]] {
//        
//        //session.removeObject(forKey: "areas")
//        let rows = session.getAreasByCity(city_id)
//        //print(rows)
//        if rows.count == 0 {
//            //let city_ids: [Int] = [city_id]
//            Global.instance.addSpinner(superView: view)
//            DataService.instance1.getAreaByCityIDs(city_ids: "",city_type: "") { (success) in
//                if success {
//                    
//                    let city = DataService.instance1.citysandareas
//                    var city_name = ""
//                    if city[city_id] != nil {
//                        city_name = city[city_id]!["name"] as! String
//                    }
//                    
//                    var areas: [[String: String]] = [[String: String]]()
//                    for row in (city[city_id]!["rows"] as! Array<[String: Any]>) {
//                        var area_id: String = ""
//                        var area_name: String = ""
//                        for (key, value) in row {
//                            if key == "id" {
//                                area_id = String(value as! Int)
//                            }
//                            if key == "name" {
//                                area_name = value as! String
//                            }
//                        }
//                        if area_id.count > 0 && area_name.count > 0 {
//                            areas.append(["id":area_id,"name":area_name])
//                        }
//                    }
//                    //print(areas)
//                    let area_s: [String: Any] = ["id": String(city_id), "name": city_name, "rows": areas]
//                    let city_s: [String: [String: Any]] = [String(city_id): area_s]
//                    
//                    var allAreas: [String: [String: Any]] = self.session.getAllAreas()
//                    if allAreas.count > 0 {
//                        allAreas[String(city_id)] = area_s
//                        self.session.set(allAreas, forKey: "areas")
//                    } else {
//                        self.session.set(city_s, forKey: "areas")
//                    }
//                    completion1(areas)
//                    
//                    Global.instance.removeSpinner(superView: self.view)
//                }
//            }
//        }
//        return rows
//    }
    
//    func getAreasFromCitys(_ city_ids: [Int], completion1: @escaping (_ rows: [String: [String: Any]]) -> Void) -> [String: [String: Any]] {
//        
//        //session.removeObject(forKey: "areas")
//        let rows = session.getAreasByCitys(city_ids)
//        let citys1: String = Global.instance.intsToStringComma(city_ids)
//        //print(rows)
//        if rows.count < city_ids.count {
//            //let city_ids: [Int] = [city_id]
//            Global.instance.addSpinner(superView: view)
//            DataService.instance1.getAreaByCityIDs(city_ids: citys1,city_type: "") { (success) in
//                if success {
//                    
//                    var res: [String: [String: Any]] = [String: [String: Any]]()
//                    let city = DataService.instance1.citysandareas
//                    for (city_id, _) in city {
//                        var city_name = ""
//                        if city[city_id] != nil {
//                            city_name = city[city_id]!["name"] as! String
//                        }
//                        
//                        var areas: [[String: String]] = [[String: String]]()
//                        for row in (city[city_id]!["rows"] as! Array<[String: Any]>) {
//                            var area_id: String = ""
//                            var area_name: String = ""
//                            for (key, value) in row {
//                                if key == "id" {
//                                    area_id = String(value as! Int)
//                                }
//                                if key == "name" {
//                                    area_name = value as! String
//                                }
//                            }
//                            if area_id.count > 0 && area_name.count > 0 {
//                                areas.append(["id":area_id,"name":area_name])
//                            }
//                        }
//                        //print(areas)
//                        let area_s: [String: Any] = ["id": String(city_id), "name": city_name, "rows": areas]
//                        let city_s: [String: [String: Any]] = [String(city_id): area_s]
//                        
//                        var allAreas: [String: [String: Any]] = self.session.getAllAreas()
//                        if allAreas.count > 0 {
//                            allAreas[String(city_id)] = area_s
//                            self.session.set(allAreas, forKey: "areas")
//                        } else {
//                            self.session.set(city_s, forKey: "areas")
//                        }
//                        res[String(city_id)] = area_s
//                    }
//                    completion1(res)
//                    
//                    Global.instance.removeSpinner(superView: self.view)
//                }
//            }
//        }
//        return rows
//    }
    
    func getAreaByAreaID(_ area_id: Int) -> [String: String] {
        let area = self.session.getAreaByAreaID(area_id)
        
        return area
    }
    
    func multiSelected(key: String, selecteds: [String]) {}
    
    func singleSelected(key: String, selected: String, show: String?=nil) {
        
        if searchPanel.baseVC != nil {
            searchPanel.singleSelected(key: key, selected: selected, show: show)
        } else {
            let row = getOneRowFromKey(key)
            row.value = selected
            var _show = ""
            if key == START_TIME_KEY || key == END_TIME_KEY {
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
    
    //WeekdaysSelectDelegate
    func setWeekdaysData(selecteds: [Int]) {
        if searchPanel.baseVC != nil {
            searchPanel.setWeekdaysData(selecteds: selecteds)
        } else {
            let row = getOneRowFromKey(WEEKDAY_KEY)
            var texts: [String] = [String]()
            var value: Int = 0
            if selecteds.count > 0 {
                for day in selecteds {
                    value += (pow(2, day) as NSDecimalNumber).intValue
                    for gday in Global.instance.weekdays {
                        if day == gday["value"] as! Int {
                            let text = gday["simple_text"]
                            texts.append(text! as! String)
                            break
                        }
                    }
                }
                row.show = texts.joined(separator: ",")
                row.value = String(value)
            } else {
                row.show = "全部"
            }
        }
    }
    
    func selectedManager(selected: Int, show: String, token: String) {
        let row = getOneRowFromKey(MANAGER_ID_KEY)
        row.value = String(selected)
        row.show = show
        row.token = token
    }
    
    func dateSelected(key: String, selected: String) {
        
        let row = getOneRowFromKey(key)
        row.value = selected
        row.show = selected
    }
    func checkboxValueChanged(checked: Bool) {}
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
    
    func setContent(key: String, content: String) {
        let row = getOneRowFromKey(key)
        row.value = content
        row.show = content
    }
    
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

