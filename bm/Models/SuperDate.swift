//
//  SuperDate.swift
//  bm
//
//  Created by ives on 2020/1/20.
//  Copyright © 2020 bm. All rights reserved.
//

import Foundation

@objc(SuperDate)
class SuperDate: SuperModel {
    @objc dynamic var id: Int = -1
    @objc dynamic var signup_dateable_id: Int = -1
    @objc dynamic var signup_dateable_type: String = ""
    @objc dynamic var date: String = ""
    @objc dynamic var token: String = ""
}
