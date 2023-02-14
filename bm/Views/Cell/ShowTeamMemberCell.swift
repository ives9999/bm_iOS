//
//  ShowSignupCell.swift
//  bm
//
//  Created by ives on 2022/10/26.
//  Copyright © 2022 bm. All rights reserved.
//

import UIKit

protocol ShowTeamMemberCellDelegate {
    func leavePressed(cell: ShowTeamMemberCell)
}

class ShowTeamMemberCell: UITableViewCell {
    
    var delegate: ShowTeamMemberCellDelegate?
    
    let noLbl: SuperLabel = {
        let view = SuperLabel()
        view.setTextGeneral()
        return view
    }()
    
    let avatarIV: Avatar = {
        let view = Avatar()
        return view
    }()
    
    let dataContainer: UIView = UIView()
    
    let nameLbl: SuperLabel = {
        let view = SuperLabel()
        return view
    }()
    
    let createdAtLbl: SuperLabel = {
        let view = SuperLabel()
        view.textColor = UIColor(hex: "#ffffff", alpha: 0.6)
        view.setTextSize(12)
        return view
    }()
    
    let leaveLbl: SuperLabel = {
        //let view = UIPaddingLabel(withInsets: 3, 3, 10, 10)
        let view: SuperLabel = SuperLabel()
        view.padding = UIEdgeInsets(top: 3, left: 15, bottom: 3, right: 15)
        view.corner(4)
        view.textColor = UIColor(LEAVE_TEXT)
        view.text = "請假"
        view.font = UIFont(name: FONT_NAME, size: 12)
        view.textAlignment = .center
        view.backgroundColor = UIColor(hex: LEAVE_TEXT, alpha: 0.2)
        
        return view
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#FFFFFF", alpha: 0.2)
        return view
    }()
    
//    let leaveBtn: CityButton = {
//        let view = CityButton()
//        view.setTitle("請假")
//
//        return view
//    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView() {
        backgroundColor = UIColor(MY_BLACK)
        setAnchor()
    }
    
    func setAnchor() {
        
        self.contentView.addSubview(noLbl)
        noLbl.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        self.contentView.addSubview(avatarIV)
        avatarIV.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalTo(noLbl.snp.right).offset(12)
            make.width.height.equalTo(48)
            make.centerY.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12)
        }
        
        self.contentView.addSubview(dataContainer)
        //dataContainer.backgroundColor = UIColor.blue
        dataContainer.snp.makeConstraints { make in
            make.left.equalTo(avatarIV.snp.right).offset(18)
            make.top.equalToSuperview().offset(3)
            make.centerY.equalToSuperview()
        }
        
        self.dataContainer.addSubview(nameLbl)
        nameLbl.snp.makeConstraints { make in
            make.top.equalTo(avatarIV.snp.top).offset(4)
            make.left.equalToSuperview()
        }
        
        self.dataContainer.addSubview(createdAtLbl)
        createdAtLbl.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.bottom.equalTo(avatarIV.snp.bottom).offset(-4)
        }
        
        self.contentView.addSubview(leaveLbl)
        leaveLbl.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
        
        self.contentView.addSubview(separator)
        separator.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
//        self.contentView.addSubview(leaveBtn)
//        leaveBtn.snp.makeConstraints { make in
//            make.right.equalToSuperview().offset(-12)
//            make.centerY.equalToSuperview()
//        }
//
//        leaveBtn.addTarget(self, action: #selector(leavePressed), for: .touchDown)
    }
    
    func update(row: TeamMemberTable, no: Int) {
//        if no == 1 {
//            self.contentView.backgroundColor = UIColor.gray
//        }
        self.noLbl.text = "\(no)."
        
        self.avatarIV.path(row.memberTable!.featured_path)
        
        var nickname: String = ""
        if (row.memberTable != nil) {
            nickname = row.memberTable!.nickname
        }
        self.nameLbl.text = nickname
        self.createdAtLbl.text = row.created_at.noSec()
        
        self.leaveLbl.visibility = (row.isLeave) ? .visible : .invisible
        if self.leaveLbl.visibility == .visible {
            self.leaveLbl.text = "請假\n\(row.leaveTime.noSec().noYear())"
        }
    }
    
    override func layoutSubviews() {
        self.avatarIV.makeRounded()
    }
    
//    @objc func leavePressed(view: UIButton) {
//
//        delegate?.leavePressed(cell: self)
//    }
}
