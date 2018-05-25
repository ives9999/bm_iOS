//
//  ValidateVC.swift
//  bm
//
//  Created by ives on 2018/5/24.
//  Copyright © 2018年 bm. All rights reserved.
//

import UIKit

class ValidateVC: BaseViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var codeTxt: SuperTextField!
    var type: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if type == "email" {
            titleLbl.text = "email認證"
        } else if type == "mobile" {
            titleLbl.text = "手機認證"
        }
    }

    @IBAction func submit(_ sender: Any) {
    }
    @IBAction func prevBtnPressed(_ sender: Any) {
        prev()
    }

}
