//
//  TextFieldCell.swift
//  bm
//
//  Created by ives on 2018/12/4.
//  Copyright © 2018 bm. All rights reserved.
//

import UIKit

class TextFieldCell: SuperCell {
    
    @IBOutlet weak var textField: SuperTextField!
    @IBOutlet weak var titleLbl: SuperLabel!
    @IBOutlet weak var clearBtn: SubmitButton!
    
    var formItem: FormItem?

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLbl.textAlignment = NSTextAlignment.left
    }
    
    @IBAction func textFieldDidChange(_ textField: UITextField) {
        let _formItem = formItem as! TextFieldFormItem
        _formItem.value = textField.text
    }
    
    @IBAction func clearBtnPressed(_ sender: Any) {
        textField.text = ""
        let _formItem = formItem as! TextFieldFormItem
        _formItem.reset()
    }
}

extension TextFieldCell: FormUPdatable {
    
    func update(with formItem: FormItem) {
        
        let _formItem = formItem as! TextFieldFormItem
        _formItem.make()
        
        titleLbl.text = _formItem.title
        textField.text = _formItem.value
        
        let bgColor: UIColor = _formItem.isValid  == false ? .red : .white
        textField.layer.backgroundColor = bgColor.cgColor
        textField.placeholder(_formItem.placeholder)
        textField.keyboardType = _formItem.uiProperties.keyboardType
        textField.tintColor = _formItem.uiProperties.tintColor
        
        self.formItem = formItem
    }
}
