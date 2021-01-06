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
    
    @IBOutlet weak var titleLbl: SuperLabel!
    @IBOutlet weak var featured: UIImageView!
    
    @IBOutlet weak var imageDataLbl: SuperLabel!
    @IBOutlet weak var contentLbl: SuperLabel!
    
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var imageContainerViewConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var contentConstraintViewHeight: NSLayoutConstraint!
    @IBOutlet weak var ContainerViewConstraintHeight: NSLayoutConstraint!
    
    @IBOutlet weak var submitButton: SubmitButton!
    
    var superProduct: SuperProduct?
    var product_token: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //print(superStore)
        imageDataLbl.text = "商品圖片"
        contentLbl.text = "詳細介紹"
        submitButton.setTitle("購買")
        
        titleLbl.textColor = UIColor.black
        imageDataLbl.textColor = UIColor(MY_RED)
        imageDataLbl.textAlignment = .left
        contentLbl.textColor = UIColor(MY_RED)
        contentLbl.textAlignment = .left
        imageContainerView.backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        scrollView.backgroundColor = UIColor.clear
        
        imageContainerViewConstraintHeight.constant = 0
        contentConstraintViewHeight.constant = 0
        beginRefresh()
        scrollView.addSubview(refreshControl)
        refresh()
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
                    
                    self.titleLbl.text = self.superProduct?.name
                    self.setFeatured()
                    self.setImages()
                    self.setContent()
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
        }
    }
    
    func setImages() {
        if superProduct != nil {
            if superProduct!.images.count > 0 {
                
                let h: CGFloat = imageContainerView.showImages(images: superProduct!.images)
                imageContainerViewConstraintHeight.constant = h
                changeScrollViewContentSize()
            }
        }
    }
    
    func setContent() {
        if superProduct != nil {
            
            
//            let textView = UITextView()
//
//              textView.isEditable = false
//              textView.isScrollEnabled = false
//              textView.dataDetectorTypes = .link
//              textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//              textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
//              textView.textContainer.lineFragmentPadding = 0

              //let attributed = attributedString(for: string)
              //textView.attributedText = attributed
            
            
            let textView: SuperTextView = SuperTextView(frame: CGRect.zero)
            contentView.addSubview(textView)
            textView.isScrollEnabled = false
            textView.text = superProduct!.content
            
            let fixedWidth = textView.superview!.frame.size.width
            let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            textView.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
            //textView.layoutSubviews()
            //let contentSize = textView.sizeThatFits(textView.bounds.size)
            //print(contentSize.height)
            
            //var left: NSLayoutConstraint, right: NSLayoutConstraint, top: NSLayoutConstraint, h: NSLayoutConstraint
            //左邊
            //left = NSLayoutConstraint(item: textView, attribute: .leading, relatedBy: .equal, toItem: textView.superview, attribute: .leading, multiplier: 1, constant: 8)
            //右邊
            //right = NSLayoutConstraint(item: textView, attribute: .trailing, relatedBy: .equal, toItem: textView.superview, attribute: .trailing, multiplier: 1, constant: 8)
            
            //上面
            //top = NSLayoutConstraint(item: textView, attribute: .top, relatedBy: .equal, toItem: textView.superview, attribute: .top, multiplier: 1, constant: 8)
            
            //高度
            //h = NSLayoutConstraint(item: textView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80)
            //textView.translatesAutoresizingMaskIntoConstraints = false
            //textView.sizeToFit()
            //textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            //print(textView.frame)
            //contentView.addConstraints([left, right, top, h])
            contentConstraintViewHeight.constant = textView.frame.height
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
    
    func changeScrollViewContentSize() {
        
        let h1 = featured.bounds.size.height
        let h2 = imageDataLbl.bounds.size.height
        let h3 = imageContainerViewConstraintHeight.constant
        let h4 = contentLbl.bounds.size.height
        let h5 = contentConstraintViewHeight.constant
        

        //print(contentViewConstraintHeight)
        
        let h: CGFloat = h1 + h2 + h3 + h4 + h5 + 300
        scrollView.contentSize = CGSize(width: view.frame.width, height: h)
        ContainerViewConstraintHeight.constant = h
        //print(h1)
    }
    
    @IBAction func submitBtnPressed(_ sender: Any) {
        print("purchase")
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        prev()
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        //goHome()
        prev()
    }
}
