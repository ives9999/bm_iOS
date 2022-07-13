//
//  RegisterVC.swift
//  bm
//
//  Created by ives on 2017/10/27.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import SCLAlertView

class RegisterVC: MyTableVC, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImagePickerViewDelegate {
    
    // Outlets
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var featuredView: ImagePickerView!
    @IBOutlet weak var featuredViewContainer: UIView!
    
    @IBOutlet weak var submitBtn: SubmitButton!
    @IBOutlet weak var cancelBtn: CancelButton!
    
    var imagePicker: UIImagePickerController = UIImagePickerController()
    
    //var sourceVC: MemberVC? = nil
    
    var agreePrivacy: Bool = true
    var sex: String = "M"
    var old_selected_city: String = ""
    var member_token: String = ""
    var isFeaturedChange: Bool = false
    
    var testData: [String: String] = [
//       EMAIL_KEY: "ives6@bluemobile.com.tw",
//        PASSWORD_KEY: "1234",
//        REPASSWORD_KEY: "1234",
//        NAME_KEY: "孫士君",
//        NICKNAME_KEY: "孫世君",
//        SEX_KEY: "F",
//        DOB_KEY: "1969-01-05",
//        MOBILE_KEY: "0911299990",
//        TEL_KEY: "062295888",
//        CITY_KEY: "218",
//        "city_name": "台南市",
//        AREA_KEY: "219",
//        "area_name": "中西區",
//        ROAD_KEY: "南華街101號8樓",
//        FB_KEY: "https://www.facebook.com/ives.sun",
//        LINE_KEY: "ives9999"
        :]
    //]
    
    override func viewDidLoad() {
        myTablView = tableView
        //form = RegisterForm()
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
        
        imagePicker.delegate = self
        featuredView.gallery = imagePicker
        featuredView.delegate = self
        
        
        hideKeyboardWhenTappedAround()
        //FormItemCellType.registerCell(for: tableView)
        
        let moreCellNib = UINib(nibName: "MoreCell", bundle: nil)
        tableView.register(moreCellNib, forCellReuseIdentifier: "moreCell")
        
        let textFieldCellNib = UINib(nibName: "TextFieldCell", bundle: nil)
        tableView.register(textFieldCellNib, forCellReuseIdentifier: "textFieldCell")
        
        let dateCellNib = UINib(nibName: "DateCell", bundle: nil)
        tableView.register(dateCellNib, forCellReuseIdentifier: "dateCell")
        
        let sexCellNib = UINib(nibName: "SexCell", bundle: nil)
        tableView.register(sexCellNib, forCellReuseIdentifier: "sexCell")
        
        let privacyCellNib = UINib(nibName: "PrivacyCell", bundle: nil)
        tableView.register(privacyCellNib, forCellReuseIdentifier: "privacyCell")
        
        let passwordCellNib = UINib(nibName: "PasswordCell", bundle: nil)
        tableView.register(passwordCellNib, forCellReuseIdentifier: "passwordCell")
        
        let plainCellNib = UINib(nibName: "PlainCell", bundle: nil)
        tableView.register(plainCellNib, forCellReuseIdentifier: "plainCell")
        
        initData()
    }
    
    func initData() {
        
        var rows: [OneRow] = [OneRow]()
        var row: OneRow = OneRow(title: "EMail", value: Member.instance.email, show: Member.instance.email, key: EMAIL_KEY, cell: "textField", keyboard: KEYBOARD.emailAddress, placeholder: "service@bm.com", isRequired: true)
        row.msg = "EMail沒有填寫"
        rows.append(row)
        if (!Member.instance.isLoggedIn) {
            row = OneRow(title: "密碼", value: "", show: "", key: PASSWORD_KEY, cell: "password", isRequired: true)
            row.msg = "密碼沒有填寫"
            rows.append(row)
            row = OneRow(title: "密碼確認", value: "", show: "", key: REPASSWORD_KEY, cell: "password", isRequired: true)
            row.msg = "密碼確認沒有填寫"
            rows.append(row)
        }
        
        var section: OneSection = makeSectionRow(title: "登入資料", key: "login", rows: rows)
        oneSections.append(section)
        
        rows.removeAll()
        row = OneRow(title: "姓名", value: Member.instance.name, show: Member.instance.name, key: NAME_KEY, cell: "textField", placeholder: "王大明", isRequired: true)
        row.msg = "姓名沒有填寫"
        rows.append(row)
        row = OneRow(title: "暱稱", value: Member.instance.nickname, show: Member.instance.nickname, key: NICKNAME_KEY, cell: "textField", placeholder: "大明哥", isRequired: true)
        row.msg = "暱稱沒有填寫"
        rows.append(row)
        row = OneRow(title: "生日", value: Member.instance.dob, show: Member.instance.dob, key: DOB_KEY, cell: "date", isRequired: false)
        rows.append(row)
        
        if (!Member.instance.isLoggedIn) {
            Member.instance.sex = "none"
        }
        row = OneRow(title: "性別", value: Member.instance.sex, show: Member.instance.sex, key: SEX_KEY, cell: "sex", isRequired: false)
        //row.msg = "沒有選擇性別"
        rows.append(row)
        
        if (Member.instance.isLoggedIn) {
            row = OneRow(title: "金鑰", value: Member.instance.token, show: Member.instance.token, key: TOKEN_KEY, cell: "textField", isRequired: false)
            rows.append(row)
        }
        
        section = makeSectionRow(title: "個人資料", key: "data", rows: rows)
        oneSections.append(section)
        
        rows.removeAll()
        row = OneRow(title: "行動電話", value: Member.instance.mobile, show: Member.instance.mobile, key: MOBILE_KEY, cell: "textField", keyboard: KEYBOARD.numberPad, placeholder: "0939123456", isRequired: true)
        row.msg = "行動電話沒有填寫"
        rows.append(row)
        row = OneRow(title: "市內電話", value: Member.instance.tel, show: Member.instance.tel, key: TEL_KEY, cell: "textField", keyboard: KEYBOARD.numberPad, placeholder: "021234567", isRequired: false)
        rows.append(row)
        row = OneRow(title: "縣市", value: String(Member.instance.city), show: Global.instance.zoneIDToName(Member.instance.city), key: CITY_KEY, cell: "more", isRequired: true)
        row.msg = "沒有選擇縣市"
        rows.append(row)
        row = OneRow(title: "區域", value: String(Member.instance.area), show: Global.instance.zoneIDToName(Member.instance.area), key: AREA_KEY, cell: "more", isRequired: true)
        row.msg = "沒有選擇區域"
        rows.append(row)
        row = OneRow(title: "住址", value: Member.instance.road, show: Member.instance.road, key: ROAD_KEY, cell: "textField", placeholder: "中山路60號", isRequired: true)
        row.msg = "沒有填寫住址"
        rows.append(row)
        section = makeSectionRow(title: "聯絡資料", key: "login", rows: rows)
        oneSections.append(section)
        
        rows.removeAll()
        row = OneRow(title: "FB", value: Member.instance.fb, show: Member.instance.fb, key: FB_KEY, cell: "textField", isRequired: false)
        rows.append(row)
        row = OneRow(title: "Line", value: Member.instance.line, show: Member.instance.line, key: LINE_KEY, cell: "textField", isRequired: false)
        rows.append(row)
        section = makeSectionRow(title: "社群資料", key: "login", rows: rows)
        oneSections.append(section)
        
        if (!Member.instance.isLoggedIn) {
            rows.removeAll()
            row = OneRow(title: "隱私權", value: "true", show: "同意隱私權條款", key: PRIVACY_KEY, cell: "privacy")
            rows.append(row)
            section = makeSectionRow(title: "隱私權", key: PRIVACY_KEY, rows: rows)
            oneSections.append(section)
        }
        
        old_selected_city = String(Member.instance.city)
        
        if Member.instance.avatar.count > 0 {
            featuredView.setPickedImage(url: Member.instance.avatar)
        }
        
        for (key, value) in testData {
            let row: OneRow = getOneRowFromKey(key)
            row.value = value
            if (key == CITY_KEY || key == AREA_KEY) {
                row.show = Global.instance.zoneIDToName(Int(value)!)
            } else {
                row.show = value
            }
        }
        
        if Member.instance.isLoggedIn {
            member_token = Member.instance.token
        }
        
//        if Member.instance.isLoggedIn {
//            form.removeItems(keys: [PASSWORD_KEY, REPASSWORD_KEY, PRIVACY_KEY])
//            form.formItems.remove(at: form.formItems.count - 1)
//            sections = form.getSections()
//            section_keys = form.getSectionKeys()
//
//            var keys: [String] = [String]()
//            for formItem in form.formItems {
//                if formItem.name != nil {
//                    keys.append(formItem.name!)
//                }
//            }
//
//            member_token = Member.instance.token
//            for key in keys {
//                var value: String = ""
//                if let tmp = session.string(forKey: key) {
//                    value = tmp
//                }
//
//                let formItem = getFormItemFromKey(key)
//                if formItem != nil {
//                    if key == AREA_KEY {
//                        let cityFormItem: CityFormItem = (getFormItemFromKey(CITY_KEY) as? CityFormItem)!
//                        let areaFormItem: AreaFormItem = (formItem as? AreaFormItem)!
//                        areaFormItem.city_id = Int(cityFormItem.value!)
//                    }
//                    formItem!.value = value
//                    formItem!.make()
//                }
//
//
////                let data = Member.instance.getData(key: key)
////                if Member.instance.info[key] != nil {
////                    let types: [String: String] = Member.instance.info[key]!
////                    let type: String = types["type"]!
////                    var value: String = ""
////                    if type == "String" {
////                        value = data as! String
////                    } else if type == "Int" {
////                        value = String(data as! Int)
////                    }
////
////                }
//            }
//            old_selected_city = String(Member.instance.city)
//            if Member.instance.avatar.count > 0 {
//                featuredView.setPickedImage(url: Member.instance.avatar)
//            }
//        } else {
//            if testData.count > 0 {
//                for (key, value) in testData {
//                    let formItem = getFormItemFromKey(key)
//                    if formItem != nil {
//                        if key == AREA_KEY && testData.keyExist(key: "area_name") {
//                            let _formItem = formItem as! AreaFormItem
//                            _formItem.selected_area_names = [testData["area_name"]!]
//                        }
//                        formItem!.value = value
//                        formItem!.make()
//                    }
//                }
//                old_selected_city = testData[CITY_KEY] ?? ""
//            }
//        }
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
        
        //print("section:\(indexPath.section)=>row:\(indexPath.row)")
        let row = getOneRowFromIdx(indexPath.section, indexPath.row)
        //let item = getFormItemFromIdx(indexPath)
        //let cell: UITableViewCell
        let cell_type: String = row.cell
        if (cell_type == "textField") {
            let cell: TextFieldCell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as! TextFieldCell
            cell.cellDelegate = self
            cell.update(sectionIdx: indexPath.section, rowIdx: indexPath.row, row: row)
            return cell
        } else if (cell_type == "more") {
            let cell: MoreCell = tableView.dequeueReusableCell(withIdentifier: "moreCell", for: indexPath) as! MoreCell
            cell.cellDelegate = self
            cell.update(sectionIdx: indexPath.section, rowIdx: indexPath.row, row: row)
            return cell
        } else if (cell_type == "date") {
            let cell: DateCell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as! DateCell
            cell.cellDelegate = self
            cell.update(sectionIdx: indexPath.section, rowIdx: indexPath.row, row: row)
            return cell
        } else if (cell_type == "sex") {
            let cell: SexCell = tableView.dequeueReusableCell(withIdentifier: "sexCell", for: indexPath) as! SexCell
            cell.cellDelegate = self
            cell.update(sectionIdx: indexPath.section, rowIdx: indexPath.row, row: row)
            return cell
        } else if (cell_type == "privacy") {
            let cell: PrivacyCell = tableView.dequeueReusableCell(withIdentifier: "privacyCell", for: indexPath) as! PrivacyCell
            cell.cellDelegate = self
            cell.update(sectionIdx: indexPath.section, rowIdx: indexPath.row, row: row)
            return cell
        } else if (cell_type == "password") {
            let cell: PasswordCell = tableView.dequeueReusableCell(withIdentifier: "passwordCell", for: indexPath) as! PasswordCell
            cell.cellDelegate = self
            cell.update(sectionIdx: indexPath.section, rowIdx: indexPath.row, row: row)
            return cell
        } else if (row.cell == "text") {
            
            if let cell: PlainCell = tableView.dequeueReusableCell(withIdentifier: "plainCell", for: indexPath) as? PlainCell {
                
                cell.update(title: row.title, show: row.show)
                return cell
            }
        }
//        if let cellType = item!.uiProperties.cellType {
//            cell = cellType.dequeueCell(for: tableView, at: indexPath)
//        } else {
//            cell = UITableViewCell()
//        }
        
//        if let formUpdatableCell = cell as? FormUPdatable {
//            item!.indexPath = indexPath
//            formUpdatableCell.update(with: item!)
//        }
        
//        if item!.uiProperties.cellType == FormItemCellType.textField ||
//            item!.uiProperties.cellType == FormItemCellType.sex ||
//            item!.uiProperties.cellType == FormItemCellType.privacy
//        {
//            if let formCell = cell as? FormItemCell {
//                formCell.valueDelegate = self
//            }
//        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //let item = getFormItemFromIdx(indexPath)
        let row = getOneRowFromIdx(indexPath.section, indexPath.row)
        let key = row.key
        if key == CITY_KEY {
//                    let selectItem: CityFormItem = item as! CityFormItem
//                    var selected: String = ""
//                    if selectItem.selected_city_ids.count > 0 {
//                        selected = String(selectItem.selected_city_ids[0])
//                    }
            //toSelectCity(key: key, selected: selected, delegate: self)
            toSelectSingle(key: key, selected: row.value, delegate: self)
        } else if key == AREA_KEY {
            let row1: OneRow = getOneRowFromKey(CITY_KEY)
            var city_id: Int = 0
            if let tmp: Int = Int(row1.value) {
                city_id = tmp
            }
            if (city_id == 0) {
                warning("請先選擇縣市")
            } else {
                toSelectArea(key: key, city_id: city_id, selected: row.value, delegate: self)
            }
            
//                    if row1.value == nil {
//                        warning("請先選擇縣市")
//                    } else {
                
//                        let selectItem: AreaFormItem = item as! AreaFormItem
//                        var selected: String = ""
//                        if selectItem.selected_area_ids.count > 0 {
//                            selected = String(selectItem.selected_area_ids[0])
//                        }
//                    }
//                    let cityItem: CityFormItem = getFormItemFromKey(CITY_KEY)! as! CityFormItem
//                    if cityItem.value == nil {
//                        warning("請先選擇縣市")
//                    } else {
//                        let city_id = Int(cityItem.value!)
//                        let selectItem: AreaFormItem = item as! AreaFormItem
//                        var selected: String = ""
//                        if selectItem.selected_area_ids.count > 0 {
//                            selected = String(selectItem.selected_area_ids[0])
//                        }
//                        toSelectArea(key: key, city_id: city_id, selected: selected, delegate: self)
//                    }
        } else if key == DOB_KEY {
            
//                    let dobItem: DateFormItem = getFormItemFromKey(key!)! as! DateFormItem
//                    var selected: String?
//                    if dobItem.value != nil {
//                        selected = dobItem.value!
//                    }
            toSelectDate(key: key, selected: row.value)
        }
    }
    
    override func singleSelected(key: String, selected: String, show: String?=nil) {
        
        //let item = getFormItemFromKey(key)
        let row: OneRow = getOneRowFromKey(key)
        row.value = selected
//        if row.value != selected {
//            row.reset()
//        }
        if key == AREA_KEY {
            row.show = Global.instance.zoneIDToName(Int(selected)!)
//            let cityRow = getOneRowFromKey(CITY_KEY)
//            cityRow.value = row.value
        } else if key == CITY_KEY {
            old_selected_city = selected
            row.show = Global.instance.zoneIDToName(Int(selected)!)
            //let item1 = getFormItemFromKey(AREA_KEY)
//            if old_selected_city != selected {
//                if item1 != nil {
//                    item1!.reset()
//                }
//                old_selected_city = selected
//            }
        }
        //item!.value = selected
        //item!.make()
        tableView.reloadData()
    }
    
    override func dateSelected(key: String, selected: String) {
        //let item = getFormItemFromKey(key)
        let row: OneRow = getOneRowFromKey(key)
        row.value = selected
        row.show = selected
        tableView.reloadData()
//        if item != nil {
//            if item!.value != selected {
//                item!.reset()
//            }
//            item!.value = selected
//            item!.make()
//            tableView.reloadData()
//        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImage: UIImage?
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
            isFeaturedChange = true
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
            isFeaturedChange = true
        }
        featuredView.setPickedImage(image: selectedImage!)
        picker.dismiss(animated: true, completion: nil)
    }
    
    // after choice image b is true
    func isImageSet(_ b: Bool) {}
    
    func myPresent(_ viewController: UIViewController) {
//        if let popoverController = viewController.popoverPresentationController {
//            let popView = viewController.view
//            popoverController.sourceView = viewController.view
//            popoverController.sourceRect = CGRect(x: popView!.bounds.midX, y: popView!.bounds.midY, width: 0, height: 0)
//            popoverController.permittedArrowDirections = []
//        }
        self.present(viewController, animated: true, completion: nil)
    }

//    @IBAction func registerBtnPressed(_ sender: Any) {
//        let email = emailTxt.text!
//        let password = passwordTxt.text!
//        let rePassword = rePasswordTxt.text!
//        var bCheck: Bool = true
//
//        if email.count == 0 {
//            SCLAlertView().showWarning("警告", subTitle: "請填寫email")
//            bCheck = false
//        }
//        if password.count == 0 {
//            SCLAlertView().showWarning("警告", subTitle: "請填寫密碼")
//            bCheck = false
//        }
//        if password != rePassword {
//            SCLAlertView().showWarning("警告", subTitle: "密碼不符")
//            bCheck = false
//        }
//
//        if bCheck {
//            Global.instance.addSpinner(superView: self.view)
//            MemberService.instance.register(email: email, password: password, repassword: rePassword) { (success) in
//                Global.instance.removeSpinner(superView: self.view)
//                if success {
//                    //print("register ok: \(MemberService.instance.success)")
//                    if MemberService.instance.success {
//                        let appearance = SCLAlertView.SCLAppearance(
//                            showCloseButton: false
//                        )
//                        let alert = SCLAlertView(appearance: appearance)
//                        alert.addButton("確定", action: {
//                            self.dismiss(animated: true, completion: {
//                                if self.sourceVC != nil {
//                                    self.sourceVC!._loginout()
//                                }
//                            })
//                        })
//                        alert.showSuccess("成功", subTitle: "註冊成功，請儘速通過email認證，才能使用更多功能！！")
//                    } else {
//                        //print("login failed by error email or password")
//                        SCLAlertView().showError("警告", subTitle: MemberService.instance.msg)
//                    }
//                }
//            }
//        }
//    }
//    @IBAction func registerFBBtnPressed(_ sender: Any) {
//        Facebook.instance.login(viewController: self) {
//            (success) in
//            if success {
//                //print("login fb success")
//                //self._loginFB()
//                //Session.shared.loginReset = true
//                let playerID: String = self._getPlayerID()
//                Global.instance.addSpinner(superView: self.view)
//                MemberService.instance.login_fb(playerID: playerID, completion: { (success1) in
//                    Global.instance.removeSpinner(superView: self.view)
//                    if success1 {
//                        if MemberService.instance.success {
//                            self.dismiss(animated: true, completion: {
//                                if self.sourceVC != nil {
//                                    self.sourceVC!._loginout()
//                                }
//                            })
//                        } else {
//                            //print("login failed by error email or password")
//                            self.warning(MemberService.instance.msg)
//                        }
//                    } else {
//                        self.warning("使用FB註冊，但無法新增至資料庫，請洽管理員")
//                        //print("login failed by fb")
//                    }
//                })
//            } else {
//                print("login fb failure")
//            }
//        }
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitBtnPressed(_ sender: Any) {
        
        var msg: String = ""
        for section in oneSections {
            for row in section.items {
                if (row.isRequired && row.value.count == 0) {
                    msg += row.msg + "\n"
                }
            }
        }
        
        if (!Member.instance.isLoggedIn) {
            let password: String = getOneRowValue(PASSWORD_KEY)
            let repassword: String = getOneRowValue(REPASSWORD_KEY)
            if (password != repassword) {
                msg += "密碼不符合" + "\n"
            }

            let privacy: Bool = Bool(getOneRowValue(PRIVACY_KEY))!
            if (!privacy) {
                msg += "必須同意隱私權政策才能完成註冊"
            }
        }
        
        if (msg.count > 0) {
            warning(msg)
        } else {
    
    //        for formItem in form.formItems {
    //            formItem.checkValidity()
    //            if !formItem.isValid {
    //                if formItem.msg != nil {
    //                    warning(formItem.msg!)
    //                } else {
    //                    warning("有錯誤")
    //                }
    //                break
    //            }
    //        }
            
            Global.instance.addSpinner(superView: self.view)
            var params:[String: String] = [String: String]()
            
            for section in oneSections {
                for row in section.items {
                    params[row.key] = row.value
                }
            }
            
//            for formItem in form.formItems {
//                if formItem.value != nil {
//                    let value = formItem.value!
//                    params[formItem.name!] = value
//                }
//            }
            
//            if let city_id = params[CITY_KEY] {
//                params[CITY_KEY] = city_id
//                params.removeValue(forKey: CITY_KEY)
//            }
//
//            if let area_id = params[AREA_KEY] {
//                params[AREA_KEY] = area_id
//                params.removeValue(forKey: AREA_KEY)
//            }
            
            if member_token.count > 0 {
                params[TOKEN_KEY] = member_token
            }
            
            params["do"] = "update"
            if isFeaturedChange {
                params["featured"] = "1"
            }
            //print(params)
            
            let image: UIImage? = isFeaturedChange ? featuredView.imageView.image : nil
            
            MemberService.instance.update(_params: params, image: image) { (success) in
                if success {
                    Global.instance.removeSpinner(superView: self.view)
                    
                    let jsonData: Data = MemberService.instance.jsonData!
                    do {
                        let table = try JSONDecoder().decode(RegisterUpdateResTable.self, from: jsonData)
                        if (!table.success) {
                            var msg: String = ""
                            for error in table.errors {
                                msg += error + "\n"
                            }
                            self.warning(msg)
                        } else {
                            if (table.model != nil) {
                                table.model!.toSession(isLoggedIn: true)
                            }
                            let appearance = SCLAlertView.SCLAppearance(
                                showCloseButton: false
                            )
                            let alert = SCLAlertView(appearance: appearance)
                            alert.addButton("確定", action: {
                                //print("ok")
                                if self.member_token.count == 0 {
                                    self.dismiss(animated: true, completion: nil)
                                }
                            })
                            var msg: String = ""
                            if self.member_token.count > 0 {
                                msg = "修改成功"
                                //let data = Member.instance.getData(key: NAME_KEY)
                                //print(data)
                            } else {
                                msg = "註冊成功，已經寄出email與手機的認證訊息，請繼續完成認證程序"
                            }
                            alert.showSuccess("成功", subTitle: msg)
                        }
                    } catch {
                        //self.warning(error.localizedDescription)
                        self.warning(MemberService.instance.msg)
                    }
                } else {
                    Global.instance.removeSpinner(superView: self.view)
                    self.warning("伺服器錯誤，請稍後再試，或洽管理人員")
                    //SCLAlertView().showWarning("錯誤", subTitle: "註冊失敗，伺服器錯誤，請稍後再試")
                }
            }
        }
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_LOGIN, sender: nil)
    }
    
    @IBAction func passwordBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_PASSWORD, sender: "forget_password")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == TO_PASSWORD {
            let vc: PasswordVC = segue.destination as! PasswordVC
            vc.type = sender as? String
        } else if segue.identifier == TO_LOGIN {
            //let vc: LoginVC = segue.destination as! LoginVC
            //vc.menuVC = (sender as! MenuVC)
        } else if segue.identifier == TO_REGISTER {
            //let vc: RegisterVC = segue.destination as! RegisterVC
            //vc.menuVC = (sender as! MenuVC)
        }
    }
    
//    func textFieldTextChanged(formItem: FormItem, text: String) {
//        formItem.value = text
//        //print(text)
//    }
    
    
    override func cellTextChanged(sectionIdx: Int, rowIdx: Int, str: String) {
        let row = getOneRowFromIdx(sectionIdx, rowIdx)
        row.value = str
        row.show = str
    }
    
    override func cellSexChanged(key: String, sectionIdx: Int, rowIdx: Int, sex: String) {
        let row = getOneRowFromIdx(sectionIdx, rowIdx)
        row.value = sex
        row.show = sex
    }
    
    override func cellPrivacyChanged(sectionIdx: Int, rowIdx: Int, checked: Bool) {
        let row = getOneRowFromIdx(sectionIdx, rowIdx)
        row.value = String(checked)
        if !checked {
            warning("必須同意隱私權條款，才能註冊")
        }
    }
    
//    func sexChanged(sex: String) {
//        let item = getFormItemFromKey(SEX_KEY)
//        self.sex = sex
//        item?.value = sex
//        //print(sex)
//    }
//    
//    func privacyChecked(checked: Bool) {
//        let item = getFormItemFromKey(PRIVACY_KEY)
//        if !checked {
//            warning("必須同意隱私權條款，才能註冊")
//            item?.value = nil
//        } else {
//            item?.value = "1"
//        }
//        self.agreePrivacy = checked
//        //print(checked)
//    }
    
//    func backToMenu() {
//        if self.menuVC != nil {
//            self.menuVC!._loginout()
//        }
//        self.performSegue(withIdentifier: UNWIND, sender: "refresh_team")
//    }
}

class RegisterUpdateResTable: Codable {
    
    var success: Bool = false
    var errors: [String] = [String]()
    var id: Int = 0
    var update: String = "INSERT"
    var model: MemberTable?
    
    enum CodingKeys: String, CodingKey {
        case success
        case errors
        case id
        case update
        case model
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        errors = try container.decodeIfPresent([String].self, forKey: .errors) ?? [String]()
        id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        update = try container.decodeIfPresent(String.self, forKey: .update) ?? ""
        model = try container.decodeIfPresent(MemberTable.self, forKey: .model) ?? nil
    }
}

