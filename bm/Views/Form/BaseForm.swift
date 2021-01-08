//
//  FormBaseClass.swift
//  form
//
//  Created by ives on 2018/12/3.
//  Copyright © 2018 BlueMobile. All rights reserved.
//

import Foundation

protocol FormItemDelegate {
    func checkboxValueChanged(checked: Bool) //for checkbox, now is privacy
    func sexValueChanged(sex: String)
}

class BaseForm {
    var formItems: [FormItem] = [FormItem]()
    var title: String?
    var values: [String: String]?
    var id: Int?
    var isChange: Bool = false
    //var delegate: BaseViewController? = nil
    
    init(id: Int? = nil, values: [String: String]? = nil, title: String = "") {
        self.id = id
        self.values = values
        self.title = title
        self.configureItems()
        self.fillValue()
    }
    
    @discardableResult
    func isChanged()-> (Bool, String?) {
        var msg: String?
        for item in formItems {
            if (!isChange) {
                isChange = item.updateCheckChange()
            }
        }
        if (!isChange) {
            msg = "沒有更改任何值，所以不用送出更新"
        }
        
        return (isChange, msg)
    }
    @discardableResult
    func isValid() ->(Bool, String?) {
        var isValid = true
        var msg: String?
        for item in formItems {
            item.checkValidity()
            if !item.isValid {
                isValid = false
                msg = item.msg
                break
            }
        }
        
        return (isValid, msg)
    }
    
    func configureItems() {}
    
    func fillValue() {
        for formItem in formItems {
            if formItem.name != nil && values?[formItem.name!] != nil {
                formItem.value = values?[formItem.name!]
                formItem.oldValue = formItem.value
                formItem.valueToAnother()
                formItem.make()
            }
        }
    }
    
    func getSections()-> [String] {
    
        var sections: [String] = [String]()
        for formItem in formItems {
            if (formItem.uiProperties.cellType == FormItemCellType.section) {
                sections.append(formItem.title)
            }
        }
    
        return sections
    }
    
    func getSectionKeys()-> [[String]] {
    
        var res: [[String]] = [[String]]()
        
        var rows: [String] = [String]()
        var findSection: Bool = false
        for (idx, formItem) in formItems.enumerated() {
        
            if !findSection && formItem.uiProperties.cellType == FormItemCellType.section {
                    findSection = true
                    rows = [String]()
                continue
            }
            if findSection && formItem.uiProperties.cellType == FormItemCellType.section {
                    res.append(rows)
                    rows = [String]()
                    continue
            }
            if findSection {
                rows.append(formItem.name!)
            }
        }
        res.append(rows)
        
        return res
    }
    
    func removeItem(key: String) {
        for i in 0..<formItems.count {
            let _formItem = formItems[i]
            if key == _formItem.name {
                formItems.remove(at: i)
                break
            }
        }
    }
    
    func removeItems(keys: [String]) {
        for key in keys {
            removeItem(key: key)
        }
    }
}

























