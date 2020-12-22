//
//  RegisterVC.swift
//  bm
//
//  Created by ives on 2017/10/27.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class RegisterVC: MyTableVC, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImagePickerViewDelegate, TextFieldChangeDelegate {
    
    //目前暫時沒有用到
    func textFieldTextChanged(formItem: FormItem, text: String) {
        print(text)
    }
    func setTextFieldDelegate(delegate: TextFieldChangeDelegate) {
        
    }
    
    
    // Outlets
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var featuredView: ImagePickerView!
    @IBOutlet weak var submitBtn: SubmitButton!
    
    var imagePicker: UIImagePickerController = UIImagePickerController()
    
    //var sourceVC: MemberVC? = nil
    
    var section_keys: [[String]] = [[String]]()
    
    fileprivate var form: RegisterForm!
    var agreePrivacy: Bool = true
    var sex: String = "M"
    
    let testData: [String: String] = [
        EMAIL_KEY: "ives@housetube.tw",
        PASSWORD_KEY: "1234",
        REPASSWORD_KEY: "1234",
        NAME_KEY: "孫志煌",
        NICKNAME_KEY: "列車長",
        DOB_KEY: "1969-01-05",
        MOBILE_KEY: "0911299994",
        TEL_KEY: "062295888",
        CITY_KEY: "218",
        "city_name": "台南市",
        AREA_KEY: "219",
        "area_name": "中西區",
        ROAD_KEY: "南華街101號8樓",
        FB_KEY: "https://www.facebook.com/ives.sun",
        LINE_KEY: "ives9999"
    ]
    
    override func viewDidLoad() {
        myTablView = tableView
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
        
        form = RegisterForm(delegate: self)
        imagePicker.delegate = self
        featuredView.gallery = imagePicker
        featuredView.delegate = self
        form.setDelegate(self)
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        hideKeyboardWhenTappedAround()
        FormItemCellType.registerCell(for: tableView)
        
        sections = form.getSections()
        section_keys = form.getSectionKeys()
        
        initData()
    }
    
    func initData() {
//        if testData.keyExist(key: AREA_KEY) {
//            let area_id: Int = Int(testData[AREA_KEY]!) ?? 0
//            let area = session.getAreaByAreaID(area_id)
//        }
        if testData.count > 0 {
            for (key, value) in testData {
                let formItem = getFormItemFromKey(key)
                if formItem != nil {
                    if key == AREA_KEY && testData.keyExist(key: "area_name") {
                        let _formItem = formItem as! AreaFormItem
                        _formItem.selected_area_names = [testData["area_name"]!]
                    } else if key == CITY_KEY && testData.keyExist(key: "city_name") { // test data session has, so not implement.
                        //let _formItem = formItem as! CityFormItem
                        //_formItem.selected_city_names = [testData["city_name"]!]
                    }
                    formItem!.value = value
                    formItem!.make()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section_keys[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = getFormItemFromIdx(indexPath)
        let cell: UITableViewCell
        if item != nil {
            if let cellType = item!.uiProperties.cellType {
                cell = cellType.dequeueCell(for: tableView, at: indexPath)
            } else {
                cell = UITableViewCell()
            }
            
            if let formUpdatableCell = cell as? FormUPdatable {
                item!.indexPath = indexPath
                formUpdatableCell.update(with: item!)
            }
//            if item!.uiProperties.cellType == FormItemCellType.textField {
//                if let formDelegateCell = cell as? TextFieldChangeDelegate {
//                    formDelegateCell.setTextFieldDelegate(delegate: self)
//                }
//            }
            
        } else {
            cell = UITableViewCell()
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = getFormItemFromIdx(indexPath)
        if item != nil {
            if item!.name != nil {
                //let segue = item!.segue!
                let key = item!.name
                if key == CITY_KEY {
                    let selectItem: CityFormItem = item as! CityFormItem
                    var selected: String = ""
                    if selectItem.selected_city_ids.count > 0 {
                        selected = String(selectItem.selected_city_ids[0])
                    }
                    toSelectCity(key: key, selected: selected, _delegate: self)
                } else if key == AREA_KEY {
                    let cityItem: CityFormItem = getFormItemFromKey(CITY_KEY)! as! CityFormItem
                    if cityItem.value == nil {
                        warning("請先選擇縣市")
                    } else {
                        let city_id = Int(cityItem.value!)
                        let selectItem: AreaFormItem = item as! AreaFormItem
                        var selected: String = ""
                        if selectItem.selected_area_ids.count > 0 {
                            selected = String(selectItem.selected_area_ids[0])
                        }
                        toSelectArea(key: key, city_id: city_id, selected: selected, _delegate: self)
                    }
                } else if key == DOB_KEY {
                    let dobItem: DateFormItem = getFormItemFromKey(key!)! as! DateFormItem
                    var selected: String?
                    if dobItem.value != nil {
                        selected = dobItem.value!
                    }
                    toSelectDate(key: key, selected: selected)
                }
            }
        }
    }
    
    func getFormItemFromIdx(_ indexPath: IndexPath)-> FormItem? {
        let key = section_keys[indexPath.section][indexPath.row]
        return getFormItemFromKey(key)
    }
    
    func getFormItemFromKey(_ key: String)-> FormItem? {
        var res: FormItem? = nil
        for formItem in form.formItems {
            if key == formItem.name {
                res = formItem
                break
            }
        }
        
        return res
    }
    
    override func singleSelected(key: String, selected: String) {
        
        let item = getFormItemFromKey(key)
        if item != nil {
            if item!.value != selected {
                item!.reset()
            }
            if key == AREA_KEY {
                let item1: AreaFormItem = item as! AreaFormItem
                let cityItem = getFormItemFromKey(CITY_KEY)
                item1.city_id = Int((cityItem?.value)!)
            }
            item!.value = selected
            item!.make()
            tableView.reloadData()
        }
    }
    
    override func dateSelected(key: String, selected: String) {
        let item = getFormItemFromKey(key)
        if item != nil {
            if item!.value != selected {
                item!.reset()
            }
            item!.value = selected
            item!.make()
            tableView.reloadData()
        }
    }
    
    override func checkboxValueChanged(checked: Bool) {
        let item = getFormItemFromKey(PRIVACY_KEY)
        if !checked {
            warning("必須同意隱私權條款，才能註冊")
            item?.value = nil
        } else {
            item?.value = "1"
        }
        self.agreePrivacy = checked
    }
    
    override func sexValueChanged(sex: String) {
        
        let item = getFormItemFromKey(SEX_KEY)
        self.sex = sex
        item?.value = sex
        //print(self.sex)
    }
    
    func isImageSet(_ b: Bool) {}
    
    func myPresent(_ viewController: UIViewController) {
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
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitBtnPressed(_ sender: Any) {
        Global.instance.addSpinner(superView: self.view)
        for formItem in form.formItems {
            formItem.checkValidity()
            if !formItem.isValid {
                if formItem.msg != nil {
                    warning(formItem.msg!)
                } else {
                    warning("有錯誤")
                }
                break
            }
        }
        
        var params:[String: String] = [String: String]()
        for formItem in form.formItems {
            if formItem.value != nil {
                let value = formItem.value!
                params[formItem.name!] = value
            }
        }
        if let city_id = params["city"] {
            params["city_id"] = city_id
            params.removeValue(forKey: "city")
        }
        if let area_id = params["area"] {
            params["area_id"] = area_id
            params.removeValue(forKey: "area")
        }
        //print(params)
        
//        MemberService.instance.update(_params: params, image: nil) { (success) in
//            if success {
//                Global.instance.removeSpinner(superView: self.view)
//                if MemberService.instance.success {
//                    let appearance = SCLAlertView.SCLAppearance(
//                        showCloseButton: false
//                    )
//                    let alert = SCLAlertView(appearance: appearance)
//                    alert.addButton("確定", action: {
//                        //print("ok")
//                        self.dismiss(animated: true, completion: nil)
//                    })
//                    alert.showSuccess("成功", subTitle: "註冊成功，已經寄出email與手機的認證訊息，請繼續完成認證程序")
//                    //NotificationCenter.default.post(name: NOTIF_TEAM_UPDATE, object: nil)
//                } else {
//                    self.warning(MemberService.instance.msg)
//                    //SCLAlertView().showWarning("錯誤", subTitle: MemberService.instance.msg)
//                }
//            } else {
//                Global.instance.removeSpinner(superView: self.view)
//                self.warning("伺服器錯誤，請稍後再試，或洽管理人員")
//                //SCLAlertView().showWarning("錯誤", subTitle: "註冊失敗，伺服器錯誤，請稍後再試")
//            }
//        }
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
    
    
    
//    func backToMenu() {
//        if self.menuVC != nil {
//            self.menuVC!._loginout()
//        }
//        self.performSegue(withIdentifier: UNWIND, sender: "refresh_team")
//    }
}

