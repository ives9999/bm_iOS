//
//  MainBottom2.swift
//  bm
//
//  Created by ives on 2023/3/15.
//  Copyright © 2023 bm. All rights reserved.
//

import UIKit

class MainBottom2: UIView {
    
    var focusIdx: Int = 0
    var param: PARAMS = PARAMS.team
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillEqually
        
        return view
    }()
    
    let teamItem: Item = Item(PARAMS.team)
    let courseItem: Item = Item(PARAMS.course)
    let memberItem: Item = Item(PARAMS.member)
    let arenaItem: Item = Item(PARAMS.arena)
    let moreItem: Item = Item(PARAMS.more)
    
    var items: [Item] = [Item]()
    var delegate: MainBottom2Delegate?
    
    required init(able_type: String) {
        super.init(frame: CGRect.zero)
        let param: PARAMS = PARAMS.getParam(value: able_type)
        let idx: Int = param.paramToIdx()
        self.focusIdx = idx
        self.param = param
        setupView()
    }

    init(idx: Int) {
        super.init(frame: CGRect.zero)
        self.focusIdx = idx
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        
        self.backgroundColor = UIColor(BOTTOM_VIEW_BACKGROUND)
        
        self.addSubview(stackView)

        //stackView.backgroundColor = UIColor.blue
        stackView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalToSuperview()
        }
        
        items.append(contentsOf: [teamItem, courseItem, memberItem, arenaItem, moreItem])
        
        for (idx, item) in items.enumerated() {
            let containerView: UIView = UIView()
            containerView.tag = idx
            stackView.addArrangedSubview(containerView)
            
            let innerView: UIView = UIView()
            //innerView.backgroundColor = UIColor.red
            containerView.addSubview(innerView)
            innerView.snp.makeConstraints { make in
                make.centerY.centerX.equalToSuperview()
                make.width.equalTo(26)
                make.height.equalTo(43)
            }
            
            let iconIV: UIImageView = UIImageView()
            iconIV.image = UIImage(named: item.param.iconOff())
            
            let textLbl: SuperLabel = SuperLabel()
            textLbl.text = item.param.chineseText()
            textLbl.setTextSize(10)
            textLbl.textAlignment = .center
            
            innerView.addSubview(iconIV)
            iconIV.snp.makeConstraints { make in
                make.top.left.equalToSuperview()
                make.width.height.equalTo(24)
            }
            
            innerView.addSubview(textLbl)
            textLbl.snp.makeConstraints { make in
                make.bottom.left.equalToSuperview()
                make.width.equalTo(26)
                make.height.equalTo(12)
                make.centerX.equalToSuperview()
            }
            
            item.setIV(iconIV)
            item.setText(textLbl)
            
            let tgr: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pressed(_:)))
            containerView.addGestureRecognizer(tgr)
        }
        
        on(focusIdx)
    }
    
    private func on(_ idx: Int) {
        let item: Item = items[idx]
        item.on()
    }
    
    private func off(_ idx: Int) {
        let item: Item = items[idx]
        item.off()
    }
    
    private func toggle(_ idx: Int) {
        on(idx)
        for (i, _) in items.enumerated() {
            (i == idx) ? on(i) : off(i)
        }
    }
    
    @objc func pressed(_ sender: UITapGestureRecognizer) {
        guard let idx: Int = sender.view?.tag else { return }
        self.focusIdx = idx
        self.toggle(idx)
        
        let item: Item = items[idx]
        item.to(delegate: delegate)
    }
    
    class Item {
        
        var param: PARAMS
        
        var iconIV: UIImageView?
        var textLbl: SuperLabel?
        
        init(_ param: PARAMS) {
            self.param = param
        }
        
        init() {
            self.param = PARAMS.team
        }
        
        func on() {
            iconIV?.image = UIImage(named: param.iconOn())
            textLbl?.textColor = UIColor(MY_GREEN)
        }
        
        func off() {
            iconIV?.image = UIImage(named: param.iconOff())
            textLbl?.textColor = UIColor(MY_WHITE)
        }
        
        func setIV(_ iconIV: UIImageView) {
            self.iconIV = iconIV
        }
        
        func setText(_ textLbl: SuperLabel) {
            self.textLbl = textLbl
        }
        
        func to(delegate: MainBottom2Delegate?) {
            delegate?.to(able_type: self.param.rawValue)
        }
    }
    
    enum PARAMS: String {
        case team = "team"
        case course = "course"
        case member = "member"
        case arena = "arena"
        case more = "more"
        
        static let allValues: [PARAMS] = [team, course, member, arena, more]
        
//        func allValues()-> [PARAMS] {
//            return [.team, .course, .member, .arena, .more]
//        }
        
        static func getParam(value: String)-> PARAMS {
            switch value {
            case "team": return .team
            case "course": return .course
            case "member": return .member
            case "arena": return .arena
            case "more": return .more
            default: return .team
            }
        }
        
        func paramToIdx()-> Int {
            for (idx, item) in PARAMS.allValues.enumerated() {
                if item == self {
                    return idx
                }
            }
            
            return 0
        }
        
        func chineseText()-> String {
            switch self {
            case .team: return "球隊"
            case .course: return "課程"
            case .member: return "會員"
            case .arena: return "球館"
            case .more: return "更多"
            }
        }
        
        func iconOn()-> String {
            return "\(rawValue)_on_svg"
        }
        
        func iconOff()-> String {
            return "\(rawValue)_off_svg"
        }
    }
}

protocol MainBottom2Delegate {
    
    func to(able_type: String)
}


