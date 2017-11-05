//
//  CircleImageView.swift
//  bm
//
//  Created by ives on 2017/11/4.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

@IBDesignable
class CircleImageView: UIImageView {

    override func awakeFromNib() {
        setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
}
