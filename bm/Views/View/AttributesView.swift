//
//  Attriubtes.swift
//  bm
//
//  Created by ives on 2023/5/10.
//  Copyright © 2023 bm. All rights reserved.
//

import UIKit

class AttributesView: UIView {

    var key: String = ""
    var count: Int = 0
    var column: Int = 3
    var row: Int = 1
    
    var labelWidth: Int = 80
    let labelHeight: Int = 30
    let horizonMergin: Int = 30
    let vericalMergin: Int = 16
    
    //var parent: UIView = UIView()
    var attributes: [String] = [String]()
    
    var tagLabels: [Tag] = [Tag]()
    
    var delegate: AttributesViewDelegate?
    
    //attribute: 是從資料庫撈出來的屬性值，如：{\"XS\",\"S\",\"M\",\"L\",\"XL\",\"2XL\",\"3XL\"}
    //clumn: 每列幾個欄，預設是3欄，列則是用欄跟屬性總數來計算出來的
    required init(key: String, attribute: String, column: Int = 3) {
        super.init(frame: CGRect.zero)
        
        self.key = key
        self.attributes = self.parseAttributes(attribute: attribute)
        self.column = column
        
        self.count = attributes.count
        
        var tmp: (quotient: Int, remainder: Int) = count.quotientAndRemainder(dividingBy: column)
        row = (tmp.remainder > 0) ? tmp.quotient + 1 : tmp.quotient
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setAttributes() {
        
        for (idx, attribute) in attributes.enumerated() {
            
            let tag: Tag = Tag(key: attribute, value: attribute, text: attribute, tag: idx)
            self.addSubview(tag)
            
            let tmp: (quotient: Int, remainder: Int) = idx.quotientAndRemainder(dividingBy: column)
            //商是第幾列row，餘數是第幾排column
            let leftPadding: Int = tmp.remainder*(labelWidth + horizonMergin)
            let topPadding: Int = tmp.quotient*(labelHeight + vericalMergin)
            tag.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(topPadding)
                make.left.equalToSuperview().offset(leftPadding)
                make.width.equalTo(labelWidth)
                make.height.equalTo(labelHeight)
            }
            
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
            tag.addGestureRecognizer(gestureRecognizer)
                        
            tagLabels.append(tag)
            
            //selected tag
//            if (attribute == value) {
//                tag.selected = true
//                tag.setSelectedStyle()
//            }
        }
    }
    
    func getHeight()-> Int {
        let height: Int = row*(labelHeight + vericalMergin)
        
        return height
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        let tag = sender.view as! Tag
        
        tag.selected = !tag.selected
        tag.setSelectedStyle()
        clearOtherTagSelected(selectedTag: tag)
        
        delegate?.tagPressed(key: key, idx: tag.tag, value: tag.value)
    }
    
    private func clearOtherTagSelected(selectedTag: Tag) {
        if selectedTag.selected {
            for tagLabel in tagLabels {
                if tagLabel != selectedTag {
                    tagLabel.selected = false
                    tagLabel.unSelectedStyle()
                }
            }
        }
    }
    
    //將"{\"XS\",\"S\",\"M\",\"L\",\"XL\",\"2XL\",\"3XL\"}"解析成["XS","S","M","L","XL","2XL","3XL"]
    func parseAttributes(attribute: String)-> [String] {
        
        var res: [String] = [String]()
        var tmp = attribute.replace(target: "{", withString: "")
        tmp = tmp.replace(target: "}", withString: "")
        tmp = tmp.replace(target: "\"", withString: "")
        res = tmp.components(separatedBy: ",")
        
        return res
    }
}

protocol AttributesViewDelegate {
    
    func tagPressed(key: String, idx: Int, value: String)
}
