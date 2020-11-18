//
//  List2Cell.swift
//  bm
//
//  Created by ives on 2020/11/17.
//  Copyright © 2020 bm. All rights reserved.
//

import UIKit

class List2Cell: SuperCell {

    @IBOutlet weak var listFeatured: UIImageView!
    @IBOutlet weak var titleLbl: SuperLabel!
    @IBOutlet weak var cityBtn: CityButton!
    @IBOutlet weak var addressLbl: SuperLabel!
    @IBOutlet weak var telLbl: SuperLabel!
    @IBOutlet weak var business_timeLbl: SuperLabel!
    @IBOutlet weak var mapIcon: SuperButton!
    @IBOutlet weak var telIcon: SuperButton!
    @IBOutlet weak var mobileIcon: SuperButton!
    @IBOutlet weak var refreshIcon: SuperButton!
    @IBOutlet weak var editIcon: SuperButton!
    @IBOutlet weak var deleteIcon: SuperButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLbl.numberOfLines = 0
        titleLbl.textAlignment = .left
        titleLbl.setTextSize(24)
        
        //addressLbl.textColor = UIColor(MY_GREEN)
        telLbl.textColor = UIColor(MY_GREEN)
        //business_timeLbl.textColor = UIColor(MY_GREEN)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateStoreViews(indexPath: IndexPath, row: SuperStore) {
        
        titleLbl.text = row.name
        cityBtn.setTitle(row.city)
        
        telLbl.text = row.tel_text
        //business_timeLbl.text = row.open_time_text + "~" + row.close_time_text
        
        let chevron = UIImage(named: "greater1")
        self.accessoryType = .disclosureIndicator
        self.accessoryView = UIImageView(image: chevron!)
    }
    
    override func updateConstraints() {
        let i = 6
        self.heightConstraint?.constant = 600
        super.updateConstraints()
    }
}
