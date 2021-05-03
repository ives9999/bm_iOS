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
    
    override init() {
        super.init()
    }
    
    override func getListURL() -> String {
        return URL_PRODUCT_LIST
    }
    
    override func getSource() -> String? {
        return "product"
    }
    
    override func getLikeURL(token: String? = nil) -> String {
        var url: String = URL_PRODUCT_LIKE
        if token != nil {
            url = url + "/" + token!
        }
        
        return url
    }
}
