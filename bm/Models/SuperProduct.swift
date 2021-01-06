//
//  SuperProduct.swift
//  bm
//
//  Created by ives on 2020/12/30.
//  Copyright © 2020 bm. All rights reserved.
//

import Foundation

@objc(SuperProduct)
class SuperProduct: SuperModel {
    
    @objc dynamic var id: Int = -1
    @objc dynamic var name: String = ""
    @objc dynamic var channel: String = ""
    @objc dynamic var slug: String = ""
    
    @objc dynamic var type: String = ""
    @objc dynamic var color: String = ""
    @objc dynamic var size: String = ""
    @objc dynamic var weight: String = ""
    @objc dynamic var shipping: String = ""
    @objc dynamic var gateway: String = ""
    
    @objc dynamic var content: String = ""
    @objc dynamic var alias: String = ""
    
    @objc dynamic var status: String = "online"
    @objc dynamic var token: String = ""
    @objc dynamic var sort_order: Int = 0
    @objc dynamic var pv: Int = 0
    @objc dynamic var created_id: Int = 0
    @objc dynamic var created_at: String = ""
    @objc dynamic var updated_at: String = ""
    @objc dynamic var created_at_text: String = ""
    @objc dynamic var featured_path: String = ""
    @objc dynamic var thumb: String = ""
    
    @objc dynamic var featured: UIImage = UIImage(named: "nophoto")!
    @objc dynamic var images: [String] = [String]()
    
    @objc dynamic var prices: SuperProductPrice = SuperProductPrice()
    
    override func filterRow() {
        created_at_text = created_at.noTime()
        if featured_path.count > 0 {
            if !featured_path.hasPrefix("http://") || !featured_path.hasPrefix("https://") {
                featured_path = BASE_URL + featured_path
                //print(featured_path)
            }
        }
        if images.count > 0 {
            for (idx, image) in images.enumerated() {
                if !image.hasPrefix("http://") || !image.hasPrefix("https://") {
                    let _image = BASE_URL + image
                    images[idx] = _image
                }
            }
        }
    }
    
    override func getFeaturedPath() -> String {
        return featured_path
    }
    
    override func setFeatured(_ image: UIImage) {
        featured = image
    }
}

class SuperProducts: SuperModel {
    @objc dynamic var success: Bool = false
    @objc dynamic var page: Int = 0
    @objc dynamic var totalCount: Int = 0
    @objc dynamic var perPage: Int = 0
    @objc dynamic var rows: [SuperProduct] = Array()
    
    override func printRows() {
        let row = rows[0]
        row.printRow()
    }
    
    override func getRows<SuperProduct>() -> [SuperProduct]? {
        return (rows as! [SuperProduct])
    }
    
    override func getRowFromIdx<T>(_ idx: Int) -> T? where T : SuperModel {
        if rows.count >= idx {
            return (rows[idx] as! T)
        } else {
            return nil
        }
    }
}
