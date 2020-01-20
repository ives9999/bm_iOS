//
//  OneLineCell.swift
//  bm
//
//  Created by ives on 2020/1/19.
//  Copyright © 2020 bm. All rights reserved.
//

import UIKit

class OneLineCell: SuperCell {
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLbl: SuperLabel!
    @IBOutlet weak var contentLbl: SuperLabel!
    @IBOutlet weak var contentHeight: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLbl.textAlignment = .left
        contentLbl.textAlignment = .left
        titleLbl.numberOfLines = 0
        contentLbl.numberOfLines = 0
        titleLbl.lineBreakMode = .byWordWrapping
        contentLbl.lineBreakMode = .byWordWrapping
        contentLbl.setTextColor(UIColor("#aaaaaa"))
        
//        layer.masksToBounds = true
//        layer.cornerRadius = 5
//        layer.borderWidth = 2
//        layer.shadowOffset = CGSize(width: -1, height: 1)
//        let borderColor: UIColor = .green
//        layer.borderColor = borderColor.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(icon: String, title: String, content: String, contentH: CGFloat, isPressed: Bool=false) {
        if icon.count > 0 {
            iconView.image = UIImage(named: icon)
        }
        if title.count > 0 {
            titleLbl.text = title
        }
        contentLbl.text = content
        contentHeight.constant = contentH
        
        if isPressed {
            contentLbl.textColor = UIColor(MY_GREEN)
        }
    }
}
