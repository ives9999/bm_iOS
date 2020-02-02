//
//  OlCell.swift
//  bm
//
//  Created by ives on 2020/1/30.
//  Copyright © 2020 bm. All rights reserved.
//

import UIKit

class OlCell: SuperCell {

    @IBOutlet weak var numberLbl: SuperLabel!
    @IBOutlet weak var nameLbl: SuperLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
