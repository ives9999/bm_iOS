//
//  SignupListCell.swift
//  bm
//
//  Created by ives on 2019/10/1.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit

class SignupListCell: SuperCell {
    
    @IBOutlet weak var noLbl: SuperLabel!
    @IBOutlet weak var signuperLbl: SuperLabel!
    @IBOutlet weak var signupTimeLbl: SuperLabel!
    @IBOutlet weak var courseDateLbl: SuperLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(no: String, signuper: String, signupTime: String, courseDate: String) {
        noLbl.text = no
        signuperLbl.text = signuper
        signupTimeLbl.text = signupTime
        courseDateLbl.text = courseDate
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
