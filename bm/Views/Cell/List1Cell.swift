//
//  List1Cell.swift
//  bm
//
//  Created by ives sun on 2020/11/9.
//  Copyright © 2020 bm. All rights reserved.
//

import UIKit

class List1Cell: List2Cell {

    @IBOutlet weak var addressLbl: SuperLabel!
    @IBOutlet weak var telLbl: SuperLabel!
    @IBOutlet weak var business_timeLbl: SuperLabel!
    
    @IBOutlet weak var telIcon: SuperButton!
    @IBOutlet weak var editIcon: SuperButton!
    @IBOutlet weak var deleteIcon: SuperButton!
    
    @IBOutlet weak var telConstraint: NSLayoutConstraint!
    @IBOutlet weak var refreshConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var featuredHConstraint: NSLayoutConstraint!
    
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
    
    func updateStoreViews(indexPath: IndexPath, row: StoreTable) {
        //data.printRow()
        _updateViews(row)
        
        titleLbl.text = row.name
        cityBtn.setTitle(row.city_show)
        addressLbl.text = row.address
        telLbl.text = row.tel_show
        business_timeLbl.text = row.open_time_show + "~" + row.close_time_show
        
        cityBtn.row = row
        mapIcon.row = row
        telIcon.row = row
        mobileIcon.row = row
        refreshIcon.row = row
        editIcon.row = row
        deleteIcon.row = row
        
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
        
        
        
        //print(contentView.frame.height)
    }
    
    func updateProductViews(indexPath: IndexPath, row: ProductTable) {
        //data.printRow()
        _updateViews(row)
        
        titleLbl.text = row.name
        cityBtn.setTitle("購買")
        if row.prices.count > 0 {
            let tmp: String = (row.prices[0].price_member).formattedWithSeparator
            //let tmp = m.formattedWithSeparator
            let price: String = "NT$ \(tmp)"
            telLbl.text = "價格： \(price) 元"
        } else {
            telLbl.text = "未提供"
        }
        
        cityBtn.row = row
        
        business_timeLbl.visibility = .gone
        addressLbl.visibility = .gone
        
        iconView.visibility = .gone
        mapIcon.visibility = .gone
        telIcon.visibility = .gone
        mobileIcon.visibility = .gone
        refreshIcon.visibility = .gone
        editIcon.visibility = .gone
        deleteIcon.visibility = .gone
    }
    
    func updateTeamViews(indexPath: IndexPath, row: TeamTable) {
        
        _updateViews(row)
        titleLbl.text = row.name
        cityBtn.setTitle(row.city_show)
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
}
