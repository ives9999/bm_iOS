//
//  abc.swift
//  bm
//
//  Created by ives on 2022/3/18.
//  Copyright © 2022 bm. All rights reserved.
//

import UIKit

class abc: UIView {

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
        Bundle.main.loadNibNamed("abc", owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        //containerView.backgroundColor = UIColor.red
    }
}
