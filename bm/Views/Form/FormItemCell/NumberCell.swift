//
//  NumberCell.swift
//  bm
//
//  Created by ives on 2021/1/12.
//  Copyright © 2021 bm. All rights reserved.
//

import UIKit

class NumberCell: FormItemCell {
    
    @IBOutlet weak var stepper: GMStepper!

    override func awakeFromNib() {
        super.awakeFromNib()
        stepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
    }
    
    override func update(with formItem: FormItem) {
        
        let _formItem: NumberFormItem = formItem as! NumberFormItem
        self.formItem = _formItem
        titleLbl?.text = formItem.title
        requiredImageView.isHidden = !formItem.isRequired
        
        stepper.minimumValue = Double(_formItem.min)
        stepper.maximumValue = Double(_formItem.max)
    }
    
    @objc func stepperValueChanged(stepper: GMStepper) {
        //print(stepper.value)
        if valueDelegate != nil {
            valueDelegate?.stepperValueChanged(number: Int(stepper.value), name: self.formItem!.name!)
        }
    }
}
