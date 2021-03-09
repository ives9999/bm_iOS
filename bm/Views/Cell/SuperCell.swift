//
//  SuperCell.swift
//  bm
//
//  Created by ives on 2017/11/23.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import SwipeCellKit

class SuperCell: SwipeTableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        _init()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    
    func _init() {
        textLabel?.textColor = UIColor.white
        detailTextLabel?.textColor = UIColor.white
        backgroundColor = UIColor.clear
        selectionStyle = .none
    }
}
