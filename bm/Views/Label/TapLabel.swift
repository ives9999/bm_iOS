//
//  TapLevel.swift
//  bm
//
//  Created by ives on 2023/2/7.
//  Copyright © 2023 bm. All rights reserved.
//

import UIKit

class TapLabel: SuperLabel {
    
    let defaultPadding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    var isOn: Bool = false
    var delegate: TapLabelDelegate? = nil
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    override func commonInit(){
        
        self.font = UIFont(name: FONT_NAME, size: 12)
        self.textColor = UIColor(MY_WHITE)
        self.padding = defaultPadding
        //self.backgroundColor = UIColor.blue
        self.isUserInteractionEnabled = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pressed))
        self.addGestureRecognizer(tap)
    }

    func toggle() {
        self.isOn = !self.isOn
        self.isOn ? self.on() : self.off()
    }
    
    func on() {
        self.backgroundColor = UIColor(MY_GREEN)
        self.textColor = UIColor(MY_BLACK)
        self.corner(3)
        
        self.isOn = true
    }
    
    func off() {
        self.backgroundColor = UIColor.clear
        self.textColor = UIColor(MY_WHITE)
        self.corner(0)
        
        self.isOn = false
    }
    
    @objc func pressed(_ sender: UITapGestureRecognizer) {
        if (!isOn) {
            if let n = sender.view as? TapLabel {
                isOn = !isOn
                delegate?.tapPressed(n.tag)
            }
        }
    }
}

protocol TapLabelDelegate {
    func tapPressed(_ idx: Int)
}
