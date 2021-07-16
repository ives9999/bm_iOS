//
//  PaymentCell.swift
//  bm
//
//  Created by ives sun on 2021/2/19.
//  Copyright © 2021 bm. All rights reserved.
//

import UIKit

class PaymentCell: SuperCell {

    @IBOutlet var titleLbl: SuperLabel!
    @IBOutlet var contentLbl: SuperLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentLbl.textAlignment = .right
        titleLbl.numberOfLines = 0
        contentLbl.numberOfLines = 0
    }
    
    func update(row: [String: Any]) {
        
        titleLbl.text = (row["name"] as! String)
        contentLbl.text = (row["value"] as! String)
    }
    
    func update(title: String, content: String) {
        
        titleLbl.text = title
        contentLbl.text = content
    }
}
