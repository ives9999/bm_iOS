//
//  TapLevel.swift
//  bm
//
//  Created by ives on 2023/2/7.
//  Copyright © 2023 bm. All rights reserved.
//

import UIKit

class TapLabel2: SuperLabel {
    
    let defaultPadding: UIEdgeInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
    var isOn: Bool = false
    var delegate: TapLabel2Delegate? = nil
    var fontSize: CGFloat = 11
    var cornerSize: CGFloat = 10
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    override func commonInit(){
        
        self.font = UIFont(name: FONT_NAME, size: fontSize)
        self.textColor = UIColor(hex: MY_WHITE, alpha: 0.8)
        self.padding = defaultPadding
        self.isUserInteractionEnabled = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pressed))
        self.addGestureRecognizer(tap)
    }

    func toggle() {
        self.isOn = !self.isOn
        self.isOn ? self.on() : self.off()
    }
    
    func on() {
        
        self.font = UIFont(name: FONT_BOLD_NAME, size: fontSize)
        self.textColor = UIColor(MY_GREEN)
        
        self.layer.borderColor = UIColor(MY_GREEN).cgColor
        self.layer.borderWidth = 1
        self.corner(cornerSize)
        
        self.isOn = true
    }
    
    func off() {
        
        self.font = UIFont(name: FONT_NAME, size: fontSize)
        self.textColor = UIColor(hex: MY_WHITE, alpha: 0.56)
        
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 0
        self.corner(0)
        
        self.isOn = false
    }
    
    @objc func pressed(_ sender: UITapGestureRecognizer) {
        if (!isOn) {
            if let n = sender.view as? TapLabel2 {
                isOn = !isOn
                delegate?.tapPressed(n.tag)
            }
        }
    }
}

protocol TapLabel2Delegate {
    func tapPressed(_ idx: Int)
}
