//
//  SelectManagers.swift
//  bm
//
//  Created by ives on 2020/11/28.
//  Copyright © 2020 bm. All rights reserved.
//

import Foundation

protocol SelectManagersDelegate: SelectDelegate {
    func selectedManagers(selecteds: [String])
}

class SelectManagersVC: SelectVC, UITextFieldDelegate {
    
    var selecteds: [String] = [String]()
    var delegate: SelectManagersDelegate?
    
    private var dropDown: DropDownTextField!
    private var flavourOptions: [String] = [String]()
    private var isKeywordStart: Bool = false
    private var keyword: String = ""
    
    override func viewDidLoad() {
        myTablView = tableView
        title = "管理者"
        
        super.viewDidLoad()
        
        self.view.layoutMargins = UIEdgeInsets(top: self.view.layoutMargins.top, left: 12.0, bottom: self.view.layoutMargins.bottom, right: 12.0)
        view.backgroundColor = UIColor.white
        addDropDown()
    }
    
    private func addDropDown() {
        
        let lm = view.layoutMargins
        let height: CGFloat = 40.0
        let dropDownFrame = CGRect(
            x: lm.left,
            y: lm.top + 90,
            width: view.bounds.width - (2 * lm.left),
            height: 300
        )
        dropDown = DropDownTextField(frame: dropDownFrame, title: "", options: flavourOptions)
        dropDown.delegate = self
        dropDown.textField.delegate = self
        
        view.addSubview(dropDown)
    }
    
    //按下鍵盤鍵的return鍵時，收到的事件
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //self.view.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //print("begin edit")
        keyword = textField.text ?? ""
        isKeywordStart = true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        keyword = keyword + string
//        print("all: \(dropDown.textField.text!.count)")
//        print("original: \(keyword)")
//        print("new: \(string)")
        //print(keyword.count)
        if keyword.count > 1 {
            flavourOptions = ["Chocolate", "Vanilla", "StrawBerry", "Banana", "Lime"]
            dropDown.setOptions(flavourOptions)
        }
        
        return true
    }
    
    @IBAction func submit(_ sender: Any) {
        if delegate != nil {
            delegate!.selectedManagers(selecteds: selecteds)
            prev()
        } else {
            //alertError("由於傳遞參數不正確，無法做選擇，請回上一頁重新進入")
        }
    }
}

extension SelectManagersVC: DropDownTextFieldDelegate {
    
    func menuDidAnimate(up: Bool) {
        print("animating up; \(up)")
    }
    
    func optionSelected(option: String) {
        print("option selected: \(option)")
    }
}
