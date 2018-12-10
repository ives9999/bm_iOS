//
//  TimeTableVC.swift
//  bm
//
//  Created by ives on 2018/11/24.
//  Copyright © 2018 bm. All rights reserved.
//

import UIKit

class TimeTableVC: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource, EditCellDelegate, WeekdaysSelectDelegate, TimeSelectDelegate, ColorSelectDelegate, StatusSelectDelegate, TextInputDelegate {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var token: String = ""
    var source: String = ""
    var timeTable: TimeTable = TimeTable()
    
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var cellWidth: CGFloat!
    var cellHeight: CGFloat = 50
    let cellBorderWidth: CGFloat = 1
    
    let startNum: Int = 6
    let endNum: Int = 23
    let columnNum: Int = 8
    
    var v: UIView = UIView(frame: CGRect.zero)
    var eventViews: [UIView] = [UIView]()
    
    var newY: CGFloat = 0
    let padding: CGFloat = 20
    let editTableView: UITableView = {
        let cv = UITableView(frame: .zero, style: .plain)
        cv.backgroundColor = UIColor.black
        return cv
    }()
//    let editRows: [[String: Any]] = [
//        ["ch":"標題","atype":UITableViewCellAccessoryType.none,"key":"keyword","show":"","hint":"請輸入事件標題","text_field":true]
//    ]
    fileprivate var form: TimeTableForm = TimeTableForm()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if source == "coach" {
            dataService = CoachService.instance
        }
        
        let screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        cellWidth = screenWidth/CGFloat(columnNum)

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        collectionView!.collectionViewLayout = layout
        
//        v.frame = CGRect(x: cellWidth+cellBorderWidth, y: cellHeight+cellBorderWidth, width: cellWidth-2*cellBorderWidth, height: cellHeight-2*cellBorderWidth)
//        v.backgroundColor = UIColor.red
        collectionView.addSubview(v)
        
        editTableView.delegate = self
        editTableView.dataSource = self
        editTableView.backgroundColor = UIColor.clear
        prepareSubViews()
        
        refresh()
    }
    
    private func prepareSubViews() {
        FormItemCellType.registerCells(for: editTableView)
        //self.ibTableView.allowsSelection = false
        //self.ibTableView.estimatedRowHeight = 60
        //self.ibTableView.rowHeight = 60
    }
    
    func markEvent() {
        for i in 0 ... timeTable.rows.count-1 {
            let row = timeTable.rows[i]
            let x: CGFloat = CGFloat(row.day) * cellWidth + cellBorderWidth
            let y: CGFloat = CGFloat(row._start-startNum) * cellHeight + cellBorderWidth
            let width: CGFloat = cellWidth - 2 * cellBorderWidth
            let gridNum: CGFloat = CGFloat(row._end-row._start)
            let height: CGFloat = gridNum * cellHeight - 2 * cellBorderWidth
            var frame = CGRect(x: x, y: y, width: width, height: height)
            let v: UIView = UIView(frame: frame)
            v.backgroundColor = row._color.toColor()
            v.tag = i
            
            frame = CGRect(x: 10, y: 10, width: width, height: height)
            let titleLbl = UILabel(frame: frame)
            titleLbl.text = row.title
            titleLbl.textColor = UIColor.black
            titleLbl.numberOfLines = 0
            titleLbl.sizeToFit()
            v.addSubview(titleLbl)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(clickEvent))
            v.addGestureRecognizer(tap)
            
            collectionView.addSubview(v)
            eventViews.append(v)
        }
    }
    
    @objc func clickEvent(sender: UITapGestureRecognizer) {
        //guard let a = (sender.view) else {return}
        //let idx: Int = a.tag
        //print(idx)
        showEditEvent()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        newY = scrollView.contentOffset.y
        if newY < 0 { newY = 0 }
        //print(newY)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        newY = scrollView.contentOffset.y
        if newY < 0 { newY = 0 }
        //print(scrollView.contentOffset.y)
    }
    
    override func refresh() {
        Global.instance.addSpinner(superView: self.view)
        dataService.getTT(token: token, type: source) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if success {
                self.timeTable = self.dataService.timeTable
                //self.collectionView.reloadData()
                self.markEvent()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (endNum-startNum)*columnNum
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        layout.minimumInteritemSpacing = 0
//        layout.minimumLineSpacing = 0
//        return CGSize(width: screen, height: <#T##Double#>)
//    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        let startTime: Int = indexPath.row / columnNum + startNum
        let weekday: Int = indexPath.row % columnNum
        
        let contentView = cell.contentView
        contentView.layer.borderWidth = cellBorderWidth
        contentView.layer.borderColor = UIColor.gray.cgColor
//        for row in timeTable.rows {
//            if startTime >= row._start && startTime < row._end && weekday == row.day {
//                contentView.backgroundColor = row._color.toColor()
//            }
//        }
        
        let timeLabel = cell.contentView.subviews[0] as! UILabel
        
        if weekday == 0 {
            timeLabel.text = "\(startTime)-\(startTime+1)"
        } else {
            timeLabel.text = ""
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let startTime: Int = indexPath.row / columnNum + startNum
        let weekday: Int = indexPath.row % columnNum
        //print("\(weekday)-\(startTime)")
        showEditEvent()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return form.formItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = form.formItems[indexPath.row]
        let cell: UITableViewCell
        if let cellType = item.uiProperties.cellType {
            cell = cellType.dequeueCell(for: tableView, at: indexPath)
        } else {
            cell = UITableViewCell()
        }
        
        if let formUpdatableCell = cell as? FormUPdatable {
            item.indexPath = indexPath
            formUpdatableCell.update(with: item)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Global.instance.addSpinner(superView: view)
        Global.instance.removeSpinner(superView: view)
        let item = form.formItems[indexPath.row]
        if let cellType = form.formItems[indexPath.row].uiProperties.cellType {
            if item.segue != nil {
                let segue = item.segue!
                var sender: [String: Any?] = ["indexPath":indexPath]
                if item.sender != nil {
                    sender["sender"] = item.sender
                }
                //print(item.sender)
                performSegue(withIdentifier: segue, sender: sender)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationNavigationController: UINavigationController?
        
        var indexPath: IndexPath?
        if let _sender: [String: Any?] = sender as? [String: Any?] {
            if _sender["indexPath"] != nil {
                indexPath = _sender["indexPath"] as! IndexPath
            }
        }
        
        if segue.identifier == TO_SELECT_WEEKDAY {
            destinationNavigationController = (segue.destination as! UINavigationController)
            let weekdaysSelectVC: WeekdaysSelectVC = destinationNavigationController!.topViewController as! WeekdaysSelectVC
            weekdaysSelectVC.select = "just one"
            if indexPath != nil {
                weekdaysSelectVC.indexPath = indexPath
            }
            if let _sender: [String: Any?] = sender as? [String: Any?] {
                if _sender["sender"] != nil {
                    let realSender: [Int] = _sender["sender"] as! [Int]
                    weekdaysSelectVC.selecteds = realSender
                }
            }
            weekdaysSelectVC.delegate = self
        } else if segue.identifier == TO_SELECT_TIME {
            destinationNavigationController = (segue.destination as! UINavigationController)
            let timeSelectVC: TimeSelectVC = destinationNavigationController!.topViewController as! TimeSelectVC
            timeSelectVC.select = "just one"
            if indexPath != nil {
                timeSelectVC.indexPath = indexPath
            }
            if let _sender: [String: Any?] = sender as? [String: Any?] {
                if _sender["sender"] != nil {
                    let realSender: [String: Any] = _sender["sender"] as! [String: Any]
                    timeSelectVC.input = realSender
                }
            }
            timeSelectVC.delegate = self
        } else if segue.identifier == TO_SELECT_COLOR {
            let colorSelectVC: ColorSelectVC = segue.destination as! ColorSelectVC
            colorSelectVC.delegate = self
            if indexPath != nil {
                colorSelectVC.indexPath = indexPath
            }
            //print(sender)
            if let _sender: [String: Any?] = sender as? [String: Any?] {
                if _sender["sender"] != nil {
                    let realSender: [MYCOLOR] = _sender["sender"] as! [MYCOLOR]
                    colorSelectVC.selecteds = realSender
                }
            }
        } else if segue.identifier == TO_SELECT_STATUS {
            let statusSelectVC: StatusSelectVC = segue.destination as! StatusSelectVC
            statusSelectVC.delegate = self
            if indexPath != nil {
                statusSelectVC.indexPath = indexPath
            }
            //print(sender)
            if let _sender: [String: Any?] = sender as? [String: Any?] {
                if _sender["sender"] != nil {
                    let realSender: STATUS = _sender["sender"] as! STATUS
                    statusSelectVC.selected = realSender
                }
            }
        } else if segue.identifier == TO_TEXT_INPUT {
            destinationNavigationController = (segue.destination as! UINavigationController)
            let textInputVC: TextInputVC = destinationNavigationController!.topViewController as! TextInputVC
            textInputVC.delegate = self
            if indexPath != nil {
                textInputVC.indexPath = indexPath
            }
            //print(sender)
            if let _sender: [String: Any?] = sender as? [String: Any?] {
                var realSender: [String: Any] = ["type":TEXT_INPUT_TYPE.timetable_coach,"text":""]
                if _sender["sender"] != nil {
                    realSender = _sender["sender"] as! [String: Any]
                }
                textInputVC.input = realSender
            }
        }
    }
    
    func showEditEvent() {
        collectionView.isScrollEnabled = false
        mask(y: newY, superView: collectionView)
        let layerY = workAreaHeight + newY
        var frame = CGRect(x:padding, y:layerY, width:view.frame.width-(2*padding), height:layerY)
        addLayer(superView: collectionView, frame: frame)
        let y = newY
        frame = CGRect(x: padding, y: y, width: containerView.frame.width, height: layerY)
        animation(frame: frame)
    }
    override func _addLayer() {
        editTableView.isHidden = false
        containerView.addSubview(editTableView)
        layerAddSubmitBtn(upView: editTableView)
    }
    override func otherAnimation() {
        let frame = containerView.frame
        editTableView.frame = CGRect(x: 0, y: 0, width: frame.width, height: 500)
    }
    
    @objc override func unmask() {
        UIView.animate(withDuration: 0.5) {
            self.maskView.alpha = 0
            self.editTableView.isHidden = true
            self.layerSubmitBtn.isHidden = true
            self.containerView.frame = CGRect(x:self.padding, y:self.newY+self.workAreaHeight, width:self.containerView.frame.width, height:0)
        }
        collectionView.isScrollEnabled = true
    }
    @objc override func layerSubmit(view: UIButton) {
        unmask()
        //prepareParams()
        refresh()
    }
    
    @IBAction func addTimeTableBtnPressed(_ sender: Any) {
        
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        prev()
    }
    
    func setTextField(iden: String, value: String) {
        
    }
    
    func setSwitch(indexPath: IndexPath, value: Bool) {
        
    }
    
    func clear(indexPath: IndexPath) {
        
    }
    
    func setWeekdaysData(res: [Int], indexPath: IndexPath? = nil) {
        if indexPath != nil {
            let item = form.formItems[indexPath!.row] as! WeekdayFormItem
            item.weekdays = res
            
            editTableView.reloadData()
        }
    }
    
    func setTimeData(res: [String], type: SELECT_TIME_TYPE, indexPath: IndexPath?) {
        let time = res[0]
        if indexPath != nil {
            let item = form.formItems[indexPath!.row] as! TimeFormItem
            item.value = time
        }
        editTableView.reloadData()
    }
    
    func setColorData(res: [MYCOLOR], indexPath: IndexPath?) {
        let colorType = res[0]
        if indexPath != nil {
            let item = form.formItems[indexPath!.row] as! ColorFormItem
            item.color = colorType
        }
        editTableView.reloadData()
    }
    
    func setStatusData(res: STATUS, indexPath: IndexPath?) {
        if indexPath != nil {
            let item = form.formItems[indexPath!.row] as! StatusFormItem
            item.status = res
        }
        editTableView.reloadData()
    }
    
    func setTextInputData(key: String, type: TEXT_INPUT_TYPE, text: String, indexPath: IndexPath?) {
        if indexPath != nil {
            let item = form.formItems[indexPath!.row]
            item.value = text
            item.show = text
            item.sender = ["type":type,"text":text]
        }
        editTableView.reloadData()
    }
}












