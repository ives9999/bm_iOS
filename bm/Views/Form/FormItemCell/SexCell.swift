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

    override func awakeFromNib() {
        super.awakeFromNib()
        
        male = Checkbox(frame: CGRect(x: 150, y: 10, width: 20, height: 20))
        male.checkedBorderColor = .white
        male.uncheckedBorderColor = .white
        male.borderStyle = .circle
        
        male.checkmarkColor = UIColor(MY_GREEN)
        male.checkmarkStyle = .circle
        male.isChecked = true
        
        male.increasedTouchRadius = 15
        
        male.addTarget(self, action: #selector(checkboxValueChanged(sender:)), for: .valueChanged)
        
        self.addSubview(male)
    }

    func update(with formItem: FormItem) {
        if formItem.delegate != nil {
            self.myDelegate = (formItem.delegate as! BaseViewController)
        }
    }
    
    @objc func checkboxValueChanged(sender: Checkbox) {
        //checked is t, unchecked is f.
        //print("privacy value change: \(sender.isChecked)")
        if myDelegate != nil {
            myDelegate!.checkboxValueChanged(checked: sender.isChecked)
        }
    }
    
}
