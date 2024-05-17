//
//  read_arena.swift
//  bm
//
//  Created by ives on 2024/5/17.
//  Copyright © 2024 bm. All rights reserved.
//

import UIKit

class read_arena: UITableViewCell {
    
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
        backgroundColor = UIColor(PrimaryBlock_950)
        anchor()
    }
    
    private func anchor() {
        let container: UIView = {
            let view: UIView = UIView()
            view.backgroundColor = UIColor(gray_900)
            return view
        }()
        self.addSubview(container)
        container.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(12)
            make.right.bottom.equalToSuperview().offset(-12)
        }
        
    }

    

}
