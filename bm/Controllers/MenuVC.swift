//
//  MenuVC.swift
//  bm
//
//  Created by ives on 2017/10/25.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class MenuVC: UIViewController {

    // outlets
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){}
    @IBOutlet weak var nicknameLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        print(MemberService.instance.isLoggedIn)
        if MemberService.instance.isLoggedIn { // login
            nicknameLbl.isHidden = true
            loginBtn.isHidden = true
            registerBtn.isHidden = false
        } else {
            nicknameLbl.isHidden = true
            loginBtn.isHidden = false
            registerBtn.isHidden = false
        }
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_LOGIN, sender: nil)
    }
    
    @IBAction func registerBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_REGISTER, sender: nil)
    }
}
