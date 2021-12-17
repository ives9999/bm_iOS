//
//  TimeTableVC.swift
//  bm
//
//  Created by ives on 2018/11/24.
//  Copyright © 2018 bm. All rights reserved.
//

import UIKit

class TimeTableVC: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource, ColorSelectDelegate, StatusSelectDelegate, TextInputDelegate {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var token: String = "" //coach token or arena token
    var source: String = ""
    var timetables: Timetables = Timetables()
    
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var cellWidth: CGFloat!
    var cellHeight: CGFloat = 50
    let cellBorderWidth: CGFloat = 1
    
    let startNum: Int = 7
    let endNum: Int = 23
    let columnNum: Int = 8
    
    var v: UIView = UIView(frame: CGRect.zero)
    var eventViews: [UIView] = [UIView]()
    var eventTag: Int = 0
    
    var newY: CGFloat = 0
    let padding: CGFloat = 20
    let editTableView: UITableView = {
        let cv = UITableView(frame: .zero, style: .plain)
        cv.backgroundColor = UIColor.black
        return cv
    }()

    fileprivate var form: TimeTableForm = TimeTableForm()
    let test: [String: String] = [TT_TITLE:"練球",TT_WEEKDAY:"2",TT_START_DATE:"2019-01-01",TT_END_DATE:"2019-03-31",TT_START_TIME:"14:00",TT_END_TIME:"17:00",TT_CHARGE:"800",TT_LIMIT:"6",TT_COLOR:"warning",TT_STATUS:"online",TT_CONTENT:"大家來練球"]
    var TTEditAction: String = "INSERT"

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
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
        
        beginRefresh()
        collectionView.addSubview(refreshControl)
        
        refresh()
    }
    
    private func prepareSubViews() {
        FormItemCellType.registerCell(for: editTableView)
        //self.ibTableView.allowsSelection = false
        //self.ibTableView.estimatedRowHeight = 60
        //self.ibTableView.rowHeight = 60
    }
    
    func markEvent() {
        for eventView in eventViews {
            eventView.removeFromSuperview()
        }
        eventViews.removeAll()
        let width: CGFloat = cellWidth - 2 * cellBorderWidth
        for i in 0 ... timetables.rows.count-1 {
            let row = timetables.rows[i]
            let x: CGFloat = CGFloat(row.weekday) * cellWidth + cellBorderWidth
            let y1 = (CGFloat(row._start_hour-startNum)+CGFloat(row._start_minute)/60)
            let y: CGFloat = y1 * cellHeight + cellBorderWidth
            
            var start_time: Date = Date()
            if let tmp = row.start_time.toDateTime(format:"HH:mm:ss") {
                start_time = tmp
            }
            
            var end_time: Date = Date()
            if let tmp = row.end_time.toDateTime(format:"HH:mm:ss") {
                end_time = tmp
            }
            
            let elapsed = CGFloat(end_time.timeIntervalSince(start_time)/(60*60))
            let height: CGFloat = elapsed * cellHeight - 2 * cellBorderWidth
            
            var frame = CGRect(x: x, y: y, width: width, height: height)
            let v: UIView = UIView(frame: frame)
            v.backgroundColor = row._color.toColor()
            v.tag = 1000 + i
            
            frame = CGRect(x: 3, y: 3, width: width-6, height: height-6)
            let titleLbl = UILabel(frame: frame)
            //titleLbl.backgroundColor = UIColor.white
            titleLbl.font = titleLbl.font.withSize(14)
            titleLbl.textAlignment = .center
            titleLbl.text = row.title
            titleLbl.textColor = UIColor.black
            titleLbl.numberOfLines = 0
            //titleLbl.sizeToFit()
            v.addSubview(titleLbl)
            
            /*
            let line = DrawLine(frame: CGRect(x: 5, y: 35, width: width-10, height: 1))
            v.addSubview(line)
            
            frame = CGRect(x: 3, y: 40, width: width, height: height-20)
            let contentLbl = UILabel(frame: frame)
            contentLbl.text = "人數：\n" + row.limit_text
            contentLbl.font = UIFont(name: contentLbl.font.fontName, size: 12)
            contentLbl.textColor = UIColor.black
            contentLbl.numberOfLines = 0
            contentLbl.sizeToFit()
            v.addSubview(contentLbl)
 */
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(clickEvent))
            v.addGestureRecognizer(tap)
            
            collectionView.addSubview(v)
            eventViews.append(v)
        }
    }
    
    @objc func clickEvent(sender: UITapGestureRecognizer) {
        guard let a = (sender.view) else {return}
        let idx: Int = a.tag - 1000
        //print(idx)
        eventTag = idx + 1000
        //print(eventTag)
        let event = timetables.rows[idx]
        //print(event.printRow())
        //let mirror: Mirror? = Mirror(reflecting: event)
        //mirror.
        var values: [String: String] = [String: String]()
        for formItem in form.formItems {
            if formItem.name != nil {
                let name: String = formItem.name!
                var value: String = String(describing:(event.value(forKey: name))!)
                //print(value)
                if name == TT_START_TIME || name == TT_END_TIME {
                    value = value.noSec()
                }
                values[name] = value
            }
        }
        //print(values)
        form = TimeTableForm(id: event.id, values: values)
        
        let alert = UIAlertController(title: "title", message: "content", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "檢視", style: .default) { (action) in
            self.performSegue(withIdentifier: TO_SHOW_TIMETABLE, sender: event.id)
        }
        let action2 = UIAlertAction(title: "編輯", style: .default) { (action) in
            self.TTEditAction = "UPDATE"
            self.showEditEvent(3)
        }
        let action3 = UIAlertAction(title: "刪除", style: .default) { (action) in
            self.layerDelete(view: UIButton())
        }
        let action4 = UIAlertAction(title: "取消", style: .default) { (action) in
        }
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        alert.addAction(action4)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func layerSubmit(view: UIButton) {
        if TTEditAction == "UPDATE" {
            let (isChange, msg) = form.isChanged()
            if !isChange {
                let _msg = msg ?? "沒有更改任何值，所以不用送出更新"
                warning(_msg)
                return
            }
        }
        let (isValid, msg) = form.isValid()
        if !isValid {
            let _msg = msg ?? "欄位驗證錯誤"
            warning(_msg)
            return
        }
        
        prepareParams()
    }
    
    func layerDelete(view: UIButton) {
        warning(msg: "是否真的要刪除此事件？", closeButtonTitle: "取消", buttonTitle: "確定") {
            self._layerDelete()
        }
    }
    
    func _layerDelete() {
        params.removeAll()
        params["model_token"] = token
        if form.id != nil {
            params["id"] = String(form.id!)
        }
        //print(params)
        unmask()
//        Global.instance.addSpinner(superView: view)
//        dataService.deleteTT(type: "coach", params: params) { (success) in
//            Global.instance.removeSpinner(superView: self.view)
//            if success {
//                self.refreshEvent()
//            } else {
//                self.warning(self.dataService.msg)
//            }
//        }
    }
    
    @IBAction func addTimeTableBtnPressed(_ sender: Any) {
        form = TimeTableForm()
        //form = TimeTableForm(values: test)
        TTEditAction = "INSERT"
        showEditEvent(2)
    }
    
    func prepareParams() {
        params.removeAll()
        params["model_token"] = token
        params["created_token"] = Member.instance.token
        for formItem in form.formItems {
            if formItem.name != nil && formItem.value != nil {
                params[formItem.name!] = formItem.value
            }
        }
        if form.id != nil {
            params["id"] = String(form.id!)
        }
        //print(params)
        unmask()
//        Global.instance.addSpinner(superView: view)
//        dataService.updateTT(type: "coach", params: params) { (success) in
//            Global.instance.removeSpinner(superView: self.view)
//            if success {
//                self.refreshEvent()
//            } else {
//                self.warning(self.dataService.msg)
//            }
//        }
    }
    
    func showEditEvent(_ btnCount: Int) {
        collectionView.isScrollEnabled = false
        editTableView.reloadData()
        //mask(y: newY, superView: collectionView)
        let layerY = workAreaHeight + newY
        var frame = CGRect(x:padding, y:layerY, width:view.frame.width-(2*padding), height:layerY)
        layerBtnCount = btnCount
        //addLayer(superView: collectionView, frame: frame)
        let y = newY
        frame = CGRect(x: padding, y: y, width: containerView.frame.width, height: layerY)
        //animation(frame: frame)
    }
    func _addLayer() {
        editTableView.isHidden = false
        containerView.addSubview(editTableView)
//        layerAddSubmitBtn(upView: editTableView)
//        layerAddCancelBtn(upView: editTableView)
//        if layerBtnCount > 2 {
//            layerAddDeleteBtn(upView: editTableView)
//        }
    }
    func otherAnimation() {
        let frame = containerView.frame
        editTableView.frame = CGRect(x: 0, y: 0, width: frame.width, height: 500)
    }
    
    @objc func unmask() {
        UIView.animate(withDuration: 0.5) {
            self.maskView.alpha = 0
            self.editTableView.isHidden = true
            self.panelSubmitBtn.isHidden = true
            self.panelCancelBtn.isHidden = true
            self.containerView.frame = CGRect(x:self.padding, y:self.newY+self.workAreaHeight, width:self.containerView.frame.width, height:0)
        }
        collectionView.isScrollEnabled = true
    }
    
    override func refresh() {
        Global.instance.addSpinner(superView: self.view)
//        dataService.getTT(token: token, type: source) { (success) in
//            Global.instance.removeSpinner(superView: self.view)
//            if success {
//                self.refreshEvent()
//            }
//            self.endRefresh()
//        }
    }
    
    func refreshEvent() {
        self.timetables = self.dataService.timetables
        self.markEvent()
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
        cell.tag = (startTime - startNum)*columnNum + weekday
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
        let values: [String: String] = [TT_START_TIME: String(startTime) + ":00", TT_WEEKDAY: String(weekday)]
        eventTag = (collectionView.cellForItem(at: indexPath)?.tag)!
        //print(eventTag)
        form = TimeTableForm(values: values)
        showEditEvent(2)
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
        if form.formItems[indexPath.row].uiProperties.cellType != nil {
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
                indexPath = (_sender["indexPath"] as! IndexPath)
            }
        }
        
        if segue.identifier == TO_SELECT_WEEKDAY {
            let weekdaysSelectVC: WeekdaysSelectVC = segue.destination as! WeekdaysSelectVC
            weekdaysSelectVC.select = "just one"
            if indexPath != nil {
                weekdaysSelectVC.indexPath = indexPath
            }
            if let _sender: [String: Any?] = sender as? [String: Any?] {
                if _sender["sender"] != nil {
                    let realSender: [Int] = _sender["sender"] as! [Int]
                    //weekdaysSelectVC.selecteds = realSender
                }
            }
            //weekdaysSelectVC.delegate = self
        } else if segue.identifier == TO_SELECT_DATE {
            let dateSelectVC: DateSelectVC = segue.destination as! DateSelectVC
//            if indexPath != nil {
//                dateSelectVC.indexPath = indexPath
//            }
            if let _sender: [String: Any?] = sender as? [String: Any?] {
                if _sender["sender"] != nil {
                    let realSender: [String: Any] = _sender["sender"] as! [String: Any]
                    //dateSelectVC.type = realSender["type"] as! SELECT_DATE_TYPE
                    dateSelectVC.selected = realSender["date"] as! String
                }
            }
            //dateSelectVC.delegate = self
        } else if segue.identifier == TO_SELECT_TIME {
            let timeSelectVC: TimeSelectVC = segue.destination as! TimeSelectVC
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
            //timeSelectVC.delegate = self
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
        } else if segue.identifier == TO_SHOW_TIMETABLE {
            let showTimetableVC: ShowTimetableVC = segue.destination as! ShowTimetableVC
            if let id = sender as? Int {
                showTimetableVC.tt_id = id
            }
            showTimetableVC.source = source
            showTimetableVC.token = token
        }
    }
    
//    override func setWeekdaysData(res: [Int], indexPath: IndexPath? = nil) {
//        if indexPath != nil {
//            let item = form.formItems[indexPath!.row] as! WeekdayFormItem
//            item.weekdays = res
//            
//            editTableView.reloadData()
//        }
//    }
    
    override func dateSelected(key: String, selected: String) {
        print(selected)
    }
    
//    func setDateData(res: String, type: SELECT_DATE_TYPE, indexPath: IndexPath?) {
//        if indexPath != nil {
//            let item = form.formItems[indexPath!.row] as! DateFormItem
//            item.value = res
//        }
//        editTableView.reloadData()
//    }
    
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
            item.make()
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
            let item = form.formItems[indexPath!.row] as! ContentFormItem
            item.value = text
            item.make()
        }
        editTableView.reloadData()
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
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        prev()
    }
}












