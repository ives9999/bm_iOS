//
//  EditProfileVC.swift
//  bm
//
//  Created by ives on 2017/11/8.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import SCLAlertView

class EditProfileVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dataTxt: UITextField!
    
    var key: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        if let row: [String: String] = Member.instance.info[key] {
            //print(row)
            
            dataTxt.layer.borderWidth = 2.0
            dataTxt.layer.borderColor = UIColor("#4b4b4b").cgColor
            dataTxt.backgroundColor = UIColor.black
            dataTxt.textColor = UIColor.white
            
            titleLbl.text = row["ch"]
            let type = row["type"]
            if let tmp: Any = Member.instance.getData(key: key) {
                if type == "String" {
                    dataTxt.text = tmp as! String
                }
            }
        }
    }

    @IBAction func saveBtnPressed(_ sender: Any) {
        Global.instance.addSpinner(superView: self.view)
        MemberService.instance.update(id: Member.instance.id, field: key, value: &dataTxt.text!) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if success {
                if MemberService.instance.success {
                    let appearance = SCLAlertView.SCLAppearance(
                        showCloseButton: false
                    )
                    let alert = SCLAlertView(appearance: appearance)
                    alert.addButton("確定", action: {
                        self.dismiss(animated: true, completion: nil)
                    })
                    alert.showSuccess("成功", subTitle: "修改個人資料成功")
                } else {
                    SCLAlertView().showError("錯誤", subTitle: MemberService.instance.msg)
                }
            }
            
        }
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
