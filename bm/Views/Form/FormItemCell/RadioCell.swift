//
//  RadioCell.swift
//  bm
//
//  Created by ives on 2021/8/1.
//  Copyright © 2021 bm. All rights reserved.
//

import UIKit

class RadioCell: FormItemCell {
    
    var radio: Checkbox!
    
    var sectionKey: String = ""
    var rowKey: String = ""
    var baseViewControllerDelegate: BaseViewController? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        
        radio = Checkbox(frame: CGRect(x: 8, y: 10, width: 20, height: 20))
        radio.checkedBorderColor = .white
        radio.uncheckedBorderColor = .white
        radio.borderStyle = .circle
        
        radio.checkmarkColor = UIColor(MY_GREEN)
        radio.checkmarkStyle = .circle
        radio.borderStyle = .circle
        radio.isChecked = true
        
        radio.increasedTouchRadius = 15
        
        radio.addTarget(self, action: #selector(radioValueChanged(sender:)), for: .valueChanged)
        
        self.addSubview(radio)
    }
    
    func update(sectionKey: String, rowKey: String, title: String, checked: Bool=false) {
        
        self.sectionKey = sectionKey
        self.rowKey = rowKey
        
        titleLbl?.text = title
        
        radio.isChecked = checked
    }
    
    func update(sectionKey: String, sectionIdx: Int, rowIdx: Int, row: OneRow) {
        
        self.oneRow = row
        self.sectionIdx = sectionIdx
        self.rowIdx = rowIdx
        
        //section key is 傳入 radio group的key，例如 order 中，傳入的是 gateway or shipping，而發票則是，invoice，用來判斷回傳時，該更新那個rows
        self.sectionKey = sectionKey
        
        titleLbl?.text = row.title
        
        radio.isChecked = Bool(row.value)!
    }
    
    @objc func radioValueChanged(sender: Checkbox) {
        if valueDelegate != nil {
            valueDelegate?.privacyChecked(checked: sender.isChecked)
        }
        
        if (baseViewControllerDelegate != nil) {
            baseViewControllerDelegate!.radioDidChange(sectionKey: sectionKey, rowKey: rowKey, checked: sender.isChecked)
        }
        
        if (cellDelegate != nil) {
            cellDelegate?.cellRadioChanged(key: sectionKey, sectionIdx: sectionIdx, rowIdx: rowIdx, isChecked: sender.isChecked)
        }
        //checked is t, unchecked is f.
        //print("privacy value change: \(sender.isChecked)")
//        if myDelegate != nil {
//            myDelegate!.checkboxValueChanged(checked: sender.isChecked)
//        }
    }
}
