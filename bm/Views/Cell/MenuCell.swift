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
    var titleLbl: MyLabel!
    //var tempPlayLbl: MyLabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.value1, reuseIdentifier: reuseIdentifier)
        
        iconView = UIImageView(frame: CGRect.zero)
        contentView.addSubview(iconView)
        
        titleLbl = MyLabel(frame: CGRect.zero)
        contentView.addSubview(titleLbl)
        
//        tempPlayLbl = MyLabel(frame: CGRect.zero)
//        tempPlayLbl.text = "臨打"
//        contentView.addSubview(tempPlayLbl)
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var x: CGFloat = 30
        let y: CGFloat = 10
        let iconWidth: CGFloat = 24
        let iconHeight: CGFloat = 24
        iconView.frame = CGRect(x: x, y: y, width: iconWidth, height: iconHeight)
        
        x = x + iconWidth + 30
        titleLbl.frame = CGRect(x: x, y: 0, width: bounds.width - x - 30, height: bounds.height)
        
        //let tempPlayWidth: CGFloat = 50
        //tempPlayLbl.frame = CGRect(x: bounds.width - tempPlayWidth - 90, y: 20, width: tempPlayWidth, height: bounds.height-20)
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
        }
        accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        if row["detail"] != nil {
            detailTextLabel?.text = row["detail"] as! String
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
