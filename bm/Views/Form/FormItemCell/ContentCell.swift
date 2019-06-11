//
//  ContentCell.swift
//  bm
//
//  Created by ives on 2019/6/9.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit

class ContentCell: SuperCell, FormUPdatable {

    @IBOutlet weak var titleLbl: SuperLabel!
    @IBOutlet weak var detailLbl: SuperLabel!
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var promptBtn: UIButton!
    var formItem: FormItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLbl.textAlignment = NSTextAlignment.left
        detailLbl.textAlignment = NSTextAlignment.left
        detailLbl.text = ""
        clearBtn.isHidden = true
        //detailLbl.backgroundColor = UIColor.blue
        detailLbl.numberOfLines = 0
        detailLbl.lineBreakMode = .byWordWrapping
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
                
                detailLbl.sizeToFit()
            }
        }
        promptBtn.isHidden = (formItem.tooltip == nil) ? true : false
    }
    
}
