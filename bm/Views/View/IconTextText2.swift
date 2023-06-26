//
//  IconText.swift
//  bm
//
//  Created by ives on 2023/6/13.
//  Copyright © 2023 bm. All rights reserved.
//

import Foundation

class IconTextText2: UIView {
    
    var icon: String = "noPhont"
    var title: String = "title"
    var show: String = "show"
    
    var iconWidth: Int = 24
    var iconHeight: Int = 24
    var iconIV: UIImageView = UIImageView()
    var titleLbl: SuperLabel = {
        let view: SuperLabel = SuperLabel()
        view.setTextGeneral()
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.setContentHuggingPriority(.required, for: .horizontal)
        
        return view
    }()
    
    var commonLbl: SuperLabel = {
        let view: SuperLabel = SuperLabel()
        view.setTextGeneral()
        view.text = ":"
        return view
    }()
    
    var showLbl: SuperLabel = {
        let view: SuperLabel = SuperLabel()
        view.setTextGeneral()
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        return view
    }()
    
    var delegate: IconTextText2Delegate?
    
    init(icon: String, title: String, show: String, iconWidth: Int = 24, iconHeight: Int = 24) {
        
        self.icon = icon
        self.title = title
        self.show = show
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
        titleLbl.text = self.title
        showLbl.text = self.show

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
        
        self.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.left.equalTo(iconIV.snp.right).offset(12)
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(commonLbl)
        commonLbl.snp.makeConstraints { make in
            make.left.equalTo(titleLbl.snp.right).offset(4)
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(showLbl)
        showLbl.snp.makeConstraints { make in
            make.left.equalTo(commonLbl.snp.right).offset(4)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func setIcon(_ icon: String) {
        iconIV.image = UIImage(named: icon)
    }
    
    func setTitle(_ title: String) {
        titleLbl.text = title
    }
    
    func setShow(_ show: String) {
        showLbl.text = show
    }
    
    @objc func pressed(view: UITapGestureRecognizer) {
        delegate?.pressed(icon: icon)
    }
}

protocol IconTextText2Delegate {
    func pressed(icon: String)
}
