//
//  TextVC.swift
//  bm
//
//  Created by ives on 2017/11/15.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

protocol TextInputDelegate: class {
    func setTextInputData(key: String, type: TEXT_INPUT_TYPE, text: String)
}

class TextInputVC: UIViewController {
    
    weak var delegate: TextInputDelegate?
    var input: [String: Any]?
    var key: String = CONTENT_KEY

    @IBOutlet weak var content: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var type = TEXT_INPUT_TYPE.charge
        if input!["type"] != nil {
            type = input!["type"] as! TEXT_INPUT_TYPE
        }
        var text = ""
        if input!["text"] != nil {
            text = input!["text"] as! String
        }
        title = type.rawValue
        content.text = text
        
        content.layer.borderWidth = 1.0
        content.layer.borderColor = UIColor(TEXTBORDER).cgColor

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(back))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "提交", style: .plain, target: self, action: #selector(submit))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        
        content.becomeFirstResponder()
    }
    @objc func back() {
        dismiss(animated: true, completion: nil)
    }
    @objc func submit() {
        
        if content.text!.count == 0 {
            SCLAlertView().showWarning("警告", subTitle: "沒有選擇星期日期，或請按取消回上一頁")
        } else {
            let type: TEXT_INPUT_TYPE = input!["type"] as! TEXT_INPUT_TYPE
            self.delegate?.setTextInputData(key: key, type: type, text: content.text!)
            back()
        }
    }
}
