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
    
    let ads: [String] = ["homead0", "homead1", "homead2"]
    let desciptions: [String] = ["在「更多」頁面中，選取「商品」", "商品頁面中，選擇「羽球密碼版服」商品", "在商品內頁中，按下「購買」鍵"]
    
    lazy var banner: JXBanner = {
        let banner = JXBanner()
        banner.backgroundColor = UIColor.blue
        banner.placeholderImgView.image = UIImage(named: "banner_placeholder")
        banner.delegate = self
        banner.dataSource = self
        
        return banner
    }()
    
    var adContainer: UIView = {
        let view = UIView()
        //view.backgroundColor = .red
        return view
    }()
    
    var cancelBtn: CancelButton = {
        let button = CancelButton()
        button.setTitle("關閉")
        //button.backgroundColor = UIColor(MY_GREEN)
        return button
    }()
    
    var submitBtn: SubmitButton = {
        let button = SubmitButton()
        button.setTitle("購買")
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //主要的background view設為mask
        //view.backgroundColor = UIColor(white: 1, alpha: 0.8)
        
        //放置banner的container view
        self.view.addSubview(adContainer)
        adContainer.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.edges.equalTo(self.view).inset(UIEdgeInsets(top: 50, left: 10, bottom: 50, right: 10))
        }
        
        //banner
        adContainer.addSubview(banner)
        banner.snp.makeConstraints { maker in
            maker.left.right.top.equalToSuperview()
            maker.height.equalToSuperview().multipliedBy(0.9)
        }
        
        let w1 = submitBtn.intrinsicContentSize.width
        let w2 = cancelBtn.intrinsicContentSize.width
        let w = self.view.frame.width
        let submitBtn_leading:CGFloat = (w-w1-w2)/3
        let cancelBtn_trailing: CGFloat = submitBtn_leading * -1
        
        adContainer.addSubview(submitBtn)
        submitBtn.snp.makeConstraints { make in
            //make.center.equalToSuperview()
            make.leading.equalToSuperview().offset(submitBtn_leading)
            make.bottom.equalToSuperview().offset(-24)
        }
        //submitBtn.addTarget(self, action: #selector(submit), for: .touchUpInside)
        
        adContainer.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { make in
            //make.center.equalToSuperview()
            make.trailing.equalToSuperview().offset(cancelBtn_trailing)
            make.bottom.equalToSuperview().offset(-24)
        }
        //cancelBtn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
    }
    
    @objc func submit(button: UIButton) {
        
        goHomeThen { (vc) in
            vc.toProduct()
        }
    }
    
    @objc func cancel(button: UIButton) {
        prev()
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
        return ads.count
    }
    
    //輪播cell設置
    func jxBanner(_ banner: JXBannerType, cellForItemAt index: Int, cell: UICollectionViewCell) -> UICollectionViewCell {
        let tempCell: JXBannerCell = cell as! JXBannerCell
        tempCell.layer.cornerRadius = 8
        tempCell.layer.masksToBounds = true
        tempCell.imageView.image = UIImage(named: ads[index])
        tempCell.msgLabel.text = desciptions[index]
        return tempCell
    }
    
    //banner 設置
//    func jxBanner(_ banner: JXBannerType, layoutParams: JXBannerLayoutParams) -> JXBannerLayoutParams {
//
//        let w: CGFloat = 50
//        let h: CGFloat = 50
//        return layoutParams.itemSize(CGSize(width:w, height:h)).itemSpacing(20)
//    }
}

//MARK:- JXBannerDelegate
extension HomeTotalAdVC: JXBannerDelegate {
    
    public func jxBanner(_ banner: JXBannerType, didSelectItemAt index: Int) {
        print(index)
    }
}






