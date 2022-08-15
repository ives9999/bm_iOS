//
//  MemberLevelUpPayVC.swift
//  bm
//
//  Created by ives on 2022/8/14.
//  Copyright © 2022 bm. All rights reserved.
//

import Foundation

class MemberLevelUpPayVC: BaseViewController {
    
    var name: String = ""
    var price: Int = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        top.setTitle(title: name + "會員付款")
        top.delegate = self
        
        //tableView.anchor(parent: view, top: top, bottomThreeView: bottomThreeView)
        
        setupBottomThreeView()
        
        refresh()
    }
    
}
