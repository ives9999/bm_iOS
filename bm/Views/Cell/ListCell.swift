//
//  ListCell.swift
//  bm
//
//  Created by ives on 2018/7/24.
//  Copyright © 2018年 bm. All rights reserved.
//

import UIKit

class ListCell: SuperCell {

    @IBOutlet weak var listFeatured: UIImageView!
    @IBOutlet weak var listTitleTxt: UILabel!
    @IBOutlet weak var listCityTxt: UILabel!
    @IBOutlet weak var listArenaTxt: UILabel!
    @IBOutlet weak var listBallTxt: UILabel!
    @IBOutlet weak var listDayTxt: UILabel!
    @IBOutlet weak var listIntervalTxt: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.value1, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateViews(list: List) {
        listTitleTxt.text = list.title
        listFeatured.image = list.featured
        if let item = list.data["city"] {
            listCityTxt.text = (item["show"] as! String)
        }
        if let item = list.data["arena"] {
            listArenaTxt.text = (item["show"] as! String)
        }
        if let item = list.data["ball"] {
            listBallTxt.text = (item["show"] as! String)
        }
        if let item = list.data["days"] {
            listDayTxt.text = (item["show"] as! String)
        }
        if let item = list.data["interval"] {
            listIntervalTxt.text = (item["show"] as! String)
        }
        accessoryType = UITableViewCellAccessoryType.disclosureIndicator
    }
    
}
