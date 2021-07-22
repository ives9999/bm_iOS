//
//  CartService.swift
//  bm
//
//  Created by ives on 2021/7/21.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class CartService: DataService {
    
    static let instance = CartService()
    
    override func getListURL() -> String {
        return URL_CART_LIST
    }
    
    override func getSource() -> String? {
        return "cart"
    }
}
