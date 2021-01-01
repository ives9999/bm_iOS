//
//  SuperProductPrice.swift
//  bm
//
//  Created by ives on 2020/12/31.
//  Copyright © 2020 bm. All rights reserved.
//

import Foundation

@objc(SuperProductPrice)
class SuperProductPrice: SuperModel {
    @objc dynamic var id: Int = -1
    @objc dynamic var product_id: Int = -1
    @objc dynamic var price_title: String = ""
    @objc dynamic var price_title_alias: String = ""
    @objc dynamic var price_member: Int = -1
    @objc dynamic var price_nonmember: Int = -1
    @objc dynamic var price_dummy: Int = -1
    @objc dynamic var price_desc: String = ""
    @objc dynamic var shipping_fee: Int = -1
    @objc dynamic var shipping_fee_unit: Int = -1
    @objc dynamic var shippint_fee_desc: String = ""
    @objc dynamic var tax: Int = -1
}
