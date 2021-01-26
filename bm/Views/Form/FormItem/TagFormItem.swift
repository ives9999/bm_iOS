//
//  TagFormItem.swift
//  bm
//
//  Created by ives on 2021/1/11.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class TagFormItem: FormItem {
    
    var tags: [[String: String]]?
    var selected_idxs: [Int] = [0]
    
    required init(name: String = TAG_KEY, title: String = "標籤", isRequire: Bool = false, selected_idxs: [Int] = [0]) {
        super.init(name: name, title: title, placeholder: nil, value: nil, isRequired: isRequire)
        //segue = TO_SINGLE_SELECT
        uiProperties.cellType = .tag
        self.isRequired = isRequire
        self.selected_idxs = selected_idxs
        
//        if session.array(forKey: "citys") != nil {
//            citysFromCache = (session.array(forKey: "citys") as! [[String: String]])
//        }
        reset()
    }
    
    func setTags(tags: [[String: String]]) {
        self.tags = tags
        setSelectedIdx(selected: [0])
        for (_, value) in tags[0] {
            self.value = value
        }
    }
    
    func setSelectedIdx(selected: [Int]) {
        selected_idxs = selected
    }
    
    override func reset() {
        super.reset()
        value = nil
        make()
    }
}
