//
//  TeamSubmitCell.swift
//  bm
//
//  Created by ives on 2017/11/23.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

protocol TeamSubmitCellDelegate {
    func setTextField(iden: String, value: String)
    func setSwitch(indexPath: IndexPath, value: Bool)
}

class TeamSubmitCell: SuperCell, UITextFieldDelegate {
    
    var teamSubmitCellDelegate: TeamSubmitCellDelegate?
    var generalTextField: SuperTextField!
    var generalSwitch: SuperSwitch!
    var iden: String = ""

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.value1, reuseIdentifier: reuseIdentifier)
        
        generalTextField = SuperTextField(frame: CGRect.zero)
        contentView.addSubview(generalTextField)
        generalTextField.isHidden = true
        
        generalSwitch = SuperSwitch(frame: .zero)
        contentView.addSubview(generalSwitch)
        generalSwitch.isHidden = true
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let yPadding: CGFloat = 5
        let txtWidth: CGFloat = 250
        let txtHeight: CGFloat = bounds.height - 10
        let x = bounds.width - txtWidth - 18
        let fullTextFieldFrame: CGRect = CGRect(x: x, y: yPadding, width: txtWidth, height: txtHeight)
        generalTextField.frame = fullTextFieldFrame
        
        generalSwitch.frame = CGRect(x: bounds.width-70, y: 7, width: 40, height: 20)
        
    }
    
    func forRow(indexPath:IndexPath, row: [String: Any]) {
        //print(row)
        generalTextField.delegate = self
        //generalTextField.tag = row["idx"] as! Int
        iden = row["key"] as! String
        
        if row["text_field"] != nil && (row["text_field"] as! Bool) {
            detailTextLabel?.text = ""
            generalTextField.isHidden = false
            generalSwitch.isHidden = true
            if row["keyboardType"] != nil {
                let pad: UIKeyboardType = row["keyboardType"] as! UIKeyboardType
                generalTextField.keyboardType = pad
            }
            if row["hint"] != nil {
                generalTextField.placeholder(row["hint"] as! String)
            }
            //print(iden)
            if row["show"] != nil {
                generalTextField.text = (row["show"] as! String)
            }
            accessoryType = UITableViewCellAccessoryType.none
        }
        if row["switch"] != nil && (row["switch"] as! Bool) {
            generalTextField.isHidden = true
            generalSwitch.isHidden = false
            generalSwitch.indexPath = indexPath
            generalSwitch.addTarget(self, action: #selector(switchDidValueChanged(sender:)), for: .valueChanged)
        }
        if row["atype"] as! UITableViewCellAccessoryType != UITableViewCellAccessoryType.none {
            generalTextField.isHidden = true
            generalSwitch.isHidden = true
            if row["show"] != nil {
                detailTextLabel?.text = (row["show"] as! String)
            } else {
                detailTextLabel?.text = ""
            }
            accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        textLabel?.text = (row["ch"] as! String)
        setNeedsLayout()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //print("tag: \(iden)")
        //print("text: \(textField.text)")
        teamSubmitCellDelegate?.setTextField(iden: iden, value: textField.text!)
    }
    
    @objc func switchDidValueChanged(sender: UISwitch) {
        let _sender = sender as! SuperSwitch
        teamSubmitCellDelegate?.setSwitch(indexPath: _sender.indexPath!, value: _sender.isOn)
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
