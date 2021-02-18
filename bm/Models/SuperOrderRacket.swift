//
//  SuperOrderRacket.swift
//  bm
//
//  Created by ives sun on 2021/2/18.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

@objc(SuperOrderRacket)
class SuperOrderRacket: SuperModel {
    
    @objc dynamic var id: Int = -1
    @objc dynamic var order_id: Int = -1
    @objc dynamic var product_id: Int = -1
    @objc dynamic var price_id: Int = -1
    @objc dynamic var color: String = ""
    @objc dynamic var weight: String = ""
    @objc dynamic var quantity: Int = -1
    @objc dynamic var price: Int = -1
}

class SuperOrderRackets: SuperModel {
    @objc dynamic var success: Bool = false
    @objc dynamic var rows: [SuperOrderRacket] = Array()
    
    override func printRows() {
        let row = rows[0]
        row.printRow()
    }
}
