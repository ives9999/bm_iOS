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
}

class TeamSubmitCell: SuperCell, UITextFieldDelegate {
    
    var teamSubmitCellDelegate: TeamSubmitCellDelegate?
    var generalTextField: SuperTextField!
    var iden: String = ""

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.value1, reuseIdentifier: reuseIdentifier)
        
        generalTextField = SuperTextField(frame: CGRect.zero)
        contentView.addSubview(generalTextField)
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let yPadding: CGFloat = 5
        let txtWidth: CGFloat = 250
        let txtHeight: CGFloat = bounds.height - 8
        let x = bounds.width - txtWidth
        let fullTextFieldFrame: CGRect = CGRect(x: x, y: yPadding, width: txtWidth, height: txtHeight)
        generalTextField.frame = fullTextFieldFrame
    }
    
    func forRow(row: [String: Any]) {
        //print(row)
        generalTextField.delegate = self
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
            accessoryType = UITableViewCellAccessoryType.none
        }
        textLabel?.text = (row["ch"] as! String)
        setNeedsLayout()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //print("tag: \(iden)")
        // print("text: \(textField.text)")
        teamSubmitCellDelegate?.setTextField(iden: iden, value: textField.text!)
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
