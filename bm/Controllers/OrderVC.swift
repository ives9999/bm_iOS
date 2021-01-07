//
//  OrderVC.swift
//  bm
//
//  Created by ives on 2021/1/6.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class OrderVC: BaseViewController {
    
    var superProduct: SuperProduct = SuperProduct()
    @IBOutlet weak var titleLbl: SuperLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(superProduct)
        
        titleLbl.textColor = UIColor.black
        titleLbl.text = superProduct.name
    }
}
