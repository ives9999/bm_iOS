//
//  UITableViewCell.swift
//  bm
//
//  Created by ives on 2022/12/13.
//  Copyright © 2022 bm. All rights reserved.
//

import Foundation

extension UITableViewCell {
    
    func setSelectedBackgroundColor() {
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(CELL_SELECTED1)
        selectedBackgroundView = bgColorView
    }
}
