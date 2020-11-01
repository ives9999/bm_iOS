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
        titleLbl.sizeToFit()
        
        //self.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        //backgroundColor = UIColor.gray
        
//        layer.masksToBounds = true
//        layer.cornerRadius = 0
//        layer.borderWidth = 1
//        layer.shadowOffset = CGSize(width: -1, height: 1)
//        let borderColor: UIColor = .green
//        layer.borderColor = borderColor.cgColor
    }
    
    //override func layoutSubviews() {
        //super.layoutSubviews()

        //var frame = contentView.frame
        //var new_frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height + 20)
        //contentView.frame = new_frame
        //contentView.backgroundColor = UIColor.gray
        //contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    //}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(icon: String, title: String, content: String, contentH: CGFloat=0, isPressed: Bool=false) {
        if icon.count > 0 {
            iconView.image = UIImage(named: icon)
        }
        if title.count > 0 {
            titleLbl.text = title
        }
        contentLbl.text = content
        //contentHeight.constant = contentH
        
        if isPressed {
            contentLbl.textColor = UIColor(MY_GREEN)
        }
    }
}
