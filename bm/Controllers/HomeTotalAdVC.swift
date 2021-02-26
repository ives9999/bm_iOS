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

class HomeTotalAdVC: BaseViewController {
    
    var pageCount = 3
    lazy var banner: JXBanner = {
        let banner = JXBanner()
        banner.backgroundColor = UIColor.black
        banner.placeholderImgView.image = UIImage(named: "banner_placeholder")
        banner.delegate = self
        banner.dataSource = self
        
        return banner
    }()
    
    var bView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        self.view.addSubview(bView)
        bView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.edges.equalToSuperview().inset(30)
        }
        bView.addSubview(banner)
        banner.snp.makeConstraints { maker in
            maker.left.right.top.equalToSuperview()
            maker.height.equalToSuperview().multipliedBy(0.75)
        }
        
    }
    
    @IBAction func goThat() {
        
        print("go go")
    }
}

//MARK:- JXBannerDataSource
extension HomeTotalAdVC: JXBannerDataSource {
    
    //register cell
    func jxBanner(_ banner: JXBannerType)-> JXBannerCellRegister {
        return JXBannerCellRegister(type: JXBannerCell.self, reuseIdentifier: "JXDefaultVCCell")
    }
    
    //輪播總數
    func jxBanner(numberOfItems banner: JXBannerType) -> Int {
        return pageCount
    }
    
    //輪播cell設置
    func jxBanner(_ banner: JXBannerType, cellForItemAt index: Int, cell: UICollectionViewCell) -> UICollectionViewCell {
        let tempCell: JXBannerCell = cell as! JXBannerCell
        tempCell.layer.cornerRadius = 8
        tempCell.layer.masksToBounds = true
        tempCell.imageView.image = UIImage(named: "banner_placeholder")
        tempCell.msgLabel.text = String(index) + "---他真的來囉"
        return tempCell
    }
    
    //banner 設置
    func jxBanner(_ banner: JXBannerType, layoutParams: JXBannerLayoutParams) -> JXBannerLayoutParams {
        return layoutParams.itemSize(CGSize(width: UIScreen.main.bounds.width, height: 200)).itemSpacing(20)
    }
}

//MARK:- JXBannerDelegate
extension HomeTotalAdVC: JXBannerDelegate {
    
    public func jxBanner(_ banner: JXBannerType, didSelectItemAt index: Int) {
        print(index)
    }
}






