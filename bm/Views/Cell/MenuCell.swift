//
//  MenuCell.swift
//  bm
//
//  Created by ives on 2017/11/23.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    
    var containerView: UIView = UIView()
    var iconView: UIImageView = UIImageView()
    
    var titleLbl: SuperLabel = {
        let view = SuperLabel()
        view.setTextGeneral()
        
        return view
    }()
    
    var greaterIV: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "greater1")
        
        return view
    }()
    
    var showLbl: SuperLabel = {
        let view = SuperLabel()
        view.setTextGeneral()
        
        return view
    }()
    
    let line: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCell.CellStyle.value1, reuseIdentifier: reuseIdentifier)

        contentView.backgroundColor = UIColor(MY_BLACK)

        anchor()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func anchor() {
        
        self.contentView.addSubview(containerView)
        //containerView.backgroundColor = UIColor.gray
        containerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(-4)
        }
        
        containerView.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(32)
            make.width.height.equalTo(32)
            make.centerY.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16)
        }
        
        containerView.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(16)
            make.centerY.equalTo(iconView)
        }
        
        containerView.addSubview(greaterIV)
        greaterIV.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalTo(iconView)
            make.width.height.equalTo(20)
        }
        
        containerView.addSubview(showLbl)
        showLbl.snp.makeConstraints { make in
            make.right.equalTo(greaterIV.snp.left).offset(-48)
            make.centerY.equalTo(iconView)
        }
        
//        self.contentView.addSubview(line)
//        line.snp.makeConstraints { make in
//            make.top.equalTo(containerView.snp.bottom).offset(8)
//            make.left.equalToSuperview().offset(16)
//            make.right.equalToSuperview().offset(-16)
//            make.height.equalTo(1)
//            //make.bottom.equalToSuperview().offset(10)
//        }
        
//        var c1: NSLayoutConstraint, c2: NSLayoutConstraint, c3: NSLayoutConstraint, c4: NSLayoutConstraint, c5: NSLayoutConstraint, c6: NSLayoutConstraint
//
//        c1 = NSLayoutConstraint(item: iconView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 32)
//        c2 = NSLayoutConstraint(item: iconView, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0)
//        c3 = NSLayoutConstraint(item: iconView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 32)
//        c4 = NSLayoutConstraint(item: iconView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 32)
//        c5 = NSLayoutConstraint(item: iconView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 16)
//        c6 = NSLayoutConstraint(item: iconView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: -16)
//        iconView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addConstraints([c1,c2,c3,c4,c5,c6])
        
//        c1 = NSLayoutConstraint(item: titleLbl, attribute: .leading, relatedBy: .equal, toItem: iconView, attribute: .trailing, multiplier: 1, constant: 16)
//        c2 = NSLayoutConstraint(item: titleLbl, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0)
//        titleLbl.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addConstraints([c1,c2])
        
//        c1 = NSLayoutConstraint(item: greater, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: -16)
//        c2 = NSLayoutConstraint(item: greater, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0)
//        c3 = NSLayoutConstraint(item: greater, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20)
//        c4 = NSLayoutConstraint(item: greater, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20)
//        greater.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addConstraints([c1,c2,c3,c4])
        
//        showLbl.translatesAutoresizingMaskIntoConstraints = false
//        showLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -48).isActive = true
//        showLbl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        iconView.clipsToBounds = true
//        iconView.contentMode = .scaleAspectFit
//        titleLbl.sizeToFit()
//    }
    
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
            showLbl.isHidden = false
            showLbl.text = row.show
            //greater.isHidden = true
        } else {
            showLbl.isHidden = true
        }
        
        greaterIV.isHidden =  (row.showGreater) ? false : true
        
        //setNeedsLayout()
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
        
        //setNeedsLayout()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
