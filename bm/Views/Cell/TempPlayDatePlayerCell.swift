//
//  TempPlayDatePlayerCell.swift
//  bm
//
//  Created by ives on 2018/6/25.
//  Copyright © 2018年 bm. All rights reserved.
//

import UIKit

protocol TempPlayDatePlayerCellDelegate {
    func call(position: Int)
}
class TempPlayDatePlayerCell: SuperCell {
    
    var noLbl: MyLabel!
    var titleLbl: MyLabel!
    var mobileLbl: MyLabel!
    var tempPlayDatePlayerCellDelegate: TempPlayDatePlayerCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCell.CellStyle.value1, reuseIdentifier: reuseIdentifier)
        
        noLbl = MyLabel(frame: CGRect.zero)
        contentView.addSubview(noLbl)
        
        titleLbl = MyLabel(frame: CGRect.zero)
        contentView.addSubview(titleLbl)
        
        mobileLbl = MyLabel(frame: CGRect.zero)
        contentView.addSubview(mobileLbl)
        
        _constraint()
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func _constraint() {
        var c1: NSLayoutConstraint, c2: NSLayoutConstraint
        
        c1 = NSLayoutConstraint(item: noLbl, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 8)
        c2 = NSLayoutConstraint(item: noLbl, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 15)
        noLbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints([c1,c2])
        
        c1 = NSLayoutConstraint(item: titleLbl, attribute: .leading, relatedBy: .equal, toItem: noLbl, attribute: .trailing, multiplier: 1, constant: 8)
        c2 = NSLayoutConstraint(item: titleLbl, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 15)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints([c1,c2])
        
        c1 = NSLayoutConstraint(item: mobileLbl, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: -60)
        c2 = NSLayoutConstraint(item: mobileLbl, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 15)
        mobileLbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints([c1, c2])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLbl.sizeToFit()
        mobileLbl.sizeToFit()
        mobileLbl.isUserInteractionEnabled = true
    }
    
    func setRow(row: TempPlayDatePlayer.Row, position: Int) {
        
        var name = row.name
        mobileLbl.text = row.mobile
        
        noLbl.text = String(position+1) + "."
        
        if row.status == "off" {
            name = name + "(取消)"
        }
        titleLbl.text = name
        
        accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        mobileLbl.tag = position
        let tap = UITapGestureRecognizer(target: self, action: #selector(call))
        mobileLbl.addGestureRecognizer(tap)
        
        setNeedsLayout()
    }
    
    @objc func call(sender: UITapGestureRecognizer) {
        guard let a = (sender.view as? UILabel) else {return}
        let position: Int = a.tag
        tempPlayDatePlayerCellDelegate?.call(position: position)
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
