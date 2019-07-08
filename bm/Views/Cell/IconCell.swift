//
//  IconCell.swift
//  bm
//
//  Created by ives on 2019/1/23.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit

class IconCell: SuperCell {
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLbl: SuperLabel!
    @IBOutlet weak var contentLbl: SuperLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLbl.textAlignment = .left
        contentLbl.textAlignment = .left
        titleLbl.numberOfLines = 0
        contentLbl.numberOfLines = 0
        titleLbl.lineBreakMode = .byWordWrapping
        contentLbl.lineBreakMode = .byWordWrapping
        contentLbl.setTextColor(UIColor("#aaaaaa"))
        
        //backgroundColor = UIColor.red
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(icon: String, title: String, content: String, isPressed: Bool=false) {
        if icon.count > 0 {
            iconView.image = UIImage(named: icon)
        }
        if title.count > 0 {
            titleLbl.text = title + ":"
        }
        if content.count > 0 {
            contentLbl.text = content
        }
        if isPressed {
            contentLbl.textColor = UIColor(MY_GREEN)
        }
    }
}
