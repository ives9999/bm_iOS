//
//  ShowProductVC.swift
//  bm
//
//  Created by ives on 2021/1/3.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class ShowProductVC: ShowVC {
    
    @IBOutlet weak var imageDataLbl: SuperLabel!
    
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var descView: UIView!
    
    @IBOutlet weak var imageContainerViewConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var contentConstraintViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var submitButton: SubmitButton!
    @IBOutlet weak var submitButtonConstraintLeading: NSLayoutConstraint!
    
    var myTable: ProductTable?
            
    override func viewDidLoad() {
        

        dataService = ProductService.instance
        
        //titleLbl.textColor = UIColor.black
        
        //scrollView.backgroundColor = UIColor.clear
        
        //imageContainerViewConstraintHeight.constant = 0
        //contentConstraintViewHeight.constant = 0
        
        bottom_button_count = 2
        
        super.viewDidLoad()
        
        imageDataLbl.text = "更多圖片"
        imageDataLbl.setTextSectionTitle()
        
        submitButton.setTitle("購買")
        
        //imageContainerView.backgroundColor = UIColor.clear
        //descView.backgroundColor = UIColor.clear
        
        //contentConstraintViewHeight.constant = 0
        
        refresh(ProductTable.self)
    }
    
//    override func viewWillLayoutSubviews() {
//
//        contentDataLbl.setTextTitle()
//        imageDataLbl.setTextTitle()
//    }
    
    override func refresh() {
        refresh(ProductTable.self)
    }
    
//    override func initContentView() {}
    
//    override func refresh() {
//        if product_token != nil {
//            Global.instance.addSpinner(superView: view)
//            //print(Member.instance.token)
//            let params: [String: String] = ["token": product_token!, "member_token": Member.instance.token]
//            dataService.getOne(t: ProductTable.self, params: params) { (success) in
//                if (success) {
//                    let table: Table = ProductService.instance.table!
//                    self.myTable = (table as! ProductTable)
//                    //self.superProduct!.printRow()
//
//                    self.titleLbl.text = self.myTable?.name
//                    self.setFeatured()
//                    self.setImages()
//                    self.setContent()
//
//                    self.isLike = self.myTable!.like
//                    self.likeButton.initStatus(self.isLike, self.myTable!.like_count)
//                }
//                Global.instance.removeSpinner(superView: self.view)
//                self.endRefresh()
//            }
//        }
//    }
    
    override func setData() {
        
        super.setData()
        if table != nil {
            myTable = table as? ProductTable
            if (myTable != nil) {
                //myTable!.filterRow()
                //self.courseTable?.printRow()
                //setContent()  已經在showVC的refresh有執行了
                setImages()
            }
        }
    }
    
    override func setBottomButtonPadding() {
        
        let padding: CGFloat = (screen_width - CGFloat(bottom_button_count) * button_width) / CGFloat((bottom_button_count + 1))
        likeButtonConstraintLeading.constant = CGFloat(bottom_button_count) * padding + CGFloat(bottom_button_count-1)*button_width
        submitButtonConstraintLeading.constant = padding
    }
    
//    override func setContent() {
//        let textView: SuperTextView = SuperTextView(frame: CGRect.zero)
//        textView.backgroundColor = UIColor.clear
//        descView.addSubview(textView)
//        textView.isScrollEnabled = false
//        textView.text = myTable!.content
//        textView.textColor = UIColor(TEXTGRAY)
//        textView.font = UIFont(name: FONT_NAME, size: FONT_SIZE_GENERAL)
//
//        let fixedWidth = textView.superview!.frame.size.width
//        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
//        textView.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
//
//        contentConstraintViewHeight.constant = contentConstraintViewHeight.constant
//
//        self.dataConstraintHeight.constant += contentConstraintViewHeight.constant
//
//        self.scrollContainerHeight += self.dataConstraintHeight.constant
//        self.containerViewConstraintHeight.constant = self.scrollContainerHeight
//    }
    
    func setImages() {
        if myTable != nil {
            if myTable!.images.count > 0 {
                
                let h: CGFloat = imageContainerView.showImages(images: myTable!.images)
                imageContainerViewConstraintHeight.constant = h
                
                self.dataConstraintHeight.constant += imageContainerViewConstraintHeight.constant
                
                self.scrollContainerHeight += self.dataConstraintHeight.constant
                self.containerViewConstraintHeight.constant = self.scrollContainerHeight
                //changeScrollViewContentSize()
            }
        }
    }

//    override func changeScrollViewContentSize() {
//
//        let h1 = featured.bounds.size.height
//        let h2 = imageDataLbl.bounds.size.height
//        let h3 = imageContainerViewConstraintHeight.constant
//        let h4 = contentDataLbl.bounds.size.height
//        let h5 = contentConstraintViewHeight.constant
//
//        //print(contentViewConstraintHeight)
//
//        let h: CGFloat = h1 + h2 + h3 + h4 + h5 + 300
//        scrollView.contentSize = CGSize(width: view.frame.width, height: h)
//        containerViewConstraintHeight.constant = h
//        //print(h1)
//    }
    
    @IBAction func submitBtnPressed(_ sender: Any) {
        //print("purchase")
        if token != nil {
            toAddCart(
                product_token: token!,
                login: { vc in vc.toLogin() },
                register: { vc in vc.toRegister() }
            )
        } else {
            warning("")
        }
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        prev()
    }
}

