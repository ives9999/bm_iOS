//
//  TeamTempPlayCell.swift
//  bm
//
//  Created by ives on 2017/12/1.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

protocol TeamTempPlayCellDelegate {
    func setTextField(iden: String, value: String)
    func setSwitch(iden: String, value: Bool)
}

class TeamTempPlayCell: SuperCell, UITextFieldDelegate {
    
    var teamTempPlayCellDelegate: TeamTempPlayCellDelegate?
    var generalTextField: SuperTextField!
    var generalSwitch: UISwitch!
    var iden: String = ""
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.value1, reuseIdentifier: reuseIdentifier)
        
        generalTextField = SuperTextField(frame: CGRect.zero)
        contentView.addSubview(generalTextField)
        
        generalSwitch = UISwitch(frame: CGRect.zero)
        generalSwitch.addTarget(self, action: #selector(switchStateDidChange(_:)), for: .valueChanged)
        generalSwitch.setOn(true, animated: true)
        contentView.addSubview(generalSwitch)
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let yPadding: CGFloat = 5
        let txtWidth: CGFloat = 200
        let txtHeight: CGFloat = bounds.height - 8
        let x = bounds.width - txtWidth - 5
        let fullTextFieldFrame: CGRect = CGRect(x: x, y: yPadding, width: txtWidth, height: txtHeight)
        generalTextField.frame = fullTextFieldFrame
        
        let switchWidth: CGFloat = 80
        generalSwitch.frame = CGRect(x: bounds.width - switchWidth + 10, y: 0, width: switchWidth, height: bounds.height)
    }
    func forRow(row: [String: Any]) {
        //print(row)
        //generalTextField.delegate = self
        //generalTextField.tag = row["idx"] as! Int
        iden = row["key"] as! String
        if row["atype"] as! UITableViewCellAccessoryType != UITableViewCellAccessoryType.none {
            generalTextField.isHidden = true
            if row["show"] != nil {
                detailTextLabel?.text = (row["show"] as! String)
            } else {
                detailTextLabel?.text = ""
            }
            accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        } else {
            if row["itype"] != nil {
                let itype: String = row["itype"] as! String
                if itype == "switch" {
                    generalTextField.isHidden = true
                    generalSwitch.isHidden = false
                    var b: Bool = false
                    let vtype: String = row["vtype"] as! String
                    if vtype == "String" {
                        let tmp: String = row["value"] as! String
                        b = tmp == "on" ? true : false
                    } else if vtype == "Bool" {
                        b = row["value"] as! Bool
                    }
                    //print("status: \(b)")
                    generalSwitch.setOn(b, animated: true)
                } else {
                    generalSwitch.isHidden = true
                    detailTextLabel?.text = ""
                    generalTextField.isHidden = false
                    if row["keyboardType"] != nil {
                        let pad: UIKeyboardType = row["keyboardType"] as! UIKeyboardType
                        generalTextField.keyboardType = pad
                    }
                    //print(iden)
                    if row["show"] != nil {
                        generalTextField.text = (row["show"] as! String)
                    }
                }
            }
            
            accessoryType = UITableViewCellAccessoryType.none
        }
        textLabel?.text = (row["ch"] as! String)
        setNeedsLayout()
    }
    
    @objc func switchStateDidChange(_ sender: UISwitch) {
        teamTempPlayCellDelegate!.setSwitch(iden: iden, value: sender.isOn)
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
