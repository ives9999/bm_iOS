//
//  TeamTempPlayCell.swift
//  bm
//
//  Created by ives on 2017/12/1.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class TeamTempPlayCell: SuperCell {
    
    var generalTextField: SuperTextField!
    var iden: String = ""
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.value1, reuseIdentifier: reuseIdentifier)
        
        generalTextField = SuperTextField(frame: CGRect.zero)
        contentView.addSubview(generalTextField)
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let yPadding: CGFloat = 5
        let txtWidth: CGFloat = 250
        let txtHeight: CGFloat = bounds.height - 8
        let x = bounds.width - txtWidth
        let fullTextFieldFrame: CGRect = CGRect(x: x, y: yPadding, width: txtWidth, height: txtHeight)
        generalTextField.frame = fullTextFieldFrame
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
