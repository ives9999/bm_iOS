//
//  ArenaReadVC.swift
//  bm
//
//  Created by ives on 2024/5/8.
//  Copyright © 2024 bm. All rights reserved.
//

import UIKit

class ArenaReadVC: BaseV2VC {
    
    private var viewModel: ArenaReadViewModel?
    private lazy var tableView: UITableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //viewModel = ArenaReadViewModel(repository: ArenaReadRepository())
        
        initTop()
        
//        let emailTxt2: MainTextField2 = {
//            let view: MainTextField2 = MainTextField2(key: "email", label: "Email", icon: "email_svg", placeholder: "davie@gmail.com", isRequired: true, keyboard: KEYBOARD.emailAddress)
//            
//            return view
//        }()
        let emailTxt2: UITextField = UITextField()
        emailTxt2.backgroundColor = UIColor(hex: "#D9D9D9", alpha: 0.1)
        emailTxt2.textColor = UIColor(MY_WHITE)
        emailTxt2.delegate = self
        
        self.view.addSubview(emailTxt2)
        emailTxt2.snp.makeConstraints { make in
            make.top.equalTo(showTop2!.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ArenaReadVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


























































