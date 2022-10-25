//
//  BaseScrollerView.swift
//  bm
//
//  Created by ives on 2022/10/24.
//  Copyright © 2022 bm. All rights reserved.
//

import Foundation

class BaseScrollView: UIScrollView {
    
    let contentView: UIView = {
        
        let view: UIView = UIView()
        view.backgroundColor = UIColor.red
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = UIColor.brown
        self.addSubview(contentView)
    }
    
    func setAnchor(parent: UIView) {
        
        self.contentView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }
    }
}
