//
//  IconText.swift
//  bm
//
//  Created by ives on 2023/6/13.
//  Copyright © 2023 bm. All rights reserved.
//

import Foundation

class IconText: UIView {
    
    var icon: String = "noPhont"
    var text: String = "Add"
    
    var iconWidth: Int = 24
    var iconHeight: Int = 24
    var iconIV: UIImageView = UIImageView()
    var textLbl: UILabel = SuperLabel()
    
    var delegate: IconTextDelegate?
    
    init(icon: String, text: String, iconWidth: Int = 24, iconHeight: Int = 24) {
        
        self.icon = icon
        self.text = text
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
        textLbl.text = self.text
        
        textLbl.numberOfLines = 0
        textLbl.lineBreakMode = .byWordWrapping

        self.anchor()

        let tap = UITapGestureRecognizer(target: self, action: #selector(pressed))
        self.addGestureRecognizer(tap)
    }
    
    func anchor() {
        
        self.addSubview(iconIV)
        iconIV.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(iconWidth)
            make.height.equalTo(iconHeight)
            make.top.equalToSuperview().offset(6)
            make.bottom.equalToSuperview().offset(-6)
        }
        
        self.addSubview(textLbl)
        textLbl.snp.makeConstraints { make in
            make.left.equalTo(iconIV.snp.right).offset(12)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func setIcon(_ icon: String) {
        iconIV.image = UIImage(named: icon)
    }
    
    func setText(_ text: String) {
        textLbl.text = text
    }
    
    @objc func pressed(view: UITapGestureRecognizer) {
        delegate?.pressed(icon: icon)
    }
}

protocol IconTextDelegate {
    func pressed(icon: String)
}
