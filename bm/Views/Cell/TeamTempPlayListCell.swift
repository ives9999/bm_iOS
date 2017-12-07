//
//  TeamTempPlayListCell.swift
//  bm
//
//  Created by ives on 2017/12/4.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class TeamTempPlayListCell: SuperCell {
    
    var bkView: UIView!
    var nameLbl: SuperLabel!
    var cityLbl: SuperLabel!
    var arenaLbl: SuperLabel!
    var quantityLbl: SuperLabel!
    var signupLbl: SuperLabel!
    var dateLbl: SuperLabel!
    let constant: TEAM_TEMP_PLAY_CELL = TEAM_TEMP_PLAY_CELL()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.value1, reuseIdentifier: reuseIdentifier)
        bkView = UIView(frame: CGRect.zero)
        nameLbl = SuperLabel(frame: CGRect.zero)
        cityLbl = SuperLabel(frame: CGRect.zero)
        arenaLbl = SuperLabel(frame: CGRect.zero)
        quantityLbl = SuperLabel(frame: CGRect.zero)
        signupLbl = SuperLabel(frame: CGRect.zero)
        dateLbl = SuperLabel(frame: CGRect.zero)
        bkView.addSubview(nameLbl)
        bkView.addSubview(cityLbl)
        bkView.addSubview(arenaLbl)
        bkView.addSubview(quantityLbl)
        bkView.addSubview(signupLbl)
        bkView.addSubview(dateLbl)
        
        contentView.addSubview(bkView)
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        //bkView?.frame = CGRect(x: 50, y: 50, width: bounds.width, height: constant.height - 2*constant.height_padding)
        bkView?.frame = CGRect(x: 0, y: constant.height_padding, width: bounds.width, height: constant.height - 2*constant.height_padding)
        bkView!.backgroundColor = UIColor.black
        nameLbl.frame = CGRect(x: constant.name_left_padding, y: constant.name_top_padding, width: 10, height: 10)
        //print("bkView.bounds height: \(bkView.bounds.height)")
        //print("bkView.frame height: \(bkView.frame.height)")
        //print(bkView.bounds.height-constant.name_top_padding)
        cityLbl.frame = CGRect(x: constant.name_left_padding, y: bkView.bounds.height-constant.name_top_padding-50, width: 10, height: 10)
        arenaLbl.frame = CGRect(x: constant.name_left_padding, y: bkView.bounds.height-constant.name_top_padding-20, width: 10, height: 10)
        quantityLbl.frame = CGRect(x: 100, y: bkView.bounds.height-constant.name_top_padding-50, width: 10, height: 10)
        signupLbl.frame = CGRect(x: 220, y: bkView.bounds.height-constant.name_top_padding-50, width: 10, height: 10)
        dateLbl.frame = CGRect(x: bkView.bounds.width-150, y: constant.name_top_padding, width: 10, height: 10)
        contentView.sendSubview(toBack: bkView)
        
        nameLbl.sizeToFit()
        cityLbl.sizeToFit()
        arenaLbl.sizeToFit()
        quantityLbl.sizeToFit()
        signupLbl.sizeToFit()
        dateLbl.sizeToFit()
        
        cityLbl.setTextSize(14)
        arenaLbl.setTextSize(14)
        quantityLbl.setTextSize(17)
        signupLbl.setTextSize(17)
        
        cityLbl.setTagStyle(bk: UIColor.blue)
        arenaLbl.setTagStyle(bk: UIColor.red)
        cityLbl.setTextColor(UIColor.black)
        arenaLbl.setTextColor(UIColor.black)
        
    }
    func forRow(row: Dictionary<String, [String: Any]>) {
        //accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        nameLbl.text = (row[TEAM_NAME_KEY]!["value"] as! String)
        cityLbl.text = (row["city"]!["show"] as! String)
        arenaLbl.text = (row["arena"]!["show"] as! String)
        
        let quantity: Int = (row["count"]!["quantity"] as! Int)
        let signup: Int = (row["count"]!["signup"] as! Int)
        quantityLbl.text = "接受臨打人數：" + String(quantity)
        signupLbl.text = "已報名人數：" + String(signup)
        
        let near_date_1: String = (row["near_date"]!["value"] as! String)
        let near_date_2: String = (row["near_date"]!["value1"] as! String)
        let near_date: String = near_date_1 + "(" + near_date_2 + ")"
        dateLbl.text = near_date
        
        setNeedsLayout()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
