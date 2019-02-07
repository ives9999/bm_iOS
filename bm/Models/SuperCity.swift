//
//  SuperCity.swift
//  bm
//
//  Created by ives on 2019/2/4.
//  Copyright © 2019 bm. All rights reserved.
//

import Foundation

@objc(SuperCity)
class SuperCity: SuperModel {
    @objc dynamic var id: Int = -1
    @objc dynamic var parent_id: Int = -1
    @objc dynamic var name: String = ""
    @objc dynamic var zip: String = ""
}
