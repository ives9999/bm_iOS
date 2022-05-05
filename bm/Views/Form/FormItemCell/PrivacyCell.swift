//
//  PrivacyCell.swift
//  bm
//
//  Created by ives on 2020/12/5.
//  Copyright © 2020 bm. All rights reserved.
//

import UIKit

class PrivacyCell: FormItemCell {
    
    @IBOutlet weak var textField: SuperLabel!
    
    var privacy: Checkbox!
    var myDelegate: BaseViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        privacy = Checkbox(frame: CGRect(x: 70, y: 10, width: 20, height: 20))
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

    override func update(with formItem: FormItem) {}
    
    func update(sectionIdx: Int, rowIdx: Int, row: OneRow) {
        self.oneRow = row
        self.sectionIdx = sectionIdx
        self.rowIdx = rowIdx
        privacy.addTarget(self, action: #selector(checkboxValueChanged(sender:)), for: .valueChanged)
    }
    
    @objc func checkboxValueChanged(sender: Checkbox) {
        if valueDelegate != nil {
            valueDelegate?.privacyChecked(checked: sender.isChecked)
        }
        
        if (cellDelegate != nil) {
            cellDelegate!.cellPrivacyChanged(sectionIdx: sectionIdx, rowIdx: rowIdx, checked: sender.isChecked)
        }
        //checked is t, unchecked is f.
        //print("privacy value change: \(sender.isChecked)")
//        if myDelegate != nil {
//            myDelegate!.checkboxValueChanged(checked: sender.isChecked)
//        }
    }
    
}
