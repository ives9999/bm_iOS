//
//  EditProfileVC.swift
//  bm
//
//  Created by ives on 2017/11/8.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import SCLAlertView

class EditProfileVC1: UIViewController {
    
    // Outlets
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var headerView: UIView!
    
    var dataTxt: SuperTextField!
    var dataSwitch: Switch!
    var datePicker: UIDatePicker!
    var submitBtn: SuperButton!
    
    var submitBtnConstraintTopTxt: NSLayoutConstraint!
    var submitBtnConstraintTopSwitch: NSLayoutConstraint!
    var submitBtnConstraintTopDatePicker: NSLayoutConstraint!
    
    var key: String = ""
    var model: Member!
    var allSEX: [[String: String]]!
    var value: String!
    var delegate: ProfileVC1?

    override func viewDidLoad() {
        super.viewDidLoad()
        //print(key)

        model = Member.instance
        
        _initDataTxt()
        _initDataSwitch()
        _initDatePicker()
        _initSubmitBtn()
        
//        if let row: [String: String] = model.info[key] {
//            //print(row)
//            titleLbl.text = row["ch"]
//            let data: Any = model.getData(key: key)
//            //print(tmp)
//            var oldValue: String?
//            let type = row["type"]
//            if type == "String" {
//                oldValue = (data as! String)
//                value = oldValue
//            }
//            if key == SEX_KEY {
//                let selected: String = (oldValue == allSEX[0]["key"]) ? "left" : "right"
//                setDataSwitch(left: allSEX[0]["value"]!, right: allSEX[1]["value"]!, selected: selected)
//                
//                dataTxt.isHidden = true
//                datePicker.isHidden = true
//                dataSwitch.isHidden = false
//                submitBtnConstraintTopTxt.isActive = false
//                submitBtnConstraintTopSwitch.isActive = true
//                submitBtnConstraintTopDatePicker.isActive = false
//            } else if key == DOB_KEY {
//                if oldValue?.count == 0 {
//                    oldValue = "2000-01-01"
//                }
//                setDatePicker(startDate: oldValue!)
//                
//                dataTxt.isHidden = true
//                datePicker.isHidden = false
//                dataSwitch.isHidden = true
//                submitBtnConstraintTopTxt.isActive = false
//                submitBtnConstraintTopSwitch.isActive = false
//                submitBtnConstraintTopDatePicker.isActive = true
//            } else if key == EMAIL_KEY {
//                dataTxt.isHidden = false
//                datePicker.isHidden = true
//                dataSwitch.isHidden = true
//                submitBtnConstraintTopTxt.isActive = true
//                submitBtnConstraintTopSwitch.isActive = false
//                submitBtnConstraintTopDatePicker.isActive = false
//                dataTxt.text = oldValue!
//                dataTxt.keyboardType = UIKeyboardType.emailAddress
//            } else if key == MOBILE_KEY {
//                dataTxt.isHidden = false
//                datePicker.isHidden = true
//                dataSwitch.isHidden = true
//                submitBtnConstraintTopTxt.isActive = true
//                submitBtnConstraintTopSwitch.isActive = false
//                submitBtnConstraintTopDatePicker.isActive = false
//                dataTxt.text = oldValue!
//                dataTxt.keyboardType = UIKeyboardType.numberPad
//            } else if key == TEL_KEY {
//                dataTxt.isHidden = false
//                datePicker.isHidden = true
//                dataSwitch.isHidden = true
//                submitBtnConstraintTopTxt.isActive = true
//                submitBtnConstraintTopSwitch.isActive = false
//                submitBtnConstraintTopDatePicker.isActive = false
//                dataTxt.text = oldValue!
//                dataTxt.keyboardType = UIKeyboardType.numberPad
//            } else {
//                dataTxt.isHidden = false
//                datePicker.isHidden = true
//                dataSwitch.isHidden = true
//                submitBtnConstraintTopTxt.isActive = true
//                submitBtnConstraintTopSwitch.isActive = false
//                submitBtnConstraintTopDatePicker.isActive = false
//                dataTxt.text = oldValue!
//            }
//        }
        Global.instance.addSpinner(superView: view)
        Global.instance.removeSpinner(superView: view)
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func _initDataTxt() {
        dataTxt = SuperTextField()
        view.addSubview(dataTxt)
        dataTxt.isHidden = true
        
        var c1:NSLayoutConstraint,c2:NSLayoutConstraint,c3:NSLayoutConstraint,c4:NSLayoutConstraint
        c1 = NSLayoutConstraint(item: dataTxt, attribute: .top, relatedBy: .equal, toItem: headerView, attribute: .bottom, multiplier: 1, constant: 40)
        c2 = NSLayoutConstraint(item: dataTxt, attribute: .leading, relatedBy: .equal, toItem: dataTxt.superview, attribute: .leading, multiplier: 1, constant: 12)
        c3 = NSLayoutConstraint(item: dataTxt, attribute: .trailing, relatedBy: .equal, toItem: dataTxt.superview, attribute: .trailing, multiplier: 1, constant: -12)
        c4 = NSLayoutConstraint(item: dataTxt, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
        dataTxt.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([c1,c2,c3,c4])
    }
    private func _initDataSwitch() {
        allSEX = SEX.all()
        dataSwitch = Switch()
        dataSwitch.tintColor = UIColor.black
        //dataSwitch.disabledColor = dataSwitch.tintColor.withAlphaComponent(0.4)
        //dataSwitch.backColor = dataSwitch.tintColor.withAlphaComponent(0.05)
        dataSwitch.backColor = UIColor.gray
        dataSwitch.disabledColor = UIColor.white
        dataSwitch.onColor = UIColor(MY_GREEN)
        //dataSwitch.sizeToFit()
        dataSwitch.addTarget(self, action: #selector(switchDidChangeValue(_:)), for: .valueChanged)

        view.addSubview(dataSwitch)
        dataSwitch.isHidden = true
        
        var c1:NSLayoutConstraint,c2:NSLayoutConstraint,c3:NSLayoutConstraint,c4:NSLayoutConstraint
        c1 = NSLayoutConstraint(item: dataSwitch, attribute: .top, relatedBy: .equal, toItem: headerView, attribute: .bottom, multiplier: 1, constant: 40)
        c2 = NSLayoutConstraint(item: dataSwitch, attribute: .centerX, relatedBy: .equal, toItem: dataSwitch.superview, attribute: .centerX, multiplier: 1, constant: 0)
        c3 = NSLayoutConstraint(item: dataSwitch, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)
        c4 = NSLayoutConstraint(item: dataSwitch, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
        dataSwitch.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([c1,c2,c3,c4])
    }
    private func setDataSwitch(left: String, right: String, selected: String) {
        dataSwitch.leftText = left
        dataSwitch.rightText = right
        dataSwitch.rightSelected = (selected == "right")
    }
    
    @objc func switchDidChangeValue(_ sender: Switch) {
        let selected: String = ((sender.rightSelected) ? sender.rightText : sender.leftText)!
        //print(choose)
        if key == "sex" {
            for item in allSEX {
                if item["value"] == selected {
                    value = item["key"]
                }
            }
        }
        //print(value)
    }
    
    private func _initDatePicker() {
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        let startDate: Date = "1920-01-01".toDateTime(format: "yyyy-MM-dd")
        datePicker.minimumDate = startDate
        datePicker.maximumDate = Date()
        datePicker.locale = Locale(identifier: "zh_TW")
        datePicker.backgroundColor = UIColor("#1E1F22")
        //datePicker.setValue(UIColor.red, forKey: "textColor")
        //datePicker.setValue(UIColor.red, forKeyPath: "textColor")
        //datePicker.setValue(false, forKeyPath: "highlightsToday")
        
        datePicker.addTarget(self, action: #selector(dateDidChange(_:)), for: .valueChanged)
        
        view.addSubview(datePicker)
        datePicker.isHidden = true
        
        var c1:NSLayoutConstraint,c2:NSLayoutConstraint,c3:NSLayoutConstraint,c4:NSLayoutConstraint
        c1 = NSLayoutConstraint(item: datePicker, attribute: .top, relatedBy: .equal, toItem: headerView, attribute: .bottom, multiplier: 1, constant: 40)
        c2 = NSLayoutConstraint(item: datePicker, attribute: .leading, relatedBy: .equal, toItem: datePicker.superview, attribute: .leading, multiplier: 1, constant: 12)
        c3 = NSLayoutConstraint(item: datePicker.superview!, attribute: .trailing, relatedBy: .equal, toItem: datePicker, attribute: .trailing, multiplier: 1, constant: 12)
        c4 = NSLayoutConstraint(item: datePicker, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 120)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([c1,c2,c3,c4])
    }
    private func setDatePicker(startDate: String) {
        let dob: Date = startDate.toDateTime(format: "yyyy-MM-dd")
        datePicker.date = dob
        value = startDate
    }
    @objc func dateDidChange(_ sender: Any) {
        value = datePicker.date.toString()
    }
    private func _initSubmitBtn() {
        submitBtn = SubmitButton()
        //submitBtn.alignH = .center
        //submitBtn.setTitle("送出", for: .normal)
        submitBtn.addTarget(self, action: #selector(submitBtnPressed(_:)), for: .touchUpInside)
        
        view.addSubview(submitBtn)
        
        var c2:NSLayoutConstraint,c3:NSLayoutConstraint,c4:NSLayoutConstraint
        submitBtnConstraintTopTxt = NSLayoutConstraint(item: submitBtn, attribute: .top, relatedBy: .equal, toItem: dataTxt, attribute: .bottom, multiplier: 1, constant: 18)
        submitBtnConstraintTopSwitch = NSLayoutConstraint(item: submitBtn, attribute: .top, relatedBy: .equal, toItem: dataSwitch, attribute: .bottom, multiplier: 1, constant: 18)
        submitBtnConstraintTopDatePicker = NSLayoutConstraint(item: submitBtn, attribute: .top, relatedBy: .equal, toItem: datePicker, attribute: .bottom, multiplier: 1, constant: 18)
        c2 = NSLayoutConstraint(item: submitBtn, attribute: .centerX, relatedBy: .equal, toItem: dataSwitch.superview, attribute: .centerX, multiplier: 1, constant: 0)
        c3 = NSLayoutConstraint(item: submitBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 120)
        c4 = NSLayoutConstraint(item: submitBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
        
        submitBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([submitBtnConstraintTopTxt,submitBtnConstraintTopSwitch,submitBtnConstraintTopDatePicker,c2,c3,c4])
        submitBtnConstraintTopTxt.isActive = true
        submitBtnConstraintTopSwitch.isActive = false
        submitBtnConstraintTopDatePicker.isActive = false
    }
    @objc func submitBtnPressed(_ sender: Any) {
        var _continue: Bool = true
        if (key == EMAIL_KEY || key == MOBILE_KEY) {
            _continue = false
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let alert = SCLAlertView(appearance: appearance)
            alert.addButton("確定", action: {
                self.continueSubmit()
            })
            alert.addButton("取消", action: {
            })
            let type: String = (key == EMAIL_KEY) ? "EMail" : "行動電話"
            alert.showWarning("警告", subTitle: "修改\(type)需要重新認證，是否確定要修改")
        }
        
        if (_continue) {
            self.continueSubmit()
        }
    }
    
    func continueSubmit() {
        Global.instance.addSpinner(superView: self.view)
        if key != "sex" && key != "dob" {
            value = dataTxt.text
        }
        var value1: String = value
//        MemberService.instance.update(id: Member.instance.id, field: key, value: &value1) { (success) in
//            Global.instance.removeSpinner(superView: self.view)
//            if success {
//                //print(MemberService.instance.success)
//                if MemberService.instance.success {
//                    let appearance = SCLAlertView.SCLAppearance(
//                        showCloseButton: false
//                    )
//                    let alert = SCLAlertView(appearance: appearance)
//                    alert.addButton("確定", action: {
//                        if self.delegate != nil {
//                            self.delegate!.refresh()
//                        }
//                        self.dismiss(animated: true, completion: nil)
//                    })
//                    alert.showSuccess("成功", subTitle: "修改個人資料成功")
//                } else {
//                    SCLAlertView().showError("錯誤", subTitle: MemberService.instance.msg)
//                }
//            } else {
//                SCLAlertView().showError("錯誤", subTitle: "更新錯誤")
//            }
//        }
    }
}






