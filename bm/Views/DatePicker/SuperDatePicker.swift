//
//  SuperDatePicker.swift
//  bm
//
//  Created by ives on 2019/1/18.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit

class SuperDatePicker: UIDatePicker {

    var isChanged = false
    override func addSubview(_ view: UIView) {
        //if !isChanged {
            isChanged = true
        self.backgroundColor = UIColor.white
        self.setValue(UIColor.red, forKey: "textColor")
        //self.datePickerStyle =
        //self.backgroundColor = UIColor(DARKBACKGROUND)
            //self.setValue(UIColor.white, forKey: "textColor")
            //self.setValue(false, forKey: "highlightsToday")
        //}
        super.addSubview(view)
    }

}
