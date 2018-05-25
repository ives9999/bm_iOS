//
//  BaseViewController.swift
//  bm
//
//  Created by ives on 2018/4/3.
//  Copyright © 2018年 bm. All rights reserved.
//

import UIKit
import OneSignal

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func prev() {
        dismiss(animated: true, completion: nil)
    }
    
    func _loginFB() {
        //print(Facebook.instance.uid)
        //print(Facebook.instance.email)
        let playerID: String = self._getPlayerID()
        Global.instance.addSpinner(superView: self.view)
        MemberService.instance.login_fb(playerID: playerID, completion: { (success1) in
            Global.instance.removeSpinner(superView: self.view)
            if success1 {
                if MemberService.instance.success {
                    self.performSegue(withIdentifier: UNWIND, sender: "refresh_team")
                } else {
                    //print("login failed by error email or password")
                    self.alertError(title: "錯誤", msg: MemberService.instance.msg)
                }
            } else {
                print("login failed by fb")
            }
        })
    }
    
    func _getPlayerID() -> String {
        let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
        let playerID: String = status.subscriptionStatus.userId
        //print(playerID)
        //if userID != nil {
        //let user = PFUser.cu
        //}
        return playerID
    }
    
    func alertError(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "確定", style: .default, handler: nil))
        self.present(alert, animated: true)
    }

}
