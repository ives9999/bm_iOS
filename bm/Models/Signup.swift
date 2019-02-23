//
//  Signup.swift
//  bm
//
//  Created by ives on 2019/2/21.
//  Copyright © 2019 bm. All rights reserved.
//

import Foundation

@objc(Signup)
class Signup: SuperModel {
    @objc dynamic var id: Int = -1
    @objc dynamic var member_id: Int = -1
    @objc dynamic var signupable_id: Int = -1
    @objc dynamic var signupable_type: String = ""
    @objc dynamic var status: String = ""
    @objc dynamic var cancel_times: Int = 0
    @objc dynamic var created_at: String = ""
    @objc dynamic var updated_at: String = ""
}
