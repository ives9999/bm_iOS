//
//  PasswordCell.swift
//  bm
//
//  Created by ives on 2020/12/6.
//  Copyright © 2020 bm. All rights reserved.
//

import UIKit

class PasswordCell: TextFieldCell {

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
        
        if _formItem.value != nil && _formItem.value!.count > 0 {
            let p = textToStar(input: _formItem.value!)
            textField.text = p
        }
    }
    
    @IBAction override func textFieldDidChange(_ textField: UITextField) {
        let _formItem = formItem as! PasswordFormItem
        _formItem.value = textField.text
        var p: String = ""
        if textField.text != nil && textField.text!.count > 0 {
            p = textToStar(input: textField.text!)
        }
        
        textField.text = p
    }
    
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
