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
    
    var sectionKey: String = ""
    var rowKey: String = ""
    var baseViewControllerDelegate: BaseViewController? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        stepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
    }
    
    func update(sectionKey: String, rowKey: String, title: String, value: Double, min: Double, max: Double) {
        
        self.sectionKey = sectionKey
        self.rowKey = rowKey
        
        requiredImageView.isHidden = true
        titleLbl?.text = title
        
        stepper.value = value
        stepper.minimumValue = min
        stepper.maximumValue = max
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
        formItem?.value = String(Int(stepper.value))
        if valueDelegate != nil {
            valueDelegate!.stepperValueChanged(number: Int(stepper.value), name: self.formItem!.name!)
        }
        
        if (baseViewControllerDelegate != nil) {
            baseViewControllerDelegate!.stepperValueChanged(sectionKey: sectionKey, rowKey: rowKey, number: Int(stepper.value))
        }
    }
}
