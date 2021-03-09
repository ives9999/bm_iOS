//
//  EditCell.swift
//  bm
//
//  Created by ives on 2018/11/10.
//  Copyright © 2018 bm. All rights reserved.
//

import UIKit

protocol EditCellDelegate {
    func setTextField(iden: String, value: String)
    func setSwitch(indexPath: IndexPath, value: Bool)
    func clear(indexPath: IndexPath)
}

class EditCell: SuperCell, UITextFieldDelegate {
    
    @IBOutlet weak var titleLbl: SuperLabel!
    @IBOutlet weak var detailLbl: SuperLabel!
    @IBOutlet weak var clearBtn: SuperButton!
    @IBOutlet weak var moreImageView: UIImageView!
    @IBOutlet weak var editText: SuperTextField!
    @IBOutlet weak var onoff: SuperSwitch!
    
    var iden: String = ""
    var editCellDelegate: EditCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLbl.textAlignment = NSTextAlignment.left
        detailLbl.textAlignment = NSTextAlignment.right
        editText.delegate = self
        onoff.addTarget(self, action: #selector(switchDidValueChanged(sender:)), for: .valueChanged)
        clearBtn.padding(top: 0, left: 0, bottom: 0, right: 0)
        clearBtn.addTarget(self, action: #selector(clearBtnPressed(sender:)), for: .touchUpInside)
    }

    func forRow(indexPath:IndexPath, row: [String: Any], isClear: Bool=false) {
        //print(row)
        //generalTextField.tag = row["idx"] as! Int
        clearBtn.isHidden = !isClear
        clearBtn.indexPath = indexPath
        iden = row["key"] as! String
        
        if row["text_field"] != nil && (row["text_field"] as! Bool) {
            //detailLbl.text = ""
            editText.isHidden = false
            onoff.isHidden = true
            moreImageView.isHidden = true
            //editText.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: .editingDidBegin)
            editText.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingChanged)
            
            var vType = "String"
            if row["vtype"] != nil {
                vType = row["vtype"] as! String
            }
            if row["keyboardType"] != nil {
                let pad: UIKeyboardType = row["keyboardType"] as! UIKeyboardType
                editText.keyboardType = pad
            }
            if row["hint"] != nil {
                editText.placeholder(row["hint"] as! String)
            }
            //print(iden)
            if row["value"] != nil {
                var text = ""
                if vType == "Int" {
                    let tmp = row["value"] as! Int
                    text = String(tmp)
                    if text == "-1" {
                        text = ""                        
                    }
                } else {
                    text = row["value"] as! String
                }
                editText.text = text
            }
        }
        if row["switch"] != nil && (row["switch"] as! Bool) {
            editText.isHidden = true
            onoff.isHidden = false
            onoff.indexPath = indexPath
            clearBtn.isHidden = true
        }
        if row["atype"] != nil {
            if row["atype"] as! UITableViewCell.AccessoryType != UITableViewCell.AccessoryType.none {
                editText.isHidden = true
                onoff.isHidden = true
                detailLbl.isHidden = false
                if row["show"] != nil {
                    detailLbl.text = (row["show"] as! String)
                } else {
                    detailLbl.text = ""
                }
                moreImageView.isHidden = false
            }
        }
        if row["ch"] != nil {
            titleLbl.text = (row["ch"] as! String)
        }
        if row["title"] != nil {
            titleLbl.text = (row["title"] as! String)
        }
        setNeedsLayout()
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        print("start edit")
//    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //print("tag: \(iden)")
        //print("text: \(textField.text)")
        editCellDelegate?.setTextField(iden: iden, value: textField.text!)
    }
    
    @objc func switchDidValueChanged(sender: UISwitch) {
        let _sender = sender as! SuperSwitch
        editCellDelegate?.setSwitch(indexPath: _sender.indexPath!, value: _sender.isOn)
    }
    
    @objc func clearBtnPressed(sender: UIButton) {
        let _sender = sender as! SuperButton
        //print(_sender.indexPath?.section)
        //print(_sender.indexPath?.row)
        editText.text = ""
        detailLbl.text = "全部"
        editCellDelegate?.clear(indexPath: _sender.indexPath!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
