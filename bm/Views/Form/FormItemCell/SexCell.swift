//
//  SexCell.swift
//  bm
//
//  Created by ives on 2020/12/9.
//  Copyright © 2020 bm. All rights reserved.
//

import UIKit

class SexCell: SuperCell, FormUPdatable {
    
    @IBOutlet weak var textField: SuperLabel!
    @IBOutlet weak var requiredImageView: UIImageView!
    
    var male: Checkbox!
    var female: Checkbox!
    var myDelegate: BaseViewController?
    var checked: String = "M"

    override func awakeFromNib() {
        super.awakeFromNib()
        
        male = Checkbox(frame: CGRect(x: 100, y: 10, width: 20, height: 20))
        male.checkedBorderColor = .white
        male.uncheckedBorderColor = .white
        male.borderStyle = .circle
        
        male.checkmarkColor = UIColor(MY_GREEN)
        male.checkmarkStyle = .circle
        male.isChecked = true
        
        female = Checkbox(frame: CGRect(x: 200, y: 10, width: 20, height: 20))
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
        self.addSubview(female)
    }

    func update(with formItem: FormItem) {
        
        requiredImageView.isHidden = !formItem.isRequired
        if formItem.delegate != nil {
            self.myDelegate = (formItem.delegate as! BaseViewController)
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
        if myDelegate != nil {
            myDelegate?.sexValueChanged(sex: self.checked)
        }
    }
    
    @objc func femaleValueChanged(sender: Checkbox) {
        
        if sender.isChecked {
            male.isChecked = false
            self.checked = "F"
        } else {
            male.isChecked = true
            self.checked = "M"
        }
        if myDelegate != nil {
            myDelegate?.sexValueChanged(sex: self.checked)
        }
    }
}
