//
//  Avatar.swift
//  bm
//
//  Created by ives on 2023/2/4.
//  Copyright © 2023 bm. All rights reserved.
//

import UIKit

class Avatar: UIImageView {
    
    func path(_ url: String) {
        self.downloaded(from: url)
    }
}

class featured: UIImageView {
    
    func path(_ url: String) {
        self.downloaded(from: url)
    }
}
