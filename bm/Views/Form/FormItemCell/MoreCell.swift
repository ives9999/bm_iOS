//
//  MoreCell.swift
//  bm
//
//  Created by ives on 2018/12/4.
//  Copyright © 2018 bm. All rights reserved.
//

import UIKit

class MoreCell: FormItemCell {
    
    @IBOutlet weak var detailLbl: SuperLabel!
    
    var sectionKey: String = ""
    var rowKey: String = ""
    var baseViewControllerDelegate: BaseViewController? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLbl?.textAlignment = .right
        detailLbl.textAlignment = NSTextAlignment.left
        detailLbl.textColor = UIColor(MY_GREEN)
        detailLbl.text = ""
        clearBtn.isHidden = false
    }
    
    @IBAction func clearBtnPressed(_ sender: Any) {
        clear()
    }
    
    @IBAction func promptBtnPressed(_ sender: Any) {
//        let alert = UIAlertController(title: "提示", message: (formItem?.tooltip)!, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "確定", style: .default, handler: { (action) in
//
//        }))
//        self.parentViewController?.present(alert, animated: true, completion: nil)
        cellDelegate?.cellPrompt(sectionIdx: sectionIdx, rowIdx: rowIdx)
    }
    
    func clear() {
        formItem?.reset()
        formItem?.value = nil
        formItem?.show = ""
        formItem?.sender = nil
        //clearBtn.isHidden = true
        detailLbl.text = "全部"
        if cellDelegate != nil {
            cellDelegate?.cellClear(sectionIdx: sectionIdx, rowIdx: rowIdx)
        }
    }
    
    func update(sectionKey: String, rowKey: String, title: String, value: String, show: String) {
        
        self.sectionKey = sectionKey
        self.rowKey = rowKey
        
        titleLbl!.text = title
        detailLbl.text = show
        
        promptBtn.isHidden = true
    }
    
//    func update(sectionIdx: Int, rowIdx: Int, row: OneRow) {
//
//        self.oneRow = row
//        self.sectionIdx = sectionIdx
//        self.rowIdx = rowIdx
//
//        titleLbl!.text = row.title
//        detailLbl.text = row.show
//
//        promptBtn.isHidden = true
//    }
    
    func update(sectionIdx: Int, rowIdx: Int, row: OneRow) {
        
        self.oneRow = row
        self.sectionIdx = sectionIdx
        self.rowIdx = rowIdx
        
        titleLbl!.text = row.title
        detailLbl.text = row.show
        
        requiredImageView.isHidden = !row.isRequired
        
        promptBtn.isHidden = (row.prompt.count > 0) ? false : true
        
        clearBtn.isHidden = !row.isClear
    }
    
    override func update(with formItem: FormItem) {
        self.formItem = formItem
        
        titleLbl!.text = self.formItem?.title
        detailLbl.text = self.formItem?.show
        if detailLbl.text != nil {
            if detailLbl.text!.count > 0 {
                clearBtn.isHidden = false
            }
        }
        
        promptBtn.isHidden = (formItem.tooltip == nil) ? true : false
        if requiredImageView != nil {
            requiredImageView.isHidden = !formItem.isRequired
        }
    }
}
