//
//  TextFieldCell.swift
//  bm
//
//  Created by ives on 2018/12/4.
//  Copyright © 2018 bm. All rights reserved.
//

import UIKit

class TextFieldCell: FormItemCell {
    
    @IBOutlet weak var textField: SuperTextField!
    
    var sectionKey: String = ""
    var rowKey: String = ""
    var baseViewControllerDelegate: BaseViewController? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func textFieldDidChange(_ textField: UITextField) {
        let _formItem = formItem as! TextFieldFormItem
        if self.valueDelegate != nil {
            valueDelegate!.textFieldTextChanged(formItem: _formItem, text: textField.text!)
        }
        
        if (baseViewControllerDelegate != nil) {
            baseViewControllerDelegate?.textFieldDidChange(sectionKey: sectionKey, rowKey: rowKey, text: textField.text!)
        }
    }
    
    @IBAction func clearBtnPressed(_ sender: Any) {
        textField.text = ""
        let _formItem = formItem as! TextFieldFormItem
        _formItem.reset()
    }
    
    @IBAction func promptBtnPressed(_ sender: Any) {
        let alert = UIAlertController(title: "提示", message: (formItem?.tooltip)!, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確定", style: .default, handler: { (action) in
            
        }))
        self.parentViewController?.present(alert, animated: true, completion: nil)
        
//        if popTip.isVisible {
//            popTip.hide()
//        } else {
//            if formItem?.tooltip != nil {
//                let here = CGRect(x: 100, y: 100, width: 100, height: 30)
//                popTip.show(text: (formItem?.tooltip)!, direction: .left, maxWidth: 200, in: titleLbl, from: here)
//                popTip.bringSubview(toFront: self.superview!)
//            }
//        }
    }
    
    func update(sectionKey: String, rowKey: String, title: String, value: String) {
        
        self.sectionKey = sectionKey
        self.rowKey = rowKey
        
        requiredImageView.isHidden = true
        promptBtn.isHidden = true
        
        titleLbl?.text = title
        textField.text = value
    }
    
    override func update(with formItem: FormItem) {
        
        let _formItem = formItem as! TextFieldFormItem
        _formItem.make()
        
        self.titleLbl!.text = _formItem.title
        textField.text = _formItem.value
        
        //let bgColor: UIColor = _formItem.isValid  == false ? .red : .white
        //textField.layer.backgroundColor = bgColor.cgColor
        textField.placeholder(_formItem.placeholder)
        textField.keyboardType = _formItem.uiProperties.keyboardType
        textField.tintColor = _formItem.uiProperties.tintColor
        promptBtn.isHidden = (_formItem.tooltip == nil) ? true : false
        requiredImageView.isHidden = !_formItem.isRequired
        
        self.formItem = formItem
    }
}
