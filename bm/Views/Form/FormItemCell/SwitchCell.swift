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

    func update(sectionIdx: Int, rowIdx: Int, row: OneRow) {
        
        self.oneRow = row
        self.sectionIdx = sectionIdx
        self.rowIdx = rowIdx
        
        titleLbl?.text = row.title
        onoff.setOn(Bool(row.value)!, animated: true)
    }
    
    func update(sectionIdx: Int, rowIdx: Int, row: SearchRow) {
        
        self.searchRow = row
        self.sectionIdx = sectionIdx
        self.rowIdx = rowIdx
        
        titleLbl?.text = row.title
        onoff.setOn(Bool(row.value)!, animated: true)
    }
    
    @objc func switchDidValueChanged(sender: UISwitch) {
        cellDelegate!.cellSwitchChanged(key: searchRow.key, sectionIdx: sectionIdx, rowIdx: rowIdx, isSwitch: onoff.isOn)
    }
}
