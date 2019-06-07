//
//  EditCourseVC.swift
//  bm
//
//  Created by ives on 2019/5/28.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit

class EditCourseVC: MyTableVC, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImagePickerViewDelegate, SingleSelectDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var featuredView: ImagePickerView!
    @IBOutlet weak var submitBtn: SubmitButton!
    
    var imagePicker: UIImagePickerController = UIImagePickerController()
    
    var isFeaturedChange: Bool = false
    
    //var title: String? = nil
    var token: String? = nil
    
    var section_keys: [[String]] = [[String]]()
    
    fileprivate var form: CourseForm = CourseForm()
    var superCourse: SuperCourse? = nil

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
        FormItemCellType.registerCell(for: tableView)
        
        sections = form.getSections()
        section_keys = form.getSectionKeys()
//        print(sections)
//        print(section_keys)
        if token != nil {
            refresh()
        }
        
    }
    
    override func refresh() {
        Global.instance.addSpinner(superView: view)
        CourseService.instance.getOne(token: token!) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if success {
                self.superCourse = CourseService.instance.superCourse
                self.putValue()
                self.tableView.reloadData()
            } else {
                self.warning(CourseService.instance.msg)
            }
            self.endRefresh()
        }
    }
    
    func putValue() {
        if superCourse != nil {
            let mirror: Mirror? = Mirror(reflecting: superCourse!)
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
            featuredView.setPickedImage(image: superCourse!.featured)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
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
            if segue.identifier == TO_SINGLE_SELECT {
                let vc: SingleSelectVC = segue.destination as! SingleSelectVC
                
                let rows = PRICE_UNIT.makeSelect()
                vc.rows1 = rows
                vc.key = item!.name
                vc.title = item!.title
                //vc.delegate = self
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            featuredView.setPickedImage(image: pickedImage)
            isFeaturedChange = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    // ImagePickerDelegate
    func isImageSet(_ b: Bool) {
        //isFeaturedChange = b
    }
    func myPresent(_ viewController: UIViewController) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func singleSelected(key: String, value: String) {
        let item = getFormItemFromKey(key)
        if item != nil {
            item!.value = value
            item!.make()
        }
        tableView.reloadData()
    }
    
    @IBAction func submit(_ sender: Any) {
    
    }
    
    @IBAction func cancel(_ sender: Any) {
        prev()
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        prev()
    }

}
