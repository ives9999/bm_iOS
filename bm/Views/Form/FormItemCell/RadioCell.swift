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
    
    @objc func radioValueChanged(sender: Checkbox) {
        if valueDelegate != nil {
            valueDelegate?.privacyChecked(checked: sender.isChecked)
        }
        
        if (baseViewControllerDelegate != nil) {
            baseViewControllerDelegate!.radioDidChange(sectionKey: sectionKey, rowKey: rowKey, checked: sender.isChecked)
        }
        //checked is t, unchecked is f.
        //print("privacy value change: \(sender.isChecked)")
//        if myDelegate != nil {
//            myDelegate!.checkboxValueChanged(checked: sender.isChecked)
//        }
    }
}
