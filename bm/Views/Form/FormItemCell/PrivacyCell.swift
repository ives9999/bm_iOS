//
//  PrivacyCell.swift
//  bm
//
//  Created by ives on 2020/12/5.
//  Copyright © 2020 bm. All rights reserved.
//

import UIKit

class PrivacyCell: SuperCell, FormUPdatable {
    
    @IBOutlet weak var textField: SuperLabel!
    @IBOutlet weak var requiredImageView: UIImageView!
    
    var privacy: Checkbox!
    var myDelegate: BaseViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        privacy = Checkbox(frame: CGRect(x: 8, y: 10, width: 20, height: 20))
        privacy.checkedBorderColor = .white
        privacy.uncheckedBorderColor = .white
        privacy.borderStyle = .square
        
        privacy.checkmarkColor = UIColor(MY_GREEN)
        privacy.checkmarkStyle = .square
        privacy.isChecked = true
        
        privacy.increasedTouchRadius = 15
        
        privacy.addTarget(self, action: #selector(checkboxValueChanged(sender:)), for: .valueChanged)
        
        self.addSubview(privacy)
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
