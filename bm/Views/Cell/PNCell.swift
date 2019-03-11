//
//  PNCell.swift
//  bm
//
//  Created by ives on 2019/3/8.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit

protocol PNCellDelegate {
    func remove(id: String)
}

class PNCell: SuperCell {
    
    @IBOutlet var titleLbl: SuperLabel!
    @IBOutlet var titleHeightCons: NSLayoutConstraint!
    @IBOutlet var contentTV: UITextView!
    @IBOutlet var idLbl: UILabel!
    
    var thisDelegate: PNCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    func update(id: String, title: String?, content: String) {
        idLbl.text = id
        if title != nil && title!.count > 0 {
//            titleLbl.isHidden = false
            titleHeightCons.constant = 24
            //titleLbl.visibility = .visible
            titleLbl.text = title!
            layoutIfNeeded()
        } else {
            //titleLbl.text = ""
            //titleLbl.visibility = .gone
//            titleLbl.isHidden = true
            titleHeightCons.constant = 0
        }
        //print(content)
        contentTV.text = content
        contentTV.translatesAutoresizingMaskIntoConstraints = true
        contentTV.isScrollEnabled = false
        contentTV.sizeToFit()
    }

    @IBAction func clearBtnPressed(sender: UIButton) {
        thisDelegate?.remove(id: idLbl.text!)
    }
}
