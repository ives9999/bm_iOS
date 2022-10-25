//
//  ShowTop2.swift
//  bm
//
//  Created by ives on 2022/10/24.
//  Copyright © 2022 bm. All rights reserved.
//

import Foundation

class ShowTop2: UIView {
    
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
    }
    
}
