//
//  TeamSubmitVC.swift
//  bm
//
//  Created by ives on 2017/11/9.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import SCLAlertView

class TeamSubmitVC: MyTableVC, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CityDelegate, ArenaDelegate, DaysDelegate, TimeSelectDelegate, TextInputDelegate, DegreeSelectDelegate, ImagePickerViewDelegate, TeamSubmitCellDelegate {
    
    // Outlets
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var featuredView: ImagePickerView!
    
    var imagePicker: UIImagePickerController = UIImagePickerController()
    
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
    
    let _sections: [String] = ["", "聯絡資訊", "所在地", "打球時間", "臨打說明", "其他說明"]
    var _rows: [[Dictionary<String, Any>]] = [[Dictionary<String, Any>]]()
    var team: Team = Team()
    
    override func viewDidLoad() {
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
        
        let none: UITableViewCellAccessoryType = UITableViewCellAccessoryType.none
        let more: UITableViewCellAccessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        _rows = [
            [
                ["key": TEAM_NAME_KEY,"value":name,"atype":none,"vtype":"String"]
            ],
            [
                ["key": TEAM_LEADER_KEY,"value":leader,"atype":none,"vtype":"String"],
                ["key": TEAM_MOBILE_KEY,"value":mobile,"atype":none,"vtype":"String"],
                ["key": TEAM_EMAIL_KEY,"value":email,"atype":none,"vtype":"String"]
            ],
            [
                ["key": TEAM_CITY_KEY,"value":selectedCity.name,"atype":more,"iden":TO_CITY],
                ["key": TEAM_ARENA_KEY,"value":selectedArena.name,"atype":more,"iden":TO_ARENA,"sender":selectedCity.id]
            ],
            [
                ["key": TEAM_DAY_KEY,"value":textDay,"atype":more,"iden":TO_DAY],
                ["key": TEAM_PLAY_START_KEY,"value":selectedStartTime,"atype":more,"iden":TO_SELECT_TIME,"sender":SELECT_TIME_TYPE.play_start],
                ["key": TEAM_PLAY_END_KEY,"value":selectedEndTime,"atype":more,"iden":TO_SELECT_TIME,"sender":SELECT_TIME_TYPE.play_end]
            ],
            [
                ["key": TEAM_TEMP_FEE_M_KEY,"value":temp_fee_M,"atype":none,"vtype":"Int"],
                ["key": TEAM_TEMP_FEE_F_KEY,"value":temp_fee_F,"atype":none,"vtype":"Int"],
                ["key": TEAM_TEMP_CONTENT_KEY,"value":temp_content,"atype":more,"iden":TO_TEXT_INPUT,"sender":TEXT_INPUT_TYPE.temp_play]
            ],
            [
                ["key": TEAM_BALL_KEY,"value":ball,"atype":none,"vtype":"String"],
                ["key": TEAM_DEGREE_KEY,"value":textDegree,"atype":more,"iden":TO_SELECT_DEGREE],
                ["key": TEAM_CHARGE_KEY,"value":charge,"atype":more,"iden":TO_TEXT_INPUT,"sender":TEXT_INPUT_TYPE.charge],
                ["key": TEAM_CONTENT_KEY,"value":content,"atype":more,"iden":TO_TEXT_INPUT,"sender":TEXT_INPUT_TYPE.team]
            ]
        ]
        
        
        var idx = 1;
        for (index1, row) in _rows.enumerated() {
            for (index2, item) in row.enumerated() {
                let key: String = item["key"] as! String
                let team: [String: Any]? = Team.instance.data[key]
                if team != nil {
                    _rows[index1][index2]["text"] = team?["ch"] as! String
                }
                _rows[index1][index2]["idx"] = idx
                idx += 1
            }
        }
        
        if token.count > 0 {
            Global.instance.addSpinner(superView: self.view)
            TeamService.instance.getOne(type: "team", token: token, completion: { (success) in
                if success {
                    Global.instance.removeSpinner(superView: self.view)
                    self.team = TeamService.instance.team
                    //print(self.team.data)
                    self.name = self.team.data[TEAM_NAME_KEY]!["value"] as! String
                    self._rows[0][0]["value"] = self.name
                    print(self._rows)
                    self.setData(sections: self._sections, rows: self._rows)
                    self.tableView.reloadData()
                }
            })
        }
        
        //print(_rows)
        setData(sections: _sections, rows: _rows)
        myTablView = tableView
        super.viewDidLoad()
        
        tableView.register(TeamSubmitCell.self, forCellReuseIdentifier: "cell")
        
        imagePicker.delegate = self
        featuredView.gallery = imagePicker
        featuredView.delegate = self
        
        hideKeyboardWhenTappedAround()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: TeamSubmitCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TeamSubmitCell
        cell.delegate = self
        
        let row: [String: Any] = rows![indexPath.section][indexPath.row]
        cell.forRow(row: row)
        
        return cell
        
        /*
        var cell: FormCell? = tableView.dequeueReusableCell(withIdentifier: "cell") as? FormCell
        if cell == nil {
            //print("cell is nil")
            cell = FormCell(style: UITableViewCellStyle.value1, reuseIdentifier: "cell")
            cell!.accessoryType = UITableViewCellAccessoryType.none
            cell!.selectionStyle = UITableViewCellSelectionStyle.none
        } else {
            if cell!.subviews.contains(nameTxt) {
                nameTxt.removeFromSuperview()
            }
            if cell!.subviews.contains(leaderTxt) {
                leaderTxt.removeFromSuperview()
            }
            if cell!.subviews.contains(mobileTxt) {
                mobileTxt.removeFromSuperview()
            }
            if cell!.subviews.contains(emailTxt) {
                emailTxt.removeFromSuperview()
            }
            if cell!.subviews.contains(tempFeeMTxt) {
                tempFeeMTxt.removeFromSuperview()
            }
            if cell!.subviews.contains(tempFeeFTxt) {
                tempFeeFTxt.removeFromSuperview()
            }
            if cell!.subviews.contains(ballTxt) {
                ballTxt.removeFromSuperview()
            }
            cell!.textLabel?.text = ""
            cell!.detailTextLabel?.text = ""
            cell!.accessoryType = .none
        }
        
        let row: [String: Any] = rows![indexPath.section][indexPath.row]
        let key: String = row["key"] as! String
        var team: [String: String]? = Team.instance.info[key]
        if team == nil {
            team = [String: String]()
        }
        var field: String = ""
        //var data: String = ""
        if let tmp: String = team?["ch"] {
            field = tmp
        }
        cell!.textLabel!.text = field
        let cellFrame: CGRect = cell!.bounds
        //print("cell width: \(cellFrame.width)")
        let yPadding: CGFloat = 5
        //let xPadding: CGFloat = 20
        //let xLabelWidth: CGFloat = 50
        //let xLabelWidth: CGFloat = cell!.textLabel!.frame.size.width
        //print("xLabelWidth: \(xLabelWidth)")
        let txtWidth: CGFloat = 280
        let txtHeight: CGFloat = cellFrame.height - 8
        //print("txtWidth: \(txtWidth)")
        let x = cell_width! - txtWidth
        //print("x: \(x)")
        let editFrame: CGRect = CGRect(x: x, y: yPadding, width: txtWidth, height: txtHeight)
        
        switch indexPath.section {
        case 0:  //名稱
            switch indexPath.row {
            case 0:
                nameTxt.frame = editFrame
                cell!.addSubview(nameTxt)
                break
            default:
                print("default")
            }
            break;
        case 1:  //聯絡資訊
            //let width: CGFloat = 250
            //editFrame = CGRect(x: cellFrame.width - width, y: 0, width: width, height: cellFrame.height)
            var txt: SuperTextField = SuperTextField()
            switch indexPath.row {
            case 0:
//                let leaderLbl: MyLabel = MyLabel(frame: editFrame)
//                leaderLbl.text = Member.instance.nickname
//                leaderLbl.setupView()
//                leaderLbl.frame = leaderLbl.frame.setX(cell_width! - leaderLbl.frame.width - 10)
                //print(leaderLbl.frame.width)
                //leaderLbl.backgroundColor = UIColor.black
                //leaderLbl.textAlignment = .right
                //print(Member.instance.nickname)
                //cell!.addSubview(leaderLbl)
                leaderTxt.frame = editFrame
                txt = leaderTxt
                cell!.addSubview(txt)
                break
            case 1:
                mobileTxt.frame = editFrame
                txt = mobileTxt
                cell!.addSubview(txt)
                break
            case 2:
                emailTxt.frame = editFrame
                txt = emailTxt
                cell!.addSubview(txt)
                break
            default:
                print("default")
            }
            break;
        case 2:  //所在地
            switch indexPath.row {
            case 0:
                if selectedCity.name.count > 0 {
                    cell!.detailTextLabel?.text = selectedCity.name
                }
                break
            case 1:
                if selectedArena.name.count > 0 {
                    cell!.detailTextLabel?.text = selectedArena.name
                }
                break
            default:
                print("default")
            }
            cell!.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            break
        case 3:  //打球時間
            switch indexPath.row {
            case 0:
                var res: [String] = [String]()
                for (_, value) in selectedDays {
                    res.append(value)
                }
                let text = res.joined(separator: ", ")
                cell!.detailTextLabel?.text = text
                break
            case 1:
                if selectStartTime.count > 0 {
                    cell!.detailTextLabel?.text = selectStartTime
                }
                break
            case 2:
                if selectEndTime.count > 0 {
                    cell!.detailTextLabel?.text = selectEndTime
                }
                break
            default:
                print("default")
            }
            cell!.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            break
        case 4:  //臨打
            let width: CGFloat = 150
            //let frame = editFrame.setWidth(width)
            let frame = CGRect(x: cell_width! - width, y: editFrame.origin.y, width: width, height: editFrame.height)
            switch indexPath.row {
            case 0:
                tempFeeMTxt.frame = frame
                cell!.addSubview(tempFeeMTxt)
                break
            case 1:
                tempFeeFTxt.frame = frame
                cell!.addSubview(tempFeeFTxt)
                break
            case 2:
                if temp_content.count > 0 {
                    if temp_content.count < 15 {
                        cell!.detailTextLabel?.text = temp_content
                    }
                }
                cell!.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                break
            default:
                print("default")
            }
        case 5:  //球隊說明
            switch indexPath.row {
            case 0:   //使用球種
                ballTxt.frame = editFrame
                ballTxt.setAlign(align: .right)
                cell!.addSubview(ballTxt)
                break
            case 1:   //球友程度
                if degree.count > 0 {
                    var res: [String] = [String]()
                    for key in degree {
                        let value = key.rawValue
                        res.append(value)
                    }
                    let text = res.joined(separator: ", ")
                    cell!.detailTextLabel?.text = text
                }
                cell!.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                break
            case 2:
                if charge.count > 0 {
                    if charge.count < 15 {
                        cell!.detailTextLabel?.text = charge
                    }
                }
                cell!.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                break
            case 3:
                if content.count > 0 {
                    if content.count < 15 {
                        cell!.detailTextLabel?.text = content
                    }
                }
                cell!.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                break
            default:
                print("default")
            }
        default:
            print("default")
        }
        
        //cell!.detailTextLabel!.text = "\(data)"
        return cell!
        */
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = _rows[indexPath.section][indexPath.row]
        let cell = tableView.cellForRow(at: indexPath) as! TeamSubmitCell
        if row["atype"] as! UITableViewCellAccessoryType != UITableViewCellAccessoryType.none {
            if row["iden"] != nil {
                let iden: String = row["iden"] as! String
                //print(iden)
                if iden == TO_ARENA && selectedCity.id == 0 {
                    SCLAlertView().showError("錯誤", subTitle: "請先選擇區域")
                } else {
                    performSegue(withIdentifier: iden, sender: row["sender"])
                }
            }
        } else {
            cell.generalTextField.becomeFirstResponder()
        }
        
        /*
        switch indexPath.section {
        case 2:
            switch indexPath.row {
            case 0:
                performSegue(withIdentifier: TO_CITY, sender: nil)
                break
            default:
                if selectedCity.id == 0 {
                    SCLAlertView().showError("錯誤", subTitle: "請先選擇區域")
                } else {
                    performSegue(withIdentifier: TO_ARENA, sender: selectedCity.id)
                }
                break
            }
        case 3:
            switch indexPath.row {
            case 0:
                performSegue(withIdentifier: TO_DAY, sender: nil)
                break
            case 1:
                performSegue(withIdentifier: TO_SELECT_TIME, sender: SELECT_TIME_TYPE.play_start)
                break
            case 2:
                performSegue(withIdentifier: TO_SELECT_TIME, sender: SELECT_TIME_TYPE.play_end)
                break
            default:
                print("click")
            }
        case 4:  //臨打
            switch indexPath.row {
            case 0:
                break
            case 1:
                break
            case 2:
                performSegue(withIdentifier: TO_TEXT_INPUT, sender: TEXT_INPUT_TYPE.temp_play)
                break
            default:
                print("click")
            }
        case 5:  //球隊說明
            switch indexPath.row {
            case 0:
                break
            case 1:
                performSegue(withIdentifier: TO_SELECT_DEGREE, sender: nil)
                break
            case 2:
                performSegue(withIdentifier: TO_TEXT_INPUT, sender: TEXT_INPUT_TYPE.charge)
                break
            case 3:
                performSegue(withIdentifier: TO_TEXT_INPUT, sender: TEXT_INPUT_TYPE.team)
                break
            default:
                print("default")
            }
        default:
            print("click")
        }
 */
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
            let cityVC: CityVC = destinationNavigationController!.topViewController as! CityVC
            cityVC.delegate = self
        } else if segue.identifier == TO_ARENA {
            destinationNavigationController = (segue.destination as! UINavigationController)
            let arenaVC: ArenaVC = destinationNavigationController!.topViewController as! ArenaVC
            arenaVC.delegate = self
            arenaVC.city_id = sender as! Int
        } else if segue.identifier == TO_DAY {
            destinationNavigationController = (segue.destination as! UINavigationController)
            let dayVC: DayVC = destinationNavigationController!.topViewController as! DayVC
            dayVC.delegate = self
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
        if name.count == 0 {
            isPass = false
            SCLAlertView().showWarning("提示", subTitle: "請填寫隊名")
        }
        if mobile.count == 0 {
            isPass = false
            SCLAlertView().showWarning("提示", subTitle: "請填寫電話")
        }
        //print(isPass)
        if isPass {
            Global.instance.addSpinner(superView: self.view)
            if id == 0 {
        params.merge(["channel":"bm","type":"team","created_id":Member.instance.id,"manager_id":Member.instance.id,"cat_id":21])
            }
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
            TeamService.instance.update(params: params, featuredView.imageView.image, key: "file", filename: "test.jpg", mimeType: "image/jpeg") { (success) in
                Global.instance.removeSpinner(superView: self.view)
                if success {
                    if TeamService.instance.success {
                        self.id = TeamService.instance.id
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
        self.selectedCity = city
        //print(selectedCity.name)
        _setSelectedToRows(key: TEAM_CITY_KEY, value: self.selectedCity.name)
        self.tableView.reloadData()
    }
    func setArenaData(id: Int, name: String) {
        let arena = Arena(id: id, name: name)
        self.selectedArena = arena
        _setSelectedToRows(key: TEAM_ARENA_KEY, value: self.selectedArena.name)
        self.tableView.reloadData()
    }
    func setDaysData(res: [Int: String]) {
        self.selectedDays = res
        var tmp: [String] = [String]()
        for (_, value) in selectedDays {
            tmp.append(value)
        }
        let text = tmp.joined(separator: ", ")
        _setSelectedToRows(key: TEAM_DAY_KEY, value: text)
        self.tableView.reloadData()
    }
    func setTimeData(time: String, type: SELECT_TIME_TYPE) {
        switch type {
        case SELECT_TIME_TYPE.play_start:
            selectedStartTime = time
            _setSelectedToRows(key: TEAM_PLAY_START_KEY, value: time)
            break
        case SELECT_TIME_TYPE.play_end:
            _setSelectedToRows(key: TEAM_PLAY_END_KEY, value: time)
            selectedEndTime = time
            break
        }
        self.tableView.reloadData()
    }
    func setTextInputData(text: String, type: TEXT_INPUT_TYPE) {
        switch type {
        case TEXT_INPUT_TYPE.temp_play:
            _setSelectedToRows(key: TEAM_TEMP_CONTENT_KEY, value: text)
            temp_content = text
            break
        case TEXT_INPUT_TYPE.charge:
            _setSelectedToRows(key: TEAM_CHARGE_KEY, value: text)
            charge = text
            break
        case TEXT_INPUT_TYPE.team:
            _setSelectedToRows(key: TEAM_CONTENT_KEY, value: text)
            content = text
            break
            
        }
        self.tableView.reloadData()
    }
    func setDegreeData(degree: [DEGREE]) {
        self.degree = degree
        var tmp: [String] = [String]()
        for key in degree {
            let value = key.rawValue
            tmp.append(value)
        }
        let text = tmp.joined(separator: ", ")
        _setSelectedToRows(key: TEAM_DEGREE_KEY, value: text)
        self.tableView.reloadData()
    }
    // ImagePickerDelegate
    func isImageSet(_ b: Bool) {
        //self.isFeaturedSet = b
    }
    func myPresent(_ viewController: UIViewController) {
        self.present(viewController, animated: true, completion: nil)
    }
    func setTextField(idx: Int, value: String) {
        if (idx == 1) {
            name = value
        } else if (idx == 2) {
            leader = value
        } else if (idx == 3) {
            mobile = value
        } else if (idx == 4) {
            email = value
        } else if (idx == 8) {
            temp_fee_M = Int(value)!
        } else if (idx == 9) {
            temp_fee_F = Int(value)!
        } else if (idx == 11) {
            ball = value
        }
    }
    
    func _setSelectedToRows(key: String, value: String) {
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
    }
}
