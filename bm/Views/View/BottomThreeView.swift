//
//  BottomThreeView.swift
//  bm
//
//  Created by ives on 2022/5/18.
//  Copyright © 2022 bm. All rights reserved.
//

import UIKit

class BottomThreeView: UIView {
    
//    @IBOutlet weak var submitButton: SubmitButton!
//    @IBOutlet weak var cancelButton: CancelButton!
//    @IBOutlet weak var threeButton: ThreeButton!
    
    @IBOutlet weak var containerView: UIView!
    
    var submitButton: SubmitButton = SubmitButton()
    var threeButton: ThreeButton = ThreeButton()
    var cancelButton: CancelButton = CancelButton()

    let nibName = "BottomThreeView"
    var delegate: BaseViewController?
    
    var bottom_button_count: Int = 3
    var button_width: CGFloat = 120
    var button_height: CGFloat = 30
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        
        view.addSubview(submitButton)
        view.addSubview(threeButton)
        view.addSubview(cancelButton)
        
        submitButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
        threeButton.addTarget(self, action: #selector(three), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
    }
    
    func loadViewFromNib() -> UIView? {
        
        let nib: UINib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func setBottomButtonPadding(screen_width: CGFloat) {
        
        if (submitButton.isHidden) {
            bottom_button_count -= 1
        }
        
        if (threeButton.isHidden) {
            bottom_button_count -= 1
        }

        if (cancelButton.isHidden) {
            bottom_button_count -= 1
        }
        
        let padding: CGFloat = (screen_width - CGFloat(bottom_button_count) * button_width) / CGFloat((bottom_button_count + 1))
        
        //很奇怪
//        var n: CGFloat = 300
//        if padding > 62 && padding < 63 {
//            n = padding
//        } else {
//            n = (screen_width - CGFloat(bottom_button_count) * button_width) / CGFloat((bottom_button_count + 1))
//        }
        
        if (!submitButton.isHidden) {
            submitButton.translatesAutoresizingMaskIntoConstraints = false
            //submitButton.leadingAnchor.con
            submitButton.leadingAnchor.constraint(equalTo: submitButton.superview!.leadingAnchor, constant: padding).isActive = true
            submitButton.widthAnchor.constraint(equalToConstant: button_width).isActive = true
            submitButton.heightAnchor.constraint(equalToConstant: button_height).isActive = true
            submitButton.centerYAnchor.constraint(equalTo: submitButton.superview!.centerYAnchor).isActive = true
        }
        
        if (!threeButton.isHidden) {
            let padding2 = button_width * CGFloat(bottom_button_count-2) + CGFloat(bottom_button_count-1) * padding
            threeButton.translatesAutoresizingMaskIntoConstraints = false
            threeButton.leadingAnchor.constraint(equalTo: threeButton.superview!.leadingAnchor, constant: padding2).isActive = true
            threeButton.widthAnchor.constraint(equalToConstant: button_width).isActive = true
            threeButton.heightAnchor.constraint(equalToConstant: button_height).isActive = true
            threeButton.centerYAnchor.constraint(equalTo: threeButton.superview!.centerYAnchor).isActive = true
        }

        if (!cancelButton.isHidden) {
            let padding2 = button_width * CGFloat(bottom_button_count-1) + CGFloat(bottom_button_count) * padding

            cancelButton.translatesAutoresizingMaskIntoConstraints = false
            cancelButton.leadingAnchor.constraint(equalTo: cancelButton.superview!.leadingAnchor, constant: padding2).isActive = true
            cancelButton.widthAnchor.constraint(equalToConstant: button_width).isActive = true
            cancelButton.heightAnchor.constraint(equalToConstant: button_height).isActive = true
            cancelButton.centerYAnchor.constraint(equalTo: cancelButton.superview!.centerYAnchor).isActive = true
        }
    }
    
    @objc func submit() {
        delegate?.submitBtnPressed()
    }
    
    @objc func three() {
        delegate?.threeBtnPressed()
    }

    @objc func cancel() {
        //print("cancel")
        delegate?.prev()
    }
}
