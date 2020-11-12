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

class List1Cell: SuperCell {

    @IBOutlet weak var listFeatured: UIImageView!
    @IBOutlet weak var titleLbl: SuperLabel!
    @IBOutlet weak var addressLbl: SuperLabel!
    @IBOutlet weak var telLbl: SuperLabel!
    @IBOutlet weak var business_timeLbl: SuperLabel!
    @IBOutlet weak var mapIcon: SuperButton!
    @IBOutlet weak var telIcon: SuperButton!
    @IBOutlet weak var mobileIcon: SuperButton!
    @IBOutlet weak var refreshIcon: SuperButton!
    @IBOutlet weak var editIcon: SuperButton!
    @IBOutlet weak var deleteIcon: SuperButton!
    
    var cellDelegate: List1CellDelegate?
    
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
        
        editIcon.isHidden = true
        deleteIcon.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateStoreViews(indexPath: IndexPath, data: SuperStore) {
        //data.printRow()
        self.backgroundColor = UIColor.clear
        if data.featured_path.count > 0 {
           listFeatured.downloaded(from: data.featured_path)
        }
        
        titleLbl.text = data.name
        addressLbl.text = data.address
        //print(addressLbl.calculateMaxLines())
        
        telLbl.text = data.tel_text
        business_timeLbl.text = data.open_time_text + "~" + data.close_time_text
        
        mapIcon.indexPath = indexPath
        telIcon.indexPath = indexPath
        mobileIcon.indexPath = indexPath
        refreshIcon.indexPath = indexPath
        editIcon.indexPath = indexPath
        deleteIcon.indexPath = indexPath

        var showManager = false;
        if data.managers.count > 0 {
            let member_id = Member.instance.id
            for manager in data.managers {
                //print(manager)
                if let tmp = manager["id"] as? String {
                    let manager_id = Int(tmp)
                    if member_id == manager_id {
                        showManager = true
                        break
                    }
                }
            }
        }
        if showManager {
            editIcon.isHidden = false
            deleteIcon.isHidden = false
        }
        
        let chevron = UIImage(named: "greater1")
        self.accessoryType = .disclosureIndicator
        self.accessoryView = UIImageView(image: chevron!)
        
        //self.layoutIfNeeded()
        //self.setNeedsLayout()
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
