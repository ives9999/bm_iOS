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

class SelectManagersVC: SelectVC {
    
    var selecteds: [String] = [String]()
    var delegate: SelectManagersDelegate?
    
    private var dropDown: DropDownTextField!
    private var flavourOptions = ["Chocolate", "Vanilla", "StrawBerry", "Banana", "Lime"]
    
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
            height: height
        )
        dropDown = DropDownTextField(frame: dropDownFrame, title: "Select Flavour", options: flavourOptions)
        dropDown.delegate = self
        
        view.addSubview(dropDown)
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
