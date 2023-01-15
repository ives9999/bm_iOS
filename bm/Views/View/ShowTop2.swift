//
//  ShowTop2.swift
//  bm
//
//  Created by ives on 2022/10/24.
//  Copyright © 2022 bm. All rights reserved.
//

import Foundation

class ShowTop2: UIView {
    
    var delegate: BaseViewController? = nil
    
    let titleLbl: SuperLabel = {
        let view = SuperLabel()
        view.setTextTitle()
        view.setTextColor(UIColor(MY_BLACK))
        
        return view
    }()
    
    let prevBtn: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "prev_black"), for: .normal)
        
        return view
    }()
    
    init(delegate: BaseViewController?) {
        super.init(frame: CGRect.zero)
        self.delegate = delegate
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = UIColor(MY_GREEN)
        self.addSubview(titleLbl)
        self.addSubview(prevBtn)
        
        prevBtn.addTarget(self, action: #selector(prev), for: .touchUpInside)
    }
    
    func setAnchor(parent: UIView) {
        
        let keyWindow = UIApplication.shared.connectedScenes.map({$0 as? UIWindowScene}).compactMap({$0}).first?.windows.first
        let statusBarHeight = keyWindow?.windowScene?.statusBarManager?.statusBarFrame.size.height ?? 0
        
        
        parent.addSubview(self)
        self.snp.makeConstraints { make in
            make.top.equalTo(parent).offset(statusBarHeight)
            make.left.right.equalToSuperview()
            make.height.equalTo(64)
        }
        
        self.titleLbl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        self.prevBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12)
        }
    }
    
    func setTitle(title: String) {
        titleLbl.text = title
    }
    
    @objc func prev() {
        self.delegate?.prev()
    }
}