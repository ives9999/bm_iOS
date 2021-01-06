//
//  List1Cell.swift
//  bm
//
//  Created by ives sun on 2020/11/9.
//  Copyright © 2020 bm. All rights reserved.
//

import UIKit

protocol List1CellDelegate {
    //func searchCity(indexPath: IndexPath)
    func cellShowMap(indexPath: IndexPath?)
    func cellTel(indexPath: IndexPath?)
    func cellMobile(indexPath: IndexPath?)
    func cellRefresh(indexPath: IndexPath?)
    func cellEdit(indexPath: IndexPath?)
    func cellDelete(indexPath: IndexPath?)
}

class List1Cell: UITableViewCell {

    @IBOutlet weak var listFeatured: UIImageView!
    @IBOutlet weak var titleLbl: SuperLabel!
    @IBOutlet weak var cityBtn: CityButton!
    @IBOutlet weak var addressLbl: SuperLabel!
    @IBOutlet weak var telLbl: SuperLabel!
    @IBOutlet weak var business_timeLbl: SuperLabel!
    
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var mapIcon: SuperButton!
    @IBOutlet weak var telIcon: SuperButton!
    @IBOutlet weak var mobileIcon: SuperButton!
    @IBOutlet weak var refreshIcon: SuperButton!
    @IBOutlet weak var editIcon: SuperButton!
    @IBOutlet weak var deleteIcon: SuperButton!
    
    @IBOutlet weak var mapConstraint: NSLayoutConstraint!
    @IBOutlet weak var telConstraint: NSLayoutConstraint!
    @IBOutlet weak var mobileConstraint: NSLayoutConstraint!
    @IBOutlet weak var refreshConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var featuredHConstraint: NSLayoutConstraint!
    
    var icons: [[String: Any]] = [[String: Any]]()
    let iconWidth: CGFloat = 36
    let iconMargin: CGFloat = 16
    
    var cellDelegate: List1CellDelegate?
    
    var featured_h: CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addressLbl.textColor = UIColor(MY_GREEN)
        telLbl.textColor = UIColor(MY_GREEN)
        business_timeLbl.textColor = UIColor(MY_GREEN)
        
        titleLbl.numberOfLines = 0
        titleLbl.textAlignment = .left
        titleLbl.setTextSize(24)
        
        addressLbl.numberOfLines = 0
        addressLbl.textAlignment = .left
        //addressLbl.backgroundColor = UIColor.red
        
        //self.backgroundColor = UIColor.black
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(CELL_SELECTED)
        selectedBackgroundView = bgColorView
        //selectedBackgroundView?.backgroundColor = UIColor.clear
        
        editIcon.isHidden = true
        deleteIcon.isHidden = true
        
        let _icons = [mapIcon, telIcon, mobileIcon, refreshIcon]
        let _constraints = [mapConstraint, telConstraint, mobileConstraint, refreshConstraint]
        for (idx,_icon) in _icons.enumerated() {
            let w: CGFloat = CGFloat(idx+1) * iconMargin + CGFloat(idx) * iconWidth
            icons.append(["icon": _icon!, "constraint": _constraints[idx]!, "constant": w])
        }
//        for icon in icons {
//            let w = icon["constant"] as! CGFloat
//            print(w)
//        }
    }
    
    func updateStoreViews(indexPath: IndexPath, row: SuperStore) {
        //data.printRow()
        self.backgroundColor = UIColor.clear
        
        if row.featured_path.count > 0 {
            
            featured_h = listFeatured.heightForUrl(url: row.featured_path, width: 90)
            listFeatured.downloaded(from: row.featured_path)
        }
        
        titleLbl.text = row.name
        cityBtn.setTitle(row.city)
        addressLbl.text = row.address
        telLbl.text = row.tel_text
        business_timeLbl.text = row.open_time_text + "~" + row.close_time_text
        
        mapIcon.indexPath = indexPath
        telIcon.indexPath = indexPath
        mobileIcon.indexPath = indexPath
        refreshIcon.indexPath = indexPath
        editIcon.indexPath = indexPath
        deleteIcon.indexPath = indexPath
        
        if row.address.isEmpty {
            hiddenIcon(mapIcon)
        }
        if row.tel.isEmpty {
            telIcon.visibility = .gone
        }
        if row.mobile.isEmpty {
            hiddenIcon(mobileIcon)
        }

        //如果要啟動管理功能，請打開這個註解
//        var showManager = false;
//        if row.managers.count > 0 {
//            let member_id = Member.instance.id
//            for manager in row.managers {
//                //print(manager)
//                if let tmp = manager["id"] as? String {
//                    let manager_id = Int(tmp)
//                    if member_id == manager_id {
//                        showManager = true
//                        break
//                    }
//                }
//            }
//        }
//        if showManager {
//            editIcon.isHidden = false
//            deleteIcon.isHidden = false
//        }
        
        let chevron = UIImage(named: "greater1")
        self.accessoryType = .disclosureIndicator
        self.accessoryView = UIImageView(image: chevron!)
        
        //print(contentView.frame.height)
    }
    
    func updateProductViews(indexPath: IndexPath, row: SuperProduct) {
        //data.printRow()
        self.backgroundColor = UIColor.black
        
        if row.featured_path.count > 0 {
            featured_h = listFeatured.heightForUrl(url: row.featured_path, width: 90)
            listFeatured.downloaded(from: row.featured_path)
        }
        
        titleLbl.text = row.name
        cityBtn.setTitle("購買")
        telLbl.text = "價格： \(row.prices.price_member) 元"
        business_timeLbl.visibility = .gone
        addressLbl.visibility = .gone
        
        iconView.visibility = .gone
        mapIcon.visibility = .gone
        telIcon.visibility = .gone
        mobileIcon.visibility = .gone
        refreshIcon.visibility = .gone
        editIcon.visibility = .gone
        deleteIcon.visibility = .gone
        
        let chevron = UIImage(named: "greater1")
        self.accessoryType = .disclosureIndicator
        self.accessoryView = UIImageView(image: chevron!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //print(contentView.frame.height)
        let cellH = contentView.frame.height
        
        if featured_h > 0 {
            // 16 is margin*2
            //print(listFeatured.image!.size)
            let featured_margin_h: CGFloat = (cellH - iconWidth - 16 - featured_h) / 2
            featuredHConstraint.constant = featured_margin_h
        }
    }
    
    func hiddenIcon(_ icon: SuperButton) {
        
//        let constraints = icon.superview!.constraints
//        for constraint in constraints {
//            if constraint.secondItem == nil {
//                continue
//            }
//            let firstType = String(describing: firstItem.self)
//            var _firstItem = constraint.firstItem as? UIView
//            if (firstType == "SuperButton") {
//                _firstItem = constraint.firstItem as! SuperButton
//            }
//            let secondType = String(describing: secondItem.self)
//            var _secondItem = constraint.secondItem as? UIView
//            if (secondType == "SuperButton") {
//                _secondItem = constraint.secondItem as! SuperButton
//            }
//
//
//            if _firstItem == firstItem && _secondItem == secondItem && constraint.constant == constant &&  constraint.firstAttribute == NSLayoutConstraint.Attribute.leading && constraint.secondAttribute == NSLayoutConstraint.Attribute.trailing {
//                constraint.constant = 0
//            }
//        }
        //print(leftMargin?.constant)
        //icon.widthConstraint?.constant = 0
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
    
    @IBAction func mapBtnPressed(sender: UIButton) {
        self._pressed(sender: sender) { indexPath in
            cellDelegate?.cellShowMap(indexPath: indexPath)
        }
    }
    
    @IBAction func telBtnPressed(sender: UIButton) {
        self._pressed(sender: sender) { indexPath in
            cellDelegate?.cellTel(indexPath: indexPath)
        }
    }
    
    @IBAction func mobileBtnPressed(sender: UIButton) {
        self._pressed(sender: sender) { indexPath in
            cellDelegate?.cellMobile(indexPath: indexPath)
        }
    }
    
    @IBAction func refreshBtnPressed(sender: UIButton) {
        self._pressed(sender: sender) { indexPath in
            cellDelegate?.cellRefresh(indexPath: indexPath)
        }
    }
    
    @IBAction func editBtnPressed(sender: UIButton) {
        self._pressed(sender: sender) { indexPath in
            cellDelegate?.cellEdit(indexPath: indexPath)
        }
    }
    
    @IBAction func deleteBtnPressed(sender: UIButton) {
        self._pressed(sender: sender) { indexPath in
            cellDelegate?.cellDelete(indexPath: indexPath)
        }
    }

    private func _pressed(sender: UIButton, method: (IndexPath?)-> Void) {
        
        let _sender = sender as! SuperButton
        var indexPath: IndexPath?
        if _sender.indexPath != nil {
            indexPath = _sender.indexPath!
        }
        method(indexPath)
    }
}
