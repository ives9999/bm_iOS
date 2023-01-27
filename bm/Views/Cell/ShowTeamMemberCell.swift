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
        
        self.contentView.addSubview(noLbl)
        noLbl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
        
        self.contentView.addSubview(nameLbl)
        nameLbl.snp.makeConstraints { make in
            make.left.equalTo(noLbl.snp.right).offset(12)
            make.centerY.equalToSuperview()
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
    
//    @objc func leavePressed(view: UIButton) {
//
//        delegate?.leavePressed(cell: self)
//    }
}
