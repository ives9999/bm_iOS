//
//  SignupButton.swift
//  bm
//
//  Created by ives on 2023/6/17.
//  Copyright © 2023 bm. All rights reserved.
//

import UIKit

class SignupButton2: UIView {
    
    let priceLbl: SuperLabel = {
        let view: SuperLabel = SuperLabel()
        view.setTextGeneral()
        view.text = "NT$1000 ~ 1200"
        return view
    }()
    
    let button: SuperLabel = {
        let view: SuperLabel = SuperLabel()
        view.setTextGeneral()
        view.text = "報名"
        view.textAlignment = .center
        view.backgroundColor = UIColor(hex: "#033BD9", alpha: 1)
        view.corner(12)
        return view
    }()

    var idx: Int?
    var delegate: SignupButton2Delegate?

    init() {
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
        self.backgroundColor = UIColor(MY_BLACK)
        self.layer.cornerRadius = 18
        self.layer.borderColor = UIColor.blue.cgColor
        self.layer.borderWidth = 1
        
        anchor()
        
        let tg: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pressed(sender:)))
        self.addGestureRecognizer(tg)
    }
    
    func anchor() {
        self.addSubview(priceLbl)
        priceLbl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(button)
        button.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.equalTo(90)
            make.height.equalTo(28)
        }
    }
    
    @objc func pressed(sender: UITapGestureRecognizer) {
        if idx != nil {
            delegate?.signupButtonPressed(idx: idx!)
        }
    }

}

protocol SignupButton2Delegate {
    func signupButtonPressed(idx: Int)
}
