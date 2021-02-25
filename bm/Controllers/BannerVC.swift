//
//  BannerVC.swift
//  bm
//
//  Created by ives on 2021/2/23.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation
import SnapKit
import JXBanner

class BannerVC: BaseViewController {
    
    var pageCount = 3
    lazy var banner: JXBanner = {
        let banner = JXBanner()
        banner.backgroundColor = UIColor.black
        banner.placeholderImgView.image = UIImage(named: "banner_placeholder")
        banner.delegate = self
        banner.dataSource = self
        
        return banner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func goThat() {
        
        print("go go")
    }
}
