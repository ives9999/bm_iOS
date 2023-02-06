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
    var cancelBtn: CancelButton = CancelButton()
    
    let btnWidth: CGFloat = 120
    let btnHeight: CGFloat = 40
    
    var bottom_button_count = 3
    
    var isLike: Bool = false
    
    var isShowSubmitBtn: Bool = true
    var isShowLikeBtn: Bool = true
    var isShowCancelBtn: Bool = true
    
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
        //backgroundColor = UIColor(MY_GRAY)
        self.addSubview(submitBtn)
        self.addSubview(likeBtn)
        self.addSubview(cancelBtn)
        
        submitBtn.addTarget(self, action: #selector(submit), for: .touchUpInside)
        likeBtn.addTarget(self, action: #selector(like), for: .touchUpInside)
        cancelBtn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
    }
    
    func justShowLike(parent: UIView) {
        self.isShowSubmitBtn = false
        self.isShowCancelBtn = false
        self.bottom_button_count = 1
        setAnchor(parent: parent)
    }
    
    func justShowSubmit(parent: UIView) {
        self.isShowLikeBtn = false
        self.isShowCancelBtn = false
        self.bottom_button_count = 1
        setAnchor(parent: parent)
    }
    
    func justShowCancel(parent: UIView) {
        self.isShowSubmitBtn = false
        self.isShowCancelBtn = false
        self.bottom_button_count = 1
        setAnchor(parent: parent)
    }
    
    func showButton(parent: UIView, isShowSubmit: Bool = true, isShowLike: Bool = true, isShowCancel: Bool = true) {
        
        self.isShowSubmitBtn = isShowSubmit
        self.isShowLikeBtn = isShowLike
        self.isShowCancelBtn = isShowCancel
        
        self.bottom_button_count = 0
        if self.isShowSubmitBtn { self.bottom_button_count += 1 }
        if self.isShowLikeBtn { self.bottom_button_count += 1 }
        if self.isShowCancelBtn { self.bottom_button_count += 1 }
        
        self.submitBtn.visibility = (self.isShowSubmitBtn) ? .visible : .invisible
        self.cancelBtn.visibility = (self.isShowCancelBtn) ? .visible : .invisible
        self.likeBtn.visibility = (self.isShowLikeBtn) ? .visible : .invisible
        
        setAnchor(parent: parent)
        
    }
    
    func setAnchor(parent: UIView) {
        
        parent.addSubview(self)
        self.snp.makeConstraints { make in
            make.bottom.equalTo(parent.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(80)
        }
        
        var padding: CGFloat = setBottomButtonPadding()
        let topMargin: CGFloat = 2
        
        if (isShowSubmitBtn) {
            self.submitBtn.snp.remakeConstraints { make in
                //make.centerY.equalToSuperview()
                make.top.equalToSuperview().offset(topMargin)
                make.left.equalToSuperview().offset(padding)
                make.width.equalTo(btnWidth)
                make.height.equalTo(btnHeight)
            }
        } else {
            self.submitBtn.visibility = .invisible
        }
        
        if (isShowLikeBtn) {
            padding = padding * CGFloat(bottom_button_count) + btnWidth * CGFloat(bottom_button_count-1)
            self.likeBtn.snp.remakeConstraints { make in
                //make.centerY.equalToSuperview()
                make.top.equalToSuperview().offset(topMargin)
                make.left.equalToSuperview().offset(padding)
                make.width.equalTo(btnWidth)
                make.height.equalTo(btnHeight)
            }
        } else {
            self.likeBtn.visibility = .invisible
        }
        
        if (isShowCancelBtn) {
            padding = padding * CGFloat(bottom_button_count) + btnWidth * CGFloat(bottom_button_count-1)
            self.cancelBtn.snp.remakeConstraints { make in
                //make.centerY.equalToSuperview()
                make.top.equalToSuperview().offset(topMargin)
                make.left.equalToSuperview().offset(padding)
                make.width.equalTo(btnWidth)
                make.height.equalTo(btnHeight)
            }
        } else {
            self.cancelBtn.visibility = .invisible
        }
    }
    
    @objc func submit() {
        self.delegate?.submit()
    }
    
    @objc func like() {
        self.delegate?.like()
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
    
    func initLike(isLike: Bool, count: Int) {
        self.isLike = isLike
        likeBtn.initStatus(isLike, count)
    }
    
    func setLike(_ isLike: Bool) {
        self.isLike = isLike
        likeBtn.setLike(isLike)
    }
    
    func setSubmitBtnTitle(_ title: String) {
        self.submitBtn.setTitle(title)
    }
    
//    func setSubmitBtnVisible(_ isVisible: Bool) {
//
//        self.submitBtn.visibility = (isVisible) ? .visible : .invisible
//        self.bottom_button_count = (isVisible) ? self.bottom_button_count+1 : self.bottom_button_count-1
//        var padding: CGFloat = setBottomButtonPadding()
//
//        self.submitBtn.snp.remakeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.left.equalToSuperview().offset(padding)
//            make.width.equalTo(btnWidth)
//            make.height.equalTo(btnHeight)
//        }
//
//        padding = padding*2 + btnWidth
//        self.likeBtn.snp.remakeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.left.equalToSuperview().offset(padding)
//            make.width.equalTo(btnWidth)
//            make.height.equalTo(btnHeight)
//        }
//    }
}
