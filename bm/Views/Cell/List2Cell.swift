//
//  List2Cell.swift
//  bm
//
//  Created by ives sun on 2021/4/16.
//  Copyright © 2021 bm. All rights reserved.
//

import UIKit

class List2Cell: UITableViewCell {
    
    @IBOutlet weak var listFeatured: UIImageView!
    @IBOutlet weak var titleLbl: SuperLabel!
    
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var mapIcon: SuperButton!
    @IBOutlet weak var mobileIcon: SuperButton!
    @IBOutlet weak var refreshIcon: SuperButton!
    @IBOutlet weak var likeIcon: SuperButton!
    
    @IBOutlet weak var mapConstraint: NSLayoutConstraint!
    @IBOutlet weak var mobileConstraint: NSLayoutConstraint!
    @IBOutlet weak var likeConstraint: NSLayoutConstraint!
    
    var icons: [[String: Any]] = [[String: Any]]()
    let iconWidth: CGFloat = 36
    let iconMargin: CGFloat = 16
    var featured_h: CGFloat = 0
    
    var cellDelegate: List1CellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func _updateViews<T: Table>(indexPath: IndexPath, row: T) {
        
        self.backgroundColor = UIColor.clear
        
        if row.featured_path.count > 0 {
            
            featured_h = listFeatured.heightForUrl(url: row.featured_path, width: 90)
            listFeatured.downloaded(from: row.featured_path)
        }
        
        let chevron = UIImage(named: "greater1")
        self.accessoryType = .disclosureIndicator
        self.accessoryView = UIImageView(image: chevron!)
    }
    
    func hiddenIcon(_ icon: SuperButton) {
        
        for (idx, _icon) in icons.enumerated() {
            if _icon["icon"] as! SuperButton == icon {
                icons.remove(at: idx)
            }
        }
        for (idx, _) in icons.enumerated() {
            let w: CGFloat = CGFloat(idx+1) * iconMargin + CGFloat(idx) * iconWidth
            icons[idx]["constant"] = w
            let constraint: NSLayoutConstraint = icons[idx]["constraint"] as! NSLayoutConstraint
            constraint.constant = w
        }
        icon.visibility = .gone
    }
    
    private func _pressed(sender: UIButton, method: (IndexPath?)-> Void) {
        
        let _sender = sender as! SuperButton
        var indexPath: IndexPath?
        if _sender.indexPath != nil {
            indexPath = _sender.indexPath!
        }
        method(indexPath)
    }
    
    @IBAction func refreshBtnPressed(sender: UIButton) {
        self._pressed(sender: sender) { indexPath in
            if cellDelegate != nil {
                cellDelegate!.cellRefresh(indexPath: indexPath)
            }
        }
    }
    
    @IBAction func cityBtnPressed(sender: UIButton) {
        let _sender = sender as! SuperButton
        var indexPath: IndexPath?
        if _sender.indexPath != nil {
            indexPath = _sender.indexPath!
            if cellDelegate != nil {
                cellDelegate!.cellCity(indexPath: indexPath)
            }
        }
    }
    
    @IBAction func mapBtnPressed(sender: UIButton) {
        self._pressed(sender: sender) { indexPath in
            if cellDelegate != nil {
                cellDelegate!.cellShowMap(indexPath: indexPath)
            }
        }
    }
    
    @IBAction func telBtnPressed(sender: UIButton) {
        self._pressed(sender: sender) { indexPath in
            if cellDelegate != nil {
                cellDelegate!.cellTel(indexPath: indexPath)
            }
        }
    }
    
    @IBAction func mobileBtnPressed(sender: UIButton) {
        self._pressed(sender: sender) { indexPath in
            if cellDelegate != nil {
                cellDelegate!.cellMobile(indexPath: indexPath)
            }
        }
    }
    
    @IBAction func likeBtnPressed(sender: UIButton) {
        
        self._pressed(sender: sender) { indexPath in
            if cellDelegate != nil {
                cellDelegate!.cellLike(indexPath: indexPath)
            }
        }
    }
}
