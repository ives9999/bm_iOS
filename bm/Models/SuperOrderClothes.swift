//
//  SuperOrderClothes.swift
//  bm
//
//  Created by ives sun on 2021/2/18.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

@objc(SuperOrderClothes)
class SuperOrderClothes: SuperModel {
    
    @objc dynamic var id: Int = -1
    @objc dynamic var order_id: Int = -1
    @objc dynamic var product_id: Int = -1
    @objc dynamic var price_id: Int = -1
    @objc dynamic var color: String = ""
    @objc dynamic var size: String = ""
    @objc dynamic var quantity: Int = -1
    @objc dynamic var price: Int = -1
    @objc dynamic var unit: String = "件"
}




