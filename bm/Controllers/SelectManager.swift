//
//  SelectManagers.swift
//  bm
//
//  Created by ives on 2020/11/28.
//  Copyright © 2020 bm. All rights reserved.
//

import Foundation

class SelectManagerVC: SelectVC, UITextFieldDelegate {
    
    @IBOutlet var manager_tokenField: SuperTextField!
    @IBOutlet var clearBtn: UIButton!
    @IBOutlet var nicknameLbl: SuperLabel!
    @IBOutlet var emailLbl: SuperLabel!
    @IBOutlet var mobileLbl: SuperLabel!
    @IBOutlet var memberStackView: UIStackView!
    @IBOutlet var submitBtn: SubmitButton!
    @IBOutlet var cancelBtn: CancelButton!
    
    var selected: Int = 0
    var delegate: BaseViewController?
    var manager_id: Int = 0
    var manager_token: String = ""
    
    var managerTable: MemberTable?
    
//    private var dropDown: DropDownTextField!
//    private var flavourOptions: [String] = [String]()
//    private var isKeywordStart: Bool = false
//    private var keyword: String = ""
    
    override func viewDidLoad() {
        myTablView = tableView
        title = "管理者"
        
        super.viewDidLoad()
        
        manager_tokenField.text = manager_token
        clearBtn.setTitle("", for: .normal)
        
        memberStackView.isHidden = true
        submitBtn.isHidden = true
        cancelBtn.isHidden = true
        
        //self.view.layoutMargins = UIEdgeInsets(top: self.view.layoutMargins.top, left: 12.0, bottom: self.view.layoutMargins.bottom, right: 12.0)
        //view.backgroundColor = UIColor.white
        //addDropDown()
    }
    
    func getMemberOne(token: String) {
        
        Global.instance.addSpinner(superView: self.view)
        MemberService.instance.getOne(params: ["token": token]) { success in
            
            Global.instance.removeSpinner(superView: self.view)
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            if success {
                
                let jsonData: Data = MemberService.instance.jsonData!
                do {
                    let successTable: SuccessTable = try JSONDecoder().decode(SuccessTable.self, from: jsonData)
                    if successTable.success {
                        self.managerTable = try JSONDecoder().decode(MemberTable.self, from: jsonData)
                        if self.managerTable != nil {
                            
                            self.manager_id = self.managerTable!.id
                            self.manager_token = self.managerTable!.token
                            self.nicknameLbl.text = self.managerTable!.nickname
                            self.emailLbl.text = self.managerTable!.email
                            self.mobileLbl.text = self.managerTable!.mobile
                            
                            self.memberStackView.isHidden = false
                            self.submitBtn.isHidden = false
                            self.cancelBtn.isHidden = false
                        }
                    } else {
                        self.warning("管理員金鑰錯誤，系統無此會員!!")
                    }
                    //self.managerTable = try JSONDecoder().decode(MemberTable.self, from: jsonData)
                    //let n = 6
                    
                } catch {
                    self.warning(error.localizedDescription)
                }
            } else {
                self.warning("取得會員資訊錯誤")
            }
        }
    }
    
//    private func addDropDown() {
//
//        let lm = view.layoutMargins
//        let height: CGFloat = 40.0
//        let dropDownFrame = CGRect(
//            x: lm.left,
//            y: lm.top + 90,
//            width: view.bounds.width - (2 * lm.left),
//            height: 300
//        )
//        dropDown = DropDownTextField(frame: dropDownFrame, title: "", options: flavourOptions)
//        //dropDown.delegate = self
//        //dropDown.textField.delegate = self
//
//        view.addSubview(dropDown)
//    }
    
    //按下鍵盤鍵的return鍵時，收到的事件
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //self.view.endEditing(true)
//        return true
//    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
        //print("begin edit")
//        keyword = textField.text ?? ""
//        isKeywordStart = true
//   }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //keyword = keyword + string
//        print("all: \(dropDown.textField.text!.count)")
//        print("original: \(keyword)")
//        print("new: \(string)")
        //print(keyword.count)
//        if keyword.count > 1 {
//            flavourOptions = ["Chocolate", "Vanilla", "StrawBerry", "Banana", "Lime"]
//            dropDown.setOptions(flavourOptions)
//        }
        
//        return true
//    }
    
    @IBAction func validate(_ sender: Any) {
        //memberStackView.isHidden = true
        let manager_token: String = manager_tokenField.text!
        getMemberOne(token: manager_token)
    }
    
    @IBAction func submit(_ sender: Any) {
        if delegate != nil && managerTable != nil {
            delegate!.selectedManager(selected: managerTable!.id, show: managerTable!.nickname, token: managerTable!.token)
            prev()
        } else {
            //alertError("由於傳遞參數不正確，無法做選擇，請回上一頁重新進入")
        }
    }
    
    @IBAction func clear(_ sender: Any) {
        manager_tokenField.text = ""
    }
}

//extension SelectManagersVC: DropDownTextFieldDelegate {
//
//    func menuDidAnimate(up: Bool) {
//        print("animating up; \(up)")
//    }
//
//    func optionSelected(option: String) {
//        print("option selected: \(option)")
//    }
//}
