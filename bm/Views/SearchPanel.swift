//
//  SearchPanel.swift
//  bm
//
//  Created by ives sun on 2021/6/11.
//  Copyright © 2021 bm. All rights reserved.
//

import UIKit

class SearchPanel: UIViewController {
    
    var searchPanelisHidden = true
    
    var searchTableView: UITableView = {
        let cv = UITableView(frame: .zero, style: .plain)
        cv.backgroundColor = UIColor.black
        return cv
    }()
    var maskView = UIView()
    var blackView = UIView()
    let submitBtn: SubmitButton = SubmitButton()
    let cancelBtn: CancelButton = CancelButton()
    let deleteBtn: ClearButton = ClearButton()
    var btnCount: Int = 2
    
    let titleBarHeight: CGFloat = 111
    var layerRightLeftPadding: CGFloat = 20
    var layerTopPadding: CGFloat = 30
    
    //var workAreaHeight: CGFloat = 600
    //let padding: CGFloat = 20
    var layerHeight: CGFloat = 0
    var newY: CGFloat = 0
    
    var myView: UIView? = nil
    var baseVC: BaseViewController? = nil
    
    //var searchRows: [[String: Any]] = [[String: Any]]()
    var searchSections: [SearchSection] = [SearchSection]()
    
    //func showSearchPanel(baseVC: BaseViewController, view: UIView, newY: CGFloat, searchRows: [[String: Any]]) {
    func showSearchPanel(baseVC: BaseViewController, view: UIView, newY: CGFloat, searchSections: [SearchSection]) {
        
        self.myView = view
        self.baseVC = baseVC
        self.newY = 0
        self.searchSections = searchSections
        
        searchPanelisHidden = false
        
        mask(y: titleBarHeight, superView: view)
        
        addBlackView()
        addSearchTableView()
        addSubmitButton()
        addCancelBtn()
        
        //動態結束完的位置
        let frame: CGRect = CGRect(x: layerRightLeftPadding, y: layerTopPadding, width: myView!.frame.width-(2*layerRightLeftPadding), height: maskView.frame.height-layerTopPadding)
        animation(frame: frame)
    }
    
    func animation(frame: CGRect) {
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.blackView.frame = frame
            
        }, completion: nil)
    }
    
    func addBlackView() {
        
        //開始時是在下面
        let frame: CGRect = CGRect(x:layerRightLeftPadding, y:view!.frame.height, width:myView!.frame.width-(2*layerRightLeftPadding), height:maskView.frame.height-layerTopPadding)
        blackView.frame = frame
        blackView.backgroundColor = UIColor.black
        maskView.addSubview(blackView)
        
       //_addLayer()
    }
    
    func addSearchTableView() {
        
        let frame = blackView.frame
        searchTableView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height - 300)
        searchTableView.dataSource = self
        searchTableView.delegate = self
        
        let editCellNib = UINib(nibName: "EditCell", bundle: nil)
        searchTableView.register(editCellNib, forCellReuseIdentifier: "search_cell")
        
        searchTableView.estimatedRowHeight = 44
        searchTableView.rowHeight = UITableView.automaticDimension
        
        searchTableView.separatorStyle = .singleLine
        searchTableView.separatorColor = UIColor.lightGray
        
        searchTableView.backgroundColor = UIColor.clear
        blackView.addSubview(searchTableView)
    }
    
    func addSubmitButton() {
        
        blackView.addSubview(submitBtn)
        
        let c1: NSLayoutConstraint = NSLayoutConstraint(item: submitBtn, attribute: .top, relatedBy: .equal, toItem: searchTableView, attribute: .bottom, multiplier: 1, constant: 12)
        var offset:CGFloat = 0
        if btnCount == 2 {
            offset = -60
        } else if btnCount == 3 {
            offset = -120
        }
        let c2: NSLayoutConstraint = NSLayoutConstraint(item: submitBtn, attribute: .centerX, relatedBy: .equal, toItem: submitBtn.superview, attribute: .centerX, multiplier: 1, constant: offset)
        submitBtn.translatesAutoresizingMaskIntoConstraints = false
        blackView.addConstraints([c1,c2])
        
        submitBtn.addTarget(self, action: #selector(layerSubmit(view:)), for: .touchUpInside)
        self.submitBtn.isHidden = false
    }
    
    func addCancelBtn() {
        
        blackView.addSubview(cancelBtn)
        
        let c1: NSLayoutConstraint = NSLayoutConstraint(item: cancelBtn, attribute: .top, relatedBy: .equal, toItem: searchTableView, attribute: .bottom, multiplier: 1, constant: 12)
        var offset:CGFloat = 0
        if btnCount == 2 {
            offset = 60
        }
        let c2: NSLayoutConstraint = NSLayoutConstraint(item: cancelBtn, attribute: .centerX, relatedBy: .equal, toItem: cancelBtn.superview, attribute: .centerX, multiplier: 1, constant: offset)
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        blackView.addConstraints([c1,c2])
        
        cancelBtn.addTarget(self, action: #selector(layerCancel(view:)), for: .touchUpInside)
        self.cancelBtn.isHidden = false
    }
    
    func addDeleteBtn() {
        
        blackView.addSubview(deleteBtn)
        
        let c1: NSLayoutConstraint = NSLayoutConstraint(item: deleteBtn, attribute: .top, relatedBy: .equal, toItem: searchTableView, attribute: .bottom, multiplier: 1, constant: 12)
        var offset:CGFloat = 0
        if btnCount == 2 {
            offset = 60
        } else if btnCount == 3 {
            offset = 120
        }
        let c2: NSLayoutConstraint = NSLayoutConstraint(item: deleteBtn, attribute: .centerX, relatedBy: .equal, toItem: deleteBtn.superview, attribute: .centerX, multiplier: 1, constant: offset)
        deleteBtn.translatesAutoresizingMaskIntoConstraints = false
        blackView.addConstraints([c1,c2])
        deleteBtn.addTarget(self, action: #selector(layerDelete(view:)), for: .touchUpInside)
        self.deleteBtn.isHidden = false
    }
    
    @objc func layerSubmit(view: UIButton) {
        
        unmask()
        if (baseVC != nil) {
            baseVC!.searchSections = searchSections
            baseVC!.prepareParams()
            baseVC!.refresh()
        }
    }
    
    @objc func layerDelete(view: UIButton){}
    @objc func layerCancel(view: UIButton){
        unmask()
    }

    func mask(y: CGFloat, superView: UIView? = nil, height: CGFloat? = nil) {
        
        //maskView.backgroundColor = UIColor(MY_RED)
        maskView = UIView()
        maskView.backgroundColor = UIColor(hex: "#888888", alpha: 0.9)
        //maskView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(unmask)))
        
        if (myView != nil) {
            myView!.addSubview(maskView)
            var _height: CGFloat = myView!.bounds.height
            if height != nil {
                _height = height!
            }
            maskView.frame = CGRect(x: 0, y: y, width: view!.frame.width, height: _height)
            //maskView.alpha = 0
        }
    }
    
    @objc func unmask() {
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.frame = CGRect(x:self.layerRightLeftPadding, y:self.myView!.frame.height, width:self.myView!.frame.width-(2*self.layerRightLeftPadding), height:self.maskView.frame.height-self.layerTopPadding)
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
    func valueToArray<T>(t:T.Type, row: SearchRow)-> [T] {
        
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
    
    func getDefinedRow(_ key: String) -> SearchRow {
        for section in searchSections {
            for row in section.items {
                if row.key == key {
                    return row
                }
            }
        }
        return SearchRow()
    }
    
//    func replaceRows(_ key: String, _ row: [String: Any]) {
//        for (idx, _row) in searchRows.enumerated() {
//            if _row["key"] as! String == key {
//                searchRows[idx] = row
//                break;
//            }
//        }
//    }
    
    func singleSelected(key: String, selected: String, show: String?=nil) {
        let row = getDefinedRow(key)
        var _show = ""
        if key == START_TIME_KEY || key == END_TIME_KEY {
            row.value = selected
            _show = selected.noSec()
        } else if (key == CITY_KEY || key == AREA_KEY) {
            row.value = selected
            _show = Global.instance.zoneIDToName(Int(selected)!)
        } else if (key == ARENA_KEY) {
            row.value = selected
            if (show != nil) {
                _show = show!
            }
        }
        row.show = _show
        //replaceRows(key, row)
        reloadSearchTable()
    }
    
    func setWeekdaysData(selecteds: [Int]) {
        let row = getDefinedRow(WEEKDAY_KEY)
        var texts: [String] = [String]()
        var values: [String] = [String]()
        if selecteds.count > 0 {
            for day in selecteds {
                values.append(String(day))
                for gday in Global.instance.weekdays {
                    if day == gday["value"] as! Int {
                        let text = gday["simple_text"]
                        texts.append(text! as! String)
                        break
                    }
                }
            }
            row.show = texts.joined(separator: ",")
        
            row.value = values.joined(separator: ",")
        } else {
            row.show = "全部"
        }
        //replaceRows(WEEKDAY_KEY, row)
        reloadSearchTable()
    }
    
    func setDegreeData(res: [DEGREE]) {
        
        let row = getDefinedRow(DEGREE_KEY)
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
        reloadSearchTable()
    }
    
    func setTextField(key: String, value: String) {
        
        let row = getDefinedRow(key)
        row.value = value
        //replaceRows(key, row)
    }
    
    func setSwitch(indexPath: IndexPath, value: Bool) {
        
        let row = searchSections[indexPath.section].items[indexPath.row]
        //let key = row.key
        row.value = (value) ? "1" : ""
        //replaceRows(key, row)
        
        reloadSearchTable()
    }
    
    func reloadSearchTable() {
    
        searchTableView.reloadData()
    }
    
    func clear(key: String) {
        
        let row = getDefinedRow(key)
        row.show = "全部"
        row.value = ""
        //replaceRows(key, row)
    }
}

extension SearchPanel: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return searchSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchSections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "search_cell", for: indexPath) as? EditCell {
            cell.editCellDelegate = baseVC
            let row = searchSections[indexPath.section].items[indexPath.row]
            //print(searchRow["key"])
            cell.forRow(indexPath: indexPath, row: row, isClear: true)
            return cell
        }
        
        return UITableViewCell()
    }
}

extension SearchPanel: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = searchSections[indexPath.section].items[indexPath.row]
        
        let key: String = row.key
        
        let cell: String = row.cell
        if (cell == TO_CITY || cell == TO_SELECT_TIME) {
            let selected: String = row.value
            baseVC!.toSelectSingle(key: key, selected: selected, delegate: baseVC!)
        } else if (cell == TO_SELECT_WEEKDAY) {
            
            let selecteds: [Int] = valueToArray(t: Int.self, row: row)
            baseVC!.toSelectWeekday(key: key, selecteds: selecteds, delegate: baseVC!)
        } else if cell == TO_ARENA {
            
            var row = getDefinedRow(CITY_KEY)
            var city: Int? = nil
            if let value: Int = Int(row.value) {
                city = value
//                    if (city != nil) {
//                        citys.append(city!)
//                    }
            }
            
            if (city == nil) {
                baseVC!.warning("請先選擇縣市")
            } else {
            
                //取得選擇球館的代號
                row = getDefinedRow(ARENA_KEY)
                let selected: String = row.value
                baseVC!.toSelectArena(key: key, city: city!, selected: selected, delegate: baseVC!)
            }
        } else if (cell == TO_SELECT_DEGREE) {
            
            let tmps: [String] = valueToArray(t: String.self, row: row)
            var selecteds: [DEGREE] = [DEGREE]()
            for tmp in tmps {
                selecteds.append(DEGREE.enumFromString(string: tmp))
            }
            baseVC!.toSelectDegree(selecteds: selecteds, delegate: baseVC!)
        } else if cell == TO_AREA {
            
            //var citys: [Int] = [Int]()
            var row = getDefinedRow(CITY_KEY)
            var city: Int? = nil
            if let value: Int = Int(row.value) {
                city = value
//                    if (city != nil) {
//                        citys.append(city!)
//                    }
            }
            
            if (city == nil) {
                baseVC!.warning("請先選擇縣市")
            } else {
            
                //取得選擇球館的代號
                row = getDefinedRow(AREA_KEY)
                let selected: String = row.value
        
                baseVC!.toSelectArea(key: key, city_id: city, selected: selected, delegate: baseVC!)
            }
        } else {
            //performSegue(withIdentifier: segue, sender: indexPath)
        }
    }
}
