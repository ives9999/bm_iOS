//
//  SuperSignupCancel.swift
//  bm
//
//  Created by ives on 2020/3/4.
//  Copyright © 2020 bm. All rights reserved.
//

import Foundation
@objc(SuperSignupCancel)
class SuperSignupCancel: SuperModel {
    @objc dynamic var id: Int = -1
    @objc dynamic var member_id: Int = -1
    @objc dynamic var signupable_id: Int = -1
    @objc dynamic var signupable_type: String = ""
    @objc dynamic var able_date_id: Int = -1
    @objc dynamic var cancel_deadline: String = ""
    @objc dynamic var token: String = ""
    @objc dynamic var created_at: String = ""
    @objc dynamic var updated_at: String = ""
    @objc dynamic var member_name: String = ""
}
