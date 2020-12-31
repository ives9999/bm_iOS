//
//  ProductService.swift
//  bm
//
//  Created by ives on 2020/12/30.
//  Copyright © 2020 bm. All rights reserved.
//

import Foundation

class ProductService: DataService {
    static let instance = ProductService()
    var superStores: SuperProducts = SuperProducts()
    var superProduct: SuperProduct = SuperProduct()
    
    override init() {
        super.init()
        superModel = SuperProducts(dict: [String : Any]())
    }
    
    override func getListURL() -> String {
        return URL_PRODUCT_LIST
    }
    
    override func getSource() -> String? {
        return "product"
    }
}
