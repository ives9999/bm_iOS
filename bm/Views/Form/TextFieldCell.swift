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
    
    @IBAction func clearBtnPressed(_ sender: Any) {
        print("clear")
    }
}

extension TextFieldCell: FormUPdatable {
    
    func update(with formItem: FormItem) {
        self.formItem = formItem
        
        self.titleLbl.text = self.formItem?.title
        self.textField.text = self.formItem?.value
        
        let bgColor: UIColor = self.formItem?.isValid  == false ? .red : .white
        self.textField.layer.backgroundColor = bgColor.cgColor
        if self.formItem?.placeholder != nil {
            textField.placeholder((self.formItem?.placeholder)!)
        }
        self.textField.keyboardType = self.formItem?.uiProperties.keyboardType ?? .default
        self.textField.tintColor = self.formItem?.uiProperties.tintColor
    }
}
