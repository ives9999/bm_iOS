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
let REMOTE_BASE_URL = "https://bm.sportpassword.com"
let LOCALHOST_BASE_URL = "http://bm.sportpassword.localhost"
let BASE_URL = (gSimulate) ? LOCALHOST_BASE_URL : REMOTE_BASE_URL
let URL_HOME = "\(BASE_URL)/app/"
let URL_LIST = "\(URL_HOME)%@"
let URL_SHOW = "\(URL_HOME)%@/show/%@?device=app"
let URL_LOGIN = URL_HOME + "login"
let URL_FB_LOGIN = URL_HOME + "member/fb"
let URL_REGISTER = URL_HOME + "register"
let URL_MEMBER_UPDATE = URL_HOME + "member/update"
let URL_EMAIL_VALIDATE = URL_HOME + "member/email_validate"
let URL_MOBILE_VALIDATE = URL_HOME + "member/mobile_validate"
let URL_SEND_EMAIL_VALIDATE = URL_HOME + "member/sendEmailValidate"
let URL_SEND_MOBILE_VALIDATE = URL_HOME + "member/sendMobileValidate"
let URL_MEMBER_GETONE = URL_HOME + "member/getOne"
let URL_MEMBER_BLACKLIST = URL_HOME + "member/blacklist"
let URL_FORGET_PASSWORD = BASE_URL + "/member/forget_password"
let URL_CHANGE_PASSWORD = BASE_URL + "/member/change_password"
let URL_CITYS = URL_HOME + "citys"
let URL_CUSTOM_CITYS = URL_HOME + "custom_citys"
let URL_ARENA_BY_CITY_ID = URL_HOME + "arena_by_city"
let URL_ARENA_BY_CITY_IDS = URL_HOME + "arena_by_citys"
let URL_AREA_BY_CITY_IDS = URL_HOME + "area_by_citys"
let URL_ONE = "\(URL_HOME)%@/one"
let URL_UPDATE = "\(URL_HOME)%@/update"
let URL_DELETE = "\(URL_HOME)%@/delete"
let URL_TT = "\(URL_HOME)%@/tt"

let URL_TEAM = URL_HOME + "team/"
let URL_TEAM_TEMP_PLAY = URL_TEAM + "tempPlay/onoff"
let URL_TEAM_TEMP_PLAY_LIST = URL_TEAM + "tempPlay/list"
let URL_TEAM_PLUSONE = BASE_URL + "/team/tempPlay/plusOne/"
let URL_TEAM_CANCELPLUSONE = BASE_URL + "/team/tempPlay/cancelPlusOne/"
let URL_TEAM_TEMP_PLAY_BLACKLIST = URL_TEAM + "tempPlay/blacklist"
let URL_TEAM_TEMP_PLAY_DATE = URL_TEAM + "tempPlay/date"
let URL_TEAM_TEMP_PLAY_DATE_PLAYER = URL_TEAM + "tempPlay/datePlayer"

let URL_COACH = URL_HOME + "coach/"

// Font
let FONT_NAME: String = "Apple SD Gothic Neo"
let FONT_SIZE_TITLE: CGFloat = 22
let FONT_SIZE_TABBAR: CGFloat = 14

// List pages
let IPHONE_CELL_ON_ROW: Int = 1
let IPAD_CELL_ON_ROW:Int = 2
let CELL_EDGE_MARGIN: CGFloat = 8
let TITLE_HEIGHT: CGFloat = 27
let FEATURED_HEIGHT: CGFloat = 200
let PERPAGE: Int = 8

let STATUSBAR_HEIGHT:CGFloat = 16

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
let TO_VALIDATE: String = "toValidate"
let TO_EDIT: String = "toEdit"
let TO_CITY: String = "toCity"
let TO_AREA: String = "toArea"
let TO_ARENA: String = "toArena"
let TO_WEEKDAY: String = "toWeekday"
let TO_SELECT_TIME: String = "toSelectTime"
let TO_TEXT_INPUT: String = "toTextInput"
let TO_SELECT_DEGREE: String = "toSelectDegree"
let TO_TEMP_PLAY_SHOW: String = "toTempPlayShow"
let TO_PASSWORD: String = "toPassword"
let TO_COURSE: String = "toCourse"
let TO_MANAGER: String = "toManager"
let TO_MANAGER_FUNCTION: String = "toManagerFunction"
let TO_COACH_MANAGER_FUNCTION: String = "toCoachManagerFunction"
let TO_COACH_SIGNUP: String = "toCoachSignup"
let TO_TIMETABLE: String = "toTimeTable"
let TO_COACH_SUBMIT: String = "toCoachSubmit"
let TO_TEMP_PLAY_DATE: String = "toTempPlayDate"
let TO_TEMP_PLAY_DATE_PLAYER: String = "toTempPlayDatePlayer"
let TO_TEMP_PLAY_SIGNUP_ONE: String = "toTempPlaySignupOne"
let TO_TEAM_TEMP_PLAY: String = "toTeamTempPlay"//臨打編輯
let TO_TEMP_PLAY_LIST: String = "toTempplayList"
let TO_BLACKLIST: String = "toBlacklist"
let TO_REFRESH: String = "toRefresh"
let TO_SEARCH: String = "toSearch"
let TO_MAP: String = "toMap"

// color
let MY_GREEN = "#a6d903"
let MY_RED = "#f11b90"
let STATUS_GREEN = "#658501"
let TABBAR_BACKGROUND = "#0d0d0d"
let TEXTBORDER = MY_GREEN
let PLACEHOLDER = "#8b8f90"
let TEXTBACKGROUND = "#3d3f41"

// User Defaults
let NICKNAME_KEY = "nickname"
let ISLOGGEDIN_KEY = "isLoggedIn"
let UID_KEY = "uid"
let NAME_KEY = "name"
let CHANNEL_KEY = "channel"
let DOB_KEY = "dob"
let SEX_KEY = "sex"
let PID_KEY = "pid"
let PLAYERID_KEY = "player_id"
let AVATAR_KEY = "avatar"
let MEMBER_TYPE_KEY = "type"
let SOCIAL_KEY = "social"
let MEMBER_ROLE_KEY = "role"
let VALIDATE_KEY = "validate"
let ISTEAMMANAGER_KEY = "isTeamManager"

// member
let MEMBER_FIELD_STRING = [TOKEN_KEY,EMAIL_KEY,NICKNAME_KEY,NAME_KEY,UID_KEY,CHANNEL_KEY,DOB_KEY,SEX_KEY,TEL_KEY,MOBILE_KEY,PID_KEY,AVATAR_KEY,MEMBER_ROLE_KEY,SOCIAL_KEY,PLAYERID_KEY]
let MEMBER_FIELD_INT = [ID_KEY,VALIDATE_KEY,MEMBER_TYPE_KEY]
let MEMBER_FIELD_BOOL = [ISLOGGEDIN_KEY]
let EMAIL_VALIDATE = 1
let MOBILE_VALIDATE = 2
let PID_VALIDATE = 4
let GENERAL_TYPE = 1
let TEAM_TYPE = 2
let ARENA_TYPE = 4
let MEMBER_ARRAY = [
    NAME_KEY: ["text":"姓名","icon":"name"],
    EMAIL_KEY: ["text":"email","icon":"email1"],
    NICKNAME_KEY: ["text":"暱稱","icon":""],
    DOB_KEY: ["text":"生日","icon":""],
    SEX_KEY: ["text":"性別","icon":""],
    TEL_KEY: ["text":"電話","icon":""],
    MOBILE_KEY: ["text":"手機","icon":"mobile"],
    PID_KEY: ["text":"身分證字號","icon":""],
    MEMBER_TYPE_KEY: ["text":"會員類型","icon":""],
    MEMBER_ROLE_KEY: ["text":"會員身份","icon":""],
    VALIDATE_KEY: ["text":"驗證","icon":""]
]

// Team key
let TEAM_LEADER_KEY = "leader"
let TEAM_PLAY_START_KEY = "play_start"
let TEAM_PLAY_END_KEY = "play_end"
let TEAM_INTERVAL_KEY = "interval"
let TEAM_BALL_KEY = "ball"
let TEAM_DEGREE_KEY = "degree"
let TEAM_DAYS_KEY = "days"
let TEAM_NEAR_DATE_KEY = "near_date"

let TEAM_TEMP_FEE_M_KEY = "temp_fee_M"
let TEAM_TEMP_FEE_F_KEY = "temp_fee_F"
let TEAM_TEMP_QUANTITY_KEY = "temp_quantity"
let TEAM_TEMP_SIGNUP_KEY = "temp_signup_count"
let TEAM_TEMP_CONTENT_KEY = "temp_content"
let TEAM_TEMP_STATUS_KEY = "temp_status"

// Team temp_play key

// Coach key
let COACH_SENIORITY_KEY = "seniority"
let COACH_EXP_KEY = "exp"
let COACH_FEAT_KEY = "feat"
let COACH_LICENSE_KEY = "license"

// Arena key
let ARENA_OPEN_TIME_KEY: String = "open_time"
let ARENA_CLOSE_TIME_KEY: String = "close_time"
let ARENA_BLOCK_KEY: String = "block"
let ARENA_AIR_CONDITION_KEY: String = "air_condition"
let ARENA_PARKING_KEY: String = "parking"
let ARENA_BATHROOM_KEY: String = "bathroom"
let ARENA_INTERVAL_KEY: String = "interval"

// Course key
let COURSE_PROVIDER_KEY: String = "provider_url"

// General key
let ID_KEY = "id"
let TOKEN_KEY = "token"
let EMAIL_KEY = "email"
let MOBILE_KEY = "mobile"
let TEL_KEY = "tel"
let TITLE_KEY = "title"
//let NAME_KEY = "name" member block
let SLUG_KEY = "slug"
let CAT_KEY = "cat_id"
let FEATURED_KEY = "featured_path"
let THUMB_KEY = "thumb"
let WEBSITE_KEY = "website"
let YOUTUBE_KEY = "youtube"
let VIMEO_KEY = "vimeo"
let FB_KEY = "fb"
let LINE_KEY = "line"
let CITY_KEY = "city"
let AREA_KEY = "area"
let ARENA_KEY = "arena"
let ROAD_KEY = "road"
let ADDRESS_KEY = "address"
let ZIP_KEY = "zip"
let CONTENT_KEY = "content"
let CHARGE_KEY = "charge"
let MANAGER_ID_KEY = "manager_id"
let PV_KEY = "pv"
let STATUS_KEY = "status"
let SORT_ORDER_KEY = "sort_order"
let COLOR_KEY = "color"
let CREATED_ID_KEY = "created_id"
let CREATED_AT_KEY = "created_at"
let UPDATED_AT_KEY = "updated_at"


// Notification Constants
let NOTIF_MEMBER_DID_CHANGE = Notification.Name("notifMemberChanged")
let NOTIF_MEMBER_UPDATE = Notification.Name("notifMemberUpdate")
let NOTIF_TEAM_UPDATE = Notification.Name("notifTeamUpdate")

// Push Notification
let PUSH_TEST_PLAYID = "53e3238c-d78b-40b0-abf4-90174a7a9b67"
let PUSH_LANGUAGE = "zh-Hant"

// Header
let HEADER = ["Content-Type": "application/json; charset=utf-8"]

// Team Temp play list
struct TEAM_TEMP_PLAY_CELL {
    let height: CGFloat = 130
    let height_padding: CGFloat = 8
    let name_top_padding: CGFloat = 8
    let name_left_padding: CGFloat = 8
}

// Static Cell
struct STATICCELL {
    let padding: CGFloat = 10
    let xMargin: CGFloat = 20
}











