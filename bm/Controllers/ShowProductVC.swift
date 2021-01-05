//
//  ShowProductVC.swift
//  bm
//
//  Created by ives on 2021/1/3.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class ShowProductVC: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContainerView: UIView!
    
    @IBOutlet weak var featured: UIImageView!
    
    @IBOutlet weak var productDataLbl: SuperLabel!
    @IBOutlet weak var contentLbl: SuperLabel!
    
    @IBOutlet weak var imageContainerView: UIView!
    var contentView: UIView!
    
    @IBOutlet weak var imageContainerViewConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var ContainerViewConstraintHeight: NSLayoutConstraint!
    
    var contentViewConstraintHeight: NSLayoutConstraint?
    
    var superProduct: SuperProduct?
    var product_token: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //print(superStore)
        scrollView.backgroundColor = UIColor.clear
        
        //initImageView()
        //initContentView()
        
        beginRefresh()
        scrollView.addSubview(refreshControl)
        refresh()
    }
    
    override func viewWillLayoutSubviews() {
        productDataLbl.text = "商品圖片"
        contentLbl.text = "詳細介紹"
        
        productDataLbl.textColor = UIColor(MY_RED)
        productDataLbl.textAlignment = .left
        contentLbl.textColor = UIColor(MY_RED)
        contentLbl.textAlignment = .left
    }
    
    func initContentView() {
        
        scrollContainerView.addSubview(contentView!)
        var c1: NSLayoutConstraint, c2: NSLayoutConstraint, c3: NSLayoutConstraint
        
        c1 = NSLayoutConstraint(item: contentView!, attribute: .leading, relatedBy: .equal, toItem: contentView!.superview, attribute: .leading, multiplier: 1, constant: 8)
        c2 = NSLayoutConstraint(item: contentView!, attribute: .top, relatedBy: .equal, toItem: contentLbl, attribute: .bottom, multiplier: 1, constant: 8)
        c3 = NSLayoutConstraint(item: contentView!, attribute: .trailing, relatedBy: .equal, toItem: contentView!.superview, attribute: .trailing, multiplier: 1, constant: 8)
        contentViewConstraintHeight = NSLayoutConstraint(item: contentView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        contentView!.translatesAutoresizingMaskIntoConstraints = false
        scrollContainerView.addConstraints([c1,c2,c3,contentViewConstraintHeight!])
        //contentView!.uiDelegate = self
        //contentView!.navigationDelegate = self
    }
    
    override func refresh() {
        if product_token != nil {
            Global.instance.addSpinner(superView: view)
            //print(Member.instance.token)
            let params: [String: String] = ["token": product_token!, "member_token": Member.instance.token]
            ProductService.instance.getOne(t: SuperProduct.self, params: params) { (success) in
                if (success) {
                    let superModel: SuperModel = ProductService.instance.superModel
                    self.superProduct = (superModel as! SuperProduct)
                    
                    self.setFeatured()
                    self.setImages()
                }
                Global.instance.removeSpinner(superView: self.view)
                self.endRefresh()
            }
        }
    }
    
    func setFeatured() {
        
        if superProduct != nil {
            if superProduct!.featured_path.count > 0 {
                let featured_path = superProduct!.featured_path
                if featured_path.count > 0 {
                    //print(featured_path)
                    featured.downloaded(from: featured_path)
                }
            }
            //featured.image = superCourse!.featured
        }
    }
    
    func setImages() {
        if superProduct != nil {
            if superProduct!.images.count > 0 {
                for image_url in superProduct!.images {
                    //print(image_url)
                    let imageView: UIImageView = UIImageView()
                    imageContainerView.addSubview(imageView)
                    var c1: NSLayoutConstraint, c2: NSLayoutConstraint, c3: NSLayoutConstraint
                    
                    c1 = NSLayoutConstraint(item: contentView!, attribute: .leading, relatedBy: .equal, toItem: contentView!.superview, attribute: .leading, multiplier: 1, constant: 8)
                    c2 = NSLayoutConstraint(item: contentView!, attribute: .top, relatedBy: .equal, toItem: contentLbl, attribute: .bottom, multiplier: 1, constant: 8)
                    c3 = NSLayoutConstraint(item: contentView!, attribute: .trailing, relatedBy: .equal, toItem: contentView!.superview, attribute: .trailing, multiplier: 1, constant: 8)
                    contentViewConstraintHeight = NSLayoutConstraint(item: contentView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
                    contentView!.translatesAutoresizingMaskIntoConstraints = false
                    imageContainerView.addConstraints([c1,c2,c3,contentViewConstraintHeight!])
                    
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
    
    func changeScrollViewContentSize() {
        
        let h1 = featured.bounds.size.height
        let h2 = productDataLbl.bounds.size.height
        let h3 = imageContainerViewConstraintHeight.constant
        let h6 = contentLbl.bounds.size.height
        //let h7 = contentViewConstraintHeight!.constant

        //print(contentViewConstraintHeight)
        
        let h: CGFloat = h1 + h2 + h3 + h6 + 300
        scrollView.contentSize = CGSize(width: view.frame.width, height: h)
        ContainerViewConstraintHeight.constant = h
        //print(h1)
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
//        if delegate != nil {
//            delegate!.isReload(false)
//        }
        prev()
    }
}
