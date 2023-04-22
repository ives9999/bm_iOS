//
//  ShowTab2.swift
//  bm
//
//  Created by ives on 2023/2/11.
//  Copyright © 2023 bm. All rights reserved.
//

import UIKit

class ShowTab2: UIView {
    
    //外圍框線的寬度
    let borderWidth: CGFloat = 0
    
    //框線的透明度，做出ui的效果
    let borderAlpha: CGFloat = 0.8
    
    //圓角的大小值
    let cornerRadius: CGFloat = 20
    
    //螢幕寬度，有了螢幕寬度才能計算出每個tab的寬度
    var screenWidth: CGFloat = 0
    
    //跟螢幕邊界的間隔值
    let margin: CGFloat = 20
    
    //代理人，按下每一個tab時，要接收事件的代理人
    var delegate: ShowTab2Delegate?
    
    //存放所有tab view的陣列
    var views: [UIView] = [UIView]()
    
    //記錄目前按下的事那一個tab
    var onIdx: Int = 0
    
    //宣告三個tab
    var view1: UIView = {
        let view: UIView = UIView()
        view.tag = 0
        view.layer.cornerRadius = 14
        //view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
        return view
    }()
    
    var view2: UIView = {
        let view: UIView = UIView()
        view.tag = 1
        view.layer.cornerRadius = 14
    
        return view
    }()
    
    var view3: UIView = {
        let view: UIView = UIView()
        view.tag = 2
        view.layer.cornerRadius = 14
        //view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        
        return view
    }()
    
    //三個tab內的文字
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
        
        //設定外框的參數
        //self.layer.borderWidth = borderWidth
        //self.layer.borderColor = UIColor(MY_WHITE).withAlphaComponent(borderAlpha).cgColor
        self.backgroundColor = UIColor(hex: MY_WHITE, alpha: 0.2)
        self.layer.cornerRadius = cornerRadius
        
        views.append(contentsOf: [view1, view2, view3])
        
        self.screenWidth = UIScreen.main.bounds.width
        
        //設定定位
        self.anchor()
        
        //預設顯示的tab是第一個
        self.on(view1)
        
        //設定每一個tab要執行按下的函數
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(pressed))
        view1.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(pressed))
        view2.addGestureRecognizer(tap2)
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(pressed))
        view3.addGestureRecognizer(tap3)
    }
    
    func anchor() {
        
        //計算取得每一個tab的寬度
        let w: CGFloat = ((screenWidth - margin*2) / 3).rounded()
        let h: CGFloat = 32
        
        self.addSubview(view1)
        view1.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(-4)
            make.left.equalToSuperview().offset(borderWidth)
            make.width.equalTo(w)
            //make.height.equalTo(h)
            //make.centerY.equalToSuperview()
        }
        
        self.addSubview(view2)
        view2.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(-4)
            make.left.equalTo(view1.snp.right)
            make.width.equalTo(w)
        }
        
        self.addSubview(view3)
        view3.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(-4)
            make.left.equalTo(view2.snp.right)
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
    
    //tab被點選時外觀的變化
    func on(_ view: UIView) {
        view.backgroundColor = UIColor(MY_GREEN)
        if let label: SuperLabel = view.subviews[0] as? SuperLabel {
            label.setTextColor(UIColor(MY_BLACK))
        }
    }
    
    //tab失去被點選時外觀的變化
    func off(_ view: UIView) {
        view.backgroundColor = UIColor.clear
        if let label: SuperLabel = view.subviews[0] as? SuperLabel {
            label.setTextColor(UIColor(MY_WHITE))
        }
    }
    
    func tab1Name(_ name: String) {
        label1.text = name
    }
    
    func tab2Name(_ name: String) {
        label2.text = name
    }
    
    func tab3Name(_ name: String) {
        label3.text = name
    }
    
    //tab被點選時要執行的動作
    @objc func pressed(_ sender: UITapGestureRecognizer) {
        
        //要判斷按下的是否為目前已經被按下的tab，如果是的話就不執行任何動作，要不同的tab才會動作
        
        //先記錄舊的tab的索引值
        let oldIdx: Int = onIdx
        if let view: UIView = sender.view {
            onIdx = view.tag
            
            //如果是不同的tab才執行動作
            if (onIdx != oldIdx) {
                for _view in views {
                    (_view == view) ? self.on(_view) : self.off(_view)
                }
                
                delegate?.tabPressed(view.tag)
            }
        }
    }
}

//代理者的protocol
protocol ShowTab2Delegate {
    func tabPressed(_ idx: Int)
}
