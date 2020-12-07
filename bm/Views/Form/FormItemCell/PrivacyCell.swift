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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        privacy = Checkbox(frame: CGRect(x: 8, y: 10, width: 20, height: 20))
        privacy.checkedBorderColor = .white
        privacy.uncheckedBorderColor = .white
        privacy.borderStyle = .square
        
        privacy.checkmarkColor = UIColor(MY_GREEN)
        privacy.checkmarkStyle = .square
        privacy.isChecked = true
        
        self.addSubview(privacy)
    }

    func update(with formItem: FormItem) {
        
    }
    
}
