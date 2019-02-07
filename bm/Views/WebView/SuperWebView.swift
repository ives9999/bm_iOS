//
//  SuperWebView.swift
//  bm
//
//  Created by ives on 2019/2/7.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit
import WebKit

class SuperWebView: WKWebView {

    init() {
        super.init(frame: CGRect.zero, configuration: WKWebViewConfiguration())
        self.backgroundColor = UIColor.clear
    }
    
    required init(frame: CGRect) {
        super.init(frame: frame, configuration: WKWebViewConfiguration())
        self.backgroundColor = UIColor.clear
    }
    
    required init!(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = UIColor.clear
    }

}
