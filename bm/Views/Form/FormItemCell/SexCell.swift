//
//  SexCell.swift
//  bm
//
//  Created by ives on 2020/12/9.
//  Copyright © 2020 bm. All rights reserved.
//

import UIKit

class SexCell: FormItemCell {
        
    var male: Checkbox!
    var female: Checkbox!
    @IBOutlet weak var maleLbl: SuperLabel!
    @IBOutlet weak var femaleLbl: SuperLabel!
    //var myDelegate: BaseViewController?
    var checked: String = "M"

    override func awakeFromNib() {
        super.awakeFromNib()
        
        male = Checkbox(frame: .zero)
        male.checkedBorderColor = .white
        male.uncheckedBorderColor = .white
        male.borderStyle = .circle
        
        male.checkmarkColor = UIColor(MY_GREEN)
        male.checkmarkStyle = .circle
        male.isChecked = true
        
        female = Checkbox(frame: .zero)
        female.checkedBorderColor = .white
        female.uncheckedBorderColor = .white
        female.borderStyle = .circle
        
        female.checkmarkColor = UIColor(MY_GREEN)
        female.checkmarkStyle = .circle
        female.isChecked = false
        
        female.increasedTouchRadius = 15
        
        male.addTarget(self, action: #selector(maleValueChanged(sender:)), for: .valueChanged)
        female.addTarget(self, action: #selector(femaleValueChanged(sender:)), for: .valueChanged)
        
        self.addSubview(male)
        male.translatesAutoresizingMaskIntoConstraints = false
        male.widthAnchor.constraint(equalToConstant: 20).isActive = true
        male.heightAnchor.constraint(equalToConstant: 20).isActive = true
        male.leadingAnchor.constraint(equalTo: male.superview!.leadingAnchor, constant: 115).isActive = true
        male.centerYAnchor.constraint(equalTo: male.superview!.centerYAnchor).isActive = true
        
        maleLbl.translatesAutoresizingMaskIntoConstraints = false
        maleLbl.centerYAnchor.constraint(equalTo: maleLbl.superview!.centerYAnchor).isActive = true
        maleLbl.leadingAnchor.constraint(equalTo: male.trailingAnchor, constant: 8).isActive = true
        
        self.addSubview(female)
        female.translatesAutoresizingMaskIntoConstraints = false
        female.widthAnchor.constraint(equalToConstant: 20).isActive = true
        female.heightAnchor.constraint(equalToConstant: 20).isActive = true
        female.leadingAnchor.constraint(equalTo: female.superview!.leadingAnchor, constant: 210).isActive = true
        female.centerYAnchor.constraint(equalTo: female.superview!.centerYAnchor).isActive = true

        femaleLbl.translatesAutoresizingMaskIntoConstraints = false
        femaleLbl.centerYAnchor.constraint(equalTo: femaleLbl.superview!.centerYAnchor).isActive = true
        femaleLbl.leadingAnchor.constraint(equalTo: female.trailingAnchor, constant: 8).isActive = true
    }

    override func update(with formItem: FormItem) {
        
        requiredImageView.isHidden = !formItem.isRequired
        if formItem.value == "M" {
            male.isChecked = true
            female.isChecked = false
        } else {
            male.isChecked = false
            female.isChecked = true
        }
//        if formItem.delegate != nil {
//            self.myDelegate = (formItem.delegate as! BaseViewController)
//        }
    }
    
    func update(sectionIdx: Int, rowIdx: Int, row: OneRow) {
        
        self.oneRow = row
        self.sectionIdx = sectionIdx
        self.rowIdx = rowIdx
        requiredImageView.isHidden = !row.isRequired
        if row.value == "M" {
            male.isChecked = true
            female.isChecked = false
        } else {
            male.isChecked = false
            female.isChecked = true
        }
    }
    
    @objc func maleValueChanged(sender: Checkbox) {
        
        if sender.isChecked {
            female.isChecked = false
            self.checked = "M"
        } else {
            female.isChecked = true
            self.checked = "F"
        }
        
        if (cellDelegate != nil) {
            cellDelegate!.cellSexChanged(key: oneRow.key, sectionIdx: sectionIdx, rowIdx: rowIdx, sex: self.checked)
        }
        //valueDelegate!.sexChanged(sex: self.checked)
        
//        if myDelegate != nil {
//            myDelegate?.sexValueChanged(sex: self.checked)
//        }
    }
    
    @objc func femaleValueChanged(sender: Checkbox) {
        
        if sender.isChecked {
            male.isChecked = false
            self.checked = "F"
        } else {
            male.isChecked = true
            self.checked = "M"
        }
        
        if (cellDelegate != nil) {
            cellDelegate!.cellSexChanged(key: oneRow.key, sectionIdx: sectionIdx, rowIdx: rowIdx, sex: self.checked)
        }
        //valueDelegate!.sexChanged(sex: self.checked)
//        if myDelegate != nil {
//            myDelegate?.sexValueChanged(sex: self.checked)
//        }
    }
}
