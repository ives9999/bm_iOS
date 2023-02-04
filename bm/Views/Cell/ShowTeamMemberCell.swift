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
        view.setTextGeneral()
        
        return view
    }()
    
    let leaveLbl: SuperLabel = {
        let view = SuperLabel()
        view.setTextGeneral()
        view.setTextColor(UIColor(MY_RED))
        view.text = "請假"
        
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
        
        self.contentView.backgroundColor = UIColor.gray
        
        self.contentView.addSubview(noLbl)
        noLbl.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        self.contentView.addSubview(avatarIV)
        avatarIV.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(noLbl.snp.right).offset(12)
            make.width.height.equalTo(48)
            make.centerY.equalToSuperview()
            make.bottom.equalToSuperview().offset(-24)
        }
        
        self.contentView.addSubview(dataContainer)
        dataContainer.backgroundColor = UIColor.blue
        dataContainer.snp.makeConstraints { make in
            make.left.equalTo(avatarIV.snp.right).offset(18)
            make.top.equalToSuperview().offset(3)
            make.centerY.equalToSuperview()
        }
        
        self.dataContainer.addSubview(nameLbl)
        nameLbl.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            //make.centerY.equalToSuperview()
        }
        
        self.contentView.addSubview(leaveLbl)
        leaveLbl.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
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
        self.noLbl.text = "\(no)."
        
        let f = row.memberTable!.featured_path
        self.avatarIV.downloaded(from: f)
        
        
        var nickname: String = ""
        if (row.memberTable != nil) {
            nickname = row.memberTable!.nickname
        }
        self.nameLbl.text = nickname
        
        self.leaveLbl.visibility = (row.isLeave) ? .visible : .invisible
        if self.leaveLbl.visibility == .visible {
            self.leaveLbl.text = "請假(\(row.leaveTime.noSec()))"
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
