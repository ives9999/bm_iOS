//
//  Contants.swift
//  bm
//
//  Created by ives on 2017/10/6.
//  Copyright © 2017年 bm. All rights reserved.
//

import Foundation
import UIKit

typealias CompletionHandler = (_ Success: Bool) -> ()

// URL Constants
let REMOTE_BASE_URL = "http://bm.sportpassword.com"
let LOCALHOST_BASE_URL = "http://bm.sportpassword.localhost"
let BASE_URL = (gSimulate) ? LOCALHOST_BASE_URL : REMOTE_BASE_URL
let URL_HOME = "\(BASE_URL)/app/"
let URL_LIST = "\(URL_HOME)%@"
let URL_SHOW = "\(URL_HOME)%@/show/%@?device=app"
let URL_LOGIN = URL_HOME + "login"
let URL_REGISTER = URL_HOME + "register"

// Font
let FONT_NAME: String = "Apple SD Gothic Neo"
let FONT_SIZE_TITLE: CGFloat = 22
let FONT_SIZE_TABBAR: CGFloat = 14

// List pages
let IPHONE_CELL_ON_ROW: Int = 1
let IPAD_CELL_ON_ROW:Int = 2
let CELL_EDGE_MARGIN: CGFloat = 5
let TITLE_HEIGHT: CGFloat = 60
let FEATURED_HEIGHT: CGFloat = 180
let PERPAGE: Int = 5

// spinner
let LOADING: String = "努力加載中..."
let LOADING_WIDTH: Int = 200
let LOADING_HEIGHT: Int = 40

// segues
let TO_LOGIN: String = "toLogin"
let TO_REGISTER: String = "toRegister"
let UNWIND: String = "unwindToMenu"
let MENU_TABLE: String = "meunTable"
let TO_PROFILE: String = "toProfile"
let TO_EDIT_PROFILE: String = "toEditProfile"

// color
let MY_GREEN = "#a6d903"
let STATUS_GREEN = "#658501"
let TABBAR_BACKGROUND = "#0d0d0d"

// User Defaults
let ID_KEY = "id"
let TOKEN_KEY = "token"
let EMAIL_KEY = "email"
let NICKNAME_KEY = "nickname"
let ISLOGGEDIN_KEY = "isLoggedIn"
let UID_KEY = "uid"
let NAME_KEY = "name"
let CHANNEL_KEY = "channel"
let DOB_KEY = "dob"
let SEX_KEY = "sex"
let TEL_KEY = "tel"
let MOBILE_KEY = "mobile"
let PID_KEY = "pid"
let AVATAR_KEY = "avatar"
let MEMBER_TYPE_KEY = "type"
let SOCIAL_KEY = "social"
let MEMBER_ROLE_KEY = "role"
let VALIDATE_KEY = "validate"

// member
let MEMBER_FIELD_STRING = [TOKEN_KEY,EMAIL_KEY,NICKNAME_KEY,NAME_KEY,UID_KEY,CHANNEL_KEY,DOB_KEY,SEX_KEY,TEL_KEY,MOBILE_KEY,PID_KEY,AVATAR_KEY,MEMBER_ROLE_KEY,SOCIAL_KEY]
let MEMBER_FIELD_INT = [ID_KEY,VALIDATE_KEY,MEMBER_TYPE_KEY]
let MEMBER_FIELD_BOOL = [ISLOGGEDIN_KEY]

// Notification Constants
let NOTIF_MEMBER_DID_CHANGE = Notification.Name("notifMemberChanged")

// Header
let HEADER = ["Content-Type": "application/json; charset=utf-8"]

// Static Cell
struct STATICCELL {
    let padding: CGFloat = 10
    let xMargin: CGFloat = 20
}









