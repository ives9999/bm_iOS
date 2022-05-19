//
//  BottomThreeView.swift
//  bm
//
//  Created by ives on 2022/5/18.
//  Copyright © 2022 bm. All rights reserved.
//

import UIKit

class BottomThreeView: UIView {
    
    @IBOutlet weak var submitButton: SubmitButton!
    @IBOutlet weak var cancelButton: CancelButton!
    @IBOutlet weak var threeButton: ThreeButton!

    let nibName = "BottomThreeView"
    var delegate: BaseViewController?
    
    var bottom_button_count: Int = 3
    var button_width: CGFloat = 120
    
//    @IBOutlet weak var submitButtonConstraintLeading: NSLayoutConstraint!
//    @IBOutlet weak var threeButtonConstraintLeading: NSLayoutConstraint!
//    @IBOutlet weak var cancelButtonConstraintLeading: NSLayoutConstraint!
    
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
    }
    
    func loadViewFromNib() -> UIView? {
        
        let nib: UINib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func setBottomButtonPadding(screen_width: CGFloat) {
        
        if (submitButton.isHidden) {
            bottom_button_count -= 1
        }
        
        let padding: CGFloat = (screen_width - CGFloat(bottom_button_count) * button_width) / CGFloat((bottom_button_count + 1))
        
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.leadingAnchor.constraint(equalTo: submitButton.superview!.leadingAnchor, constant: padding).isActive = true
        threeButton.translatesAutoresizingMaskIntoConstraints = false
        threeButton.leadingAnchor.constraint(equalTo: submitButton.trailingAnchor, constant: padding).isActive = true
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.leadingAnchor.constraint(equalTo: threeButton.trailingAnchor, constant: padding).isActive = true
        
//        submitButtonConstraintLeading.constant = padding
//        threeButtonConstraintLeading.constant = CGFloat(bottom_button_count) * padding + CGFloat(bottom_button_count-1)*button_width
//        cancelButtonConstraintLeading.constant = CGFloat(bottom_button_count) * padding + CGFloat(bottom_button_count-1)*button_width
    }

}
