//
//  SwitchCell.swift
//  bm
//
//  Created by ives on 2021/11/8.
//  Copyright © 2021 bm. All rights reserved.
//

import UIKit

class SwitchCell: FormItemCell {
    
    @IBOutlet weak var onoff: SuperSwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        onoff.setOn(false, animated: true)
        onoff.addTarget(self, action: #selector(switchDidValueChanged(sender:)), for: .valueChanged)
    }

//    func update(sectionIdx: Int, rowIdx: Int, row: OneRow) {
//        
//        self.oneRow = row
//        self.sectionIdx = sectionIdx
//        self.rowIdx = rowIdx
//        
//        titleLbl?.text = row.title
//        onoff.setOn(Bool(row.value)!, animated: true)
//    }
    
    func update(sectionIdx: Int, rowIdx: Int, row: OneRow) {
        
        self.oneRow = row
        self.sectionIdx = sectionIdx
        self.rowIdx = rowIdx
        
        titleLbl?.text = row.title
        
        let key = row.key
        var val: Bool = false
        
        if key == STATUS_KEY || key == TEAM_TEMP_STATUS_KEY {
            val = (row.value == "online") ? true : false
        } else {
            val = (row.value == "1") ? true : false
        }
        onoff.setOn(val, animated: true)
    }
    
    @objc func switchDidValueChanged(sender: UISwitch) {
        cellDelegate!.cellSwitchChanged(key: oneRow.key, sectionIdx: sectionIdx, rowIdx: rowIdx, isSwitch: onoff.isOn)
    }
}
