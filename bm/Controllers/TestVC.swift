//
//  TestVC.swift
//  bm
//
//  Created by ives on 2023/7/1.
//  Copyright © 2023 bm. All rights reserved.
//

import Foundation

class TestVC: UIViewController {
    
    let titleLbl: SuperLabel = {
        let view: SuperLabel = SuperLabel()
        view.setTextTitle()
        view.text = "標題"
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        anchor()
    }
    
    func anchor() {
        view.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
