//
//  Panel.swift
//  bm
//
//  Created by ives on 2021/8/13.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class Panel: UIViewController {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        //nameTxt = SuperTextField()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    convenience init(baseVC: BaseViewController) {
        self.init(nibName:nil, bundle:nil)
        self.baseVC = baseVC
        self.myView = baseVC.view
    }
    
    var myView: UIView? = nil
    var maskView = UIView()
    var blackView = UIView()
    
    let submitBtn: SubmitButton = SubmitButton()
    let cancelBtn: CancelButton = CancelButton()
    let deleteBtn: ClearButton = ClearButton()
    var btnCount: Int = 2
    
    let titleBarHeight: CGFloat = 111
    var rightLeftPadding: CGFloat = 50
    var topPadding: CGFloat = 30
    var height: CGFloat = 300
    
    var tableView: UITableView = {
        let cv = UITableView(frame: .zero, style: .plain)
        cv.backgroundColor = UIColor.black
        return cv
    }()
    
    var baseVC: BaseViewController? = nil
    
    var myRows: [[String: String]] = [[String: String]]()
    
    func show(rows: [[String: String]]) {
        
        maskView = myView!.mask()
        
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: baseVC, action: #selector(layerCancel))
        maskView.addGestureRecognizer(gesture)
        
        let top: CGFloat = (maskView.frame.height-height)/2
        blackView = maskView.blackView(left: rightLeftPadding, top: top, width: maskView.frame.width-2*rightLeftPadding, height:height)
        
        myRows = rows
        //addTableView()
        addCancelBtn()
        
        //動態結束完的位置
//        let frame: CGRect = CGRect(x: layerRightLeftPadding, y: layerTopPadding, width: myView!.frame.width-(2*layerRightLeftPadding), height: maskView.frame.height-layerTopPadding)
//        animation(frame: frame)
    }
    
    func addTableView() {
        
        let frame = blackView.frame
        tableView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height - 300)
        tableView.dataSource = self
        tableView.delegate = self
        
        let plainNib = UINib(nibName: "PlainCell", bundle: nil)
        tableView.register(plainNib, forCellReuseIdentifier: "PlainCell")
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.lightGray
        
        tableView.backgroundColor = UIColor.red
        blackView.addSubview(tableView)
    }
    
    func addSubmitButton() {
        
        blackView.addSubview(submitBtn)
        
        let c1: NSLayoutConstraint = NSLayoutConstraint(item: submitBtn, attribute: .top, relatedBy: .equal, toItem: tableView, attribute: .bottom, multiplier: 1, constant: 12)
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
        
        let c1: NSLayoutConstraint = NSLayoutConstraint(item: cancelBtn, attribute: .bottom, relatedBy: .equal, toItem: cancelBtn.superview, attribute: .bottom, multiplier: 1, constant: -12)
        var offset:CGFloat = 0
        if btnCount == 2 {
            offset = 60
        }
        let c2: NSLayoutConstraint = NSLayoutConstraint(item: cancelBtn, attribute: .centerX, relatedBy: .equal, toItem: cancelBtn.superview, attribute: .centerX, multiplier: 1, constant: offset)
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        blackView.addConstraints([c1,c2])
        
        cancelBtn.addTarget(self, action: #selector(layerCancel), for: .touchUpInside)
        self.cancelBtn.isHidden = false
    }
    
    func addDeleteBtn() {
        
        blackView.addSubview(deleteBtn)
        
        let c1: NSLayoutConstraint = NSLayoutConstraint(item: deleteBtn, attribute: .top, relatedBy: .equal, toItem: tableView, attribute: .bottom, multiplier: 1, constant: 12)
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
//        if (baseVC != nil) {
//            baseVC!.searchRows = searchRows
//            baseVC!.prepareParams()
//            baseVC!.refresh()
//        }
    }
    
    @objc func layerDelete(view: UIButton){}
    @objc func layerCancel(){
        unmask()
    }
    
    func unmask() {
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.frame = CGRect(x:self.rightLeftPadding, y:self.myView!.frame.height, width:self.myView!.frame.width-(2*self.rightLeftPadding), height:self.maskView.frame.height-self.topPadding)
        }, completion: { (finished) in
            if finished {
                for view in self.maskView.subviews {
                    view.removeFromSuperview()
                }
                self.maskView.removeFromSuperview()
            }
        })
    }
    
    func animation(frame: CGRect) {
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.blackView.frame = frame
            
        }, completion: nil)
    }
}

extension Panel: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = myRows.count
        return count
    }
    
    func tableView(tableView: UITableView,
      heightForRowAtIndexPath indexPath: NSIndexPath)
      -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PlainCell", for: indexPath) as? PlainCell {
            //cell.editCellDelegate = baseVC
            //let searchRow = searchRows[indexPath.row]
            //print(searchRow["key"])
            let row: [String: String] = myRows[indexPath.row]
            var title: String = ""
            if let tmp: String = row[TITLE_KEY] {
                title = tmp
            }
            var show: String = ""
            if let tmp: String = row[SHOW_KEY] {
                show = tmp
            }
            cell.update(title: title, show: show)
            return cell
        }
        
        return UITableViewCell()
    }
}

extension Panel: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let row = searchRows[indexPath.row]
//
//        var key: String? = nil
//        if (row.keyExist(key: "key") && row["key"] != nil) {
//            key = row["key"] as? String
//        }
//
//        let segue: String = row["segue"] as! String
//        if (segue == TO_CITY || segue == TO_SELECT_TIME) {
//            var selected: String? = nil
//            if (row.keyExist(key: "value") && row["value"] != nil) {
//                selected = row["value"] as? String
//            }
//            //baseVC!.toSelectCity(key: key, selected: selected, delegate: baseVC!)
//            baseVC!.toSelectSingle(key: key, selected: selected, delegate: baseVC!)
//        } else if (segue == TO_SELECT_WEEKDAY) {
//
//            let selecteds: [Int] = valueToArray(t: Int.self, row: row)
//            baseVC!.toSelectWeekday(key: key, selecteds: selecteds, delegate: baseVC!)
//        } else if segue == TO_ARENA {
//
//            var city: Int? = nil
//            var row = getDefinedRow(CITY_KEY)
//            if let value: String = row["value"] as? String {
//                city = Int(value)
////                    if (city != nil) {
////                        citys.append(city!)
////                    }
//            }
//
//            if (city == nil) {
//                baseVC!.warning("請先選擇縣市")
//            } else {
//
//                //取得選擇球館的代號
//                row = getDefinedRow(ARENA_KEY)
//                let selected: String = row["value"] as! String
//                baseVC!.toSelectArena(key: key, city: city!, selected: selected, delegate: baseVC!)
//            }
//        } else if (segue == TO_SELECT_DEGREE) {
//
//            let tmps: [String] = valueToArray(t: String.self, row: row)
//            var selecteds: [DEGREE] = [DEGREE]()
//            for tmp in tmps {
//                selecteds.append(DEGREE.enumFromString(string: tmp))
//            }
//            baseVC!.toSelectDegree(selecteds: selecteds, delegate: baseVC!)
//        } else if segue == TO_AREA {
//
//            //var citys: [Int] = [Int]()
//            var city: Int? = nil
//            var row = getDefinedRow(CITY_KEY)
//            if let value: String = row["value"] as? String {
//                city = Int(value)
////                    if (city != nil) {
////                        citys.append(city!)
////                    }
//            }
//
//            if (city == nil) {
//                baseVC!.warning("請先選擇縣市")
//            } else {
//
//                //取得選擇球館的代號
//                row = getDefinedRow(AREA_KEY)
//                var selected: String? = nil
//                if (row.keyExist(key: "value") && row["value"] != nil) {
//                    selected = row["value"] as? String
//                }
//                baseVC!.toSelectArea(key: key, city_id: city, selected: selected, delegate: baseVC!)
//            }
//        } else {
//            //performSegue(withIdentifier: segue, sender: indexPath)
//        }
    }
}
