//
//  read_arena.swift
//  bm
//
//  Created by ives on 2024/5/17.
//  Copyright © 2024 bm. All rights reserved.
//

import UIKit

class read_arena: UITableViewCell {
    
    let container: UIView = {
        let view: UIView = UIView()
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        view.backgroundColor = UIColor(PrimaryBlock_950)
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(gray_700).cgColor
        return view
    }()
    
    let memberContainer: UIView = {
        let view: UIView = UIView()
        //view.backgroundColor = UIColor.red
        return view
    }()
    
    let featruedIV: UIImageView = {
        let view: UIImageView = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 6
        view.clipsToBounds = true
        //view.backgroundColor = UIColor.yellow
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    let cityLbl: SuperLabel = {
        let view = SuperLabel()
        view.setTextColor(UIColor(bg_300))
        view.setTextSize(14)
        return view
    }()
    
    let pvLbl: SuperLabel = {
        let view = SuperLabel()
        view.setTextColor(UIColor(bg_300))
        view.setTextSize(14)
        return view
    }()
    
    let nameLbl: SuperLabel = {
        let view = SuperLabel()
        view.setTextSize(18)
        view.setTextBold()
        view.setTextColor(UIColor(Primary_300))
        
        return view
    }()
    
    let avatarIV: UIImageView = {
        let view: UIImageView = UIImageView()
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    let memberNameLbl: SuperLabel = {
        let view = SuperLabel()
        view.setTextSize(15)
        view.setTextColor(UIColor(bg_300))
        
        return view
    }()
    
    let createdLbl: SuperLabel = {
        let view = SuperLabel()
        view.setTextSize(15)
        view.setTextColor(UIColor(bg_300))
        
        return view
    }()
    
    let moreLbl: SuperLabel = {
        let view = SuperLabel()
        view.setTextSize(18)
        view.setTextColor(UIColor(bg_300))
        view.text = "更多..."
        view.isUserInteractionEnabled = true
        return view
    }()
    
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
        backgroundColor = UIColor(bg_950)
//        let imageGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toArenaShow))
//        featruedIV.addGestureRecognizer(imageGR)
        
        anchor()
    }
    
    private func anchor() {
        
        self.addSubview(container)
        container.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(4)
            make.right.equalToSuperview().offset(-4)
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        container.addSubview(featruedIV)
        featruedIV.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(12)
            //make.centerY.equalToSuperview()
            make.height.width.equalTo(90)
//            make.left.top.equalToSuperview().offset(8)
//            make.right.bottom.equalToSuperview().offset(-8)
        }
        
        container.addSubview(cityLbl)
        cityLbl.snp.makeConstraints { make in
            make.top.equalTo(featruedIV.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(12)
        }
        
        container.addSubview(pvLbl)
        pvLbl.snp.makeConstraints { make in
            make.centerY.equalTo(cityLbl.snp.centerY)
            make.right.equalToSuperview().offset(-12)
        }
        
        let pvIcon: UIImageView = {
            let view: UIImageView = UIImageView()
            view.image = UIImage(named: "member_svg")
            view.tintColor = UIColor(bg_300)
            return view
        }()
        
        container.addSubview(pvIcon)
        pvIcon.snp.makeConstraints { make in
            make.centerY.equalTo(cityLbl.snp.centerY)
            make.right.equalTo(pvLbl.snp.left)
            make.width.height.equalTo(16)
        }
        
        container.addSubview(nameLbl)
        nameLbl.snp.makeConstraints { make in
            make.top.equalTo(cityLbl.snp.bottom).offset(18)
            make.left.equalToSuperview().offset(12)
        }
        
        container.addSubview(memberContainer)
        memberContainer.snp.makeConstraints { make in
            make.top.equalTo(nameLbl.snp.bottom).offset(18)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        memberContainer.addSubview(avatarIV)
        avatarIV.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.width.height.equalTo(36)
            make.bottom.equalToSuperview()
        }
        
        memberContainer.addSubview(memberNameLbl)
        memberNameLbl.snp.makeConstraints { make in
            make.top.equalTo(avatarIV.snp.top)
            make.left.equalTo(avatarIV.snp.right).offset(6)
        }
        
        memberContainer.addSubview(createdLbl)
        createdLbl.snp.makeConstraints { make in
            make.bottom.equalTo(avatarIV.snp.bottom)
            make.left.equalTo(avatarIV.snp.right).offset(6)
        }
        
        memberContainer.addSubview(moreLbl)
        moreLbl.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalTo(avatarIV.snp.centerY)
        }
    }

    func update(row: ArenaReadDao.Arena, idx: Int) {
        var featured_path: String? = nil
        for image in row.images {
            if (image.isFeatured) {
                featured_path = image.path
                break
            }
        }
        
        if (featured_path != nil) {
            let width = UIScreen.main.bounds.width - 32
            let height = featruedIV.heightForUrl(url: featured_path!, width: width)
            featruedIV.snp.updateConstraints { make in
                make.width.equalTo(width)
                make.height.equalTo(height)
            }
            featruedIV.downloaded(from: featured_path!, isCircle: false)
        }
        cityLbl.text = row.zone.city_name
        pvLbl.text = row.pv.formattedWithSeparator
        
        nameLbl.text = "\(idx). \(row.name)"
        
        avatarIV.downloaded(from: row.member.avatar)
        memberNameLbl.text = row.member.nickname
        createdLbl.text = row.created_at.noSec()
        
        let moreGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toArenaShow))
        moreGR.cancelsTouchesInView = true
        moreLbl.addGestureRecognizer(moreGR)
    }

    @objc func toArenaShow() {
        print("press")
    }
}
