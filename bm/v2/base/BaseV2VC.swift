//
//  BaseViewController.swift
//  bm
//
//  Created by ives on 2024/5/8.
//  Copyright © 2024 bm. All rights reserved.
//

import UIKit

class BaseV2VC: UIViewController {
    
    var showTop2: ShowTop2?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func initTop() {
        showTop2 = ShowTop2()
        showTop2!.anchor(parent: self.view)
        showTop2!.setTitle("球館")
        showTop2!.showLog()
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
