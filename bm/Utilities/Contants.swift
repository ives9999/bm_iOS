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
typealias DATA = Dictionary<String, [String: Any]>

let CHANNEL = "bm"

// URL Constants
let REMOTE_BASE_URL = "http://bm.sportpassword.com"
let LOCALHOST_BASE_URL = "http://bm.sportpassword.localhost"
let BASE_URL = (gSimulate) ? LOCALHOST_BASE_URL : REMOTE_BASE_URL
let URL_HOME = "\(BASE_URL)/app/"
let URL_LIST = "\(URL_HOME)%@"
let URL_SHOW = "\(URL_HOME)%@/show/%@?device=app"
let URL_LOGIN = URL_HOME + "login"
let URL_REGISTER = URL_HOME + "register"
let URL_MEMBER_UPDATE = URL_HOME + "member/update"
let URL_CITYS = URL_HOME + "citys"
let URL_ARENA_BY_CITY_ID = URL_HOME + "arena_by_city"
let URL_TEAM_UPDATE = URL_HOME + "team/update"
let URL_ONE = "\(URL_HOME)%@/one"
let URL_TEAM = URL_HOME + "team/"
let URL_TEAM_TEMP_PLAY = URL_TEAM + "tempPlay/onoff"
let URL_TEAM_TEMP_PLAY_LIST = URL_TEAM + "tempPlay/list"
let URL_TEAM_PLUSONE = BASE_URL + "/team/tempPlay/plusOne/"

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
let TO_TEAM_SUBMIT: String = "toTeamSubmit"
let TO_TEAM_TEMP_PLAY: String = "toTeamTempPlay"
let TO_CITY: String = "toCity"
let TO_ARENA: String = "toArena"
let TO_DAY: String = "toDay"
let TO_SELECT_TIME: String = "toSelectTime"
let TO_TEXT_INPUT: String = "toTextInput"
let TO_SELECT_DEGREE: String = "toSelectDegree"
let TO_TEMP_PLAY_SHOW: String = "toTempPlayShow"

// color
let MY_GREEN = "#a6d903"
let MY_RED = "#f11b90"
let STATUS_GREEN = "#658501"
let TABBAR_BACKGROUND = "#0d0d0d"
let TEXTBORDER = "#4B4B4B"

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

// Team key
let TEAM_ID_KEY = "id"
let TEAM_CHANNEL_KEY = "channel"
let TEAM_NAME_KEY = "name"
let TEAM_LEADER_KEY = "leader"
let TEAM_MOBILE_KEY = "mobile"
let TEAM_EMAIL_KEY = "email"
let TEAM_WEBSITE_KEY = "website"
let TEAM_FB_KEY = "fb"
let TEAM_YOUTUBE_KEY = "youtube"
let TEAM_PLAY_START_KEY = "play_start"
let TEAM_PLAY_END_KEY = "play_end"
let TEAM_BALL_KEY = "ball"
let TEAM_DEGREE_KEY = "degree"
let TEAM_SLUG_KEY = "slug"
let TEAM_CHARGE_KEY = "charge"
let TEAM_CONTENT_KEY = "content"
let TEAM_MANAGER_ID_KEY = "manager_id"
let TEAM_TEMP_FEE_M_KEY = "temp_fee_M"
let TEAM_TEMP_FEE_F_KEY = "temp_fee_F"
let TEAM_TEMP_QUANTITY_KEY = "temp_quantity"
let TEAM_TEMP_SIGNUP_KEY = "temp_signup_count"
let TEAM_TEMP_CONTENT_KEY = "temp_content"
let TEAM_TEMP_STATUS_KEY = "temp_status"
let TEAM_PV_KEY = "pv"
let TEAM_TOKEN_KEY = "token"
let TEAM_CREATED_ID_KEY = "created_id"
let TEAM_CREATED_AT_KEY = "created_at"
let TEAM_UPDATED_AT_KEY = "updated_at"
let TEAM_THUMB_KEY = "thumb"
let TEAM_CITY_KEY = "city"
let TEAM_ARENA_KEY = "arena"
let TEAM_DAYS_KEY = "days"
let TEAM_FEATURED_KEY = "featured_path"
let TEAM_CAT_KEY = "cat_id"
let TEAM_NEAR_DATE_KEY = "near_date"

// Team temp_play key


// Notification Constants
let NOTIF_MEMBER_DID_CHANGE = Notification.Name("notifMemberChanged")
let NOTIF_MEMBER_UPDATE = Notification.Name("notifMemberUpdate")

// Header
let HEADER = ["Content-Type": "application/json; charset=utf-8"]

// Team Temp play list
struct TEAM_TEMP_PLAY_CELL {
    let height: CGFloat = 100
    let height_padding: CGFloat = 8
    let name_top_padding: CGFloat = 8
    let name_left_padding: CGFloat = 8
}

// Static Cell
struct STATICCELL {
    let padding: CGFloat = 10
    let xMargin: CGFloat = 20
}











