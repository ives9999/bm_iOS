//
//  TeamSubmitVC.swift
//  bm
//
//  Created by ives on 2017/11/9.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import SCLAlertView

class TeamSubmitVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, CityDelegate, ArenaDelegate, DaysDelegate, TimeSelectDelegate, TextInputDelegate, DegreeSelectDelegate, ImagePickerViewDelegate {

    // Outlets
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var featuredView: ImagePickerView!
    
    var imagePicker: UIImagePickerController = UIImagePickerController()
    
    let sections: [String] = ["", "聯絡資訊", "所在地", "打球時間", "臨打說明", "其他說明"]
    let rows: [[String]] = [
        [TEAM_NAME_KEY],
        [TEAM_LEADER_KEY, TEAM_MOBILE_KEY, TEAM_EMAIL_KEY],
        [TEAM_ZONE_ID_KEY, TEAM_ARENA_ID_KEY],
        [TEAM_DAY_KEY, TEAM_PLAY_START_KEY, TEAM_PLAY_END_KEY],
        [TEAM_TEMP_FEE_M_KEY, TEAM_TEMP_FEE_F_KEY, TEAM_TEMP_CONTENT_KEY],
        [TEAM_BALL_KEY, TEAM_DEGREE_KEY, TEAM_CHARGE_KEY, TEAM_CONTENT_KEY]
    ]
    var id: Int = 0
    var nameTxt: SuperTextField = SuperTextField()
    
    var leaderTxt: SuperTextField = SuperTextField()
    var mobileTxt: NumberTextField = NumberTextField()
    var emailTxt: EMailTextField = EMailTextField()
    
    var tempFeeMTxt: NumberTextField = NumberTextField()
    var tempFeeFTxt: NumberTextField = NumberTextField()
    
    var ballTxt: SuperTextField = SuperTextField()
    
    var city_id: Int = 0
    var city_name: String = ""
    var selectedCity: City = City(id: 0, name: "")
    var selectedArena: Arena = Arena(id: 0, name: "")
    var selectedDays: [Int: String] = [Int: String]()
    var selectStartTime: String = ""
    var selectEndTime: String = ""
    var temp_content: String = ""
    var degree: [DEGREE] = [DEGREE]()
    var charge: String = ""
    var content: String = ""
    
    var cell_width: CGFloat?
    
    var isFeaturedSet: Bool = false
    
    func setCityData(id: Int, name: String) {
        let city = City(id: id, name: name)
        self.selectedCity = city
        self.tableView.reloadData()
    }
    func setArenaData(id: Int, name: String) {
        let arena = Arena(id: id, name: name)
        self.selectedArena = arena
        self.tableView.reloadData()
    }
    func setDaysData(res: [Int: String]) {
        self.selectedDays = res
        self.tableView.reloadData()
    }
    func setTimeData(time: String, type: SELECT_TIME_TYPE) {
        switch type {
        case SELECT_TIME_TYPE.play_start:
            selectStartTime = time
            break
        case SELECT_TIME_TYPE.play_end:
            selectEndTime = time
            break
        }
        self.tableView.reloadData()
    }
    func setTextInputData(text: String, type: TEXT_INPUT_TYPE) {
        switch type {
        case TEXT_INPUT_TYPE.temp_play:
            temp_content = text
            break
        case TEXT_INPUT_TYPE.charge:
            charge = text
            break
        case TEXT_INPUT_TYPE.team:
            content = text
            break
        
        }
        self.tableView.reloadData()
    }
    func setDegreeData(degree: [DEGREE]) {
        self.degree = degree
        self.tableView.reloadData()
    }
    // ImagePickerDelegate
    func isImageSet(_ b: Bool) {
        self.isFeaturedSet = b
    }
    func myPresent(_ viewController: UIViewController) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    convenience init() {
        self.init(nibName:nil, bundle:nil)
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        //nameTxt = SuperTextField()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder aDecoder: NSCoder) {
        //nameTxt = SuperTextField()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        
        //tableView.register(FormCell.self, forCellReuseIdentifier: "cell")
        
        imagePicker.delegate = self
        featuredView.gallery = imagePicker
        featuredView.delegate = self
        
        hideKeyboardWhenTappedAround()
        
        nameTxt.father = self
        //nameTxt.setupView()
        mobileTxt.father = self
        emailTxt.father = self
        
        cell_width = tableView.frame.width
        //print(cell_width)
        
        nameTxt.text = "快樂羽球隊"
        leaderTxt.text = "孫志煌"
        mobileTxt.text = "0911299994"
        emailTxt.text = "ives@housetube.tw"
        ballTxt.text = "RSL 4"
        tempFeeMTxt.text = "150"
        tempFeeFTxt.text = "100"
        temp_content = "請勿報名沒有來，列入黑名單"
        charge = "一季3600含球"
        content = "歡迎加入"
        selectStartTime = "16:00"
        selectEndTime = "18:00"
        degree = [DEGREE.high, DEGREE.soso]
        selectedDays = [2: "星期二", 4:"星期四"]
        selectedCity = City(id: 218, name: "台南")
        selectedArena = Arena(id: 10, name: "全穎羽球館")
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UITableViewHeaderFooterView()
        view.layer.backgroundColor = UIColor.clear.cgColor
        
        return view
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UITableViewHeaderFooterView()
        view.layer.backgroundColor = UIColor.clear.cgColor
        
        return view
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel!.font = UIFont(name: FONT_NAME, size: FONT_SIZE_TITLE)
        header.textLabel!.textColor = UIColor.white
    }
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let footer = view as! UITableViewHeaderFooterView
        let separator: UIView = UIView(frame: CGRect(x: 15, y: 0, width: footer.frame.width, height: 1))
        separator.layer.backgroundColor = UIColor("#6c6c6e").cgColor
        footer.addSubview(separator)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        
        let key: String = rows[indexPath.section][indexPath.row]
        var row: [String: String]? = Team.instance.info[key]
        if row == nil {
            row = [String: String]()
        }
        var field: String = ""
        //var data: String = ""
        if let tmp: String = row?["ch"] {
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
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            nameTxt.becomeFirstResponder()
            break
        case 1:
            switch indexPath.row {
            case 0:
                break
            case 1:
                mobileTxt.becomeFirstResponder()
                break
            case 2:
                emailTxt.becomeFirstResponder()
                break
            default:
                print("click")
            }
            break
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
                tempFeeMTxt.becomeFirstResponder()
                break
            case 1:
                tempFeeFTxt.becomeFirstResponder()
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
                ballTxt.becomeFirstResponder()
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
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //cell.layer.backgroundColor = UIColor.clear.cgColor
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
        Global.instance.addSpinner(superView: self.view)
        var params:[String: Any] = [String: Any]()
        var isPass: Bool = true
        if nameTxt.text?.count == 0 {
            SCLAlertView().showWarning("提示", subTitle: "請填寫隊名")
            isPass = false
        }
        if mobileTxt.text?.count == 0 {
            SCLAlertView().showWarning("提示", subTitle: "請填寫電話")
            isPass = false
        }
        if isPass {
            if id == 0 {
                params.merge(["channel":"bm","type":"team","created_id":Member.instance.id,"manager_id":Member.instance.id,"cat_id":21])
            }
            params["name"] = nameTxt.text!
            params["slug"] = nameTxt.text!
            params["mobile"] = mobileTxt.text!
            params["leader"] = leaderTxt.text!
            params["email"] = emailTxt.text!
            params["ball"] = ballTxt.text!
            params["temp_fee_M"] = tempFeeMTxt.text!
            params["temp_fee_F"] = tempFeeFTxt.text!
            params["charge"] = charge
            params["temp_content"] = temp_content
            params["content"] = content
            params["play_time"] = selectStartTime + " - " + selectEndTime
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
            TeamService.instance.uploadImage(params: params, featuredView.imageView.image, key: "file", filename: "test.jpg", mimeType: "image/jpeg") { (success) in
                Global.instance.removeSpinner(superView: self.view)
                if success {
                    self.id = TeamService.instance.id
                    //print(self.id)
                }
            }
//            if isFeaturedSet {
//                let image: UIImage = featuredView.imageView.image!
//                let imageData: Data = UIImageJPEGRepresentation(image, 0.2)!
//                let base64: String = imageData.base64EncodedString(options: .lineLength64Characters)
//                //let json = try? JSONEncoder().encode(base64)
//                params["featured"] = base64
//            }
//            TeamService.instance.update(params: params) { (success) in
//                Global.instance.removeSpinner(superView: self.view)
//                if success {
//                    self.id = TeamService.instance.id
//                    print(self.id)
//                }
//            }
        }
    }
    

}
