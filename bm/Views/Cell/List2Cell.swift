//
//  List2Cell.swift
//  bm
//
//  Created by ives sun on 2021/4/16.
//  Copyright © 2021 bm. All rights reserved.
//

import UIKit

protocol List1CellDelegate {
    //func searchCity(indexPath: IndexPath)
    func cellShowMap(row: Table)
    func cellTel(row: Table)
    func cellMobile(row: Table)
    func cellRefresh()
    func cellEdit(row: Table)
    func cellDelete(row: Table)
    func cellCity(row: Table)
    func cellLike(row: Table)
}

class List2Cell: UITableViewCell {
    
    @IBOutlet weak var listFeatured: UIImageView!
    @IBOutlet weak var titleLbl: SuperLabel!
    @IBOutlet weak var cityBtn: CityButton!
    
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
    
    var table: Table?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateViews(_ _row: Table) {
        
        _updateViews(_row)
        
        if _row.name.count > 0 {
            titleLbl.text = _row.name
        } else if _row.title.count > 0 {
            titleLbl.text = _row.title
        }
        
        if _row.city_show.count > 0 {
            cityBtn.setTitle(_row.city_show)
        } else {
            cityBtn.isHidden = true
        }
        
        
        refreshIcon.row = _row
        if mobileIcon != nil {
            mobileIcon.row = _row
        }
        if mapIcon != nil {
            mapIcon.row = _row
        }
        if cityBtn != nil {
            cityBtn.row = _row
        }
        likeIcon.row = _row
    }
    
    func _updateViews(_ row: Table) {
        
        self.backgroundColor = UIColor.clear
        
        if row.featured_path.count > 0 {
            
            //print(row.featured_path)
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
    
    @IBAction func refreshBtnPressed(sender: UIButton) {
        let _sender = sender as! SuperButton
        if _sender.row != nil {
            //row = _sender.row as! T
            if cellDelegate != nil {
                cellDelegate!.cellRefresh()
            }
        }
//        self._pressed(sender: sender) { indexPath in
//            if cellDelegate != nil {
//                cellDelegate!.cellRefresh(row: row)
//            }
//        }
    }
    
    @IBAction func cityBtnPressed(sender: UIButton) {
        self._pressed(sender: sender) { (row) in
            if cellDelegate != nil {
                cellDelegate!.cellCity(row: row)
            }
        }
    }
    
    @IBAction func mapBtnPressed(sender: UIButton) {
        self._pressed(sender: sender) { row in
            if cellDelegate != nil {
                cellDelegate!.cellShowMap(row: row)
            }
        }
    }
    
    @IBAction func telBtnPressed(sender: UIButton) {
        self._pressed(sender: sender) { row in
            if cellDelegate != nil {
                cellDelegate!.cellTel(row: row)
            }
        }
    }
    
    @IBAction func mobileBtnPressed(sender: UIButton) {
        
        self._pressed(sender: sender) { row in
            if cellDelegate != nil {
                cellDelegate!.cellMobile(row: row)
            }
        }
    }
    
    @IBAction func likeBtnPressed(sender: UIButton) {
        
        self._pressed(sender: sender) { row in
            if cellDelegate != nil {
                cellDelegate!.cellLike(row: row)
            }
        }
    }
    
    private func _pressed(sender: UIButton, method: (Table)-> Void) {
        
        let _sender = sender as! SuperButton
        var row: Table?
        if _sender.row != nil {
            row = _sender.row
            method(row!)
        }
    }
}


extension List1CellDelegate {
    func cellShowMap(row: Table){}
    func cellTel(row: Table){}
    func cellMobile(row: Table){}
    func cellRefresh(){}
    func cellEdit(row: Table){}
    func cellDelete(row: Table){}
    func cellCity(row: Table){}
    func cellLike(row: Table){}
}

