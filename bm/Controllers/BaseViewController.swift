//
//  BaseViewController.swift
//  bm
//
//  Created by ives on 2018/4/3.
//  Copyright © 2018年 bm. All rights reserved.
//

import UIKit
import OneSignal
import SCLAlertView

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
                    SCLAlertView().showError("錯誤", subTitle: MemberService.instance.msg)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
