//
//  PasswordVC.swift
//  bm
//
//  Created by ives on 2017/12/20.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class PasswordVC: UIViewController {
    
    var type: String!
    var label1: SuperLabel!
    var email: EMailTextField!
    var submitBtn: SuperButton!

    @IBOutlet weak var bkView: UIImageView!
    @IBOutlet weak var logoView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label1 = SuperLabel()
        label1.text = "請輸入註冊時的email"
        email = EMailTextField()
        submitBtn = SuperButton()
        submitBtn.setTitle("送出", for: .normal)
        submitBtn.padding(top: 3, left: 22, bottom: 3, right: 22)
        submitBtn.cornerRadius(18)
        submitBtn.addTarget(self, action: #selector(submit(_:)), for: UIControlEvents.touchUpInside)
        
        view.addSubview(label1)
        view.addSubview(email)
        view.addSubview(submitBtn)
        _layout()

        print(type)
    }
    
    private func _layout() {
        var c1: NSLayoutConstraint,c2: NSLayoutConstraint,c3: NSLayoutConstraint,c4: NSLayoutConstraint
        c1 = NSLayoutConstraint(item: label1, attribute: .centerX, relatedBy: .equal, toItem: label1.superview, attribute: .centerX, multiplier: 1, constant: 0)
        c2 = NSLayoutConstraint(item: label1, attribute: .top, relatedBy: .equal, toItem: logoView, attribute: .bottom, multiplier: 1, constant: 50)
        label1.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([c1, c2])
        c1 = NSLayoutConstraint(item: email, attribute: .centerX, relatedBy: .equal, toItem: email.superview, attribute: .centerX, multiplier: 1, constant: 0)
        c2 = NSLayoutConstraint(item: email, attribute: .top, relatedBy: .equal, toItem: label1, attribute: .bottom, multiplier: 1, constant: 12)
        c3 = NSLayoutConstraint(item: email, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)
        email.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([c1, c2, c3])
        c1 = NSLayoutConstraint(item: submitBtn, attribute: .centerX, relatedBy: .equal, toItem: submitBtn.superview, attribute: .centerX, multiplier: 1, constant: 0)
        c2 = NSLayoutConstraint(item: submitBtn, attribute: .top, relatedBy: .equal, toItem: email, attribute: .bottom, multiplier: 1, constant: 12)
        submitBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([c1, c2])
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        label1.sizeToFit()
        submitBtn.sizeToFit()
        view.layoutIfNeeded()
    }
    
    @objc func submit(_ sender: Any) {
        
    }

    @IBAction func prevBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
