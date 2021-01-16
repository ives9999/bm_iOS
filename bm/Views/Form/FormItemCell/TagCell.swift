//
//  TagCell.swift
//  bm
//
//  Created by ives on 2021/1/11.
//  Copyright © 2021 bm. All rights reserved.
//

import UIKit

class TagCell: FormItemCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containViewHeight: NSLayoutConstraint!
    
    let labelWidth: CGFloat = 100
    let labelHeight: CGFloat = 30
    let horizonMergin: CGFloat = 8
    let vericalMergin: CGFloat = 8
    let column: Int = 3
    var row: Int = 0
    
    var tagLabels: [Tag] = [Tag]()
    var tagDicts: [[String: String]] = [[String: String]]()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func update(with formItem: FormItem) {
        self.formItem = formItem
        
        requiredImageView.isHidden = !formItem.isRequired
        titleLbl!.text = self.formItem?.title
        
        var count = tagDicts.count
        if let _formItem: TagFormItem = formItem as? TagFormItem {
            
            if count == 0 {
                tagDicts = _formItem.tags!
            }
        }
        var res = count.quotientAndRemainder(dividingBy: column)
        row = (res.remainder >= 0) ? res.quotient + 1 : res.quotient
        
        count = 0
        for tagDict in tagDicts {
            for (key, value) in tagDict {
                let tag: Tag = Tag()
                containerView.addSubview(tag)
                tag.tag = count
                tag.key = key
                tag.value = value
                tag.text = value
                
                if let _formItem: TagFormItem = formItem as? TagFormItem {
                    for idx in _formItem.selected_idxs {
                        if count == idx {
                            tag.selected = true
                            tag.setSelectedStyle()
                        }
                    }
                }
                
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
                tag.addGestureRecognizer(gestureRecognizer)
                tagLabels.append(tag)
                
                //tag.backgroundColor = UIColor.red
                res = count.quotientAndRemainder(dividingBy: column)
                //print(res)
                setMargin(block: tag, row_count: res.quotient + 1, column_count: res.remainder + 1)
                count = count + 1
                break
            }
        }
        
        var height: CGFloat = 70
        if count > 0 {
            let marginCount: Int = (row == 1) ? 2 : row*2-1
            height = CGFloat(row)*labelHeight + CGFloat(marginCount)*vericalMergin
        }
        containViewHeight.constant = height
    }
    
    //    (1, 1)  (1, 2)  (1, 3)
    //    (2, 1)  (2, 2)  (2, 3)
    //    (3, 1)  (3, 2)  (3, 3)
        
    private func setMargin(block: UILabel, row_count: Int, column_count: Int) {
        let leading: CGFloat = CGFloat(column_count-1)*labelWidth + CGFloat(column_count)*horizonMergin
        let top: CGFloat = CGFloat(row_count-1)*labelHeight + CGFloat(row_count)*vericalMergin
        
        var left: NSLayoutConstraint, up: NSLayoutConstraint, h: NSLayoutConstraint, w: NSLayoutConstraint
        
        //左邊
        left = NSLayoutConstraint(item: block, attribute: .leading, relatedBy: .equal, toItem: block.superview, attribute: .leading, multiplier: 1, constant: leading)
        
        //上面
        up = NSLayoutConstraint(item: block, attribute: .top, relatedBy: .equal, toItem: block.superview, attribute: .top, multiplier: 1, constant: top)
        
        //寬度
        w = NSLayoutConstraint(item: block, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: labelWidth)
        
        //高度
        h = NSLayoutConstraint(item: block, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: labelHeight)
        block.translatesAutoresizingMaskIntoConstraints = false
        containerView.addConstraints([left, up, w, h])
    }
        
    @objc func handleTap(sender: UITapGestureRecognizer) {
        let tag = sender.view as! Tag
        
        let _formItem: TagFormItem = formItem as! TagFormItem
        _formItem.selected_idxs = [tag.tag]
        _formItem.value = tag.value
        
        tag.selected = !tag.selected
        tag.setSelectedStyle()
        clearOtherTagSelected(selectedTag: tag)
//        print(tag.key)
//        print(tag.value)
        if valueDelegate != nil {
            valueDelegate!.tagChecked(checked: tag.selected, name: self.formItem!.name!, key: tag.key!, value: tag.value)
        }
    }
    
    func clearOtherTagSelected(selectedTag: Tag) {
        if selectedTag.selected {
            for tagLabel in tagLabels {
                if tagLabel != selectedTag {
                    tagLabel.selected = false
                    tagLabel.unSelectedStyle()
                }
            }
        }
    }
}
