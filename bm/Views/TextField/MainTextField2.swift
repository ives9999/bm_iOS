//
//  MainTextField2.swift
//  bm
//
//  Created by ives on 2023/3/21.
//  Copyright © 2023 bm. All rights reserved.
//

import UIKit

class MainTextField2: UIView {
    
    var icon: String?
    
    var label: SuperLabel = {
        let view: SuperLabel = SuperLabel()
        view.setTextBold()
        
        return view
    }()
    
    var textField: SuperTextField = {
        let view: SuperTextField = SuperTextField()
        view.backgroundColor = UIColor(hex: "#D9D9D9", alpha: 0.1)
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(hex: "#FFFFFF", alpha: 0.4).cgColor
        
        view.leftViewMode = .always
        
        return view
    }()
    
    let iconIV: UIImageView = {
        let view: UIImageView = UIImageView(frame: CGRect(x: 16, y: 16, width: 18, height: 18))
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    let iconView: UIView = {
        let view: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        view.layer.cornerRadius = 5
        //mainView.backgroundColor = UIColor.blue
        
        return view
    }()

    init(label: String, icon: String) {
        
        self.label.text = label
        self.icon = icon
        
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
        anchor()
        
        if icon != nil {
            iconIV.image = UIImage(named: icon!)
        }
        iconView.addSubview(iconIV)
        textField.leftView = iconView
    }
    
    func anchor() {
        self.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
        }
        
        self.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(5)
        }
    }
}
