//
//  SuperSignupStandby.swift
//  bm
//
//  Created by ives on 2020/1/20.
//  Copyright © 2020 bm. All rights reserved.
//

import Foundation
@objc(SuperSignupStandby)
class SuperSignupStandby: SuperModel {
    @objc dynamic var id: Int = -1
    @objc dynamic var member_id: Int = -1
    @objc dynamic var signup_able_id: Int = -1
    @objc dynamic var signup_able_type: String = ""
    @objc dynamic var able_date_id: Int = -1
    @objc dynamic var cancel_deadline: String = ""
    @objc dynamic var token: String = ""
    @objc dynamic var created_at: String = ""
    @objc dynamic var updated_at: String = ""
    @objc dynamic var member_name: String = ""
}
