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
    var placeholder: String?
    var isShowDelete: Bool = true
    var isPassword: Bool = false
    var value: String = ""
    var keyboard: KEYBOARD = KEYBOARD.default
    var text: String = ""
    var isRequired: Bool = false
    
    var labelContainer: UIView = UIView()
    
    var label: SuperLabel = {
        let view: SuperLabel = SuperLabel()
        view.setTextBold()
        
        return view
    }()
    
    var required: SuperLabel = {
        let view: SuperLabel = SuperLabel()
        view.highlight()
        view.text = "*必填"
        view.setTextSize(12)
        view.visibility = .invisible
        
        return view
    }()
    
    var textField: UITextField = {
        let view: UITextField = UITextField()
        view.backgroundColor = UIColor(hex: "#D9D9D9", alpha: 0.1)
        
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(hex: "#FFFFFF", alpha: 0.4).cgColor
        view.textColor = UIColor(MY_WHITE)
        
        view.font = UIFont(name: FONT_NAME, size: FONT_SIZE_GENERAL)
        
        view.attributedPlaceholder = NSAttributedString(
            string: "email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(hex: "#FFFFFF", alpha: 0.31)]
        )
        
        view.autocapitalizationType = .none
                
        return view
    }()

    init(label: String, value: String = "", icon: String, placeholder: String? = nil, isShowDelete: Bool = true, isRequired: Bool = false, isPassword: Bool = false, keyboard: KEYBOARD = .default) {
        
        self.label.text = label
        self.value = value
        self.icon = icon
        self.placeholder = placeholder
        self.isShowDelete = isShowDelete
        self.isRequired = isRequired
        self.isPassword = isPassword
        self.keyboard = keyboard
        
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
            textField.setIcon(icon!)
        }
        
        if value.count > 0 {
            textField.text = value
        }
        
        if (isRequired) {
            required.visibility = .visible
        }
        
        if placeholder != nil {
            textField.placeholder = placeholder
        }
        
        if isShowDelete {
            textField.showDelete()
        }
        
        if isPassword {
            textField.isSecureTextEntry = isPassword
            textField.showEye()
        }
        
        textField.keyboardType = keyboard.enumToSwift()
        
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func anchor() {
        self.addSubview(labelContainer)
        labelContainer.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        labelContainer.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.bottom.left.equalToSuperview()
        }
        
        labelContainer.addSubview(required)
        required.snp.makeConstraints { make in
            make.bottom.right.equalToSuperview()
        }
        
        self.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(10)
        }
    }
    
    func setValue(_ value: String) {
        self.value = value
        textField.text = value
        self.text = value
    }
    
    func setLabel(_ label: String) {
        self.label.text = label
    }
    
    func setIcon(_ icon: String) {
        textField.setIcon(icon)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        //print(textField.text)
        self.text = textField.text ?? ""
    }
}
