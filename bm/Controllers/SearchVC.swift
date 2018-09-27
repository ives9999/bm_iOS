//
//  SearchVC.swift
//  bm
//
//  Created by ives on 2018/9/26.
//  Copyright © 2018年 bm. All rights reserved.
//

import UIKit

class SearchVC: BaseViewController {

    var type: String!
    
    var layer: CALayer {
        return view.layer
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        layer.backgroundColor = UIColor.white.cgColor
        layer.borderWidth = 100.0
        layer.borderColor = UIColor.red.cgColor
    }

    @IBAction func prevBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cityBtnPressed(_ sender: Any) {
        print("aaa")
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
