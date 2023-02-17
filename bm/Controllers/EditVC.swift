//
//  TeamEditVC.swift
//  bm
//
//  Created by ives on 2017/11/9.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import SCLAlertView

class EditVC: MyTableVC, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImagePickerViewDelegate {
    
    // Outlets
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var featuredView: ImagePickerView!
    @IBOutlet weak var submitBtn: SubmitButton!
    
    var imagePicker: UIImagePickerController = UIImagePickerController()
    var token: String?
    var isFeaturedChange: Bool = false
    
    var delegate: BaseViewController?
    
    override func viewDidLoad() {
        
        //print("token: \(token)")
 
        //let token: String = model.data[TEAM_TOKEN_KEY]!["value"] as! String
//        if source == "team" {
//            model = Team.instance
//            dataService = TeamService.instance
//            ch = "球隊"
//        } else if source == "coach" {
//            model = Coach.instance
//            dataService = CoachService.instance
//            ch = "教練"
//        } else if source == "arena" {
//            model = Arena.instance
//            dataService = ArenaService.instance
//            ch = "球館"
//        }
        
        super.viewDidLoad()
        
        //titleLbl.text = title
        
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
        
        let switchCellNib = UINib(nibName: "SwitchCell", bundle: nil)
        tableView.register(switchCellNib, forCellReuseIdentifier: "switchCell")
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
        } else if (cell_type == "switch") {
            if let cell: SwitchCell = tableView.dequeueReusableCell(withIdentifier: "switchCell", for: indexPath) as? SwitchCell {
                
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
            cellMoreClick(key: row.key, row: row, delegate: self)
        }
        
//        Global.instance.addSpinner(superView: view)
//        Global.instance.removeSpinner(superView: view)
        //let row: [String: Any] = _getRowByindexPath(indexPath: indexPath)
//        var key = NAME_KEY
//        if row["key"] != nil {
//            key = row["key"]! as! String
//        }
//        let cell = tableView.cellForRow(at: indexPath) as! EditCell
//        if row["atype"] as! UITableViewCell.AccessoryType != UITableViewCell.AccessoryType.none {
//            if row["segue"] != nil {
//                let segue: String = row["segue"] as! String
//                //print(iden)
////                let city: Int = model.data[CITY_KEY]!["value"] as! Int
////                if segue == TO_ARENA && city == 0 {
////                    SCLAlertView().showError("錯誤", subTitle: "請先選擇區域")
////                } else if segue == TO_TEXT_INPUT {
////                    var sender: [String: Any] = [String: Any]()
////                    sender["key"] = key
////                    if row["sender"] != nil {
////                        sender["sender"] = row["sender"]
////                    }
////                    performSegue(withIdentifier: segue, sender: sender)
////                } else {
////                    performSegue(withIdentifier: segue, sender: row["sender"])
////                }
//            }
//        } else {
//            cell.editText.becomeFirstResponder()
//        }
    }
    
    func submitValidate() {}
    
    func submit(_ sender: Any) {
        
        var action = "UPDATE"
        if token != nil && token!.count == 0 {
            action = "INSERT"
        }
        
        msg = ""
        for section in oneSections {
            for row in section.items {
                params[row.key] = row.value
                if row.isRequired && row.show.count == 0 {
                    msg += row.msg + "\n"
                }
            }
        }
        
        submitValidate()
        
        if msg.count > 0 {
            warning(msg)
        } else {
            //print(params)
            if action == "INSERT" {
                params[CREATED_ID_KEY] = String(Member.instance.id)
            }
            
            if token != nil && token!.count > 0 {
                params["token"] = token!
            }
            
            //params["do"] = "update"
            
            //print(params)
            let image: UIImage? = isFeaturedChange ? featuredView.imageView.image : nil
            dataService.update(_params: params, image: image) { (success) in
                if success {
                    
                    self.jsonData = self.dataService.jsonData
                    do {
                        if (self.jsonData != nil) {
                            let table: SuccessTable = try JSONDecoder().decode(SuccessTable.self, from: self.jsonData!)
                            if table.success {
                                self.msg = (action == "INSERT") ? "新增成功" : "修改成功"
                                self.info(msg: self.msg, buttonTitle: "關閉") {
                                    if self.delegate != nil {
                                        self.delegate!.refresh()
                                        self.prev()
                                    }
                                }
                            } else {
                                self.warning(table.msg)
                            }
                        } else {
                            self.warning("無法從伺服器取得正確的json資料，請洽管理員")
                        }
                    } catch {
                        self.warning("解析JSON字串時，得到空值，請洽管理員")
                    }
                } else {
                    self.warning("新增 / 修改失敗，伺服器無法新增成功，請稍後再試")
                }
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
//        if delegate != nil {
//            delegate!.isReload(false)
//        }
        prev()
    }
    
    @IBAction override func prevBtnPressed(_ sender: Any) {
//        if delegate != nil {
//            delegate!.isReload(false)
//        }
        prev()
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
        isFeaturedChange = b
    }
    
    func myPresent(_ viewController: UIViewController) {
        self.present(viewController, animated: true, completion: nil)
    }
}
