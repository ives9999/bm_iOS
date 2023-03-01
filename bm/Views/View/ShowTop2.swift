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
        view.font = UIFont(name: FONT_BOLD_NAME, size: 16)
        view.setTextColor(UIColor(MY_WHITE))
        
        return view
    }()
    
    let prevBtn: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "prev_svg"), for: .normal)
        
        return view
    }()
    
    let refreshIcon: IconView2 = {
        let view = IconView2(icon: "refresh_svg")
        
        return view
    }()
    
    let addIconText: IconText2 = IconText2(icon: "add_svg", text: "新增")
    
    required init() {
        super.init(frame: CGRect.zero)
        setupView()
    }
    
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
        //backgroundColor = UIColor.gray
        self.addSubview(titleLbl)
        self.addSubview(prevBtn)
        
        prevBtn.addTarget(self, action: #selector(prev), for: .touchUpInside)
        
        let refreshGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(refresh))
        refreshIcon.addGestureRecognizer(refreshGR)
    }
    
    func anchor(parent: UIView) {
        
        let keyWindow = UIApplication.shared.connectedScenes.map({$0 as? UIWindowScene}).compactMap({$0}).first?.windows.first
        let statusBarHeight = keyWindow?.windowScene?.statusBarManager?.statusBarFrame.size.height ?? 0
        
        
        parent.addSubview(self)
        self.snp.makeConstraints { make in
            make.top.equalTo(parent).offset(statusBarHeight)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(30)
        }
        
        self.titleLbl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(60)
            make.centerY.equalToSuperview()
            //make.centerX.equalToSuperview()
        }
        
        self.prevBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            //make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview()
            make.width.height.equalTo(24)
        }
    }
    
    func showRefresh() {
        self.addSubview(refreshIcon)
        self.refreshIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.width.height.equalTo(20)
        }
    }
    
    func showAdd(rightAnchor: IconView2? = nil) {
        addIconText.delegate = self
        self.addSubview(addIconText)
        self.addIconText.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            if (rightAnchor != nil) {
                make.right.equalTo(rightAnchor!.snp.left).offset(-12)
            } else {
                make.right.equalToSuperview().offset(-12)
            }
        }
    }
    
    func setTitle(title: String) {
        titleLbl.text = title
    }
    
    @objc func prev() {
        self.delegate?.prev()
    }
    
    @objc func refresh() {
        self.delegate?.refresh()
    }
}

extension ShowTop2: IconText2Delegate {
    
    func pressed(icon: String) {
        if icon == "add_svg" {
            self.delegate?.addPressed()
        }
    }
}
