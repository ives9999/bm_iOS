//
//  TeamTempPlayListCell.swift
//  bm
//
//  Created by ives on 2017/12/4.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

protocol TeamTempPlayListCellDelegate {
}

class TeamTempPlayListCell: SuperCell {
    
    var bkView: UIView!
    var nameLbl: SuperLabel!
    var cityBtn: SuperButton!
    var arenaBtn: SuperButton!
    var quantityLbl: SuperLabel!
    var signupLbl: SuperLabel!
    var dateLbl: SuperLabel!
    var timeLbl: SuperLabel!
    let constant: TEAM_TEMP_PLAY_CELL = TEAM_TEMP_PLAY_CELL()
    
    var cellDelegate: TeamTempPlayListCellDelegate?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.value1, reuseIdentifier: reuseIdentifier)
        bkView = UIView(frame: CGRect.zero)
        nameLbl = SuperLabel(frame: CGRect.zero)
        cityBtn = SuperButton(frame: CGRect.zero,textColor:UIColor.black, bkColor:UIColor(MY_GREEN))
        arenaBtn = SuperButton(frame: CGRect.zero,textColor:UIColor.black, bkColor:UIColor(MY_GREEN))
        quantityLbl = SuperLabel(frame: CGRect.zero)
        signupLbl = SuperLabel(frame: CGRect.zero)
        dateLbl = SuperLabel(frame: CGRect.zero)
        timeLbl = SuperLabel(frame: CGRect.zero)
        bkView.addSubview(nameLbl)
        bkView.addSubview(cityBtn)
        bkView.addSubview(arenaBtn)
        bkView.addSubview(quantityLbl)
        bkView.addSubview(signupLbl)
        bkView.addSubview(dateLbl)
        bkView.addSubview(timeLbl)
        
        contentView.addSubview(bkView)
        bkView!.backgroundColor = UIColor.clear
        _layout()
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLbl.sizeToFit()
        quantityLbl.sizeToFit()
        signupLbl.sizeToFit()
        dateLbl.sizeToFit()
        
//        let f = contentView.frame
//        let fr = UIEdgeInsetsInsetRect(f, UIEdgeInsetsMake(10, 10, 10, 10))
//        contentView.frame = fr
    }
    func forRow(row: Dictionary<String, [String: Any]>) {
        //accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        nameLbl.text = (row[NAME_KEY]!["value"] as! String)
        cityBtn.setTitle((row["city"]!["show"] as! String), for: .normal)
        let city_id = row["city"]!["value"] as! Int
        cityBtn.tag = city_id
        cityBtn.addTarget(cellDelegate, action: #selector(TempPlayVC.cityBtnPressed(sender:)), for: .touchUpInside)
        arenaBtn.setTitle((row["arena"]!["show"] as! String), for: .normal)
        let arena_id = row["arena"]!["value"] as! Int
        arenaBtn.tag = arena_id
        arenaBtn.addTarget(cellDelegate, action: #selector(TempPlayVC.arenaBtnPressed(sender:)), for: .touchUpInside)
        
        let quantity: Int = (row["count"]!["quantity"] as! Int)
        let signup: Int = (row["count"]!["signup"] as! Int)
        var quantity_show: String = "未提供"
        if quantity >= 0 {
            quantity_show = String(quantity)
        }
        quantityLbl.text = "接受臨打人數：" + quantity_show
        signupLbl.text = "已報名人數：" + String(signup)
        
        let near_date: String = (row["near_date"]!["show"] as! String)
        dateLbl.text = near_date
        
        let interval: String = (row[TEAM_PLAY_START_KEY]!["show"] as! String) + "-" + (row[TEAM_PLAY_END_KEY]!["show"] as! String)
        timeLbl.text = interval
        
        setNeedsLayout()
    }
    
//    @objc func press(sender: UIButton) {
//        print(sender.tag)
//    }
    
    func _layout() {
        bkView?.frame = CGRect(x: 0, y: constant.height_padding, width: bounds.width, height: constant.height - 2*constant.height_padding)
        
        
        let nameLblC1: NSLayoutConstraint = NSLayoutConstraint(item: nameLbl, attribute: .leading, relatedBy: .equal, toItem: nameLbl.superview, attribute: .leading, multiplier: 1, constant: constant.name_left_padding)
        let nameLblC2: NSLayoutConstraint = NSLayoutConstraint(item: nameLbl, attribute: .top, relatedBy: .equal, toItem: nameLbl.superview, attribute: .top, multiplier: 1, constant: constant.name_top_padding)
        //let c3: NSLayoutConstraint = NSLayoutConstraint(item: nameLbl, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 10)
        //let c4: NSLayoutConstraint = NSLayoutConstraint(item: nameLbl, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 10)
        
        let cityBtnC1: NSLayoutConstraint = NSLayoutConstraint(item: cityBtn, attribute: .leading, relatedBy: .equal, toItem: nameLbl, attribute: .trailing, multiplier: 1, constant: 10)
        let cityBtnC2: NSLayoutConstraint = NSLayoutConstraint(item: cityBtn, attribute: .centerY, relatedBy: .equal, toItem: nameLbl, attribute: .centerY, multiplier: 1, constant: 0)
        
        let arenaBtnC1: NSLayoutConstraint = NSLayoutConstraint(item: arenaBtn, attribute: .leading, relatedBy: .equal, toItem: arenaBtn.superview, attribute: .leading, multiplier: 1, constant: constant.name_left_padding)
        let arenaBtnC2: NSLayoutConstraint = NSLayoutConstraint(item: arenaBtn, attribute: .top, relatedBy: .equal, toItem: nameLbl, attribute: .bottom, multiplier: 1, constant: 8)
        
        let quantityLblC1: NSLayoutConstraint = NSLayoutConstraint(item: quantityLbl, attribute: .leading, relatedBy: .equal, toItem: quantityLbl.superview, attribute: .leading, multiplier: 1, constant: constant.name_left_padding)
        let quantityLblC2: NSLayoutConstraint = NSLayoutConstraint(item: quantityLbl, attribute: .top, relatedBy: .equal, toItem: arenaBtn, attribute: .bottom, multiplier: 1, constant: 8)
        
        let signupLblC1: NSLayoutConstraint = NSLayoutConstraint(item: signupLbl, attribute: .leading, relatedBy: .equal, toItem: signupLbl.superview, attribute: .leading, multiplier: 1, constant: constant.name_left_padding)
        let signupLblC2: NSLayoutConstraint = NSLayoutConstraint(item: signupLbl, attribute: .top, relatedBy: .equal, toItem: quantityLbl, attribute: .bottom, multiplier: 1, constant: 2)
        
        let dateLblC1: NSLayoutConstraint = NSLayoutConstraint(item: dateLbl, attribute: .trailing, relatedBy: .equal, toItem: dateLbl.superview, attribute: .trailing, multiplier: 1, constant: constant.name_left_padding * -1)
        let dateLblC2: NSLayoutConstraint = NSLayoutConstraint(item: dateLbl, attribute: .centerY, relatedBy: .equal, toItem: quantityLbl, attribute: .centerY, multiplier: 1, constant: 0)
        
        let timeLblC1: NSLayoutConstraint = NSLayoutConstraint(item: timeLbl, attribute: .trailing, relatedBy: .equal, toItem: timeLbl.superview, attribute: .trailing, multiplier: 1, constant: constant.name_left_padding * -1)
        let timeLblC2: NSLayoutConstraint = NSLayoutConstraint(item: timeLbl, attribute: .centerY, relatedBy: .equal, toItem: signupLbl, attribute: .centerY, multiplier: 1, constant: 0)
        
        nameLbl.translatesAutoresizingMaskIntoConstraints = false
        cityBtn.translatesAutoresizingMaskIntoConstraints = false
        arenaBtn.translatesAutoresizingMaskIntoConstraints = false
        quantityLbl.translatesAutoresizingMaskIntoConstraints = false
        signupLbl.translatesAutoresizingMaskIntoConstraints = false
        dateLbl.translatesAutoresizingMaskIntoConstraints = false
        timeLbl.translatesAutoresizingMaskIntoConstraints = false
        
        bkView.addConstraint(nameLblC1)
        bkView.addConstraint(nameLblC2)
        bkView.addConstraint(arenaBtnC1)
        bkView.addConstraint(arenaBtnC2)
        bkView.addConstraint(cityBtnC1)
        bkView.addConstraint(cityBtnC2)
        bkView.addConstraint(quantityLblC1)
        bkView.addConstraint(quantityLblC2)
        bkView.addConstraint(signupLblC1)
        bkView.addConstraint(signupLblC2)
        bkView.addConstraint(dateLblC1)
        bkView.addConstraint(dateLblC2)
        bkView.addConstraint(timeLblC1)
        bkView.addConstraint(timeLblC2)
        
        arenaBtn.setTextSize(14)
        cityBtn.setTextSize(14)
        quantityLbl.setTextSize(16)
        quantityLbl.setTextColor(UIColor(MY_GREEN))
        signupLbl.setTextSize(16)
        signupLbl.setTextColor(UIColor(MY_RED))
        dateLbl.setTextSize(16)
        timeLbl.setTextSize(16)
        
        cityBtn.padding(top: 3, left: 20, bottom: 3, right: 20)
        arenaBtn.padding(top: 3, left: 20, bottom: 3, right: 20)
        cityBtn.cornerRadius(10)
        arenaBtn.cornerRadius(10)
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
