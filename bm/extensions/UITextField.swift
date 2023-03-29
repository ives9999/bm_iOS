//
//  UITextField.swift
//  bm
//
//  Created by ives on 2023/3/22.
//  Copyright © 2023 bm. All rights reserved.
//

import Foundation

extension UITextField {
    
    func setIcon(_ icon: String) {
        let iconView: UIImageView = UIImageView(frame: CGRect(x:16, y:16, width: 18, height: 18))
        iconView.image = UIImage(named: icon)

        let iconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        iconContainerView.addSubview(iconView)

        leftView = iconContainerView
        leftViewMode = .always
    }
    
    func showDelete() {
        let iconView: UIImageView = UIImageView(frame: CGRect(x:16, y:16, width: 18, height: 18))
        iconView.image = UIImage(named: "delete_svg")
        
        let iconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        iconContainerView.addSubview(iconView)

        rightView = iconContainerView
        rightViewMode = .always
        
        let GR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(clean(_:)))
        iconContainerView.addGestureRecognizer(GR)
    }
    
    func showEye() {
        let iconView1: UIImageView = UIImageView(frame: CGRect(x:0, y:16, width: 18, height: 18))
        iconView1.image = UIImage(named: "see_password_svg")
        let iconView2: UIImageView = UIImageView(frame: CGRect(x:16, y:16, width: 18, height: 18))
        iconView2.image = UIImage(named: "delete_svg")
        
        let iconContainerView1: UIView = UIView(frame: CGRect(x:0, y:0, width: 18, height: 50))
        iconContainerView1.addSubview(iconView1)
        let iconContainerView2: UIView = UIView(frame: CGRect(x:18, y:0, width: 50, height: 50))
        //iconContainerView2.backgroundColor = UIColor.red
        iconContainerView2.addSubview(iconView2)
        
        let iconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 68, height: 50))
        iconContainerView.addSubview(iconContainerView1)
        iconContainerView.addSubview(iconContainerView2)

        rightView = iconContainerView
        rightViewMode = .always
        
        let GR1: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showPassword(_:)))
        iconContainerView1.addGestureRecognizer(GR1)
        
        let GR2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(clean(_:)))
        iconContainerView2.addGestureRecognizer(GR2)
    }
    
    @objc func clean(_ sender: UIGestureRecognizer) {
        self.text = ""
    }
    
    @objc func showPassword(_ sender: UIGestureRecognizer) {
        isSecureTextEntry.toggle()
    }
}
