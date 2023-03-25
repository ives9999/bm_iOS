//
//  LoginVC.swift
//  bm
//
//  Created by ives on 2017/10/26.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import SCLAlertView
//import FBSDKLoginKit

class LoginVC: BaseViewController, UITextFieldDelegate {
    
//    var memberVC: MemberVC? = nil
//
//    // outlets
//    @IBOutlet weak var emailTxt: SuperTextField!
//    @IBOutlet weak var passwordTxt: SuperTextField!
//    @IBOutlet weak var submitBtn: SubmitButton!
//    @IBOutlet weak var forgetPasswordBtn: UIButton!
//    @IBOutlet weak var registerBtn: UIButton!
    //@IBOutlet weak var facebookLogin: FBLoginButton!
    
    var showTop2: ShowTop2?
    
    let loginLbl: SuperLabel = {
        let view: SuperLabel = SuperLabel()
        view.setTextBoldAndSize(24)
        view.text = "登入"
        
        return view
    }()
    
    let descLbl: SuperLabel = {
        let view: SuperLabel = SuperLabel()
        view.setTextGeneral()
        view.text = "請輸入email與密碼來登入"
        
        return view
    }()
    
    let emailTxt2: MainTextField2 = {
        let view: MainTextField2 = MainTextField2(label: "Email", icon: "email_svg", placeholder: "davie@gmail.com", keyboard: KEYBOARD.emailAddress)
        
        return view
    }()
    
    let passwordTxt2: MainTextField2 = {
        let view: MainTextField2 = MainTextField2(label: "密碼", icon: "password_svg", placeholder: "密碼", isShowDelete: false, isPassword: true)
        
        return view
    }()
    
    let forgetPasswordLbl: SuperLabel = {
        let view: SuperLabel = SuperLabel()
        view.setTextSize(14)
        view.setTextColor(TEXT_WHITE40)
        view.text = "忘記密碼？"
        
        return view
    }()
    
    let registerContainer: UIView = UIView()
    let registerDescLbl: SuperLabel = {
        let view: SuperLabel = SuperLabel()
        view.setTextSize(14)
        view.setTextColor(TEXT_WHITE40)
        view.text = "還沒有帳號？"
        
        return view
    }()
    let registerLbl: SuperLabel = {
        let view: SuperLabel = SuperLabel()
        view.setTextSize(16)
        view.setTextColor(UIColor(MY_GREEN))
        view.text = "註冊"
        
        return view
    }()
    
    let submitButton: SubmitButton = SubmitButton()
    
    var table: MemberTable?
    
    var registerPadding: CGFloat = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        showTop2 = ShowTop2(delegate: self)
        showTop2!.anchor(parent: self.view)
        showTop2!.setTitle(title: "登入")
        
        let forgetPasswordGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(forgetPassword(_:)))
        forgetPasswordLbl.addGestureRecognizer(forgetPasswordGR)
        
        let w1:CGFloat = registerDescLbl.intrinsicContentSize.width
        let w2:CGFloat = registerLbl.intrinsicContentSize.width
        registerPadding = (screen_width - (w1 + w2))/2
        
        let registerGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(register(_:)))
        registerLbl.addGestureRecognizer(registerGR)
        
        emailTxt2.setValue("ives@bluemobile.com.tw")
        passwordTxt2.setValue("K5SD23r6")
        
        anchor()
        
        submitButton.delegate = self
        
//        emailTxt.backgroundColor = UIColor(SEARCH_BACKGROUND)
//        emailTxt.attributedPlaceholder = NSAttributedString(
//            string: "EMail",
//            attributes: [NSAttributedString.Key.foregroundColor: UIColor(SEARCH_BACKGROUND_PLACEHOLDER)]
//        )
//        emailTxt.keyboardType = .emailAddress
//
//        passwordTxt.backgroundColor = UIColor(SEARCH_BACKGROUND)
//        passwordTxt.attributedPlaceholder = NSAttributedString(
//            string: "密碼",
//            attributes: [NSAttributedString.Key.foregroundColor: UIColor(SEARCH_BACKGROUND_PLACEHOLDER)]
//        )
//        passwordTxt.isSecureTextEntry = true
//
//        emailTxt.delegate = self
//        passwordTxt.delegate = self
//
//        forgetPasswordBtn.setTitleColor(UIColor(MY_GRAY), for: .normal)
//        registerBtn.setTitleColor(UIColor(MY_GREEN), for: .normal)
        
        //emailTxt.align(.left)
        //emailTxt.borderWidth(0)
        //emailTxt.backgroundColor = UIColor.clear
        //passwordTxt.align(.left)
        //passwordTxt.borderWidth(0)
        //passwordTxt.backgroundColor = UIColor.clear

//        emailTxt.text = "ives@housetube.tw"
//        passwordTxt.text = "K5SD23r6"
    }
    
    func anchor() {
        self.view.addSubview(loginLbl)
        loginLbl.snp.makeConstraints { make in
            make.top.equalTo(showTop2!.snp.bottom).offset(100)
            make.left.equalToSuperview().offset(20)
        }
        
        self.view.addSubview(descLbl)
        descLbl.snp.makeConstraints { make in
            make.top.equalTo(loginLbl.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(20)
        }
        
        self.view.addSubview(emailTxt2)
        emailTxt2.snp.makeConstraints { make in
            make.top.equalTo(descLbl.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        self.view.addSubview(passwordTxt2)
        passwordTxt2.snp.makeConstraints { make in
            make.top.equalTo(emailTxt2.snp.bottom).offset(26)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        self.view.addSubview(forgetPasswordLbl)
        forgetPasswordLbl.snp.makeConstraints { make in
            make.top.equalTo(passwordTxt2.snp.bottom).offset(15)
            make.right.equalToSuperview().offset(-20)
        }
        
        self.view.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(forgetPasswordLbl.snp.bottom).offset(65)
            make.centerX.equalToSuperview()
            make.width.equalTo(335)
            make.height.equalTo(52)
        }
        
        self.view.addSubview(registerContainer)
        registerContainer.snp.makeConstraints { make in
            make.top.equalTo(submitButton.snp.bottom).offset(25)
            make.left.right.equalToSuperview()
            make.height.equalTo(20)
        }
        
        registerContainer.addSubview(registerDescLbl)
        registerDescLbl.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(registerPadding)
        }
        registerContainer.addSubview(registerLbl)
        registerLbl.snp.makeConstraints { make in
            make.left.equalTo(registerDescLbl.snp.right)
            make.centerY.equalTo(registerDescLbl.snp.centerY)
        }
    }
    
    @objc func forgetPassword(_ sender: UITapGestureRecognizer) {
        toPassword(type: "forget_password")
    }
    
    @objc func register(_ sender: UITapGestureRecognizer) {
        toRegister()
    }

//    @IBAction func prevBtnPressed(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
//    }
//    @IBAction func closeBtnPressed(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
//    }
    
//    @objc override func submit() {
//
//    }
    
//    @IBAction func loginFBBtnPressed(_ sender: Any) {
//
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
//                        self.warning("使用FB登入，但無法新增至資料庫，請洽管理員")
//                        //print("login failed by fb")
//                    }
//                })
//            } else {
//                print("login fb failure")
//            }
//        }
//    }
    
//    @IBAction func registerBtnPressed(_ sender: Any) {
//        toRegister()
//    }
//    @IBAction func passwordBtnPressed(_ sender: Any) {
//        performSegue(withIdentifier: TO_PASSWORD, sender: "forget_password")
//    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == TO_PASSWORD {
//            let vc: PasswordVC = segue.destination as! PasswordVC
//            vc.type = sender as? String
//        } else if segue.identifier == UNWIND {
//            //let vc: MenuVC = segue.destination as! MenuVC
//        } else if segue.identifier == TO_LOGIN {
//            //let vc: LoginVC = segue.destination as! LoginVC
//            //vc.menuVC = (sender as! MenuVC)
//        } else if segue.identifier == TO_REGISTER {
//            //let vc: RegisterVC = segue.destination as! RegisterVC
//            //vc.menuVC = (sender as! MenuVC)
//        }
//    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.view.endEditing(true)
//        return true
//    }
    
//    func backToMenu() {
//        if self.menuVC != nil {
//            self.menuVC!._loginout()
//        }
//        self.performSegue(withIdentifier: UNWIND, sender: "refresh_team")
//    }
}

extension LoginVC: SubmitButtonDelegate {
    
    func submit2() {
        let email = emailTxt2.text
        let password = passwordTxt2.text
        //print(email)
        if email.count == 0 {
            SCLAlertView().showWarning("警告", subTitle: "請填寫email")
            return
        }
        if password.count == 0 {
            SCLAlertView().showWarning("警告", subTitle: "請填寫密碼")
            return
        }
        let playerID: String = _getPlayerID()
        Global.instance.addSpinner(superView: self.view)
        MemberService.instance.login(email: email, password: password, playerID: playerID) { (success) in
            Global.instance.removeSpinner(superView: self.view)
            if success {

                let jsonData: Data = MemberService.instance.jsonData!
                do {
                    let successTable: SuccessTable = try JSONDecoder().decode(SuccessTable.self, from: jsonData)

                    if (!successTable.success) {
                        self.warning(successTable.msg)
                    } else {
                        self.table = try JSONDecoder().decode(MemberTable.self, from: jsonData)
                        if (self.table != nil) {
                            //self.table?.printRow()
                            self.table!.toSession(isLoggedIn: true)
                            //self.session.dump()
                            self.toMember()

//                            self.dismiss(animated: true, completion: {
//                                self.toMember()
//                            })
                        }


                    }
                } catch {
                    self.warning(error.localizedDescription)
                }

            } else {
                //print("login failed by server")
                let appearance = SCLAlertView.SCLAppearance(
                    showCloseButton: false
                )
                let alert = SCLAlertView(appearance: appearance)
                alert.addButton("確定", action: {
                    self.performSegue(withIdentifier: UNWIND, sender: nil)
                })
                alert.showWarning("警告", subTitle: MemberService.instance.msg)
            }
        }
    }
}






