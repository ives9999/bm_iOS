//
//  ArenaShowVC.swift
//  bm
//
//  Created by ives on 2024/5/24.
//  Copyright © 2024 bm. All rights reserved.
//

import UIKit

class ArenaShowVC: BaseV2VC {
    
    var token: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    

    // MARK: - init view for controller
    override func initView() {
        super.initView()
        
        let filterContainer: UIView = {
            let view = UIView()
            //view.backgroundColor = UIColor.white
            return view
        }()
        self.view.addSubview(filterContainer)
        filterContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            //make.top.equalTo(textLbl.snp.bottom)
            make.top.equalTo(showTop2!.snp.bottom)
            make.height.equalTo(50)
        }
    }

}
