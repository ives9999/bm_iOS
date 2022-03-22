//
//  MenuCell.swift
//  bm
//
//  Created by ives on 2017/11/23.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class MenuCell: SuperCell {
    
    var iconView: UIImageView!
    var titleLbl: SuperLabel!
    var greater: UIImageView!
    //var titleLbl: MyLabel!
    //var tempPlayLbl: MyLabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCell.CellStyle.value1, reuseIdentifier: reuseIdentifier)
        
        iconView = UIImageView(frame: CGRect.zero)
        contentView.addSubview(iconView)
        
        greater = UIImageView(frame: CGRect.zero)
        greater.image = UIImage(named: "greater1")
        contentView.addSubview(greater)
        
        titleLbl = SuperLabel(frame: CGRect.zero)
        contentView.addSubview(titleLbl)
        _constraint()
        titleLbl.setTextGeneral()
        
//        tempPlayLbl = MyLabel(frame: CGRect.zero)
//        tempPlayLbl.text = "臨打"
//        contentView.addSubview(tempPlayLbl)
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func _constraint() {
        var c1: NSLayoutConstraint, c2: NSLayoutConstraint, c3: NSLayoutConstraint, c4: NSLayoutConstraint, c5: NSLayoutConstraint, c6: NSLayoutConstraint
        
        c1 = NSLayoutConstraint(item: iconView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 32)
        c2 = NSLayoutConstraint(item: iconView, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0)
        c3 = NSLayoutConstraint(item: iconView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 32)
        c4 = NSLayoutConstraint(item: iconView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 32)
        c5 = NSLayoutConstraint(item: iconView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 16)
        c6 = NSLayoutConstraint(item: iconView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: -16)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints([c1,c2,c3,c4,c5,c6])
        
        c1 = NSLayoutConstraint(item: titleLbl, attribute: .leading, relatedBy: .equal, toItem: iconView, attribute: .trailing, multiplier: 1, constant: 16)
        c2 = NSLayoutConstraint(item: titleLbl, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints([c1,c2])
        
        c1 = NSLayoutConstraint(item: greater, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: -16)
        c2 = NSLayoutConstraint(item: greater, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0)
        c3 = NSLayoutConstraint(item: greater, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20)
        c4 = NSLayoutConstraint(item: greater, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20)
        greater.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints([c1,c2,c3,c4])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconView.clipsToBounds = true
        iconView.contentMode = .scaleAspectFit
        titleLbl.sizeToFit()
    }
    
    func setRow(row: MemberRow) {
        
        if row.icon.count > 0 {
            iconView.isHidden = false
            iconView.image = UIImage(named: row.icon)
        } else {
            iconView.isHidden = true
        }
 
        titleLbl.text = row.title
        titleLbl.textColor = row.color
//        accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
//        tintColor = UIColor(MY_WHITE)
        
        if row.show.count > 0 {
            detailTextLabel?.text = row.show
            greater.isHidden = true
        }
        
        setNeedsLayout()
    }
    
    func setRow(row: [String: Any]) {
        
        if row["icon"] != nil {
            iconView.isHidden = false
            iconView.image = UIImage(named: row["icon"] as! String)
        } else {
            iconView.isHidden = true
        }
 
        if row["text"] != nil {
            titleLbl.text = (row["text"] as! String)
            if row["color"] != nil {
                titleLbl.textColor = row["color"] as? UIColor
            }
        }
        accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        if row["detail"] != nil {
            detailTextLabel?.text = (row["detail"] as! String)
        }
        
        setNeedsLayout()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
