//
//  OneLineCell2.swift
//  bm
//
//  Created by ives on 2023/6/14.
//  Copyright © 2023 bm. All rights reserved.
//

import UIKit

class OneLineCell2: UITableViewCell {
    
    var contentIT: IconTextText2 = {
        let view: IconTextText2 = IconTextText2(icon: "", title: "", show: "", iconWidth: 24, iconHeight: 24)
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    func commonInit() {
        self.contentView.backgroundColor = UIColor(MY_BLACK)
        anchor()
    }
    
    func anchor() {
        self.contentView.addSubview(contentIT)
        //contentIT.backgroundColor = UIColor.red
        contentIT.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().offset(6)
            make.bottom.equalToSuperview().offset(-6)
        }
    }

    func update(icon: String, title: String, show: String) {
        contentIT.setIcon(icon)
        contentIT.setTitle(title)
        contentIT.setShow(show)
    }
}
