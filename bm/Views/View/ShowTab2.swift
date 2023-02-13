//
//  ShowTab2.swift
//  bm
//
//  Created by ives on 2023/2/11.
//  Copyright © 2023 bm. All rights reserved.
//

import UIKit

class ShowTab2: UIView {
    
    let borderWidth: CGFloat = 1
    let borderAlpha: CGFloat = 0.8
    let cornerRadius: CGFloat = 8
    
    var screenWidth: CGFloat = 0
    let margin: CGFloat = 25
    
    var delegate: ShowTab2Delegate?
    
    var views: [UIView] = [UIView]()
    
    var onIdx: Int = 0
    
    var view1: UIView = {
        let view: UIView = UIView()
        //view.backgroundColor = UIColor(MY_GREEN)
        view.tag = 0
        view.layer.cornerRadius = 8
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        //view.isUserInteractionEnabled = true
        return view
    }()
    
    var view2: UIView = {
        let view: UIView = UIView()
        view.tag = 1
        //view.backgroundColor = UIColor.red
        //view.isUserInteractionEnabled = true
        return view
    }()
    
    var view3: UIView = {
        let view: UIView = UIView()
        view.tag = 2
        //view.backgroundColor = UIColor.blue
        view.layer.cornerRadius = 8
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        //view.isUserInteractionEnabled = true
        return view
    }()
    
    var label1: SuperLabel = {
        let view: SuperLabel = SuperLabel()
        view.text = "介紹"
        
        return view
    }()
    
    var label2: SuperLabel = {
        let view: SuperLabel = SuperLabel()
        view.text = "隊員"
        
        return view
    }()
    
    var label3: SuperLabel = {
        let view: SuperLabel = SuperLabel()
        view.text = "臨打"
        
        return view
    }()

    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = UIColor(MY_WHITE).withAlphaComponent(borderAlpha).cgColor
        self.layer.cornerRadius = cornerRadius
        
        views.append(contentsOf: [view1, view2, view3])
        
        self.screenWidth = UIScreen.main.bounds.width
        self.anchor()
        self.on(view1)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(pressed))
        view1.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(pressed))
        view2.addGestureRecognizer(tap2)
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(pressed))
        view3.addGestureRecognizer(tap3)
    }
    
    func anchor() {
        let w: CGFloat = (screenWidth - margin*2) / 3
        self.addSubview(view1)
        view1.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(borderWidth)
            make.bottom.equalToSuperview().offset(-1 * borderWidth)
            make.width.equalTo(w)
        }
        
        self.addSubview(view2)
        view2.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(borderWidth)
            make.left.equalTo(view1.snp.right)
            make.bottom.equalToSuperview().offset(-1 * borderWidth)
            make.width.equalTo(w)
        }
        
        self.addSubview(view3)
        view3.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(borderWidth)
            make.left.equalTo(view2.snp.right)
            make.bottom.equalToSuperview().offset(-1 * borderWidth)
            make.width.equalTo(w)
        }
        
        view1.addSubview(label1)
        label1.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        view2.addSubview(label2)
        label2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        view3.addSubview(label3)
        label3.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func on(_ view: UIView) {
        view.backgroundColor = UIColor(MY_GREEN)
        if let label: SuperLabel = view.subviews[0] as? SuperLabel {
            label.setTextColor(UIColor(MY_BLACK))
        }
    }
    
    func off(_ view: UIView) {
        view.backgroundColor = UIColor.clear
        if let label: SuperLabel = view.subviews[0] as? SuperLabel {
            label.setTextColor(UIColor(MY_WHITE))
        }
    }
    
    @objc func pressed(_ sender: UITapGestureRecognizer) {
        let oldIdx: Int = onIdx
        if let view: UIView = sender.view {
            onIdx = view.tag
            if (onIdx != oldIdx) {
                for _view in views {
                    (_view == view) ? self.on(_view) : self.off(_view)
                }
                
                delegate?.tabPressed(view.tag)
            }
        }
    }
}

protocol ShowTab2Delegate {
    func tabPressed(_ idx: Int)
}
