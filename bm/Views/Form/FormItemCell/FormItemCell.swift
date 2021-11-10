//
//  FormItemCell.swift
//  bm
//
//  Created by ives on 2020/12/22.
//  Copyright © 2020 bm. All rights reserved.
//

import UIKit

class FormItemCell: SuperCell, FormUPdatable {
    
    var formItem: FormItem?
    var valueDelegate: ValueChangedDelegate?
    
    var cellDelegate: List2CellDelegate?
    var oneRow: OneRow = OneRow()
    var searchRow: SearchRow = SearchRow()
    var sectionIdx: Int = 0
    var rowIdx: Int = 0
    
    @IBOutlet weak var titleLbl: SuperLabel?
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var promptBtn: UIButton!
    @IBOutlet weak var requiredImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        if titleLbl != nil {
            titleLbl!.textAlignment = NSTextAlignment.left
        }
    }
    
    func update(with formItem: FormItem) {}

}
