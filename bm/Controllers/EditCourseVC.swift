//
//  EditCourseVC.swift
//  bm
//
//  Created by ives on 2019/5/28.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit

protocol ReloadDelegate {
    func isReload(_ yes: Bool)
}

class EditCourseVC: MyTableVC, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImagePickerViewDelegate {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var featuredView: ImagePickerView!
    @IBOutlet weak var submitBtn: SubmitButton!
    
    var imagePicker: UIImagePickerController = UIImagePickerController()
    
    var isFeaturedChange: Bool = false
    
    //var title: String? = nil
    var course_token: String? = nil
    var coach_token: String? = nil
    
    var myTable: CourseTable? = nil
    
    var delegate: ReloadDelegate?
    
//    var section_keys: [[String]] = [[String]]()
//    var sections: [String]?

    override func viewDidLoad() {
        myTablView = tableView
        form = CourseForm()
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
        
        
//        FormItemCellType.registerCell(for: tableView)
//
//        sections = form.getSections()
//        section_keys = form.getSectionKeys()
        
//        print(sections)
//        print(section_keys)
        if course_token != nil && course_token!.count > 0 {
            refresh()
        }
    }
    
    func initData() {
        
        if myTable != nil {
            var rows: [OneRow] = [OneRow]()
            var row: OneRow = OneRow(title: "標題", value: myTable!.title, show: myTable!.title, key: TITLE_KEY, cell: "textField", keyboard: KEYBOARD.default, placeholder: "兒童訓練班")
            row.msg = "標題沒有填寫"
            rows.append(row)
            row = OneRow(title: "youtube代碼", value: myTable!.youtube, show: myTable!.youtube, key: YOUTUBE_KEY, cell: "textField", keyboard: KEYBOARD.default, placeholder: "請輸入youtube代碼", isRequired: false)
            rows.append(row)
            
            var section: OneSection = makeSectionRow(title: "一般", key: "general", rows: rows)
            oneSections.append(section)
            
            rows.removeAll()
            row = OneRow(title: "收費標準", value: String(myTable!.price), show: String(myTable!.price), key: PRICE_KEY, cell: "textField", isRequired: false)
            rows.append(row)
            row = OneRow(title: "收費週期", value: myTable!.price_unit, show: myTable!.price_unit_show, key: PRICE_UNIT_KEY, cell: "more", isRequired: false)
            rows.append(row)
            row = OneRow(title: "補充說明", value: myTable!.price_short_show, show: myTable!.price_short_show, key: PRICE_DESC_KEY, cell: "textField", isRequired: false)
            rows.append(row)
            
            section = makeSectionRow(title: "收費", key: "charge", rows: rows)
            oneSections.append(section)
            
            rows.removeAll()
            row = OneRow(title: "課程週期", value: myTable!.kind, show: myTable!.kind_show, key: COURSE_KIND_KEY, cell: "more", isRequired: false)
            rows.append(row)
            row = OneRow(title: "週期", value: myTable!.cycle_unit, show: myTable!.cycle_unit_show, key: CYCLE_UNIT_KEY, cell: "more", isRequired: false)
            rows.append(row)
            row = OneRow(title: "星期幾", value: String(myTable!.weekday), show: myTable!.weekdays_show, key: WEEKDAY_KEY, cell: "more", isRequired: false)
            rows.append(row)
            row = OneRow(title: "開始時間", value: myTable!.start_time, show: myTable!.start_time_show, key: START_TIME_KEY, cell: "more", isRequired: false)
            rows.append(row)
            row = OneRow(title: "結束時間", value: myTable!.end_time, show: myTable!.end_time_show, key: END_TIME_KEY, cell: "more", isRequired: false)
            rows.append(row)
            row = OneRow(title: "開始日期", value: myTable!.start_date, show: myTable!.start_date, key: START_DATE_KEY, cell: "more", isRequired: false)
            rows.append(row)
            row = OneRow(title: "結束日期", value: myTable!.end_date, show: myTable!.end_date, key: END_DATE_KEY, cell: "more", isRequired: false)
            rows.append(row)
            row = OneRow(title: "人數限制", value: String(myTable!.people_limit), show: String(myTable!.people_limit), key: PEOPLE_LIMIT_KEY, cell: "textField", isRequired: false)
            rows.append(row)
            row = OneRow(title: "詳細介紹", value: myTable!.content, show: myTable!.content, key: CONTACT_KEY, cell: "textField", isRequired: false)
            rows.append(row)
            section = makeSectionRow(title: "課程", key: "course", rows: rows)
            oneSections.append(section)
        }
    }
    
    override func refresh() {
        
        Global.instance.addSpinner(superView: view)
        let params: [String: String] = ["token": course_token!]
        CourseService.instance.getOne(params: params) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if success {
                let jsonData: Data = CourseService.instance.jsonData!
                do {
                    self.myTable = try JSONDecoder().decode(CourseTable.self, from: jsonData)
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
                self.warning(CourseService.instance.msg)
            }
            self.endRefresh()
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
        return 45
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        let item = getFormItemFromIdx(indexPath)
//        if item!.name == CONTENT_KEY {
//            return 200
//        } else {
//            return 60
//        }
//        //return 60
//    }
    
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
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        let headerView = UIView()
//        headerView.backgroundColor = UIColor.white
//        headerView.tag = section
//
//        let titleLabel = UILabel()
//        titleLabel.text = sections?[section]
//        titleLabel.textColor = UIColor.black
//        titleLabel.sizeToFit()
//        titleLabel.frame = CGRect(x: 10, y: 0, width: 100, height: 34)
//        headerView.addSubview(titleLabel)
//
//        let mark = UIImageView(image: UIImage(named: "to_right"))
//        mark.frame = CGRect(x: view.frame.width-10-20, y: (34-20)/2, width: 20, height: 20)
//        headerView.addSubview(mark)
//
//        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleExpandClose))
//        headerView.addGestureRecognizer(gesture)
//
//        return headerView
//    }
    
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
//        if item != nil {
//            if let cellType = item!.uiProperties.cellType {
//                cell = cellType.dequeueCell(for: tableView, at: indexPath)
//            } else {
//                cell = UITableViewCell()
//            }
//
//            if let formUpdatableCell = cell as? FormUPdatable {
//                item!.indexPath = indexPath
//                formUpdatableCell.update(with: item!)
//            }
//
//        } else {
//            cell = UITableViewCell()
//        }
        
        return UITableViewCell()
    }
    
//    func getFormItemFromIdx(_ indexPath: IndexPath)-> FormItem? {
//        let key = section_keys[indexPath.section][indexPath.row]
//        return getFormItemFromKey(key)
//    }
    
//    func getFormItemFromKey(_ key: String)-> FormItem? {
//        var res: FormItem? = nil
//        for formItem in form.formItems {
//            if key == formItem.name {
//                res = formItem
//                break
//            }
//        }
//
//        return res
//    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row: OneRow = oneSections[indexPath.section].items[indexPath.row]
        
        if (row.cell == "more") {
            moreClickForOne(key: row.key, row: row, delegate: self)
        }
        
//        let row = getFormItemFromIdx(indexPath)
//        if row != nil {
//            if (row!.name != nil) {
//                let key = row!.name!
//                if (key == PRICE_UNIT_KEY || key == CYCLE_UNIT_KEY || key == COURSE_KIND_KEY || key == START_TIME_KEY || key == END_TIME_KEY) {
//                    var selected: String? = nil
//                    if (row!.value != nil) {
//                        selected = row!.value
//                    }
//                    toSelectSingle(key: key, selected: selected, delegate: self)
//                } else if (key == START_DATE_KEY || key == END_DATE_KEY) {
//                    var selected: String? = nil
//                    if (row!.value != nil) {
//                        selected = row!.value
//                    }
//                    toSelectDate(key: key, selected: selected)
//                } else if (key == WEEKDAY_KEY) {
//                    let items: [String] = row!.sender as! [String]
//                    var selecteds: [Int] = [Int]()
//                    for item in items {
//                        if let tmp: Int = Int(item) {
//                            selecteds.append(tmp)
//                        }
//                    }
//                    toSelectWeekday(key: key, selecteds: selecteds, delegate: self)
//                } else if (key == CONTENT_KEY) {
//                    var content: String? = nil
//                    if row!.sender != nil {
//                        content = row!.sender as? String
//                    }
//                    toEditContent(key: key, title: row!.title, content: content, _delegate: self)
//                }
//                //performSegue(withIdentifier: segue, sender: indexPath)
//            }
//        }
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
        isFeaturedChange = b
    }
    func myPresent(_ viewController: UIViewController) {
        self.present(viewController, animated: true, completion: nil)
    }
    
//    override func singleSelected(key: String, selected: String, show: String?=nil) {
//        let item = getFormItemFromKey(key)
//        if item != nil {
//            item!.value = selected
//            item!.make()
//            tableView.reloadData()
//        }
//    }
    
//    override func setWeekdaysData(selecteds: [Int]) {
//        let item = getFormItemFromKey(WEEKDAY_KEY)
//        //let tmps: [Int] = selecteds.map({ Int($0)! })
//        let value = String(Global.instance.weekdaysToDBValue(selecteds))
//
//        item!.value = value
//        item!.make()
//        tableView.reloadData()
//    }
    
 //   override func multiSelected(key: String, selecteds: [String]) {
//        let item = getFormItemFromKey(key)
//        if item != nil {
//            var value: String = "-1"
//            if item!.name! == WEEKDAY_KEY {
//                let tmps: [Int] = selecteds.map({ Int($0)! })
//                value = String(Global.instance.weekdaysToDBValue(tmps))
//            }
//            item!.value = value
//            item!.make()
//            tableView.reloadData()
//        }
//    }
    
//    override func setContent(key: String, content: String) {
//        let item = getFormItemFromKey(key)
//        if item != nil {
//            item!.value = content
//            item!.make()
//            tableView.reloadData()
//        }
//    }
    
//    override func dateSelected(key: String, selected: String) {
//        let item = getFormItemFromKey(key)
//        if item != nil {
//            item!.value = selected
//            item!.make()
//            tableView.reloadData()
//        }
//    }
    
    @IBAction func submit(_ sender: Any) {
        
        var action = "UPDATE"
        if course_token != nil && course_token!.count == 0 {
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
                params["cat_id"] = String(41)
            }
            if course_token != nil {
                params["course_token"] = course_token!
            }
            if coach_token != nil {
                params["coach_token"] = coach_token!
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
//        for formItem in form.formItems {
//            if formItem.value != nil {
//                let value = formItem.value!
//                //print(formItem.name)
//                params[formItem.name!] = value
//            } else {
//                params[formItem.name!] = ""
//            }
//        }
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
