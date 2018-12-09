//
//  FormValidableProtocol.swift
//  form
//
//  Created by ives on 2018/12/3.
//  Copyright © 2018 BlueMobile. All rights reserved.
//

import Foundation

protocol FormValidable {
    var isValid: Bool {get set}
    var isRequired: Bool{get set}
    func checkValidity()
}
