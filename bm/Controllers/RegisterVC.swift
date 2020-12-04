//
//  RegisterVC.swift
//  bm
//
//  Created by ives on 2017/10/27.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class RegisterVC: MyTableVC, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImagePickerViewDelegate {

    // Outlets
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var featuredView: ImagePickerView!
    @IBOutlet weak var submitBtn: SubmitButton!
    
    var imagePicker: UIImagePickerController = UIImagePickerController()
    
    //var sourceVC: MemberVC? = nil
    
    var section_keys: [[String]] = [[String]]()
    
    fileprivate var form: RegisterForm = RegisterForm()
    
    override func viewDidLoad() {
        myTablView = tableView
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
        //emailTxt.delegate = self
        //passwordTxt.delegate = self
        //rePasswordTxt.delegate = self
        
        imagePicker.delegate = self
        featuredView.gallery = imagePicker
        featuredView.delegate = self
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        hideKeyboardWhenTappedAround()
        FormItemCellType.registerCell(for: tableView)
        
        sections = form.getSections()
        section_keys = form.getSectionKeys()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section_keys[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = getFormItemFromIdx(indexPath)
        let cell: UITableViewCell
        if item != nil {
            if let cellType = item!.uiProperties.cellType {
                cell = cellType.dequeueCell(for: tableView, at: indexPath)
            } else {
                cell = UITableViewCell()
            }
            
            if let formUpdatableCell = cell as? FormUPdatable {
                item!.indexPath = indexPath
                formUpdatableCell.update(with: item!)
            }
        } else {
            cell = UITableViewCell()
        }
        
        return cell
    }
    
    func getFormItemFromIdx(_ indexPath: IndexPath)-> FormItem? {
        let key = section_keys[indexPath.section][indexPath.row]
        return getFormItemFromKey(key)
    }
    
    func getFormItemFromKey(_ key: String)-> FormItem? {
        var res: FormItem? = nil
        for formItem in form.formItems {
            if key == formItem.name {
                res = formItem
                break
            }
        }
        
        return res
    }
    
    func isImageSet(_ b: Bool) {}
    
    func myPresent(_ viewController: UIViewController) {
        self.present(viewController, animated: true, completion: nil)
    }

//    @IBAction func registerBtnPressed(_ sender: Any) {
//        let email = emailTxt.text!
//        let password = passwordTxt.text!
//        let rePassword = rePasswordTxt.text!
//        var bCheck: Bool = true
//
//        if email.count == 0 {
//            SCLAlertView().showWarning("警告", subTitle: "請填寫email")
//            bCheck = false
//        }
//        if password.count == 0 {
//            SCLAlertView().showWarning("警告", subTitle: "請填寫密碼")
//            bCheck = false
//        }
//        if password != rePassword {
//            SCLAlertView().showWarning("警告", subTitle: "密碼不符")
//            bCheck = false
//        }
//
//        if bCheck {
//            Global.instance.addSpinner(superView: self.view)
//            MemberService.instance.register(email: email, password: password, repassword: rePassword) { (success) in
//                Global.instance.removeSpinner(superView: self.view)
//                if success {
//                    //print("register ok: \(MemberService.instance.success)")
//                    if MemberService.instance.success {
//                        let appearance = SCLAlertView.SCLAppearance(
//                            showCloseButton: false
//                        )
//                        let alert = SCLAlertView(appearance: appearance)
//                        alert.addButton("確定", action: {
//                            self.dismiss(animated: true, completion: {
//                                if self.sourceVC != nil {
//                                    self.sourceVC!._loginout()
//                                }
//                            })
//                        })
//                        alert.showSuccess("成功", subTitle: "註冊成功，請儘速通過email認證，才能使用更多功能！！")
//                    } else {
//                        //print("login failed by error email or password")
//                        SCLAlertView().showError("警告", subTitle: MemberService.instance.msg)
//                    }
//                }
//            }
//        }
//    }
//    @IBAction func registerFBBtnPressed(_ sender: Any) {
//        Facebook.instance.login(viewController: self) {
//            (success) in
//            if success {
//                //print("login fb success")
//                //self._loginFB()
//                //Session.shared.loginReset = true
//                let playerID: String = self._getPlayerID()
//                Global.instance.addSpinner(superView: self.view)
//                MemberService.instance.login_fb(playerID: playerID, completion: { (success1) in
//                    Global.instance.removeSpinner(superView: self.view)
//                    if success1 {
//                        if MemberService.instance.success {
//                            self.dismiss(animated: true, completion: {
//                                if self.sourceVC != nil {
//                                    self.sourceVC!._loginout()
//                                }
//                            })
//                        } else {
//                            //print("login failed by error email or password")
//                            self.warning(MemberService.instance.msg)
//                        }
//                    } else {
//                        self.warning("使用FB註冊，但無法新增至資料庫，請洽管理員")
//                        //print("login failed by fb")
//                    }
//                })
//            } else {
//                print("login fb failure")
//            }
//        }
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func colseBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_LOGIN, sender: nil)
    }
    
    @IBAction func passwordBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_PASSWORD, sender: "forget_password")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == TO_PASSWORD {
            let vc: PasswordVC = segue.destination as! PasswordVC
            vc.type = sender as! String
        } else if segue.identifier == TO_LOGIN {
            //let vc: LoginVC = segue.destination as! LoginVC
            //vc.menuVC = (sender as! MenuVC)
        } else if segue.identifier == TO_REGISTER {
            //let vc: RegisterVC = segue.destination as! RegisterVC
            //vc.menuVC = (sender as! MenuVC)
        }
    }
    
//    func backToMenu() {
//        if self.menuVC != nil {
//            self.menuVC!._loginout()
//        }
//        self.performSegue(withIdentifier: UNWIND, sender: "refresh_team")
//    }
}

