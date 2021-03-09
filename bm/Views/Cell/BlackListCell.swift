//
//  BlackListCell.swift
//  bm
//
//  Created by ives on 2018/6/19.
//  Copyright © 2018年 bm. All rights reserved.
//

import UIKit

protocol BlackListCellDelegate {
    func cancel(position: Int)
    func call(position: Int)
}

class BlackListCell: SuperCell {
    
    var memberNameLbl: MyLabel!
    var teamNameLbl: MyLabel!
    var memberMobileLbl: MyLabel!
    var dateLbl: MyLabel!
    var cancelBtn: CancelButton
    let secondLineMargin: CGFloat = 1.0
    let secondItemMargin: CGFloat = 160
    
    var accessoryBtn: UIButton?
    var blacklistCellDelegate: BlackListCellDelegate?

    init(style: UITableViewCell.AccessoryType, reuseIdentifier: String?) {
        cancelBtn = CancelButton()
        super.init(style: UITableViewCell.CellStyle.value1, reuseIdentifier: reuseIdentifier)
        
        memberNameLbl = MyLabel(frame: CGRect.zero)
        contentView.addSubview(memberNameLbl)
        memberMobileLbl = MyLabel(frame: CGRect.zero)
        contentView.addSubview(memberMobileLbl)
        
        teamNameLbl = MyLabel(frame: CGRect.zero)
        contentView.addSubview(teamNameLbl)
        dateLbl = MyLabel(frame: CGRect.zero)
        contentView.addSubview(dateLbl)
        
        
        contentView.addSubview(cancelBtn)
        
        _constraint()
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func _constraint() {
        var c1: NSLayoutConstraint, c2: NSLayoutConstraint, c3: NSLayoutConstraint, c4: NSLayoutConstraint
        
        c1 = NSLayoutConstraint(item: memberNameLbl, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 16)
        c2 = NSLayoutConstraint(item: memberNameLbl, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 8)
        memberNameLbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints([c1,c2])
        
        c1 = NSLayoutConstraint(item: memberMobileLbl, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: secondItemMargin)
        c2 = NSLayoutConstraint(item: memberMobileLbl, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 8)
        memberMobileLbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints([c1,c2])
        
        
        c1 = NSLayoutConstraint(item: teamNameLbl, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 16)
        c2 = NSLayoutConstraint(item: teamNameLbl, attribute: .top, relatedBy: .equal, toItem: memberNameLbl, attribute: .bottom, multiplier: 1, constant: secondLineMargin)
        teamNameLbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints([c1,c2])
        
        c1 = NSLayoutConstraint(item: dateLbl, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: secondItemMargin)
        c2 = NSLayoutConstraint(item: dateLbl, attribute: .top, relatedBy: .equal, toItem: memberMobileLbl, attribute: .bottom, multiplier: 1, constant: secondLineMargin)
        dateLbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints([c1,c2])
        
        c1 = NSLayoutConstraint(item: cancelBtn, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 16)
        c2 = NSLayoutConstraint(item: cancelBtn, attribute: .top, relatedBy: .equal, toItem: teamNameLbl, attribute: .bottom, multiplier: 1, constant: secondLineMargin+12)
        c3 = NSLayoutConstraint(item: cancelBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 120)
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints([c1,c2,c3])
 
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        memberNameLbl.sizeToFit()
        memberMobileLbl.sizeToFit()
        teamNameLbl.sizeToFit()
        dateLbl.sizeToFit()
        accessoryBtn?.frame.origin.x = 120
        cancelBtn.contentHorizontalAlignment = .center
        memberMobileLbl.isUserInteractionEnabled = true
    }
    
    func setRow(row: [String: Any], position: Int) {
        if row["memberName"] != nil {
            memberNameLbl.text = (row["memberName"] as! String)
        }
        if row["memberMobile"] != nil {
            memberMobileLbl.text = (row["memberMobile"] as! String)
        }
        if row["teamName"] != nil {
            teamNameLbl.text = (row["teamName"] as! String)
        }
        if row["date"] != nil {
            dateLbl.text = (row["date"] as! String)
        }
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.tag = position
        cancelBtn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        memberMobileLbl.tag = position
        let tap = UITapGestureRecognizer(target: self, action: #selector(call))
        memberMobileLbl.addGestureRecognizer(tap)
        
        accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        
        setNeedsLayout()
    }
    
    @objc func cancel(sender: UIButton) {
        let position: Int = sender.tag
        blacklistCellDelegate?.cancel(position: position)
    }
    @objc func call(sender: UITapGestureRecognizer) {
        guard let a = (sender.view as? UILabel) else {return}
        let position: Int = a.tag
        blacklistCellDelegate?.call(position: position)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        accessoryType = .disclosureIndicator
        accessoryBtn = subviews.compactMap{$0 as? UIButton}.first
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
