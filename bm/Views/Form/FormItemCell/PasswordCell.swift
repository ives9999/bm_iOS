//
//  PasswordCell.swift
//  bm
//
//  Created by ives on 2020/12/6.
//  Copyright © 2020 bm. All rights reserved.
//

import UIKit

class PasswordCell: FormItemCell, UITextFieldDelegate {
    
    @IBOutlet weak var textField: SuperTextField!
    
    var realPassword: String = ""

    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        titleLbl?.textAlignment = .right
        backgroundColor = UIColor.clear
        
        textField.layer.cornerRadius = 4
        textField.clipsToBounds = true
        textField.fontSize = FONT_SIZE_GENERAL
    }
    
    override func update(with formItem: FormItem) {
        
        let _formItem = formItem as! PasswordFormItem
        _formItem.make()
        
        titleLbl!.text = _formItem.title
        textField.text = _formItem.value
        
        textField.placeholder(_formItem.placeholder)
        textField.keyboardType = _formItem.uiProperties.keyboardType
        textField.tintColor = _formItem.uiProperties.tintColor
        requiredImageView.isHidden = !_formItem.isRequired
        
        self.formItem = formItem
        textField.delegate = self
        
        if _formItem.value != nil && _formItem.value!.count > 0 {
            let p = textToStar(input: _formItem.value!)
            textField.text = p
        }
    }
    
    func update(sectionIdx: Int, rowIdx: Int, row: OneRow) {
        
        self.oneRow = row
        self.sectionIdx = sectionIdx
        self.rowIdx = rowIdx
        
        titleLbl!.text = row.title
        textField.text = row.value
        
        textField.placeholder(row.placeholder)
        textField.keyboardType = row.keyboard.enumToSwift()
        //textField.tintColor = _formItem.uiProperties.tintColor
        requiredImageView.isHidden = !row.isRequired
        
        textField.delegate = self
        
        if row.value.count > 0 {
            let p = textToStar(input: row.value)
            textField.text = p
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
//        print("textField.text: \(textField.text!)")
//        print("range: \(range.location)")
//        print("string: \(string)")
//        print("")
        
        oneRow.value += string
//        let _formItem = formItem as! PasswordFormItem
//        if _formItem.value == nil {
//            _formItem.value = ""
//        }
//        _formItem.value! += string
                
        var p: String = ""
        if textField.text != nil && textField.text!.count > 0 {
            p = textToStar(input: textField.text!)
        }
        textField.text = p
        
        return true
    }
    
    @IBAction func clearBtnPressed(_ sender: Any) {
        textField.text = ""
//        let _formItem = formItem as! PasswordFormItem
//        _formItem.reset()
        if (cellDelegate != nil) {
            cellDelegate!.cellClear(sectionIdx: sectionIdx, rowIdx: rowIdx)
        }
    }
    
    private func textToStar(input: String)-> String {
        
        var p: String = ""
        for _ in 1...textField.text!.count {
            p = p.appending("*")
        }
        
        return p
    }
}
