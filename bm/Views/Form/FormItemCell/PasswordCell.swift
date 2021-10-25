//
//  PasswordCell.swift
//  bm
//
//  Created by ives on 2020/12/6.
//  Copyright © 2020 bm. All rights reserved.
//

import UIKit

class PasswordCell: TextFieldCell, UITextFieldDelegate {
    
    var realPassword: String = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
    
    override func update(sectionIdx: Int, rowIdx: Int, row: OneRow) {
        
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
    
//    @IBAction override func textFieldDidChange(_ textField: UITextField) {
//        let _formItem = formItem as! PasswordFormItem
//        
//        _formItem.value = textField.text
//        var p: String = ""
//        if textField.text != nil && textField.text!.count > 0 {
//            p = textToStar(input: textField.text!)
//        }
//        
//        textField.text = p
//    }
    
    @IBAction override func clearBtnPressed(_ sender: Any) {
        textField.text = ""
        let _formItem = formItem as! PasswordFormItem
        _formItem.reset()
    }
    
    private func textToStar(input: String)-> String {
        
        var p: String = ""
        for _ in 1...textField.text!.count {
            p = p.appending("*")
        }
        
        return p
    }
}
