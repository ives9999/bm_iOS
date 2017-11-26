//
//  TeamSubmitCell.swift
//  bm
//
//  Created by ives on 2017/11/23.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

protocol TeamSubmitCellDelegate {
    func setTextField(idx: Int, value: String)
}

class TeamSubmitCell: SuperCell, UITextFieldDelegate {
    
    var delegate: TeamSubmitCellDelegate?
    var generalTextField: SuperTextField!

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
        generalTextField.delegate = self
        generalTextField.tag = row["idx"] as! Int
        if row["atype"] as! UITableViewCellAccessoryType != UITableViewCellAccessoryType.none {
            generalTextField.isHidden = true
            if row["value"] != nil {
                detailTextLabel?.text = (row["value"] as! String)
            } else {
                detailTextLabel?.text = ""
            }
            accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        } else {
            detailTextLabel?.text = ""
            generalTextField.isHidden = false
            if row["value"] != nil {
                var value: String = ""
                if row["vtype"] as! String == "Int" {
                    let tmp: Int = row["value"] as! Int
                    value = tmp < 0 ? "" : String(tmp)
                } else {
                    value = row["value"] as! String
                }
                generalTextField.text = value
            }
            accessoryType = UITableViewCellAccessoryType.none
        }
        textLabel?.text = (row["text"] as! String)
        setNeedsLayout()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //print("tag: \(textField.tag)")
        //print("text: \(textField.text)")
        delegate?.setTextField(idx: textField.tag, value: textField.text!)
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
