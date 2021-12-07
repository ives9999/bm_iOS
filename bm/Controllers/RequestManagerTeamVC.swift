//
//  RequestManagerTeamVC.swift
//  bm
//
//  Created by ives on 2021/11/30.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation
import UIKit

class RequestManagerTeamVC: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImagePickerViewDelegate {
    
    @IBOutlet var teamNameClearBtn: UIButton!
    @IBOutlet var managerTokenClearBtn: UIButton!
    @IBOutlet var managerView: UIView!
    @IBOutlet var imageView: UIView!
    @IBOutlet var teamNameTF: SuperTextField!
    @IBOutlet var memberStackView: UIStackView!
    @IBOutlet var manager_tokenTF: SuperTextField!
    @IBOutlet var nicknameLbl: SuperLabel!
    @IBOutlet var emailLbl: SuperLabel!
    @IBOutlet var mobileLbl: SuperLabel!
    @IBOutlet var submitBtn: SubmitButton!
    @IBOutlet var cancelBtn: CancelButton!
    @IBOutlet var line2: UIView!
    
    @IBOutlet var teamImageView1: ImagePickerView!
    @IBOutlet var teamImageView2: ImagePickerView!
    
    var imagerPicker: MyImagePickerVC = MyImagePickerVC()
    
    var managerTable: MemberTable?
    
    override func viewDidLoad() {
        
        dataService = TeamService.instance
        able_type = "team"
        
        imagerPicker.delegate = self
        
        teamImageView1.gallery = imagerPicker
        teamImageView1.delegate = self
        teamImageView1.idx = 1
        
        teamImageView2.gallery = imagerPicker
        teamImageView2.delegate = self
        teamImageView2.idx = 2
        
        super.viewDidLoad()
        
        teamNameClearBtn.setTitle("", for: .normal)
        managerTokenClearBtn.setTitle("", for: .normal)
        
//        managerView.isHidden = true
//        line2.isHidden = true
//        imageView.isHidden = true
    }
    
    func checkManagerToken() {
        
        managerView.isHidden = false
        memberStackView.isHidden = true
    }
    
    @IBAction func isNameExist() {
        
        let teamName: String = teamNameTF.text ?? ""
        if teamName.count == 0 {
            warning("請填球隊名稱")
        } else {
            Global.instance.addSpinner(superView: self.view)
            dataService.isNameExist(name: teamName) { success in
                
                Global.instance.removeSpinner(superView: self.view)
                
                if success {
                    
                    let jsonData: Data = self.dataService.jsonData!
                    do {
                        let successTable: SuccessTable = try JSONDecoder().decode(SuccessTable.self, from: jsonData)
                        if successTable.success {
                            self.checkManagerToken()
                        } else {
                            self.warning("球隊名稱錯誤，系統無此球隊，須完全符合系統幫您建立的球隊名稱")
                        }
                    } catch {
                        self.warning(error.localizedDescription)
                    }
                } else {
                    self.warning("取得會員資訊錯誤")
                }
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImage: UIImage?
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
        }
        
        if selectedImage != nil {
            if let p: MyImagePickerVC = picker as? MyImagePickerVC {
                if p.idx == 1 {
                    teamImageView1.setPickedImage(image: selectedImage!)
                } else {
                    teamImageView2.setPickedImage(image: selectedImage!)
                }
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func isImageSet(_ b: Bool) {}
    
    func myPresent(_ viewController: UIViewController) {
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    func getMemberOne(token: String) {
        
        Global.instance.addSpinner(superView: self.view)
        MemberService.instance.getOne(params: ["token": token]) { success in
            
            Global.instance.removeSpinner(superView: self.view)
            
            if success {
                
                let jsonData: Data = MemberService.instance.jsonData!
                do {
                    let successTable: SuccessTable = try JSONDecoder().decode(SuccessTable.self, from: jsonData)
                    if successTable.success {
                        self.managerTable = try JSONDecoder().decode(MemberTable.self, from: jsonData)
                        if self.managerTable != nil {

                            self.nicknameLbl.text = self.managerTable!.nickname
                            self.emailLbl.text = self.managerTable!.email
                            self.mobileLbl.text = self.managerTable!.mobile

                            self.memberStackView.isHidden = false
                            self.line2.isHidden = false
                            self.imageView.isHidden = false
                            //self.submitBtn.isHidden = false
                            //self.cancelBtn.isHidden = false
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
    
    @IBAction func submit(_ sender: Any) {
        
        let manager_type: String = able_type
        let manager_type_token: String = ""
        let manager_token: String = manager_tokenTF.text!
        let member_token: String = Member.instance.token
        
        params["manager_type"] = manager_type
        params["manager_type_token"] = manager_type_token
        params["manager_token"] = manager_token
        params["member_token"] = Member.instance.token
        params["do"] = "update"
    }
    
    @IBAction func validate(_ sender: Any) {
        //memberStackView.isHidden = true
        let manager_token: String = manager_tokenTF.text!
        if manager_token.count == 0 {
            warning("請輸入管理員金鑰")
        } else {
            getMemberOne(token: manager_token)
        }
    }
    
    @IBAction func nameClear() {
        teamNameTF.text = ""
    }
    
    @IBAction func tokenClear() {
        manager_tokenTF.text = ""
    }
    
    @IBAction func prev1() {
        prev()
    }
    
    @IBAction func cancel() {
        prev()
    }
}
