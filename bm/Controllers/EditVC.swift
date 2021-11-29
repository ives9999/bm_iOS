//
//  TeamEditVC.swift
//  bm
//
//  Created by ives on 2017/11/9.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import SCLAlertView

class EditVC: MyTableVC, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImagePickerViewDelegate {
    
    // Outlets
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var featuredView: ImagePickerView!
    @IBOutlet weak var submitBtn: SubmitButton!
    
    var imagePicker: UIImagePickerController = UIImagePickerController()
    var token: String?
    var isFeaturedChange: Bool = false
    
    var delegate: BaseViewController?
    
    override func viewDidLoad() {
        
        //print("token: \(token)")
 
        //let token: String = model.data[TEAM_TOKEN_KEY]!["value"] as! String
//        if source == "team" {
//            model = Team.instance
//            dataService = TeamService.instance
//            ch = "球隊"
//        } else if source == "coach" {
//            model = Coach.instance
//            dataService = CoachService.instance
//            ch = "教練"
//        } else if source == "arena" {
//            model = Arena.instance
//            dataService = ArenaService.instance
//            ch = "球館"
//        }
        
        super.viewDidLoad()
        
        //titleLbl.text = title
        
        imagePicker.delegate = self
        featuredView.gallery = imagePicker
        featuredView.delegate = self
        
        hideKeyboardWhenTappedAround()
        
        let moreCellNib = UINib(nibName: "MoreCell", bundle: nil)
        tableView.register(moreCellNib, forCellReuseIdentifier: "moreCell")
        
        let textFieldCellNib = UINib(nibName: "TextFieldCell", bundle: nil)
        tableView.register(textFieldCellNib, forCellReuseIdentifier: "textFieldCell")
        
        let dateCellNib = UINib(nibName: "DateCell", bundle: nil)
        tableView.register(dateCellNib, forCellReuseIdentifier: "dateCell")
        
        let contentCellNib = UINib(nibName: "ContentCell", bundle: nil)
        tableView.register(contentCellNib, forCellReuseIdentifier: "contentCell")
        
        let switchCellNib = UINib(nibName: "SwitchCell", bundle: nil)
        tableView.register(switchCellNib, forCellReuseIdentifier: "switchCell")
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {

        return oneSections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int = 0
        if !oneSections[section].isExpanded {
            count = 0
        } else {
            count = oneSections[section].items.count
        }
        
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = getOneRowFromIdx(indexPath.section, indexPath.row)
        let cell_type: String = row.cell
        
        if (cell_type == "textField") {
            if let cell: TextFieldCell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as? TextFieldCell {
                
                //let cell: TextFieldCell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as! TextFieldCell
                cell.cellDelegate = self
                cell.update(sectionIdx: indexPath.section, rowIdx: indexPath.row, row: row)
                
                return cell
            }
        } else if (row.cell == "more") {
            if let cell: MoreCell = tableView.dequeueReusableCell(withIdentifier: "moreCell", for: indexPath) as? MoreCell {
                
                cell.cellDelegate = self
                cell.update(sectionIdx: indexPath.section, rowIdx: indexPath.row, row: row)

                return cell
            }
        } else if (cell_type == "switch") {
            if let cell: SwitchCell = tableView.dequeueReusableCell(withIdentifier: "switchCell", for: indexPath) as? SwitchCell {
                
                cell.cellDelegate = self
                cell.update(sectionIdx: indexPath.section, rowIdx: indexPath.row, row: row)
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row: OneRow = oneSections[indexPath.section].items[indexPath.row]
        
        if (row.cell == "more") {
            moreClickForOne(key: row.key, row: row, delegate: self)
        }
        
//        Global.instance.addSpinner(superView: view)
//        Global.instance.removeSpinner(superView: view)
        //let row: [String: Any] = _getRowByindexPath(indexPath: indexPath)
//        var key = NAME_KEY
//        if row["key"] != nil {
//            key = row["key"]! as! String
//        }
//        let cell = tableView.cellForRow(at: indexPath) as! EditCell
//        if row["atype"] as! UITableViewCell.AccessoryType != UITableViewCell.AccessoryType.none {
//            if row["segue"] != nil {
//                let segue: String = row["segue"] as! String
//                //print(iden)
////                let city: Int = model.data[CITY_KEY]!["value"] as! Int
////                if segue == TO_ARENA && city == 0 {
////                    SCLAlertView().showError("錯誤", subTitle: "請先選擇區域")
////                } else if segue == TO_TEXT_INPUT {
////                    var sender: [String: Any] = [String: Any]()
////                    sender["key"] = key
////                    if row["sender"] != nil {
////                        sender["sender"] = row["sender"]
////                    }
////                    performSegue(withIdentifier: segue, sender: sender)
////                } else {
////                    performSegue(withIdentifier: segue, sender: row["sender"])
////                }
//            }
//        } else {
//            cell.editText.becomeFirstResponder()
//        }
    }
    
    func submit(_ sender: Any) {
        
        var action = "UPDATE"
        if token != nil && token!.count == 0 {
            action = "INSERT"
        }
        
        var msg: String = ""
        for section in oneSections {
            for row in section.items {
                params[row.key] = row.value
                if row.isRequired && row.show.count == 0 {
                    msg += row.msg + "\n"
                }
            }
        }
        
        if msg.count > 0 {
            warning(msg)
        } else {
            //print(params)
            if action == "INSERT" {
                params[CREATED_ID_KEY] = String(Member.instance.id)
            }
            
            if token != nil && token!.count > 0 {
                params["token"] = token!
            }
            
            //params["do"] = "update"
            
            //print(params)
            let image: UIImage? = isFeaturedChange ? featuredView.imageView.image : nil
            dataService.update(_params: params, image: image) { (success) in
                if success {
                    
                    self.jsonData = self.dataService.jsonData
                    do {
                        if (self.jsonData != nil) {
                            let table: SuccessTable = try JSONDecoder().decode(SuccessTable.self, from: self.jsonData!)
                            if table.success {
                                self.info(msg: "修改成功", buttonTitle: "關閉") {
                                    if self.delegate != nil {
                                        self.delegate!.refresh()
                                        self.prev()
                                    }
                                }
                            } else {
                                self.warning(table.msg)
                            }
                        } else {
                            self.warning("無法從伺服器取得正確的json資料，請洽管理員")
                        }
                    } catch {
                        self.warning("解析JSON字串時，得到空值，請洽管理員")
                    }
                } else {
                    self.warning("新增 / 修改失敗，伺服器無法新增成功，請稍後再試")
                }
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
//        if delegate != nil {
//            delegate!.isReload(false)
//        }
        prev()
    }
    
    @IBAction override func prevBtnPressed(_ sender: Any) {
//        if delegate != nil {
//            delegate!.isReload(false)
//        }
        prev()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImage: UIImage?
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
        }
        featuredView.setPickedImage(image: selectedImage!)
        picker.dismiss(animated: true, completion: nil)
    }
    
    // ImagePickerDelegate
    func isImageSet(_ b: Bool) {
        isFeaturedChange = b
    }
    
    func myPresent(_ viewController: UIViewController) {
        self.present(viewController, animated: true, completion: nil)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        var destinationNavigationController: UINavigationController?
//        if segue.identifier == TO_CITY {
//            let citySelectVC: CitySelectVC = segue.destination as! CitySelectVC
//            citySelectVC.delegate = self
//            let tmp = sender as! Int
//            if tmp > 0 {
//                citySelectVC.citys = [City(id: tmp, name: "")]
//            }
//        } else if segue.identifier == TO_ARENA {
////            let arenaSelectVC: ArenaSelectVC = segue.destination as! ArenaSelectVC
////            arenaSelectVC.delegate = self
////            let tmp = sender as! [String: Int]
////            if tmp["city_id"] != nil {
////                let citys: [Int] = [tmp["city_id"]!]
////                arenaSelectVC.citys = citys
////            }
////            if tmp["arena_id"] != nil {
////                let arenas: [Arena] = [Arena(id:tmp["arena_id"]!, name:"")]
////                arenaSelectVC.arenas = arenas
////            }
//        } else if segue.identifier == TO_SELECT_WEEKDAY {
//            let weekdaysSelectVC: WeekdaysSelectVC = segue.destination as! WeekdaysSelectVC
//            weekdaysSelectVC.selecteds = (sender as! [Int])
//            weekdaysSelectVC.delegate = self
//        } else if segue.identifier == TO_SELECT_TIME {
//            let timeSelectVC: TimeSelectVC = segue.destination as! TimeSelectVC
//            timeSelectVC.delegate = self
//            timeSelectVC.input = (sender as! [String: Any])
//        } else if segue.identifier == TO_TEXT_INPUT {
//            destinationNavigationController = (segue.destination as! UINavigationController)
//            let textInputVC: TextInputVC = destinationNavigationController!.topViewController as! TextInputVC
//            textInputVC.delegate = self
//            let _sender = sender as! [String: Any]
//            let input = _sender["sender"] as! [String: Any]
//            textInputVC.input = input
//            let key = _sender["key"] as! String
//            textInputVC.key = key
//        } else if segue.identifier == TO_SELECT_DEGREE {
////            let degreeSelectVC: DegreeSelectVC = segue.destination as! DegreeSelectVC
////            degreeSelectVC.delegate = self
////            degreeSelectVC.degrees = (sender as! [Degree])
//        }
//    }
//
//    @IBAction func cancel(_ sender: Any) {
//        prev()
//    }
//
//    @IBAction func submit(_ sender: Any) {
//        var params:[String: Any]!
//        var isPass: Bool = true
//        let name: String = model.data[NAME_KEY]!["value"] as! String
//        if name.count == 0 {
//            isPass = false
//            SCLAlertView().showWarning("提示", subTitle: "請填寫名稱")
//        }
//        let mobile: String = model.data[MOBILE_KEY]!["value"] as! String
//        if mobile.count == 0 {
//            isPass = false
//            SCLAlertView().showWarning("提示", subTitle: "請填寫電話")
//        }
//        //print(isPass)
//        //print(model.data)
//        if isPass {
//            params = model.makeSubmitArr()
//            if params.count == 0 && !isFeaturedChange {
//                SCLAlertView().showWarning("提示", subTitle: " 沒有修改任何資料或圖片")
//            } else {
//                if params.count == 0 { // just update image
//                    params[CREATED_ID_KEY] = Member.instance.id
//                    if model.data[ID_KEY]!["value"] != nil {
//                        let id: Int = model.data[ID_KEY]!["value"] as! Int
//                        params[ID_KEY] = id
//                    }
//                }
//                //print(params)
//                Global.instance.addSpinner(superView: self.view)
//
//                //print(isFeaturedChange)
//                let image: UIImage? = isFeaturedChange ? featuredView.imageView.image : nil
//                dataService.update(type: source, params: params, image, key: "file", filename: "test.jpg", mimeType: "image/jpeg") { (success) in
//                    Global.instance.removeSpinner(superView: self.view)
//                    if success {
//                        if self.dataService.success {
//                            let id: Int = self.dataService.id
//                            self.model.data[ID_KEY]!["value"] = id
//                            self.model.data[ID_KEY]!["show"] = id
//                            //print(self.id)
//                            //if self.id > 0 {
//                            let appearance = SCLAlertView.SCLAppearance(
//                                showCloseButton: false
//                            )
//                            let alert = SCLAlertView(appearance: appearance)
//                            if (self.action == "INSERT") {
//                                alert.addButton("確定", action: {
//                                    self.dismiss(animated: true, completion: nil)
//                                })
//                            } else {
//                                alert.addButton("回上一頁", action: {
//                                    self.dismiss(animated: true, completion: nil)
//                                })
//                                alert.addButton("繼續修改", action: {
//                                })
//                            }
//                            alert.showSuccess("成功", subTitle: "新增 / 修改成功")
//                            NotificationCenter.default.post(name: NOTIF_TEAM_UPDATE, object: nil)
//                        } else {
//                            SCLAlertView().showWarning("錯誤", subTitle: self.dataService.msg)
//                        }
//                    } else {
//                        SCLAlertView().showWarning("錯誤", subTitle: "新增 / 修改失敗，伺服器無法新增成功，請稍後再試")
//                    }
//                }
//            }
//        }
//    }
//    func setCityData(id: Int, name: String) {
//        let city_id: Int = model.data[CITY_KEY]!["value"] as! Int
//        if city_id != id {
//            let city = City(id: id, name: name)
//            model.updateCity(city)
//            model.data[CITY_KEY]!["change"] = true
//            self.tableView.reloadData()
//        }
//    }
//    func setCitysData(res: [City])
//    {
//        //not use
//    }
//    override func setArenaData(res: [ArenaTable]) {
////        let arena_id: Int = model.data[ARENA_KEY]!["value"] as! Int
////        if arena_id != id {
////            let arena = Arena(id: id, name: name)
////            model.updateArena(arena)
////            model.data[ARENA_KEY]!["change"] = true
////            self.tableView.reloadData()
////        }
//    }
//    func setArenasData(res: [Arena])
//    {
//        //not use
//    }
//    override func setWeekdaysData(selecteds: [Int]) {
//        let days: [Int] = model.data[TEAM_WEEKDAYS_KEY]!["value"] as! [Int]
//        if !selecteds.containsSameElements(as: days) {
//            model.updateWeekdays(selecteds)
//            model.data[TEAM_WEEKDAYS_KEY]!["change"] = true
//            self.tableView.reloadData()
//        }
//    }
//    override func setTimeData(res: [String], type: SELECT_TIME_TYPE, indexPath: IndexPath?) {
//        let time = res[0]
//        switch type {
//        case SELECT_TIME_TYPE.play_start:
//            let key = TEAM_PLAY_START_KEY
//            var start: String = model.data[key]!["value"] as! String
//            start = start.noSec()
//            if start != time {
//                model.updateTime(key: key, time)
//                model.data[key]!["change"] = true
//                self.tableView.reloadData()
//            }
//            break
//        case SELECT_TIME_TYPE.play_end:
//            let key = TEAM_PLAY_END_KEY
//            var end: String = model.data[key]!["value"] as! String
//            end = end.noSec()
//            if end != time {
//                model.updateTime(key: key, time)
//                model.data[key]!["change"] = true
//                self.tableView.reloadData()
//            }
//            break
//        }
//    }
//    func setTextInputData(key: String, type: TEXT_INPUT_TYPE, text: String, indexPath: IndexPath?) {
//        let old: String = model.data[key]!["value"] as! String
//        if old != text {
//            model.data[key]!["change"] = true
//            model.updateText(key: key, text: text)
//            tableView.reloadData()
//        }
//        //print(model.data)
//    }
//
//    override func setDegreeData(res: [DEGREE]) {
////        let old: [String] = model.data[TEAM_DEGREE_KEY]!["value"] as! [String]
////        var res1: [String] = [String]()
////        for degree in res {
////            res1.append(DEGREE.DBValue(degree.value))
////        }
////        if !res1.containsSameElements(as: old) {
////            model.updateDegree(res)
////            model.data[TEAM_DEGREE_KEY]!["change"] = true
////            self.tableView.reloadData()
////        }
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//        var selectedImage: UIImage?
//        if let editedImage = info[.editedImage] as? UIImage {
//            selectedImage = editedImage
//        } else if let originalImage = info[.originalImage] as? UIImage {
//            selectedImage = originalImage
//        }
//        featuredView.setPickedImage(image: selectedImage!)
//        picker.dismiss(animated: true, completion: nil)
//    }
//
//    // ImagePickerDelegate
//    func isImageSet(_ b: Bool) {
//        //isFeaturedChange = b
//    }
//    func myPresent(_ viewController: UIViewController) {
//        self.present(viewController, animated: true, completion: nil)
//    }
//
//    func _getRowByindexPath(indexPath: IndexPath) -> [String: Any] {
//        var section: Int = -1
//        var row: Int = -1
//        var res: [String: Any]?
//        for (_, value) in model.data {
//            if value["section"] != nil {
//                section = value["section"] as! Int
//            }
//            if value["row"] != nil {
//                row = value["row"] as! Int
//            }
//            if section == indexPath.section && row == indexPath.row {
//                res = value
//                break
//            }
//        }
//        return res!
//    }
//    override func setTextField(key: String, value: String) {
//        for (key, _) in model.data {
//            if key == iden {
//                let item: [String: Any] = model.data[key]!
//                let oldValue: Any = item["value"] as Any
//                let vtype: String = item["vtype"] as! String
//                if vtype == "String" {
//                    model.data[key]!["value"] = value
//                    if oldValue as! String != value {
//                        model.data[key]!["change"] = true
//                    }
//                } else if vtype == "Int" {
//                    var value1: Int = -1
//                    if value.count > 0 {
//                        value1 = Int(value)!
//                    }
//                    model.data[key]!["value"] = value1
//                    if oldValue as! Int != value1 {
//                        model.data[key]!["change"] = true
//                    }
//                } else if vtype == "Bool" {
//                    if value.count > 0 {
//                        let value1: Bool = Bool(value)!
//                        model.data[key]!["value"] = value1
//                        if oldValue as! Bool != value1 {
//                            model.data[key]!["change"] = true
//                        }
//                    }
//                }
//                model.data[key]!["show"] = value
//            }
//        }
//        //print(model.data)
//    }
//
//    override func clear(indexPath: IndexPath) {
//        let dataRow = _getRowByindexPath(indexPath: indexPath)
//        if dataRow["atype"] != nil && (dataRow["atype"] as! UITableViewCell.AccessoryType == .disclosureIndicator) {
//            if dataRow["key"] != nil {
//                let key = dataRow["key"] as! String
//                //print(key)
//                if (key == CITY_KEY) {
//                    updateCity()
//                    updateArena()
//                    tableView.reloadData()
//                } else if (key == ARENA_KEY) {
//                    updateArena()
//                } else if (key == TEAM_WEEKDAYS_KEY) {
//                    updateDays()
//                } else if (key == TEAM_PLAY_START_KEY || key == TEAM_PLAY_END_KEY) {
//                    updateTime(type: key, time:nil)
//                } else if (key == TEAM_DEGREE_KEY) {
//                    updateDegree()
//                } else if (key == TEAM_TEMP_CONTENT_KEY || key == CHARGE_KEY || key == CONTENT_KEY) {
//                    updateText(key: key)
//                }
//                model.data[key]!["change"] = true
//            }
//        }
//    }
//
//    func updateCity(citys: [City]?=nil) {
//        if (citys != nil && (citys?.count)! > 0) {
//            let city = citys![0]
//            model.updateCity(city)
//        } else {
//            model.updateCity()
//        }
//    }
//
//    func updateArena(arenas: [Arena]?=nil) {
//        if (arenas != nil && (arenas?.count)! > 0) {
//            let id = arenas![0].id
//            let name = arenas![0].title
//            let arena = Arena(id: id, name: name)
//            model.updateArena(arena)
//        } else {
//            model.updateArena()
//        }
//    }
//
//    func updateDays(days: [Int]? = nil) {
//        if (days != nil && (days?.count)! > 0) {
//            model.updateWeekdays(days!)
//        } else {
//            model.updateWeekdays()
//        }
//    }
//
//    func updateTime(type: String, time: String?=nil) {
//        switch (type) {
//        case TEAM_PLAY_START_KEY:
//            model.updateTime(key: TEAM_PLAY_START_KEY, time)
//            break
//        case TEAM_PLAY_END_KEY:
//            model.updateTime(key: TEAM_PLAY_END_KEY, time)
//            break
//        default:
//            model.updateTime(key: TEAM_PLAY_START_KEY, time)
//        }
//    }
//
//    func updateDegree(degrees: [Degree]?=nil) {
//        if (degrees != nil && (degrees?.count)! > 0) {
//            model.updateDegree(degrees!)
//        } else {
//            model.updateDegree()
//        }
//    }
//
//    func updateText(key: String, content: String?=nil) {
//        model.updateText(key: key, text: content)
//    }
}
