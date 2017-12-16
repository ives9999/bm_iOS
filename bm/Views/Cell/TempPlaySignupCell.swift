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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.value1, reuseIdentifier: reuseIdentifier)
        nameLbl = SuperLabel()
        contentView.addSubview(nameLbl)
        created_atLbl = SuperLabel()
        contentView.addSubview(created_atLbl)
        //nameLbl.backgroundColor = UIColor.black
        //created_atLbl.backgroundColor = UIColor.black
        
        let views: [[String: UILabel]] = [["label1":nameLbl], ["label2":created_atLbl]]
        let constraints: [NSLayoutConstraint] = tempPlayShowTableConstraint(views)
        contentView.addConstraints(constraints)
        
        /*
        let nameLblC1: NSLayoutConstraint = NSLayoutConstraint(item: nameLbl, attribute: .leading, relatedBy: .equal, toItem: nameLbl.superview, attribute: .leading, multiplier: 1, constant: constant.name_left_padding)
        let nameLblC2: NSLayoutConstraint = NSLayoutConstraint(item: nameLbl, attribute: .centerY, relatedBy: .equal, toItem: nameLbl.superview, attribute: .centerY, multiplier: 1, constant: 0)
        nameLbl.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addConstraint(nameLblC1)
        contentView.addConstraint(nameLblC2)
 */
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
        nameLbl.text = row["nickname"]
        if let str: String = row["created_at"] {
            //print(str)
            let d: Date = df.date(from: str)!
            created_atLbl.text = d.toString(format: "yyyy-MM-dd HH:mm")
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