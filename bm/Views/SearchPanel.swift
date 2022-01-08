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
    var oneSections: [OneSection] = [OneSection]()
    
    //func showSearchPanel(baseVC: BaseViewController, view: UIView, newY: CGFloat, searchRows: [[String: Any]]) {
    func showSearchPanel(baseVC: BaseViewController, view: UIView, newY: CGFloat, oneSections: [OneSection]) {
        
        self.myView = view
        self.baseVC = baseVC
        self.newY = 0
        self.oneSections = oneSections
        
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
        
        let plainNib = UINib(nibName: "PlainCell", bundle: nil)
        searchTableView.register(plainNib, forCellReuseIdentifier: "PlainCell")
        
        let textFieldNib = UINib(nibName: "TextFieldCell", bundle: nil)
        searchTableView.register(textFieldNib, forCellReuseIdentifier: "TextFieldCell")
        
        let moreCellNib = UINib(nibName: "MoreCell", bundle: nil)
        searchTableView.register(moreCellNib, forCellReuseIdentifier: "MoreCell")
        
        let switchCellNib = UINib(nibName: "SwitchCell", bundle: nil)
        searchTableView.register(switchCellNib, forCellReuseIdentifier: "SwitchCell")
        
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
            baseVC!.oneSections = oneSections
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
//    func valueToArray<T>(t:T.Type, row: SearchRow)-> [T] {
//        
//        var selecteds: [T] = [T]()
//        //print(t)
//        var type: String = "String"
//        if (t.self == Int.self) {
//            type = "Int"
//        }
//        
//        if (row.value.count > 0) {
//            let values = row.value.components(separatedBy: ",")
//            for value in values {
//                if (type == "Int") {
//                    if let tmp = Int(value) {
//                        selecteds.append(tmp as! T)
//                    }
//                } else {
//                    if let tmp = value as? T {
//                        selecteds.append(tmp)
//                    }
//                }
//            }
//        }
//        
//        return selecteds
//    }
    
    func getDefinedRow(_ key: String) -> OneRow {
        for section in oneSections {
            for row in section.items {
                if row.key == key {
                    return row
                }
            }
        }
        return OneRow()
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
    
    func setWeekdaysData(selecteds: Int) {
        let row = getDefinedRow(WEEKDAYS_KEY)
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
            
            row.show = shows.joined(separator: ",")
            row.value = String(selecteds)
        } else {
            row.show = ""
        }
        //replaceRows(WEEKDAY_KEY, row)
        reloadSearchTable()
    }
//    
//    func setDegreeData(res: [DEGREE]) {
//        
//        let row = getDefinedRow(DEGREE_KEY)
//        var names: [String] = [String]()
//        var values: [String] = [String]()
//        if res.count > 0 {
//            for degree in res {
//                names.append(degree.rawValue)
//                values.append(DEGREE.DBValue(degree))
//            }
//            row.show = names.joined(separator: ",")
//            row.value = values.joined(separator: ",")
//        } else {
//            row.show = "全部"
//            row.value = ""
//        }
//        //replaceRows(DEGREE_KEY, row)
//        reloadSearchTable()
//    }
//    
//    func setTextField(key: String, value: String) {
//        
//        let row = getDefinedRow(key)
//        row.value = value
//        //replaceRows(key, row)
//    }
//    
//    func setSwitch(indexPath: IndexPath, value: Bool) {
//        
//        let row = searchSections[indexPath.section].items[indexPath.row]
//        //let key = row.key
//        row.value = (value) ? "1" : ""
//        //replaceRows(key, row)
//        
//        reloadSearchTable()
//    }
    
    func reloadSearchTable() {
    
        searchTableView.reloadData()
    }
    
//    func clear(key: String) {
//
//        let row = getDefinedRow(key)
//        row.show = "全部"
//        row.value = ""
//        //replaceRows(key, row)
//    }
}

extension SearchPanel: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return oneSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return oneSections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = oneSections[indexPath.section].items[indexPath.row]
        let cell_type: String = row.cell
        
        if (cell_type == "more") {
            
            let cell: MoreCell = tableView.dequeueReusableCell(withIdentifier: "MoreCell", for: indexPath) as! MoreCell
            cell.cellDelegate = baseVC
            cell.update(sectionIdx: indexPath.section, rowIdx: indexPath.row, row: row)
            return cell
            
        } else if (row.cell == "text") {
            
            if let cell: PlainCell = tableView.dequeueReusableCell(withIdentifier: "PlainCell", for: indexPath) as? PlainCell {
                
                cell.update(title: row.title, show: row.show)
                return cell
            }
        } else if (cell_type == "textField") {
            if let cell: TextFieldCell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath) as? TextFieldCell {
                
                cell.cellDelegate = baseVC
                cell.update(sectionIdx: indexPath.section, rowIdx: indexPath.row, row: row)
                return cell
            }
        } else if (cell_type == "switch") {
            if let cell: SwitchCell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as? SwitchCell {
                
                cell.cellDelegate = baseVC
                cell.update(sectionIdx: indexPath.section, rowIdx: indexPath.row, row: row)
                return cell
            }
        }
                                                          
        
//        if let cell = tableView.dequeueReusableCell(withIdentifier: "search_cell", for: indexPath) as? EditCell {
//            cell.editCellDelegate = baseVC
//            let row = searchSections[indexPath.section].items[indexPath.row]
//            //print(searchRow["key"])
//            cell.forRow(indexPath: indexPath, row: row, isClear: true)
//            return cell
//        }
        
        return UITableViewCell()
    }
}

extension SearchPanel: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = oneSections[indexPath.section].items[indexPath.row]
        
        let key: String = row.key
        
        let cell: String = row.cell
        if (cell == "more") {
            baseVC!.cellMoreClick(key: key, row: row, delegate: baseVC!)
//            let selected: String = row.value
//            baseVC!.toSelectSingle(key: key, selected: selected, delegate: baseVC!)
        } else {
            //performSegue(withIdentifier: segue, sender: indexPath)
        }
    }
}
