//
//  EditCourseVC.swift
//  bm
//
//  Created by ives on 2019/5/28.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit

class EditCourseVC: MyTableVC, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImagePickerViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var featuredView: ImagePickerView!
    @IBOutlet weak var submitBtn: SubmitButton!
    
    var imagePicker: UIImagePickerController = UIImagePickerController()
    
    var isFeaturedChange: Bool = false
    
    //var title: String? = nil
    var coachToken: String? = nil
    
    var section_keys: [[String]] = [[String]]()
    
    fileprivate var form: CourseForm = CourseForm()

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
        let key = section_keys[indexPath.section][indexPath.row]
        let item = getFormItemFromKey(key)
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
        
        let item = form.formItems[indexPath.row]
        if form.formItems[indexPath.row].uiProperties.cellType != nil {
            if item.segue != nil {
                let segue = item.segue!
                var sender: [String: Any?] = ["indexPath":indexPath]
                if item.sender != nil {
                    sender["sender"] = item.sender
                }
                //print(item.sender)
                performSegue(withIdentifier: segue, sender: sender)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == TO_SINGLE_SELECT {
            
        }
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
    
    @IBAction func submit(_ sender: Any) {
    
    }
    
    @IBAction func cancel(_ sender: Any) {
        prev()
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        prev()
    }

}
