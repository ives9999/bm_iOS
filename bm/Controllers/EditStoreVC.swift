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
    var section_keys: [[String]] = [[String]]()
    
    fileprivate var form: StoreForm = StoreForm()
    
    var delegate: EditStoreDelegate?
    
    let session: UserDefaults = UserDefaults.standard
    
    var citysandareas:[Int:[String:Any]] = [Int:[String:Any]]()
    
    override func viewDidLoad() {
        myTablView = tableView
        super.viewDidLoad()
        
        if title == nil {
            title = "體育用品店"
        }
        titleLbl.text = title
        
        imagePicker.delegate = self
        featuredView.gallery = imagePicker
        featuredView.delegate = self
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        hideKeyboardWhenTappedAround()
        FormItemCellType.registerCell(for: tableView)
        
        sections = form.getSections()
        section_keys = form.getSectionKeys()
//        print(sections)
//        print(section_keys)
        if store_token != nil && store_token!.count > 0 {
            //refresh()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
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
            if item!.name != nil {
                //let segue = item!.segue!
                let key = item!.name
                if key == CITY_KEY {
                    let selectItem: CityFormItem = item as! CityFormItem
                    var selected: String = ""
                    if selectItem.selected_city_ids.count > 0 {
                        selected = String(selectItem.selected_city_ids[0])
                    }
                    
                    toSingleSelect(key: key, selected: selected, _delegate: self)
                } else if key == AREA_KEY {
                    let cityItem: CityFormItem = getFormItemFromKey(CITY_KEY) as! CityFormItem
                    var city_id: Int = 0
                    if cityItem.value != nil {
                        city_id = Int(cityItem.value!)!
                        var city_ids: [Int] = [city_id]
                        
                        StoreService.instance.getAreaByCityIDs(city_ids: city_ids,city_type: "complete") { (success) in
                            if success {
                                //print(self.citys)
                                let tmp = StoreService.instance.citysandareas
                                
                                city_ids = [Int]()
                                for (city_id, _) in tmp {
                                    city_ids.append(city_id)
                                }
                                for city_id in city_ids {
                                    for (id, item) in tmp {
                                        if id == city_id {
                                            self.citysandareas[id] = item
                                            break
                                        }
                                    }
                                }
                                //print(self.citysandareas)
                                Global.instance.removeSpinner(superView: self.tableView)
                            }
                        }
                    } else {
                        warning("請先選擇縣市")
                    }
                }
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
                
                if item!.name == CITY_KEY {
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
                //vc.delegate = self
            } else if segue.identifier == TO_SELECT_DATE {
                let vc: DateSelectVC = segue.destination as! DateSelectVC
                vc.key = item!.name
                vc.selected = item!.value!
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
    
    override func singleSelected(key: String, selected: String) {
        
        let item = getFormItemFromKey(key)
        if item != nil {
            if key == CITY_KEY {
                item!.value = selected
            }
            item!.make()
            tableView.reloadData()
        }
    }
    
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
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        if delegate != nil {
            delegate!.isReload(false)
        }
        prev()
    }
}
