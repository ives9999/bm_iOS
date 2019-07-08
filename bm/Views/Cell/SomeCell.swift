//
//  SomeCell.swift
//  bm
//
//  Created by ives on 2019/7/1.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit

class SomeCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
