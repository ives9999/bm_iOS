//
//  Top.swift
//  bm
//
//  Created by ives on 2022/4/4.
//  Copyright © 2022 bm. All rights reserved.
//

import Foundation

class Top: UIView {
    
    @IBOutlet weak var containerView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("Top", owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
