//
//  MemoCell.swift
//  bm
//
//  Created by ives on 2021/8/1.
//  Copyright © 2021 bm. All rights reserved.
//

import UIKit

class MemoCell: FormItemCell {
    
    @IBOutlet weak var memoTextField: SuperTextField!
    
    var sectionKey: String = ""
    var rowKey: String = ""
    var baseViewControllerDelegate: BaseViewController? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func update(sectionKey: String, rowKey: String, title: String, value: String) {
        
        self.sectionKey = sectionKey
        self.rowKey = rowKey
        
        titleLbl?.text = title
        memoTextField.text = value
        memoTextField.textColor = UIColor(MY_GREEN)
    }
    
    func update(sectionIdx: Int, rowIdx: Int, row: OneRow) {
        
        self.oneRow = row
        self.sectionIdx = sectionIdx
        self.rowIdx = rowIdx
        
        titleLbl?.text = row.title
        memoTextField.text = row.value
    }
    
    @IBAction func textFieldDidChange(_ textField: UITextField) {
//        if (baseViewControllerDelegate != nil) {
//            baseViewControllerDelegate?.textFieldDidChange(sectionKey: sectionKey, rowKey: rowKey, text: textField.text!)
//        }
        
        if (cellDelegate != nil) {
            cellDelegate?.cellTextChanged(sectionIdx: sectionIdx, rowIdx: rowIdx, str: textField.text!)
        }
    }
}
