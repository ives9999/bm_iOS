//
//  IconTextVertical2.swift
//  bm
//
//  Created by ives on 2023/3/17.
//  Copyright © 2023 bm. All rights reserved.
//

import UIKit

class IconTextVertical2: UIView {

    var icon: String = "noPhont"
    var text: String = "Add"
    
    var frameWidth: Int = 87
    var frameHeight: Int = 52
    var iconWidth: Int = 24
    var iconHeight: Int = 24
    var iconIV: UIImageView = UIImageView()
    var textLbl: UILabel = SuperLabel()
    
    var delegate: IconTextVertical2Delegate?
    
    init(icon: String, text: String, frameWidth: Int = 87, frameHeight: Int = 52, iconWidth: Int = 24, iconHeight: Int = 24) {
        
        self.icon = icon
        self.text = text
        self.frameWidth = frameWidth
        self.frameHeight = frameHeight
        self.iconWidth = iconWidth
        self.iconHeight = iconHeight
        
        super.init(frame: .zero)
        commonInit()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        
        iconIV.image = UIImage(named: icon)
        setText(self.text)
        setIcon(self.icon)

        self.anchor()

        let tap = UITapGestureRecognizer(target: self, action: #selector(pressed))
        self.addGestureRecognizer(tap)
    }
    
    func anchor() {
        
        self.snp.makeConstraints { make in
            make.width.equalTo(frameWidth)
            make.height.equalTo(frameHeight)
        }
        
        self.addSubview(iconIV)
        iconIV.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalTo(iconWidth)
            make.height.equalTo(iconHeight)
            make.centerX.equalToSuperview()
        }
        
        self.addSubview(textLbl)
        textLbl.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    func setText(_ text: String) {
        textLbl.text = text
    }
    
    func setIcon(_ icon: String) {
        iconIV.image = UIImage(named: icon)
    }
    
    @objc func pressed(view: UITapGestureRecognizer) {
        delegate?.pressed(icon: icon)
    }

}

protocol IconTextVertical2Delegate {
    func pressed(icon: String)
}
