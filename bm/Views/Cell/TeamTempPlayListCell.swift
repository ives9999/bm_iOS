//
//  TeamTempPlayListCell.swift
//  bm
//
//  Created by ives on 2017/12/4.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class TeamTempPlayListCell: SuperCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.value1, reuseIdentifier: reuseIdentifier)
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    func forRow(row: Dictionary<String, [String: Any]>) {
        accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        textLabel?.text = (row[TEAM_NAME_KEY]!["value"] as! String)
        detailTextLabel?.text = (row["near_date"]!["value"] as! String)
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
