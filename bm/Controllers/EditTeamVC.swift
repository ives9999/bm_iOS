//
//  EditTeamVC.swift
//  bm
//
//  Created by ives on 2021/11/19.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class EditTeamVC: MyTableVC, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImagePickerViewDelegate {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var featuredView: ImagePickerView!
    @IBOutlet weak var submitBtn: SubmitButton!
    
    var imagePicker: UIImagePickerController = UIImagePickerController()
    
    var isFeaturedChange: Bool = false
    
    //var title: String? = nil
    var team_token: String? = nil
    
    var myTable: TeamTable? = nil
    
    var delegate: ReloadDelegate?

    override func viewDidLoad() {
        myTablView = tableView
        super.viewDidLoad()

        if title == nil {
            title = "課程"
        }
        titleLbl.text = title
        
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
        
        if team_token != nil && team_token!.count > 0 {
            refresh()
        }
    }
    
    override func refresh() {
        
        Global.instance.addSpinner(superView: view)
        let params: [String: String] = ["token": team_token!]
        TeamService.instance.getOne(params: params) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if success {
                let jsonData: Data = TeamService.instance.jsonData!
                do {
                    self.myTable = try JSONDecoder().decode(TeamTable.self, from: jsonData)
                    if (self.myTable != nil) {
                        self.myTable!.filterRow()
                        self.initData()
                        //self.putValue()
                        self.titleLbl.text = self.myTable!.title
                        self.tableView.reloadData()
                    }
                } catch {
                    self.warning(error.localizedDescription)
                }
                
                
//                let table: Table = CourseService.instance.table!
//                self.courseTable = table as? CourseTable
//                self.putValue()
//                self.titleLbl.text = table.title
//                self.tableView.reloadData()
            } else {
                self.warning(TeamService.instance.msg)
            }
            self.endRefresh()
        }
    }
    
    func initData() {
        
        if myTable != nil {
            var rows: [OneRow] = [OneRow]()
            var row: OneRow = OneRow(title: "名稱", value: myTable!.name, show: myTable!.name, key: TITLE_KEY, cell: "textField", keyboard: KEYBOARD.default, placeholder: "羽球密碼羽球隊")
            row.msg = "球隊名稱沒有填寫"
            rows.append(row)
            row = OneRow(title: "縣市", value: String(myTable!.city_id), show: myTable!.city_show, key: CITY_KEY, cell: "more", keyboard: KEYBOARD.default, placeholder: "", isRequired: true)
            row.msg = "沒有選擇縣市"
            rows.append(row)
            row = OneRow(title: "球館", value: String(myTable!.arena_id), show: myTable!.arena!.name, key: ARENA_KEY, cell: "more", keyboard: KEYBOARD.default, placeholder: "", isRequired: true)
            rows.append(row)
            
            var section: OneSection = makeSectionRow(title: "基本資料", key: "general", rows: rows)
            oneSections.append(section)
            
            rows.removeAll()
            var weekdays: Int = 0
            for weekday in myTable!.weekdays {
                let n: Int = (pow(2, weekday.weekday) as NSDecimalNumber).intValue
                weekdays = weekdays & n
            }
            row = OneRow(title: "星期幾", value: String(weekdays), show: myTable!.weekdays_show, key: WEEKDAY_KEY, cell: "more", isRequired: true)
            row.msg = "沒有選擇星期幾"
            rows.append(row)
            row = OneRow(title: "開始時間", value: myTable!.play_start, show: myTable!.play_start_show, key: START_TIME_KEY, cell: "more", isRequired: true)
            row.msg = "沒有選擇開始時間"
            rows.append(row)
            row = OneRow(title: "結束時間", value: myTable!.play_end, show: myTable!.play_end_show, key: END_TIME_KEY, cell: "more", isRequired: true)
            row.msg = "沒有選擇結束時間"
            rows.append(row)
            row = OneRow(title: "程度", value: myTable!.degree, show: myTable!.degree_show, key: PRICE_UNIT_KEY, cell: "more", isRequired: false)
            rows.append(row)
            row = OneRow(title: "球種", value: myTable!.ball, show: myTable!.ball, key: TEAM_BALL_KEY, cell: "textField", keyboard: KEYBOARD.default, placeholder: "RSL4號球")
            rows.append(row)
            row = OneRow(title: "臨打費用-男", value: String(myTable!.temp_fee_M), show: myTable!.temp_fee_M_show, key: TEAM_TEMP_FEE_M_KEY, cell: "textField", keyboard: KEYBOARD.default, placeholder: "300")
            rows.append(row)
            row = OneRow(title: "臨打費用-女", value: String(myTable!.temp_fee_F), show: myTable!.temp_fee_F_show, key: TEAM_TEMP_FEE_F_KEY, cell: "textField", keyboard: KEYBOARD.default, placeholder: "200")
            rows.append(row)
            
            section = makeSectionRow(title: "打球資料", key: "charge", rows: rows)
            oneSections.append(section)
            
            rows.removeAll()
            row = OneRow(title: "隊長", value: String(myTable!.manager_id), show: myTable!.manager_nickname, key: MANAGER_ID_KEY, cell: "more", isRequired: false)
            row.token = myTable!.manager_token
            rows.append(row)
            row = OneRow(title: "line", value: myTable!.line, show: myTable!.line, key: LINE_KEY, cell: "textField", keyboard: KEYBOARD.default, placeholder: "david221")
            rows.append(row)
            row = OneRow(title: "行動電話", value: myTable!.mobile, show: myTable!.mobile, key: MOBILE_KEY, cell: "textField", keyboard: KEYBOARD.numberPad, placeholder: "0939123456")
            rows.append(row)
            row = OneRow(title: "EMail", value: myTable!.email, show: myTable!.email, key: EMAIL_KEY, cell: "textField", keyboard: KEYBOARD.emailAddress, placeholder: "service@bm.com")
            rows.append(row)
            row = OneRow(title: "youtube代碼", value: myTable!.youtube, show: myTable!.youtube, key: YOUTUBE_KEY, cell: "textField", keyboard: KEYBOARD.default, placeholder: "請輸入youtube代碼", isRequired: false)
            rows.append(row)
            row = OneRow(title: "FB", value: myTable!.fb, show: myTable!.fb, key: FB_KEY, cell: "textField", keyboard: KEYBOARD.default, placeholder: "請輸入FB網址", isRequired: false)
            rows.append(row)
            
            
            section = makeSectionRow(title: "聯絡資料", key: "course", rows: rows)
            oneSections.append(section)
            
            row = OneRow(title: "收費詳細說明", value: myTable!.charge, show: myTable!.charge, key: CHARGE_KEY, cell: "more")
            rows.append(row)
            row = OneRow(title: "更多詳細說明", value: myTable!.content, show: myTable!.content, key: CONTENT_KEY, cell: "more")
            rows.append(row)
            
            section = makeSectionRow(title: "詳細說明", key: "content", rows: rows)
            oneSections.append(section)
        }
    }
    
//    func putValue() {
//        if courseTable != nil {
//            
//            let mirror: Mirror = Mirror(reflecting: courseTable!)
//            let propertys: [[String: Any]] = mirror.toDictionary()
//            
//            for formItem in form.formItems {
//                
//                for property in propertys {
//                    
//                    if ((property["label"] as! String) == formItem.name) {
//                        var type: String = property["type"] as! String
//                        type = type.getTypeOfProperty()!
//                        //print("label=>\(property["label"]):value=>\(property["value"]):type=>\(type)")
//                        var content: String = ""
//                        if type == "Int" {
//                            content = String(property["value"] as! Int)
//                        } else if type == "Bool" {
//                            content = String(property["value"] as! Bool)
//                        } else if type == "String" {
//                            content = property["value"] as! String
//                        }
//                        formItem.value = content
//                        formItem.make()
//                        break
//                    }
//                }
//            }
//            
//            let featured_path = courseTable!.featured_path
//            if featured_path.count > 0 {
//                //print(featured_path)
//                featuredView.setPickedImage(url: featured_path)
//            }
//            //featuredView.setPickedImage(image: superCourse!.featured)
//        }
//    }
    
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
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row: OneRow = oneSections[indexPath.section].items[indexPath.row]
        
        if (row.cell == "more") {
            moreClickForOne(key: row.key, row: row, delegate: self)
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        let indexPath = sender as! IndexPath
//        let item = getFormItemFromIdx(indexPath)
//        if item != nil {
//            var rows: [[String: String]]? = nil
//            if segue.identifier == TO_SINGLE_SELECT {
//
//                let vc: SingleSelectVC = segue.destination as! SingleSelectVC
//
//                if item!.name == PRICE_UNIT_KEY {
//                    rows = PRICE_UNIT.makeSelect()
//                } else if item!.name == CYCLE_UNIT_KEY {
//                    rows = CYCLE_UNIT.makeSelect()
//                } else if item!.name == COURSE_KIND_KEY {
//                    rows = COURSE_KIND.makeSelect()
//                } else if item!.name == START_TIME_KEY || item!.name == END_TIME_KEY {
//                    let times = Global.instance.makeTimes()
//                    rows = [[String: String]]()
//                    for time in times {
//                        rows!.append(["title": time, "value": time+":00"])
//                    }
//                }
//                if rows != nil {
//                    vc.rows1 = rows
//                }
//
//                vc.key = item!.name
//                vc.title = item!.title
//                vc.delegate = self
//            } else if segue.identifier == TO_MULTI_SELECT {
//                let vc: MultiSelectVC = segue.destination as! MultiSelectVC
//
//                if item!.name == WEEKDAY_KEY {
//                    rows = WEEKDAY.makeSelect()
//                    //print(rows)
//                    if item!.sender != nil {
//                        let selecteds = item!.sender as! [String]
//                        //print(selecteds)
//                        vc.selecteds = selecteds
//                    }
//                }
//
//                if rows != nil {
//                    vc.rows1 = rows
//                }
//
//                vc.key = item!.name
//                vc.title = item!.title
//                vc.delegate = self
//            } else if segue.identifier == TO_CONTENT_EDIT {
//                let vc: ContentEditVC = segue.destination as! ContentEditVC
//                if item!.name == CONTENT_KEY {
//                    if item!.sender != nil {
//                        let content = item!.sender as! String
//                        vc.content = content
//                    }
//                }
//                vc.key = item!.name
//                vc.title = item!.title
//                vc.delegate = self
//            } else if segue.identifier == TO_SELECT_DATE {
//                let vc: DateSelectVC = segue.destination as! DateSelectVC
//                vc.key = item!.name
//                vc.selected = item!.value!
//                vc.title = item!.title
//                vc.delegate = self
//            }
//
//        }
//    }
    
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
        //isFeaturedChange = b
    }
    func myPresent(_ viewController: UIViewController) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func submit(_ sender: Any) {
        
        var action = "UPDATE"
        if team_token != nil && team_token!.count == 0 {
            action = "INSERT"
        }
        
        var params:[String: String] = [String: String]()
        
        var msg: String = ""
        for section in oneSections {
            for row in section.items {
                params[row.key] = row.value
                if row.isRequired && row.value.count == 0 {
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
                params["cat_id"] = String(21)
            }
            if team_token != nil {
                params["team_token"] = team_token!
            }
            
            //print(params)
            let image: UIImage? = isFeaturedChange ? featuredView.imageView.image : nil
            CourseService.instance.update(_params: params, image: image) { (success) in
                if success {
                    
                    self.jsonData = CourseService.instance.jsonData
                    do {
                        if (self.jsonData != nil) {
                            let table: SuccessTable = try JSONDecoder().decode(SuccessTable.self, from: self.jsonData!)
                            if table.success {
                                self.info(msg: "修改成功", buttonTitle: "關閉") {
                                    if self.delegate != nil {
                                        self.delegate!.isReload(true)
                                    }
                                }
                            } else {
                                self.warning(table.msg)
                            }
                        } else {
                            self.warning("無法從伺服器取得正確的json資料，請洽管理員")
                        }
                    } catch {
                        self.msg = "解析JSON字串時，得到空值，請洽管理員"
                    }
                } else {
                    self.warning("新增 / 修改失敗，伺服器無法新增成功，請稍後再試")
                }
            }
        }
    }
    
    func textFieldTextChanged(formItem: FormItem, text: String) {
        formItem.value = text
        //print(text)
    }
    
    @IBAction func cancel(_ sender: Any) {
        if delegate != nil {
            delegate!.isReload(false)
        }
        prev()
    }
    
    @IBAction override func prevBtnPressed(_ sender: Any) {
        if delegate != nil {
            delegate!.isReload(false)
        }
        prev()
    }

}
