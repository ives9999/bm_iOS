//
//  MemberOneCell.swift
//  bm
//
//  Created by ives on 2018/6/8.
//  Copyright © 2018年 bm. All rights reserved.
//

import UIKit

class TempPlaySignupOneCell: SuperCell {
    
    var iconView: UIImageView!
    var titleLbl: MyLabel!
    var valueLbl: MyLabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.value1, reuseIdentifier: reuseIdentifier)
        
        iconView = UIImageView(frame: CGRect.zero)
        contentView.addSubview(iconView)
        
        titleLbl = MyLabel(frame: CGRect.zero)
        contentView.addSubview(titleLbl)
        
        valueLbl = MyLabel(frame: CGRect.zero)
        contentView.addSubview(valueLbl)
        
        _constraint()
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func _constraint() {
        var c1: NSLayoutConstraint, c2: NSLayoutConstraint, c3: NSLayoutConstraint, c4: NSLayoutConstraint
        
        c1 = NSLayoutConstraint(item: iconView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 32)
        c2 = NSLayoutConstraint(item: iconView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 15)
        c3 = NSLayoutConstraint(item: iconView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 24)
        c4 = NSLayoutConstraint(item: iconView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 24)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints([c1,c2,c3,c4])
        
        c1 = NSLayoutConstraint(item: titleLbl, attribute: .leading, relatedBy: .equal, toItem: iconView, attribute: .trailing, multiplier: 1, constant: 16)
        c2 = NSLayoutConstraint(item: titleLbl, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 15)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints([c1,c2])
        
        c1 = NSLayoutConstraint(item: valueLbl, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: -60)
        c2 = NSLayoutConstraint(item: valueLbl, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 15)
        valueLbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints([c1, c2])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconView.clipsToBounds = true
        iconView.contentMode = .scaleAspectFit
        titleLbl.sizeToFit()
        valueLbl.sizeToFit()
    }
    
    func setRow(row: [String: Any]) {
        
        if row["icon"] != nil {
            iconView.isHidden = false
            iconView.image = UIImage(named: row["icon"] as! String)
        } else {
            iconView.isHidden = true
        }
        
        if row["title"] != nil {
            titleLbl.text = (row["title"] as! String)
        }
        if row["value"] != nil {
            valueLbl.text = (row["value"] as! String)
        }
        var more: Bool = false
        if row["more"] != nil {
            more = row["more"] as! Bool
        }
        if (more) {
            accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        
        setNeedsLayout()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
