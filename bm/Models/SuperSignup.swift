//
//  Signup.swift
//  bm
//
//  Created by ives on 2019/2/21.
//  Copyright © 2019 bm. All rights reserved.
//

import Foundation

@objc(SuperSignup)
class SuperSignup: SuperModel {
    @objc dynamic var id: Int = -1
    @objc dynamic var member_id: Int = -1
    @objc dynamic var signupable_id: Int = -1
    @objc dynamic var signupable_type: String = ""
    @objc dynamic var able_date: String = ""
    @objc dynamic var cancel_deadline: String = ""
    @objc dynamic var status: String = ""
    @objc dynamic var cancel_times: Int = 0
    @objc dynamic var created_at: String = ""
    @objc dynamic var updated_at: String = ""
    @objc dynamic var member_name: String = ""
}

class SuperSignups: SuperModel {
    @objc dynamic var success: Bool = false
    @objc dynamic var page: Int = 0
    @objc dynamic var totalCount: Int = 0
    @objc dynamic var perPage: Int = 0
    @objc dynamic var rows: [SuperSignup] = Array()
    
    override func printRows() {
        let row = rows[0]
        row.printRow()
    }
    
    override func getRows<SuperSignup>() -> [SuperSignup]? {
        return (rows as! [SuperSignup])
    }
    
    override func getRowFromIdx<T>(_ idx: Int) -> T? where T : SuperModel {
        if rows.count >= idx {
            return (rows[idx] as! T)
        } else {
            return nil
        }
    }
}
