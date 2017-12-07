//
//  TeamTempPlayListCell.swift
//  bm
//
//  Created by ives on 2017/12/4.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

class TeamTempPlayListCell: SuperCell {
    
    var bkView: UIView!
    var nameLbl: SuperLabel!
    var cityLbl: Tag!
    var arenaLbl: Tag!
    var quantityLbl: SuperLabel!
    var signupLbl: SuperLabel!
    var dateLbl: SuperLabel!
    let constant: TEAM_TEMP_PLAY_CELL = TEAM_TEMP_PLAY_CELL()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.value1, reuseIdentifier: reuseIdentifier)
        bkView = UIView(frame: CGRect.zero)
        nameLbl = SuperLabel(frame: CGRect.zero)
        cityLbl = Tag(frame: CGRect.zero, bk: UIColor(MY_GREEN),textColor: UIColor.black)
        arenaLbl = Tag(frame: CGRect.zero, bk: UIColor(MY_GREEN),textColor: UIColor.black)
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
        bkView!.backgroundColor = UIColor.clear
        //nameLbl.frame = CGRect(x: constant.name_left_padding, y: constant.name_top_padding, width: 10, height: 10)
        //cityLbl.frame = CGRect(x: constant.name_left_padding, y: bkView.bounds.height-constant.name_top_padding-50, width: 10, height: 10)
        //arenaLbl.frame = CGRect(x: constant.name_left_padding, y: bkView.bounds.height-constant.name_top_padding-20, width: 10, height: 10)
        //quantityLbl.frame = CGRect(x: 100, y: bkView.bounds.height-constant.name_top_padding-50, width: 10, height: 10)
        //signupLbl.frame = CGRect(x: 220, y: bkView.bounds.height-constant.name_top_padding-50, width: 10, height: 10)
        //dateLbl.frame = CGRect(x: bkView.bounds.width-150, y: constant.name_top_padding, width: 10, height: 10)
        contentView.sendSubview(toBack: bkView)
        
        let nameLblC1: NSLayoutConstraint = NSLayoutConstraint(item: nameLbl, attribute: .leading, relatedBy: .equal, toItem: nameLbl.superview, attribute: .leading, multiplier: 1, constant: constant.name_left_padding)
        let nameLblC2: NSLayoutConstraint = NSLayoutConstraint(item: nameLbl, attribute: .top, relatedBy: .equal, toItem: nameLbl.superview, attribute: .top, multiplier: 1, constant: constant.name_top_padding)
        //let c3: NSLayoutConstraint = NSLayoutConstraint(item: nameLbl, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 10)
        //let c4: NSLayoutConstraint = NSLayoutConstraint(item: nameLbl, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 10)
        
        let arenaLblC1: NSLayoutConstraint = NSLayoutConstraint(item: arenaLbl, attribute: .leading, relatedBy: .equal, toItem: nameLbl, attribute: .trailing, multiplier: 1, constant: 10)
        let arenaLblC2: NSLayoutConstraint = NSLayoutConstraint(item: arenaLbl, attribute: .centerY, relatedBy: .equal, toItem: nameLbl, attribute: .centerY, multiplier: 1, constant: 0)
        
        let cityLblC1: NSLayoutConstraint = NSLayoutConstraint(item: cityLbl, attribute: .leading, relatedBy: .equal, toItem: arenaLbl, attribute: .trailing, multiplier: 1, constant: 5)
        let cityLblC2: NSLayoutConstraint = NSLayoutConstraint(item: cityLbl, attribute: .centerY, relatedBy: .equal, toItem: arenaLbl, attribute: .centerY, multiplier: 1, constant: 0)
        
        let quantityLblC1: NSLayoutConstraint = NSLayoutConstraint(item: quantityLbl, attribute: .leading, relatedBy: .equal, toItem: quantityLbl.superview, attribute: .leading, multiplier: 1, constant: constant.name_left_padding)
        let quantityLblC2: NSLayoutConstraint = NSLayoutConstraint(item: quantityLbl, attribute: .top, relatedBy: .equal, toItem: nameLbl, attribute: .bottom, multiplier: 1, constant: 8)
        
        let signupLblC1: NSLayoutConstraint = NSLayoutConstraint(item: signupLbl, attribute: .leading, relatedBy: .equal, toItem: signupLbl.superview, attribute: .leading, multiplier: 1, constant: constant.name_left_padding)
        let signupLblC2: NSLayoutConstraint = NSLayoutConstraint(item: signupLbl, attribute: .top, relatedBy: .equal, toItem: quantityLbl, attribute: .bottom, multiplier: 1, constant: 2)
        
        let dateLblC1: NSLayoutConstraint = NSLayoutConstraint(item: dateLbl, attribute: .trailing, relatedBy: .equal, toItem: dateLbl.superview, attribute: .trailing, multiplier: 1, constant: -20)
        let dateLblC2: NSLayoutConstraint = NSLayoutConstraint(item: dateLbl, attribute: .centerY, relatedBy: .equal, toItem: quantityLbl, attribute: .centerY, multiplier: 1, constant: 0)
        
        nameLbl.translatesAutoresizingMaskIntoConstraints = false
        cityLbl.translatesAutoresizingMaskIntoConstraints = false
        arenaLbl.translatesAutoresizingMaskIntoConstraints = false
        quantityLbl.translatesAutoresizingMaskIntoConstraints = false
        signupLbl.translatesAutoresizingMaskIntoConstraints = false
        dateLbl.translatesAutoresizingMaskIntoConstraints = false
        
        bkView.addConstraint(nameLblC1)
        bkView.addConstraint(nameLblC2)
        bkView.addConstraint(arenaLblC1)
        bkView.addConstraint(arenaLblC2)
        bkView.addConstraint(cityLblC1)
        bkView.addConstraint(cityLblC2)
        bkView.addConstraint(quantityLblC1)
        bkView.addConstraint(quantityLblC2)
        bkView.addConstraint(signupLblC1)
        bkView.addConstraint(signupLblC2)
        bkView.addConstraint(dateLblC1)
        bkView.addConstraint(dateLblC2)
        
        nameLbl.sizeToFit()
        cityLbl.sizeToFit()
        arenaLbl.sizeToFit()
        quantityLbl.sizeToFit()
        signupLbl.sizeToFit()
        dateLbl.sizeToFit()
        
        cityLbl.setTextSize(14)
        arenaLbl.setTextSize(14)
        quantityLbl.setTextSize(16)
        quantityLbl.setTextColor(UIColor(MY_GREEN))
        signupLbl.setTextSize(16)
        signupLbl.setTextColor(UIColor(MY_RED))
        //dateLbl.setTextSize(17)
        
        
        
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
