//
//  TempPlaySignupCell.swift
//  bm
//
//  Created by ives on 2017/12/13.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class TempPlaySignupCell: SuperCell {
    
    var nameLbl: SuperLabel!
    var created_atLbl: SuperLabel!
    let constant: TEAM_TEMP_PLAY_CELL = TEAM_TEMP_PLAY_CELL()
    //let columns: 
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCell.CellStyle.value1, reuseIdentifier: reuseIdentifier)
        nameLbl = SuperLabel()
        contentView.addSubview(nameLbl)
        created_atLbl = SuperLabel()
        contentView.addSubview(created_atLbl)
        //nameLbl.backgroundColor = UIColor.black
        //created_atLbl.backgroundColor = UIColor.black
        
//        let views: [[String: UILabel]] = [["label1":nameLbl], ["label2":created_atLbl]]
//        let constraints: [NSLayoutConstraint] = tempPlayShowTableConstraint(views)
//        contentView.addConstraints(constraints)
        
        
        let nameLblC1: NSLayoutConstraint = NSLayoutConstraint(item: nameLbl, attribute: .leading, relatedBy: .equal, toItem: nameLbl.superview, attribute: .leading, multiplier: 1, constant: 4)
        let nameLblC2: NSLayoutConstraint = NSLayoutConstraint(item: nameLbl, attribute: .centerY, relatedBy: .equal, toItem: nameLbl.superview, attribute: .centerY, multiplier: 1, constant: 0)
        nameLbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints([nameLblC1,nameLblC2])
        
        let c1: NSLayoutConstraint = NSLayoutConstraint(item: created_atLbl, attribute: .leading, relatedBy: .equal, toItem: nameLbl, attribute: .trailing, multiplier: 1, constant: 8)
        let c2: NSLayoutConstraint = NSLayoutConstraint(item: created_atLbl, attribute: .centerY, relatedBy: .equal, toItem: created_atLbl.superview, attribute: .centerY, multiplier: 1, constant: 0)
        created_atLbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints([c1,c2])
 
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        //backgroundColor = UIColor.red
        nameLbl.sizeToFit()
        created_atLbl.sizeToFit()
    }
    func forRow(row: [String: String]) {
        //print(frame.width)
        
        var status = "on"
        var status1 = ""
        if row["status"] != nil {
            status = row["status"]!
            if status == "off" {
                status1 = "(取消)"
            }
        }
        
        nameLbl.text = "\(row["nickname"]!)\(status1)"
        if let str: String = row["created_at"] {
            //print(str)
            let d: Date = df.date(from: str)!
            created_atLbl.text = d.toString(format: "yyyy-MM-dd HH:mm")
        }
        accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
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
