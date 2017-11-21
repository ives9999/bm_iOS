//
//  TextVC.swift
//  bm
//
//  Created by ives on 2017/11/15.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import SCLAlertView
import UIColor_Hex_Swift

protocol TextInputDelegate: class {
    func setTextInputData(text: String, type: TEXT_INPUT_TYPE)
}

class TextInputVC: UIViewController {
    
    weak var delegate: TextInputDelegate?
    var type: TEXT_INPUT_TYPE = TEXT_INPUT_TYPE.team
    @IBOutlet weak var textTxt: SuperTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var title: String = ""
        switch type {
        case .temp_play:
            title = "臨打說明"
            break
        case .charge:
            title = "收費說明"
            break
        case .team:
            title = "球隊說明"
            break
        }
        self.title = title
        
        textTxt.layer.borderWidth = 1.0
        textTxt.layer.borderColor = UIColor(TEXTBORDER).cgColor

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(back))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "提交", style: .plain, target: self, action: #selector(submit))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        
        textTxt.becomeFirstResponder()
    }
    @objc func back() {
        dismiss(animated: true, completion: nil)
    }
    @objc func submit() {
        
        if textTxt.text!.count == 0 {
            SCLAlertView().showWarning("警告", subTitle: "沒有選擇星期日期，或請按取消回上一頁")
        } else {
            self.delegate?.setTextInputData(text: textTxt.text!, type: type)
            back()
        }
    }
}
