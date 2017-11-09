//
//  TeamSubmitVC.swift
//  bm
//
//  Created by ives on 2017/11/9.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class TeamSubmitVC: UIViewController {

    // Outlets
    @IBOutlet weak var titleLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func prevBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    

}
