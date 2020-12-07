//
//  MoreCell.swift
//  bm
//
//  Created by ives on 2018/12/4.
//  Copyright © 2018 bm. All rights reserved.
//

import UIKit

class MoreCell: SuperCell, FormUPdatable {
    
    @IBOutlet weak var titleLbl: SuperLabel!
    @IBOutlet weak var detailLbl: SuperLabel!
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var promptBtn: UIButton!
    @IBOutlet weak var requiredImageView: UIImageView!
    var formItem: FormItem?

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLbl.textAlignment = NSTextAlignment.left
        detailLbl.textAlignment = NSTextAlignment.right
        detailLbl.text = ""
        clearBtn.isHidden = true
    }
    
    @IBAction func clearBtnPressed(_ sender: Any) {
        clear()
    }
    
    @IBAction func promptBtnPressed(_ sender: Any) {
        let alert = UIAlertController(title: "提示", message: (formItem?.tooltip)!, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確定", style: .default, handler: { (action) in
            
        }))
        self.parentViewController?.present(alert, animated: true, completion: nil)
    }
    
    func clear() {
        formItem?.reset()
        formItem?.value = nil
        formItem?.show = ""
        formItem?.sender = nil
        clearBtn.isHidden = true
        detailLbl.text = ""
    }
    
    func update(with formItem: FormItem) {
        self.formItem = formItem
        
        titleLbl.text = self.formItem?.title
        detailLbl.text = self.formItem?.show
        if detailLbl.text != nil {
            if detailLbl.text!.count > 0 {
                clearBtn.isHidden = false
            }
        }
        promptBtn.isHidden = (formItem.tooltip == nil) ? true : false
        requiredImageView.isHidden = !formItem.isRequired
    }
}
