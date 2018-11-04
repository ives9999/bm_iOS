//
//  TeamEditVC.swift
//  bm
//
//  Created by ives on 2017/11/9.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class EditVC: MyTableVC, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CitySelectDelegate, ArenaSelectDelegate, DaysSelectDelegate, TimeSelectDelegate, TextInputDelegate, DegreeSelectDelegate, ImagePickerViewDelegate, EditCellDelegate {
    
    // Outlets
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var featuredView: ImagePickerView!
    @IBOutlet weak var submitBtn: UIButton!
    
    var imagePicker: UIImagePickerController = UIImagePickerController()
    var token: String = ""
    var isFeaturedChange: Bool = false
    var model: SuperData = Team.instance
    var action: String = "INSERT"
    var source: String = "team"
    var ch: String = "球隊"
    
    override func viewDidLoad() {
        //print("token: \(token)")
 
        //let token: String = model.data[TEAM_TOKEN_KEY]!["value"] as! String
        if source == "team" {
            model = Team.instance
            dataService = TeamService.instance
            ch = "球隊"
        } else if source == "coach" {
            model = Coach.instance
            dataService = CoachService.instance
            ch = "教練"
        } else if source == "arena" {
            model = Arena.instance
            dataService = ArenaService.instance
            ch = "球館"
        }
        
        if token.count > 0 {
            action = "UPDATE"
            //model.neverFill()
            Global.instance.addSpinner(superView: self.view)
            dataService.getOne(type: source, token: token, completion: { (success) in
                if success {
                    Global.instance.removeSpinner(superView: self.view)
                    self.titleLbl.text = (self.model.data[NAME_KEY]!["value"] as! String)
                    //print(self.model.data)
                    self.tableView.reloadData()
                    if let pickedImage: UIImage = self.model.data[FEATURED_KEY]!["value"] as? UIImage {
                        self.featuredView.setPickedImage(image: pickedImage)
                    }
                    //self.featuredView.imageView.image = (model.data[TEAM_FEATURED_KEY]!["value"] as! UIImage)
                }
            })
        } else {
            model.initData()
        }
 
        
        //print(_rows)
        //setData(sections: model.sections, rows: _rows)
        sections = model.sections
        myTablView = tableView
        super.viewDidLoad()
        
        submitBtn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 20, bottom: 6, right: 20)
        submitBtn.layer.cornerRadius = 12
        
        tableView.register(EditCell.self, forCellReuseIdentifier: "cell")
        
        imagePicker.delegate = self
        featuredView.gallery = imagePicker
        featuredView.delegate = self
        
        //print(model.data)
        
        hideKeyboardWhenTappedAround()
        Global.instance.addSpinner(superView: self.view)
        Global.instance.removeSpinner(superView: self.view)
        
        
        if (action == "UPDATE") {
            titleLbl.text = "更新" + ch
        } else {
            titleLbl.text = "新增" + ch
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int = 0
        for (_, value) in model.data {
            if value["section"] != nil {
                let _section: Int = value["section"] as! Int
                if section == _section {
                    if value["row"] != nil {
                        count += 1
                    }
                }
            }
        }
        //print("section: \(section), count: \(count)")
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //print("section: \(indexPath.section), row: \(indexPath.row)")
        let cell: EditCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EditCell
        cell.editCellDelegate = self
        let row: [String: Any] = _getRowByindexPath(indexPath: indexPath)
        //print(row)
        //if indexPath.section == 0 && indexPath.row == 0 {
            //print(row)
        //}
        cell.forRow(indexPath: indexPath, row: row)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Global.instance.addSpinner(superView: view)
        Global.instance.removeSpinner(superView: view)
        let row: [String: Any] = _getRowByindexPath(indexPath: indexPath)
        let cell = tableView.cellForRow(at: indexPath) as! EditCell
        if row["atype"] as! UITableViewCellAccessoryType != UITableViewCellAccessoryType.none {
            if row["segue"] != nil {
                let segue: String = row["segue"] as! String
                //print(iden)
                let city: Int = model.data[CITY_KEY]!["value"] as! Int
                if segue == TO_ARENA && city == 0 {
                    SCLAlertView().showError("錯誤", subTitle: "請先選擇區域")
                } else {
                    performSegue(withIdentifier: segue, sender: row["sender"])
                }
            }
        } else {
            cell.generalTextField.becomeFirstResponder()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            featuredView.setPickedImage(image: pickedImage)
            isFeaturedChange = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationNavigationController: UINavigationController?
        if segue.identifier == TO_CITY {
            destinationNavigationController = (segue.destination as! UINavigationController)
            let citySelectVC: CitySelectVC = destinationNavigationController!.topViewController as! CitySelectVC
            citySelectVC.delegate = self
            let tmp = sender as! Int
            if tmp > 0 {
                citySelectVC.citys = [City(id: tmp, name: "")]
            }
        } else if segue.identifier == TO_ARENA {
            destinationNavigationController = (segue.destination as! UINavigationController)
            let arenaSelectVC: ArenaSelectVC = destinationNavigationController!.topViewController as! ArenaSelectVC
            arenaSelectVC.delegate = self
            let tmp = sender as! [String: Int]
            if tmp["city_id"] != nil {
                let citys: [Int] = [tmp["city_id"]!]
                arenaSelectVC.citys = citys
            }
            if tmp["arena_id"] != nil {
                let arenas: [Arena] = [Arena(id:tmp["arena_id"]!, name:"")]
                arenaSelectVC.arenas = arenas
            }
        } else if segue.identifier == TO_DAY {
            destinationNavigationController = (segue.destination as! UINavigationController)
            let daysSelectVC: DaysSelectVC = destinationNavigationController!.topViewController as! DaysSelectVC
            daysSelectVC.selectedDays = (sender as! [Int])
            daysSelectVC.delegate = self
        } else if segue.identifier == TO_SELECT_TIME {
            destinationNavigationController = (segue.destination as! UINavigationController)
            let timeSelectVC: TimeSelectVC = destinationNavigationController!.topViewController as! TimeSelectVC
            timeSelectVC.delegate = self
            timeSelectVC.input = (sender as! [String: Any])
        } else if segue.identifier == TO_TEXT_INPUT {
            destinationNavigationController = (segue.destination as! UINavigationController)
            let textInputVC: TextInputVC = destinationNavigationController!.topViewController as! TextInputVC
            textInputVC.delegate = self
            textInputVC.input = (sender as! [String: Any])
        } else if segue.identifier == TO_SELECT_DEGREE {
            destinationNavigationController = (segue.destination as! UINavigationController)
            let degreeSelectVC: DegreeSelectVC = destinationNavigationController!.topViewController as! DegreeSelectVC
            degreeSelectVC.delegate = self
            degreeSelectVC.degrees = (sender as! [Degree])
        }
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        prev()
    }
    
    @IBAction func submit(_ sender: Any) {
        var params:[String: Any]!
        var isPass: Bool = true
        let name: String = model.data[NAME_KEY]!["value"] as! String
        if name.count == 0 {
            isPass = false
            SCLAlertView().showWarning("提示", subTitle: "請填寫隊名")
        }
        let mobile: String = model.data[MOBILE_KEY]!["value"] as! String
        if mobile.count == 0 {
            isPass = false
            SCLAlertView().showWarning("提示", subTitle: "請填寫電話")
        }
        //print(isPass)
        //print(model.data)
        if isPass {
            params = model.makeSubmitArr()
            if params.count == 0 && !isFeaturedChange {
                SCLAlertView().showWarning("提示", subTitle: " 沒有修改任何資料或圖片")
            } else {
                if params.count == 0 { // just update image
                    params[CREATED_ID_KEY] = Member.instance.id
                    if model.data[ID_KEY]!["value"] != nil {
                        let id: Int = model.data[ID_KEY]!["value"] as! Int
                        params[ID_KEY] = id
                    }
                }
                //print(params)
                Global.instance.addSpinner(superView: self.view)
                
                //print(isFeaturedChange)
                let image: UIImage? = isFeaturedChange ? featuredView.imageView.image : nil
                dataService.update(type: source, params: params, image, key: "file", filename: "test.jpg", mimeType: "image/jpeg") { (success) in
                    Global.instance.removeSpinner(superView: self.view)
                    if success {
                        if self.dataService.success {
                            let id: Int = self.dataService.id
                            self.model.data[ID_KEY]!["value"] = id
                            self.model.data[ID_KEY]!["show"] = id
                            //print(self.id)
                            //if self.id > 0 {
                            let appearance = SCLAlertView.SCLAppearance(
                                showCloseButton: false
                            )
                            let alert = SCLAlertView(appearance: appearance)
                            if (self.action == "INSERT") {
                                alert.addButton("確定", action: {
                                    self.dismiss(animated: true, completion: nil)
                                })
                            } else {
                                alert.addButton("回上一頁", action: {
                                    self.dismiss(animated: true, completion: nil)
                                })
                                alert.addButton("繼續修改", action: {
                                })
                            }
                            alert.showSuccess("成功", subTitle: "新增 / 修改成功")
                            NotificationCenter.default.post(name: NOTIF_TEAM_UPDATE, object: nil)
                        } else {
                            SCLAlertView().showWarning("錯誤", subTitle: self.dataService.msg)
                        }
                    } else {
                        SCLAlertView().showWarning("錯誤", subTitle: "新增 / 修改失敗，伺服器無法新增成功，請稍後再試")
                    }
                }
            }
        }
    }
    func setCityData(id: Int, name: String) {
        let city_id: Int = model.data[CITY_KEY]!["value"] as! Int
        if city_id != id {
            let city = City(id: id, name: name)
            model.updateCity(city)
            model.data[CITY_KEY]!["change"] = true
            self.tableView.reloadData()
        }
    }
    func setCitysData(res: [City])
    {
        //not use
    }
    func setArenaData(id: Int, name: String) {
        let arena_id: Int = model.data[ARENA_KEY]!["value"] as! Int
        if arena_id != id {
            let arena = Arena(id: id, name: name)
            model.updateArena(arena)
            model.data[ARENA_KEY]!["change"] = true
            self.tableView.reloadData()
        }
    }
    func setArenasData(res: [Arena])
    {
        //not use
    }
    func setDaysData(res: [Int]) {
        let days: [Int] = model.data[TEAM_DAYS_KEY]!["value"] as! [Int]
        if !res.containsSameElements(as: days) {
            model.updateDays(res)
            model.data[TEAM_DAYS_KEY]!["change"] = true
            self.tableView.reloadData()
        }
    }
    func setTimeData(time: String, type: SELECT_TIME_TYPE) {
        switch type {
        case SELECT_TIME_TYPE.play_start:
            var start: String = model.data[TEAM_PLAY_START_KEY]!["value"] as! String
            start = start.noSec()
            if start != time {
                model.updatePlayStartTime(time)
                model.data[TEAM_PLAY_START_KEY]!["change"] = true
                self.tableView.reloadData()
            }
            break
        case SELECT_TIME_TYPE.play_end:
            var end: String = model.data[TEAM_PLAY_END_KEY]!["value"] as! String
            end = end.noSec()
            if end != time {
                model.updatePlayEndTime(time)
                model.data[TEAM_PLAY_END_KEY]!["change"] = true
                self.tableView.reloadData()
            }
            break
        }
    }
    func setTextInputData(text: String, type: TEXT_INPUT_TYPE) {
        switch type {
        case TEXT_INPUT_TYPE.temp_play:
            let old: String = model.data[TEAM_TEMP_CONTENT_KEY]!["value"] as! String
            if old != text {
                model.updateTempContent(text)
                model.data[TEAM_TEMP_CONTENT_KEY]!["change"] = true
                self.tableView.reloadData()
            }
            break
        case TEXT_INPUT_TYPE.charge:
            let old: String = model.data[CHARGE_KEY]!["value"] as! String
            if old != text {
                model.updateCharge(text)
                model.data[CHARGE_KEY]!["change"] = true
                self.tableView.reloadData()
            }
            break
        case TEXT_INPUT_TYPE.team:
            let old: String = model.data[CONTENT_KEY]!["value"] as! String
            if old != text {
                model.updateContent(text)
                model.data[CONTENT_KEY]!["change"] = true
                self.tableView.reloadData()
            }
            break
            
        case .exp:
            
            break
        case .feat:
            break
        case .license:
            break
        case .coach:
            break
        }
        //print(model.data)
    }
    func setDegreeData(res: [Degree]) {
        let old: [String] = model.data[TEAM_DEGREE_KEY]!["value"] as! [String]
        var res1: [String] = [String]()
        for degree in res {
            res1.append(DEGREE.DBValue(degree.value))
        }
        if !res1.containsSameElements(as: old) {
            model.updateDegree(res)
            model.data[TEAM_DEGREE_KEY]!["change"] = true
            self.tableView.reloadData()
        }
    }
    // ImagePickerDelegate
    func isImageSet(_ b: Bool) {
        //isFeaturedChange = b
    }
    func myPresent(_ viewController: UIViewController) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func _getRowByindexPath(indexPath: IndexPath) -> [String: Any] {
        var section: Int = -1
        var row: Int = -1
        var res: [String: Any]?
        for (_, value) in model.data {
            if value["section"] != nil {
                section = value["section"] as! Int
            }
            if value["row"] != nil {
                row = value["row"] as! Int
            }
            if section == indexPath.section && row == indexPath.row {
                res = value
                break
            }
        }
        return res!
    }
    func setTextField(iden: String, value: String) {
        for (key, _) in model.data {
            if key == iden {
                let item: [String: Any] = model.data[key]!
                let oldValue: Any = item["value"] as Any
                let vtype: String = item["vtype"] as! String
                if vtype == "String" {
                    model.data[key]!["value"] = value
                    if oldValue as! String != value {
                        model.data[key]!["change"] = true
                    }
                } else if vtype == "Int" {
                    var value1: Int = -1
                    if value.count > 0 {
                        value1 = Int(value)!
                    }
                    model.data[key]!["value"] = value1
                    if oldValue as! Int != value1 {
                        model.data[key]!["change"] = true
                    }
                } else if vtype == "Bool" {
                    if value.count > 0 {
                        let value1: Bool = Bool(value)!
                        model.data[key]!["value"] = value1
                        if oldValue as! Bool != value1 {
                            model.data[key]!["change"] = true
                        }
                    }
                }
                model.data[key]!["show"] = value
            }
        }
        //print(model.data)
    }
    func setSwitch(indexPath: IndexPath, value: Bool) {
    }
}
