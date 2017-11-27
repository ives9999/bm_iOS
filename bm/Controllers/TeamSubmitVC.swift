//
//  TeamSubmitVC.swift
//  bm
//
//  Created by ives on 2017/11/9.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import SCLAlertView

class TeamSubmitVC: MyTableVC, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CitySelectDelegate, ArenaSelectDelegate, DaysSelectDelegate, TimeSelectDelegate, TextInputDelegate, DegreeSelectDelegate, ImagePickerViewDelegate, TeamSubmitCellDelegate {
    
    // Outlets
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var featuredView: ImagePickerView!
    
    var imagePicker: UIImagePickerController = UIImagePickerController()
    var token: String = ""
    
    /*
    var id: Int = 0
    var token: String = ""
    var name: String = ""
    var leader: String = ""
    var mobile: String = ""
    var email: String = ""
    var temp_fee_M: Int = -1
    var temp_fee_F: Int = -1
    var ball: String = ""
    
    var city_id: Int = 0
    var city_name: String = ""
    var selectedCity: City = City(id: 0, name: "")
    var selectedArena: Arena = Arena(id: 0, name: "")
    var selectedDays: [Int: String] = [Int: String]()
    var selectedStartTime: String = ""
    var selectedEndTime: String = ""
    var temp_content: String = ""
    var degree: [DEGREE] = [DEGREE]()
    var charge: String = ""
    var content: String = ""
 */
    
    override func viewDidLoad() {
        //print(Team.instance.data)
        //print(token)
        /*name = "快樂羽球隊"
        leader = "孫志煌"
        mobile = "0911299994"
        email = "ives@housetube.tw"
        temp_fee_M = 150
        temp_fee_F = 100
        ball = "RSL 4"
        
        temp_content = "請勿報名沒有來，列入黑名單"
        charge = "一季3600含球"
        content = "歡迎加入"
        selectedStartTime = "16:00"
        selectedEndTime = "18:00"
        degree = [DEGREE.high, DEGREE.soso]
        selectedDays = [2: "星期二", 4:"星期四"]
        selectedCity = City(id: 218, name: "台南")
        selectedArena = Arena(id: 10, name: "全穎羽球館")*/
        
        
        /*
        var tmp:[String] = [String]()
        for (_, value) in selectedDays {
            tmp.append(value)
        }
        let textDay = tmp.joined(separator: ", ")
        tmp = [String]()
        for key in degree {
            let value = key.rawValue
            tmp.append(value)
        }
        let textDegree = tmp.joined(separator: ", ")
        */
        
 
        //let token: String = Team.instance.data[TEAM_TOKEN_KEY]!["value"] as! String
        if token.count > 0 {
            Global.instance.addSpinner(superView: self.view)
            TeamService.instance.getOne(type: "team", token: token, completion: { (success) in
                if success {
                    Global.instance.removeSpinner(superView: self.view)
                    //print(Team.instance.data)
                    Team.instance.extraShow()
                    print(Team.instance.data)
                    self.tableView.reloadData()
                }
            })
        }
        
        //print(_rows)
        //setData(sections: Team.instance.sections, rows: _rows)
        sections = Team.instance.sections
        myTablView = tableView
        super.viewDidLoad()
        
        tableView.register(TeamSubmitCell.self, forCellReuseIdentifier: "cell")
        
        imagePicker.delegate = self
        featuredView.gallery = imagePicker
        featuredView.delegate = self
        
        hideKeyboardWhenTappedAround()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int = 0
        for (_, value) in Team.instance.data {
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
        let cell: TeamSubmitCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TeamSubmitCell
        cell.delegate = self
        
        let row: [String: Any] = _getRowByindexPath(indexPath: indexPath)
//        if indexPath.section == 0 && indexPath.row == 0 {
//            print(row)
//        }
        cell.forRow(row: row)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let row: [String: Any] = _getRowByindexPath(indexPath: indexPath)
        let cell = tableView.cellForRow(at: indexPath) as! TeamSubmitCell
        if row["atype"] as! UITableViewCellAccessoryType != UITableViewCellAccessoryType.none {
            if row["segue"] != nil {
                let segue: String = row["segue"] as! String
                //print(iden)
                let city: Int = Team.instance.data[TEAM_CITY_KEY]!["value"] as! Int
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
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationNavigationController: UINavigationController?
        if segue.identifier == TO_CITY {
            destinationNavigationController = (segue.destination as! UINavigationController)
            let citySelectVC: CitySelectVC = destinationNavigationController!.topViewController as! CitySelectVC
            citySelectVC.delegate = self
            citySelectVC.city_id = (sender as! Int)
        } else if segue.identifier == TO_ARENA {
            destinationNavigationController = (segue.destination as! UINavigationController)
            let arenaSelectVC: ArenaSelectVC = destinationNavigationController!.topViewController as! ArenaSelectVC
            arenaSelectVC.delegate = self
            arenaSelectVC.selectedID = (sender as! [String: Int])
        } else if segue.identifier == TO_DAY {
            destinationNavigationController = (segue.destination as! UINavigationController)
            let daysSelectVC: DaysSelectVC = destinationNavigationController!.topViewController as! DaysSelectVC
            daysSelectVC.selectedDays = (sender as! [Int])
            daysSelectVC.delegate = self
        } else if segue.identifier == TO_SELECT_TIME {
            destinationNavigationController = (segue.destination as! UINavigationController)
            let timeSelectVC: TimeSelectVC = destinationNavigationController!.topViewController as! TimeSelectVC
            timeSelectVC.delegate = self
            timeSelectVC.type = sender as! SELECT_TIME_TYPE
        } else if segue.identifier == TO_TEXT_INPUT {
            destinationNavigationController = (segue.destination as! UINavigationController)
            let textInputVC: TextInputVC = destinationNavigationController!.topViewController as! TextInputVC
            textInputVC.delegate = self
            textInputVC.type = sender as! TEXT_INPUT_TYPE
        } else if segue.identifier == TO_SELECT_DEGREE {
            destinationNavigationController = (segue.destination as! UINavigationController)
            let degreeSelectVC: DegreeSelectVC = destinationNavigationController!.topViewController as! DegreeSelectVC
            degreeSelectVC.delegate = self
        }
    }
    
    
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submit(_ sender: Any) {
        var params:[String: Any] = [String: Any]()
        var isPass: Bool = true
        let name: String = Team.instance.data[TEAM_NAME_KEY]!["value"] as! String
        if name.count == 0 {
            isPass = false
            SCLAlertView().showWarning("提示", subTitle: "請填寫隊名")
        }
        let mobile: String = Team.instance.data[TEAM_MOBILE_KEY]!["value"] as! String
        if mobile.count == 0 {
            isPass = false
            SCLAlertView().showWarning("提示", subTitle: "請填寫電話")
        }
        //print(isPass)
        if isPass {
            Global.instance.addSpinner(superView: self.view)
            let id: Int = Team.instance.data["id"]!["value"] as! Int
            if id <= 0 {
        params.merge(["channel":"bm","type":"team","created_id":Member.instance.id,"manager_id":Member.instance.id,"cat_id":21])
            }
            
            /*
            for (index1, row) in _rows.enumerated() {
                for (index2, item) in row.enumerated() {
                    if item["value"] != nil {
                        let key: String = item["key"] as! String
                        params[key] = item["value"]
                    }
                }
            }
 */
            
            /*
            params[TEAM_NAME_KEY] = name
            params[TEAM_SLUG_KEY] = name
            params[TEAM_MOBILE_KEY] = mobile
            params["leader"] = leader
            params["email"] = email
            params["ball"] = ball
            params["temp_fee_M"] = temp_fee_M
            params["temp_fee_F"] = temp_fee_F
            params["charge"] = charge
            params["temp_content"] = temp_content
            params["content"] = content
            params["play_time"] = selectedStartTime + " - " + selectedEndTime
            var _degree: [String] = [String]()
            for value in degree {
                _degree.append(DEGREE.DBValue(value))
            }
            params["degree"] = _degree
            var _days: [Int] = [Int]()
            for (key, _) in selectedDays {
                _days.append(key)
            }
            params["play_day"] = _days
            params["city_id"] = selectedCity.id
            params["arena_id"] = selectedArena.id
            params["featured_id"] = 0
 */
            TeamService.instance.update(params: params, featuredView.imageView.image, key: "file", filename: "test.jpg", mimeType: "image/jpeg") { (success) in
                Global.instance.removeSpinner(superView: self.view)
                if success {
                    if TeamService.instance.success {
                        let id: Int = TeamService.instance.id
                        Team.instance.data[TEAM_ID_KEY]!["value"] = id
                        Team.instance.data[TEAM_ID_KEY]!["show"] = id
                        //print(self.id)
                        //if self.id > 0 {
                        SCLAlertView().showSuccess("成功", subTitle: "新增 / 修改球隊成功")
                    } else {
                        SCLAlertView().showWarning("錯誤", subTitle: TeamService.instance.msg)
                    }
                } else {
                    SCLAlertView().showWarning("錯誤", subTitle: "新增 / 修改球隊失敗，伺服器無法新增成功，請稍後再試")
                }
            }
        }
    }
    func setCityData(id: Int, name: String) {
        let city = City(id: id, name: name)
        Team.instance.updateCity(city)
        self.tableView.reloadData()
    }
    func setArenaData(id: Int, name: String) {
        let arena = Arena(id: id, name: name)
        Team.instance.updateArena(arena)
        self.tableView.reloadData()
    }
    func setDaysData(res: [Int]) {
        Team.instance.updateDays(res)
        self.tableView.reloadData()
    }
    func setTimeData(time: String, type: SELECT_TIME_TYPE) {
        switch type {
        case SELECT_TIME_TYPE.play_start:
            //selectedStartTime = time
            _setSelectedToRows(key: TEAM_PLAY_START_KEY, value: time)
            break
        case SELECT_TIME_TYPE.play_end:
            _setSelectedToRows(key: TEAM_PLAY_END_KEY, value: time)
            //selectedEndTime = time
            break
        }
        self.tableView.reloadData()
    }
    func setTextInputData(text: String, type: TEXT_INPUT_TYPE) {
        switch type {
        case TEXT_INPUT_TYPE.temp_play:
            _setSelectedToRows(key: TEAM_TEMP_CONTENT_KEY, value: text)
            //temp_content = text
            break
        case TEXT_INPUT_TYPE.charge:
            _setSelectedToRows(key: TEAM_CHARGE_KEY, value: text)
            //charge = text
            break
        case TEXT_INPUT_TYPE.team:
            _setSelectedToRows(key: TEAM_CONTENT_KEY, value: text)
            //content = text
            break
            
        }
        self.tableView.reloadData()
    }
    func setDegreeData(degree: [DEGREE]) {
        //self.degree = degree
        var tmp: [String] = [String]()
        for key in degree {
            let value = key.rawValue
            tmp.append(value)
        }
        let text = tmp.joined(separator: ", ")
        //_setSelectedToRows(key: TEAM_DEGREE_KEY, value: text)
        self.tableView.reloadData()
    }
    // ImagePickerDelegate
    func isImageSet(_ b: Bool) {
        //self.isFeaturedSet = b
    }
    func myPresent(_ viewController: UIViewController) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func _getRowByindexPath(indexPath: IndexPath) -> [String: Any] {
        var section: Int = -1
        var row: Int = -1
        var res: [String: Any]?
        for (_, value) in Team.instance.data {
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
    func setTextField(idx: Int, value: String) {
        /*
        for (index1, row) in _rows.enumerated() {
            for (index2, item) in row.enumerated() {
                if item["idx"] as! Int == idx {
                    _rows[index1][index2]["value"] = value
                    _rows[index1][index2]["show"] = value
                }
            }
        }
 */
    }
    
    func _setSelectedToRows(key: String, value: String) {
        /*
        print("key: \(key), value: \(value)")
        for (index1, row) in _rows.enumerated() {
            for (index2, item) in row.enumerated() {
                if item["key"] as! String == key {
                    _rows[index1][index2]["value"] = value
                }
            }
        }
        //print(_rows)
        setData(sections: _sections, rows: _rows)
 */
    }
}
