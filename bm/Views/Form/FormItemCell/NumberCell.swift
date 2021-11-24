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
    //var baseViewControllerDelegate: BaseViewController? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        stepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
    }
    
    func update(sectionKey: String, rowKey: String, title: String, value: Double, min: Double, max: Double) {
        
        self.sectionKey = sectionKey
        self.rowKey = rowKey
        
        requiredImageView.isHidden = true
        titleLbl?.text = title
        
        stepper.minimumValue = min
        stepper.maximumValue = max
        stepper.value = value
        //stepper.label.text = "5"
    }
    
    override func update(with formItem: FormItem) {
        
        let _formItem: NumberFormItem = formItem as! NumberFormItem
        self.formItem = _formItem
        titleLbl?.text = formItem.title
        requiredImageView.isHidden = !formItem.isRequired
        
        stepper.minimumValue = Double(_formItem.min)
        stepper.maximumValue = Double(_formItem.max)
    }
    
    func update(sectionIdx: Int, rowIdx: Int, row: OneRow) {
        self.oneRow = row
        self.sectionIdx = sectionIdx
        self.rowIdx = rowIdx
        
        requiredImageView.isHidden = !row.isRequired
        titleLbl!.text = row.title
        
        requiredImageView.isHidden = !row.isRequired
        
        let tmp: [String] = row.show.components(separatedBy: ",")
        if tmp.count > 1 {
            if let tmp1: Double = Double(tmp[0]) {
                stepper.minimumValue = tmp1
            }
            if let tmp2: Double = Double(tmp[1]) {
                stepper.maximumValue = tmp2
            }
        }
        stepper.value = Double(row.value)!
    }
    
    @objc func stepperValueChanged(stepper: GMStepper) {
        //print(stepper.value)
        formItem?.value = String(Int(stepper.value))
        
        if valueDelegate != nil {
            valueDelegate!.stepperValueChanged(number: Int(stepper.value), name: self.formItem!.name!)
        }
        
//        if (baseViewControllerDelegate != nil) {
//            baseViewControllerDelegate!.stepperValueChanged(sectionKey: sectionKey, rowKey: rowKey, number: Int(stepper.value))
//        }
        
        if (cellDelegate != nil) {
            cellDelegate?.cellNumberChanged(sectionIdx: sectionIdx, rowIdx: rowIdx, number: Int(stepper.value))
        }
    }
}
