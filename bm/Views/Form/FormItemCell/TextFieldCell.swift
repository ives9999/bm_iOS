//
//  TextFieldCell.swift
//  bm
//
//  Created by ives on 2018/12/4.
//  Copyright © 2018 bm. All rights reserved.
//

import UIKit

class TextFieldCell: SuperCell, FormUPdatable {
    
//    func textFieldTextChanged(formItem: FormItem, text: String) {
//        if textFieldDelegate != nil {
//            textFieldDelegate!.textFieldTextChanged(formItem: formItem, text: textField.text!)
//        }
//    }
    
    
    @IBOutlet weak var textField: SuperTextField!
    @IBOutlet weak var titleLbl: SuperLabel!
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var promptBtn: UIButton!
    @IBOutlet weak var requiredImageView: UIImageView!
    
    var formItem: FormItem?
    
    var textFieldDelegate: TextFieldChangeDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLbl.textAlignment = NSTextAlignment.left
    }
    
    @IBAction func textFieldDidChange(_ textField: UITextField) {
        let _formItem = formItem as! TextFieldFormItem
        _formItem.value = textField.text
        //self.parentViewController?.textFieldTextChanged()
        //textFieldTextChanged(formItem: _formItem, text: textField.text!)
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
    
    func update(with formItem: FormItem) {
        
        let _formItem = formItem as! TextFieldFormItem
        _formItem.make()
        
        titleLbl.text = _formItem.title
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
    
    func setTextFieldDelegate(delegate: TextFieldChangeDelegate) {
        self.textFieldDelegate = delegate
    }
}
