//
//  PlainCell.swift
//  bm
//
//  Created by ives sun on 2021/1/8.
//  Copyright © 2021 bm. All rights reserved.
//

import UIKit

class PlainCell: FormItemCell {
    
    @IBOutlet weak var detailLbl: SuperLabel!
    
    var sectionKey: String = ""
    var rowKey: String = ""
    var baseViewControllerDelegate: BaseViewController? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        detailLbl.textColor = UIColor(MY_GREEN)
        // Initialization code
    }
    
    func update(sectionKey: String, rowKey: String, title: String, show: String) {
        
        self.sectionKey = sectionKey
        self.rowKey = rowKey
        
        titleLbl?.text = title
        detailLbl?.text = show
    }
    
    func update(title: String, show: String) {
        
        titleLbl?.text = title
        detailLbl?.text = show
    }
    
    func update(row: OneRow) {
        titleLbl?.text = row.title
        if (row.titleColor != nil) {
            titleLbl?.textColor = row.titleColor
        }
        
        detailLbl?.text = row.show
        if (row.showColor != nil) {
            detailLbl?.textColor = row.showColor
        }
    }

    override func update(with formItem: FormItem) {
        self.formItem = formItem
        
        titleLbl!.text = self.formItem?.title
        detailLbl.text = self.formItem?.show
    }
}
