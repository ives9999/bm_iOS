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
        //view.backgroundColor = UIColor.red
        return view
    }()
    
    let featruedIV: UIImageView = {
        let view: UIImageView = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        
        return view
    }()
    
    let nameLbl: SuperLabel = {
        let view = SuperLabel()
        view.setTextGeneral()
        
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
            make.left.right.equalToSuperview()
            make.centerY.centerX.equalToSuperview()
            make.height.width.equalTo(90)
//            make.left.top.equalToSuperview().offset(8)
//            make.right.bottom.equalToSuperview().offset(-8)
        }
        
        container.addSubview(nameLbl)
        nameLbl.snp.makeConstraints { make in
            make.top.equalTo(featruedIV.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-20)
        }
    }

    func update(row: ArenaReadDao.Arena) {
        var featured_path: String? = nil
        for image in row.images {
            if (image.isFeatured) {
                featured_path = image.path
                break
            }
        }
        
        if (featured_path != nil) {
            let width = self.frame.width - 8
            let height = featruedIV.heightForUrl(url: featured_path!, width: width)
            featruedIV.snp.updateConstraints { make in
                make.width.equalTo(width)
                make.height.equalTo(height)
            }
            featruedIV.downloaded(from: featured_path!, isCircle: false)
        }
        nameLbl.text = row.name
    }

}
