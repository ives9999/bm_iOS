//
//  TabTop.swift
//  bm
//
//  Created by ives on 2022/3/19.
//  Copyright © 2022 bm. All rights reserved.
//

import UIKit

class TabTop: UIView {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var textLbl: SuperLabel!
    
    @IBOutlet weak var line: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("TabTop", owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        //containerView.backgroundColor = UIColor.red
    }

    public func setData(iconStr: String, text: String) {
        
        icon.image = UIImage(named: iconStr)
        textLbl.text = text
    }
    
    public func isFocus(_ isFocus: Bool) {
        
        line.backgroundColor = isFocus ? UIColor(MY_GREEN) : UIColor.clear
    }
}
