//
//  EditCourseVC.swift
//  bm
//
//  Created by ives on 2019/5/28.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit
import SCLAlertView

protocol EditCourseDelegate {
    func isReload(_ yes: Bool)
}

class EditCourseVC: MyTableVC, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImagePickerViewDelegate, ContentEditDelegate, ValueChangedDelegate {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var featuredView: ImagePickerView!
    @IBOutlet weak var submitBtn: SubmitButton!
    
    var imagePicker: UIImagePickerController = UIImagePickerController()
    
    var isFeaturedChange: Bool = false
    
    //var title: String? = nil
    var course_token: String? = nil
    var coach_token: String? = nil
    
    var courseTable: CourseTable? = nil
    
    var delegate: EditCourseDelegate?

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
        FormItemCellType.registerCell(for: tableView)
        
        sections = form.getSections()
        section_keys = form.getSectionKeys()
//        print(sections)
//        print(section_keys)
        if course_token != nil && course_token!.count > 0 {
            refresh()
        }
        
    }
    
    override func refresh() {
        Global.instance.addSpinner(superView: view)
        let params: [String: String] = ["token": course_token!]
        CourseService.instance.getOne(t: CourseTable.self, params: params) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if success {
                let table: Table = CourseService.instance.table!
                self.courseTable = table as? CourseTable
                self.putValue()
                self.tableView.reloadData()
            } else {
                self.warning(CourseService.instance.msg)
            }
            self.endRefresh()
        }
    }
    
    func putValue() {
        if courseTable != nil {
            let mirror: Mirror? = Mirror(reflecting: courseTable!)
            if mirror != nil {
                for formItem in self.form.formItems {
                    let name = formItem.name!
                    for (property, value) in mirror!.children {
                        if name == property {
                            let typeof = type(of: value)
                            if typeof == String.self {
                                formItem.value = value as? String
                            } else if typeof == Int.self {
                                let tmp = value as! Int
                                formItem.value = String(tmp)
                            }
                            formItem.make()
                        }
                        
                    }
                }
            }
            //featuredView.s
            let featured_path = courseTable!.featured_path
            if featured_path.count > 0 {
                //print(featured_path)
                featuredView.setPickedImage(url: featured_path)
            }
            //featuredView.setPickedImage(image: superCourse!.featured)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let item = getFormItemFromIdx(indexPath)
        if item!.name == CONTENT_KEY {
            return 200
        } else {
            return 60
        }
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
            
            if item!.uiProperties.cellType == FormItemCellType.textField {
                if let formCell = cell as? FormItemCell {
                    formCell.valueDelegate = self
                }
            }
        } else {
            cell = UITableViewCell()
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Global.instance.addSpinner(superView: view)
        Global.instance.removeSpinner(superView: view)
        
        let item = getFormItemFromIdx(indexPath)
        if item != nil {
            if item!.segue != nil {
                let segue = item!.segue!
                performSegue(withIdentifier: segue, sender: indexPath)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let indexPath = sender as! IndexPath
        let item = getFormItemFromIdx(indexPath)
        if item != nil {
            var rows: [[String: String]]? = nil
            if segue.identifier == TO_SINGLE_SELECT {
                
                let vc: SingleSelectVC = segue.destination as! SingleSelectVC
                
                if item!.name == PRICE_UNIT_KEY {
                    rows = PRICE_UNIT.makeSelect()
                } else if item!.name == CYCLE_UNIT_KEY {
                    rows = CYCLE_UNIT.makeSelect()
                } else if item!.name == COURSE_KIND_KEY {
                    rows = COURSE_KIND.makeSelect()
                } else if item!.name == START_TIME_KEY || item!.name == END_TIME_KEY {
                    let times = Global.instance.makeTimes()
                    rows = [[String: String]]()
                    for time in times {
                        rows!.append(["title": time, "value": time+":00"])
                    }
                }
                if rows != nil {
                    vc.rows1 = rows
                }
                
                vc.key = item!.name
                vc.title = item!.title
                vc.delegate = self
            } else if segue.identifier == TO_MULTI_SELECT {
                let vc: MultiSelectVC = segue.destination as! MultiSelectVC
                
                if item!.name == WEEKDAY_KEY {
                    rows = WEEKDAY.makeSelect()
                    //print(rows)
                    if item!.sender != nil {
                        let selecteds = item!.sender as! [String]
                        //print(selecteds)
                        vc.selecteds = selecteds
                    }
                }
                
                if rows != nil {
                    vc.rows1 = rows
                }
                
                vc.key = item!.name
                vc.title = item!.title
                vc.delegate = self
            } else if segue.identifier == TO_CONTENT_EDIT {
                let vc: ContentEditVC = segue.destination as! ContentEditVC
                if item!.name == CONTENT_KEY {
                    if item!.sender != nil {
                        let content = item!.sender as! String
                        vc.content = content
                    }
                }
                vc.key = item!.name
                vc.title = item!.title
                vc.delegate = self
            } else if segue.identifier == TO_SELECT_DATE {
                let vc: DateSelectVC = segue.destination as! DateSelectVC
                vc.key = item!.name
                vc.selected = item!.value!
                vc.title = item!.title
                vc.delegate = self
            }
            
        }
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
        //isFeaturedChange = b
    }
    func myPresent(_ viewController: UIViewController) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    override func singleSelected(key: String, selected: String) {
        let item = getFormItemFromKey(key)
        if item != nil {
            item!.value = selected
            item!.make()
            tableView.reloadData()
        }
    }
    
    override func multiSelected(key: String, selecteds: [String]) {
        let item = getFormItemFromKey(key)
        if item != nil {
            var value: String = "-1"
            if item!.name! == WEEKDAY_KEY {
                let tmps: [Int] = selecteds.map({ Int($0)! })
                value = String(Global.instance.weekdaysToDBValue(tmps))
            }
            item!.value = value
            item!.make()
            tableView.reloadData()
        }
    }
    
    func setContent(key: String, content: String) {
        let item = getFormItemFromKey(key)
        if item != nil {
            item!.value = content
            item!.make()
            tableView.reloadData()
        }
    }
    
    override func dateSelected(key: String, selected: String) {
        let item = getFormItemFromKey(key)
        if item != nil {
            item!.value = selected
            item!.make()
            tableView.reloadData()
        }
    }
    
    @IBAction func submit(_ sender: Any) {
        
        var action = "UPDATE"
        if course_token != nil && course_token!.count == 0 {
            action = "INSERT"
        }
        
        var params:[String: String] = [String: String]()
        for formItem in form.formItems {
            if formItem.value != nil {
                let value = formItem.value!
                //print(formItem.name)
                params[formItem.name!] = value
            }
        }
        //print(params)
        if action == "INSERT" {
            params[CREATED_ID_KEY] = String(Member.instance.id)
            params["cat_id"] = String(44)
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
                if CourseService.instance.success {
                    let appearance = SCLAlertView.SCLAppearance(
                        showCloseButton: false
                    )
                    let alert = SCLAlertView(appearance: appearance)
                    if (action == "INSERT") {
                        alert.addButton("確定", action: {
                            if self.delegate != nil {
                                self.delegate!.isReload(true)
                            }
                            self.dismiss(animated: true, completion: nil)
                        })
                    } else {
                        alert.addButton("回上一頁", action: {
                            if self.delegate != nil {
                            
                                self.delegate!.isReload(true)
                            }
                            self.dismiss(animated: true, completion: nil)
                        })
                        alert.addButton("繼續修改", action: {
                        })
                    }
                    alert.showSuccess("成功", subTitle: "新增 / 修改成功")
                    NotificationCenter.default.post(name: NOTIF_TEAM_UPDATE, object: nil)
                } else {
                    SCLAlertView().showWarning("錯誤", subTitle: CourseService.instance.msg)
                }
            } else {
                SCLAlertView().showWarning("錯誤", subTitle: "新增 / 修改失敗，伺服器無法新增成功，請稍後再試")
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
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        if delegate != nil {
            delegate!.isReload(false)
        }
        prev()
    }

}
