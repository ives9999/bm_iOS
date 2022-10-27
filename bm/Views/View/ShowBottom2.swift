//
//  ShowBottom2.swift
//  bm
//
//  Created by ives on 2022/10/26.
//  Copyright © 2022 bm. All rights reserved.
//

import UIKit

class ShowBottom2: UIView {

    var delegate: BaseViewController? = nil
    var submitBtn: SubmitButton = SubmitButton()
    var likeBtn: LikeButton = LikeButton()
    
    let btnWidth: CGFloat = 120
    let btnHeight: CGFloat = 40
    
    var bottom_button_count = 2
    
    var isLike: Bool = false
    
    init(delegate: BaseViewController?) {
        super.init(frame: CGRect.zero)
        self.delegate = delegate
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = UIColor(MY_GRAY)
        self.addSubview(submitBtn)
        self.addSubview(likeBtn)
        
        submitBtn.addTarget(self, action: #selector(submit), for: .touchUpInside)
        likeBtn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
    }
    
    func setAnchor(parent: UIView) {
        
        parent.addSubview(self)
        self.snp.makeConstraints { make in
            make.bottom.equalTo(parent.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(80)
        }
        
        var padding: CGFloat = setBottomButtonPadding()
        
        self.submitBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(padding)
            make.width.equalTo(btnWidth)
            make.height.equalTo(btnHeight)
        }
        
        padding = padding*2 + btnWidth
        self.likeBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(padding)
            make.width.equalTo(btnWidth)
            make.height.equalTo(btnHeight)
        }
    }
    
    @objc func submit() {
        self.delegate?.submit()
    }
    
    @objc func cancel() {
        self.delegate?.cancel()
    }
    
    private func setBottomButtonPadding()-> CGFloat {
        
        let screen_width = UIScreen.main.bounds.width
        let padding: CGFloat = (screen_width - CGFloat(bottom_button_count) * btnWidth) / CGFloat((bottom_button_count + 1))
        //likeButtonConstraintLeading.constant = CGFloat(bottom_button_count) * padding + CGFloat(bottom_button_count-1)*btnWidth
        
        return padding
    }
    
    func setLike(isLike: Bool, count: Int) {
        self.isLike = isLike
        likeBtn.initStatus(isLike, count)
    }
    
    func setSubmitBtnTitle(_ title: String) {
        self.submitBtn.setTitle(title)
    }
    
    func setSubmitBtnVisible(_ isVisible: Bool) {
        
        self.submitBtn.visibility = (isVisible) ? .visible : .invisible
        self.bottom_button_count = (isVisible) ? self.bottom_button_count+1 : self.bottom_button_count-1
        var padding: CGFloat = setBottomButtonPadding()
        
        self.submitBtn.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(padding)
            make.width.equalTo(btnWidth)
            make.height.equalTo(btnHeight)
        }
        
        padding = padding*2 + btnWidth
        self.likeBtn.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(padding)
            make.width.equalTo(btnWidth)
            make.height.equalTo(btnHeight)
        }
    }
}
