//
//  EditStoreVC.swift
//  bm
//
//  Created by ives on 2020/11/20.
//  Copyright © 2020 bm. All rights reserved.
//

import Foundation

protocol EditStoreDelegate {
    func isReload(_ yes: Bool)
}

class EditStoreVC: MyTableVC, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImagePickerViewDelegate {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var featuredView: ImagePickerView!
    @IBOutlet weak var submitBtn: SubmitButton!
    
    var imagePicker: UIImagePickerController = UIImagePickerController()
    
    var store_token: String? = nil    
    
    var delegate: EditStoreDelegate?
    
    //let session: UserDefaults = UserDefaults.standard
    
    var citysandareas:[Int:[String:Any]] = [Int:[String:Any]]()
    
    override func viewDidLoad() {
        myTablView = tableView
        form = StoreForm()
        super.viewDidLoad()
        
        if title == nil {
            title = "體育用品店"
        }
        titleLbl.text = title
        
        imagePicker.delegate = self
        featuredView.gallery = imagePicker
        featuredView.delegate = self
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        
        hideKeyboardWhenTappedAround()
        FormItemCellType.registerCell(for: tableView)
        
//        sections = form.getSections()
//        section_keys = form.getSectionKeys()
//        print(sections)
//        print(section_keys)
        if store_token != nil && store_token!.count > 0 {
            //refresh()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return section_keys[section].count
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let item = getFormItemFromIdx(indexPath)
        let cell: UITableViewCell = UITableViewCell()
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
//        } else {
//            cell = UITableViewCell()
//        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Global.instance.addSpinner(superView: view)
        Global.instance.removeSpinner(superView: view)
        
//        let item = getFormItemFromIdx(indexPath)
//        if item != nil {
//            if item!.name != nil {
//                //let segue = item!.segue!
//                let key = item!.name
//                if key == CITY_KEY {
//                    let selectItem: CityFormItem = item as! CityFormItem
//                    var selected: String = ""
//                    if selectItem.selected_city_ids.count > 0 {
//                        selected = String(selectItem.selected_city_ids[0])
//                    }
//                    //toSelectCity(key: key, selected: selected, delegate: self)
//                    toSelectSingle(key: key, selected: selected, delegate: self)
//
//                    //let selecteds: [String] = [String]()
//                    //toSelectCitys(key: key, selecteds: selecteds, _delegate: self)
//                    //let city_ids: [Int] = [52, 66]
//                    //toSelectAreas(key: key, city_ids: city_ids, selecteds: selecteds, _delegate: self)
//                } else if key == AREA_KEY {
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
//                } else if key == OPEN_TIME_KEY || key == CLOSE_TIME_KEY {
//                    let times = Global.instance.makeTimes()
//                    var rows = [[String: String]]()
//                    for time in times {
//                        rows.append(["title": time, "value": time+":00"])
//                    }
//                    toSingleSelect(key: key, title: item!.title, rows: rows, _delegate: self)
//                } else if key == MANAGERS_KEY {
//                    //toSelectCity(key: key, selected: "", _delegate: self)
//                    toSelectManagers(delegate: self)
//                }
//            }
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
//        let indexPath = sender as! IndexPath
//        let item = getFormItemFromIdx(indexPath)
//        if item != nil {
//            var rows: [[String: String]]? = nil
//            if segue.identifier == TO_SINGLE_SELECT {
//                
//                let vc: SingleSelectVC = segue.destination as! SingleSelectVC
//                
//                if item!.name == CITY_KEY {
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
//                //vc.delegate = self
//            } else if segue.identifier == TO_SELECT_MANAGERS {
//                
//            }
//            
//        }
    }
    
    override func singleSelected(key: String, selected: String, show: String?=nil) {
        
//        let item = getFormItemFromKey(key)
//        if item != nil {
//            if item!.value != selected {
//                item!.reset()
//            }
//            if key == AREA_KEY {
//                let item1: AreaFormItem = item as! AreaFormItem
//                let cityItem = getFormItemFromKey(CITY_KEY)
//                item1.city_id = Int((cityItem?.value)!)
//            }
//            item!.value = selected
//            item!.make()
//            tableView.reloadData()
//        }
    }
    
//    override func selectedManagers(selecteds: [String]) {
//
//        let key = MANAGERS_KEY
//    }
    
    func isImageSet(_ b: Bool) {
    }
    
    func myPresent(_ viewController: UIViewController) {
        self.present(viewController, animated: true, completion: nil)
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
