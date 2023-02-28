//
//  Avatar.swift
//  bm
//
//  Created by ives on 2023/2/4.
//  Copyright © 2023 bm. All rights reserved.
//

import UIKit

class Avatar: UIImageView {
    
    func path(_ url: String, isCircle: Bool = true, rounded: CGFloat = 0, contentMode mode: UIView.ContentMode = UIView.ContentMode.scaleAspectFit) {
        self.downloaded(from: url, isCircle: isCircle, rounded: rounded, contentMode: mode)
    }
}

class Featured: UIImageView {
    
    func path(_ url: String, isCircle: Bool = true, rounded: CGFloat = 0, contentMode mode: UIView.ContentMode = UIView.ContentMode.scaleAspectFit) {
        self.downloaded(from: url, isCircle: isCircle, rounded: rounded, contentMode: mode)
    }
}
