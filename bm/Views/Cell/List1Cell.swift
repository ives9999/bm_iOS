//
//  List1Cell.swift
//  bm
//
//  Created by ives sun on 2020/11/9.
//  Copyright © 2020 bm. All rights reserved.
//

import UIKit

class List1Cell: SuperCell {

    @IBOutlet weak var listFeatured: UIImageView!
    @IBOutlet weak var titleLbl: SuperLabel!
    @IBOutlet weak var addressLbl: SuperLabel!
    @IBOutlet weak var telLbl: SuperLabel!
    @IBOutlet weak var business_timeLbl: SuperLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addressLbl.textColor = UIColor(MY_GREEN)
        telLbl.textColor = UIColor(MY_GREEN)
        //business_timeLbl.textColor = UIColor(MY_GREEN)
        
        addressLbl.numberOfLines = 0
        addressLbl.textAlignment = .left
        //addressLbl.backgroundColor = UIColor.red
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateStoreViews(indexPath: IndexPath, data: SuperStore) {
        //data.printRow()
        self.backgroundColor = UIColor.clear
        if data.featured_path.count > 0 {
           // listFeatured.downloaded(from: data.featured_path)
        }
        
        titleLbl.text = data.name
        addressLbl.text = data.address
        
//        listCityBtn.setTextSize(14)
//        listCityBtn.alignH = UIControlContentHorizontalAlignment.center
//
//        listCityBtn.setTitle(data.city)
//        listArenaTxt.text = data.address
        telLbl.text = data.tel_text
        //business_timeLbl.text = data.open_time_text + "~" + data.close_time_text
//
//        var showManager = false;
//        if data.managers.count > 0 {
//            let member_id = Member.instance.id
//            for manager in data.managers {
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
//            listMarker.isHidden = false
//            //listMarker.text = "管理"
//        } else {
//            listMarker.isHidden = true
//        }
//        listBallTxt.isHidden = true
        
        let chevron = UIImage(named: "greater1")
        self.accessoryType = .disclosureIndicator
        self.accessoryView = UIImageView(image: chevron!)
        
        //self.layoutIfNeeded()
        //self.setNeedsLayout()
    }
    
}
