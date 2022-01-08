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
    
    @IBOutlet weak var cityBtn: CityButton!
    @IBOutlet weak var areaBtn: CityButton!
    @IBOutlet weak var arenaBtn: CityButton!
    
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var mapIcon: SuperButton!
    @IBOutlet weak var mobileIcon: SuperButton!
    @IBOutlet weak var refreshIcon: SuperButton!
    @IBOutlet weak var likeIcon: LikeIcon!
    
    @IBOutlet weak var iconViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapConstraint: NSLayoutConstraint!
    @IBOutlet weak var mobileConstraint: NSLayoutConstraint!
    @IBOutlet weak var likeConstraint: NSLayoutConstraint!
    
    var icons: [[String: Any]] = [[String: Any]]()
    let iconWidth: CGFloat = 36
    let iconMargin: CGFloat = 16
    var featured_h: CGFloat = 0
    
    var cellDelegate: List2CellDelegate?
    
    var table: Table?
    
    //var isLike: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLbl.setTextTitle()
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(CELL_SELECTED)
        selectedBackgroundView = bgColorView
        
        if (likeIcon != nil) {
            let likeImg = UIImage(named: "like")
            likeIcon.setBackgroundImage(likeImg, for: .normal)
        }
    }
    
    func _updateViews(_ row: Table) {
        
        self.backgroundColor = UIColor.clear
        
        if row.featured_path.count > 0 {
            
            //print(row.featured_path)
            featured_h = listFeatured.heightForUrl(url: row.featured_path, width: 90)
            listFeatured.downloaded(from: row.featured_path)
        }
    }

    
    func updateViews(_ _row: Table) {
        
        _updateViews(_row)
        
        if _row.name.count > 0 {
            titleLbl.text = _row.name
        } else if _row.title.count > 0 {
            titleLbl.text = _row.title
        }
        
        if cityBtn != nil {
            if _row.city_show.count > 0 {
                cityBtn.setTitle(_row.city_show)
                cityBtn.isHidden = false
            } else {
                cityBtn.isHidden = true
            }
        }
        
//        if (_row.mobile_show.count == 0 && _row.tel_show.count == 0) {
//            hiddenIcon(mobileIcon)
//        } else {
//            mobileIcon.isHidden = false
//        }
        
        if (likeIcon != nil) {
            likeIcon.isLike = !_row.like
            likeIcon.setLike()
        }
        
        if refreshIcon != nil {
            refreshIcon.row = _row
        }
        
        if mobileIcon != nil {
            mobileIcon.row = _row
        }
        
        if mapIcon != nil {
            mapIcon.row = _row
        }
        
        if cityBtn != nil {
            cityBtn.row = _row
        }
        
        if areaBtn != nil {
            areaBtn.row = _row
        }
        
        if arenaBtn != nil {
            arenaBtn.row = _row
        }
        
        if (likeIcon != nil) {
            likeIcon.row = _row
        }
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
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        //print(contentView.frame.height)
//        let cellH = contentView.frame.height
//
//        if featured_h > 0 {
//            // 16 is margin*2
//            //print(listFeatured.image!.size)
//            let featured_margin_h: CGFloat = (cellH - iconWidth - 16 - featured_h) / 2
//            featuredHConstraint.constant = featured_margin_h
//        }
//    }
    
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
    
    //if page is arena list, arena press is this
    @IBAction func areaBtnPressed(sender: UIButton) {
        self._pressed(sender: sender) { (row) in
            if cellDelegate != nil {
                cellDelegate!.cellArea(row: row)
            }
        }
    }
    
    @IBAction func arenaBtnPressed(sender: UIButton) {
        self._pressed(sender: sender) { (row) in
            if cellDelegate != nil {
                cellDelegate!.cellArena(row: row)
            }
        }
    }
    
    @IBAction func mapBtnPressed(sender: UIButton) {
        self._pressed(sender: sender) { row in
            if cellDelegate != nil {
                cellDelegate!.cellMap(row: row)
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
            
            if (Member.instance.isLoggedIn) {
                likeIcon.setLike()
                if cellDelegate != nil {
                    cellDelegate!.cellLike(row: row)
                }
            } else {
                //warning
                if cellDelegate != nil {
                    cellDelegate!.cellToLogin()
                }
            }
        }
    }
    
    @IBAction func editBtnPressed(sender: UIButton) {
        self._pressed(sender: sender) { (row) in
            if cellDelegate != nil {
                cellDelegate!.cellEdit(row: row)
            }
        }
    }
    
    @IBAction func deleteBtnPressed(sender: UIButton) {
        self._pressed(sender: sender) { (row) in
            if cellDelegate != nil {
                cellDelegate!.cellDelete(row: row)
            }
        }
    }
    
    func _pressed(sender: UIButton, method: (Table)-> Void) {
        
        let _sender = sender as! SuperButton
        var row: Table?
        if _sender.row != nil {
            row = _sender.row
            method(row!)
        }
    }
}

protocol List2CellDelegate {
    //func searchCity(indexPath: IndexPath)
    func cellMap(row: Table)
    func cellTel(row: Table)
    func cellMobile(row: Table)
    func cellRefresh()
    func cellEdit(row: Table)
    func cellDelete(row: Table)
    func cellCity(row: Table)
    func cellArea(row: Table)
    func cellArena(row: Table)
    func cellLike(row: Table)
    func cellWarning(msg: String)
    func cellToLogin()
    func cellSignup(row: Table)
    
    func cellSexChanged(key: String, sectionIdx: Int, rowIdx: Int, sex: String)
    func cellTextChanged(sectionIdx: Int, rowIdx: Int, str: String)
    func cellPrivacyChanged(sectionIdx: Int, rowIdx: Int, checked: Bool)
    
    func cellSetTag(sectionIdx: Int, rowIdx: Int, value: String, isChecked: Bool)
    func cellNumberChanged(sectionIdx: Int, rowIdx: Int, number: Int)
    func cellRadioChanged(key: String, sectionIdx: Int, rowIdx: Int, isChecked: Bool)
    func cellSwitchChanged(key: String, sectionIdx: Int, rowIdx: Int, isSwitch: Bool)
    func cellClear(sectionIdx: Int, rowIdx: Int)
    func cellPrompt(sectionIdx: Int, rowIdx: Int)
}

//extension List2CellDelegate {
//    func cellMap(row: Table){}
//    func cellTel(row: Table){}
//    func cellMobile(row: Table){}
//    func cellRefresh(){}
//    func cellEdit(row: Table){}
//    func cellDelete(row: Table){}
//   func cellCity(row: Table){}
//    func cellArea(row: Table){}
//    func cellArena(row: Table){}
//    func cellLike(row: Table){}
//    func cellWarning(msg: String){}
//    func cellToLogin(){}
    
//    func cellSexChanged(key: String, sectionIdx: Int, rowIdx: Int, sex: String) {}
//    func cellTextChanged(sectionIdx: Int, rowIdx: Int, str: String) {}
//    func cellPrivacyChanged(sectionIdx: Int, rowIdx: Int, checked: Bool) {}
//}

