//
//  BaseScrollerView.swift
//  bm
//
//  Created by ives on 2022/10/24.
//  Copyright © 2022 bm. All rights reserved.
//

import Foundation
import SnapKit

class BaseScrollView: UIScrollView {
    
    var delegate1: BaseViewController?
    var parent: UIView?
    
    let stackContentView: UIStackView = {
        let view = UIStackView()
        //view.backgroundColor = UIColor.red
        view.axis = .vertical
        view.spacing = 0
        return view
    }()
    
//    let contentView: UIView = {
//
//        let view: UIView = UIView()
//        view.backgroundColor = UIColor.red
//        return view
//    }()
    
    init(parent: UIView, delegate: BaseViewController?) {
        super.init(frame: CGRect.zero)
        self.parent = parent
        parent.addSubview(self)
        setupView()
        
        self.delegate1 = delegate
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
        //backgroundColor = UIColor.brown
        //self.addSubview(contentView)
        self.addSubview(stackContentView)
        
        stackContentView.layer.cornerRadius = 26.0
        stackContentView.clipsToBounds = true
    }
    
    func setAnchor(top: ConstraintItem, bottom: ConstraintItem) {
        
        self.snp.makeConstraints { make in
            make.top.equalTo(top)
            make.right.left.equalToSuperview()
            make.bottom.equalTo(bottom)
        }
        
        self.stackContentView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    func setAnchor(top: ConstraintItem, right: UIView, bottom: ConstraintItem, left: UIView) {
        
        self.snp.makeConstraints { make in
            make.top.equalTo(top)
            make.right.equalTo(right)
            make.bottom.equalTo(bottom)
            make.left.equalTo(left)
        }
        
        self.stackContentView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
}
