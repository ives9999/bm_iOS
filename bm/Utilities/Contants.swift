//
//  Contants.swift
//  bm
//
//  Created by ives on 2017/10/6.
//  Copyright © 2017年 bm. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

typealias CompletionHandler = (_ Success: Bool) -> ()
typealias DATA = Dictionary<String, [String: Any]>

let CHANNEL = "bm"

// URL Constants
let REMOTE_BASE_URL = "https://bm.sportpassword.com"
//let REMOTE_BASE_URL = "https://sandbox.sportpassword.com"
//let REMOTE_BASE_URL = "http://192.168.100.120"
//let LOCALHOST_BASE_URL = "http://127.0.0.1"
//let LOCALHOST_BASE_URL = "http://bm.sportpassword.localhost"
//let LOCALHOST_BASE_URL = "http://192.168.100.120"
let LOCALHOST_BASE_URL = "https://sandbox.sportpassword.com"
let BASE_URL = (gSimulate) ? LOCALHOST_BASE_URL : REMOTE_BASE_URL

let URL_AREA_BY_CITY_IDS = URL_HOME + "area_by_citys"
let URL_ARENA_BY_CITY_ID = URL_HOME + "arena_by_city"
let URL_ARENA_BY_CITY_IDS = URL_HOME + "arena_by_citys"
let URL_ARENA_LIKE = "\(URL_HOME)arena/like"
let URL_ARENA_LIST = "\(URL_HOME)arena/list"
let URL_CANCEL_SIGNUP = "\(URL_HOME)%@/cancelSignup/%d"
let URL_CART_LIST = "\(URL_HOME)cart/list"
let URL_CART_UPDATE = "\(URL_HOME)cart/update"
let URL_CHANGE_PASSWORD = BASE_URL + "/member/change_password"
let URL_CITYS = URL_HOME + "citys"
let URL_COACH = URL_HOME + "coach/"
let URL_COACH_LIKE = "\(URL_HOME)coach/like"
let URL_COACH_LIST = "\(URL_HOME)coach/list"
let URL_COURSE_CALENDAR = "\(URL_HOME)course/calendar"
let URL_COURSE_LIKE = "\(URL_HOME)course/like"
let URL_COURSE_LIST = "\(URL_HOME)course/list"
let URL_COURSE_SIGNUP_LIST = URL_HOME + "course/signup_list"
let URL_CUSTOM_CITYS = URL_HOME + "custom_citys"
let URL_DELETE = "\(URL_HOME)%@/delete"
let URL_ECPAY2_C2C_MAP = "\(URL_HOME)order/ecpay2_c2c_map"
let URL_EMAIL_VALIDATE = URL_HOME + "member/email_validate"
let URL_FB_LOGIN = URL_HOME + "member/fb"
let URL_FORGET_PASSWORD = BASE_URL + "/member/forget_password"
let URL_HOME = "\(BASE_URL)/app/"
let URL_ISNAMEEXIST = "\(URL_HOME)%@/isNameExist"
let URL_LIKE = "\(URL_HOME)%@" // use URL_COURSE_LIKE etc...
let URL_LIST = "\(URL_HOME)%@"
let URL_LOGIN = URL_HOME + "login"
let URL_MANAGER_SIGNUPLIST = URL_HOME + "%@/manager_signup_list"
let URL_MEMBER_BANK = URL_HOME + "member/bank"
let URL_MEMBER_BLACKLIST = URL_HOME + "member/blacklist"
let URL_MEMBER_COINLIST = URL_HOME + "member/coinlist"
let URL_MEMBER_COINRETURN = URL_HOME + "member/coinReturn"
let URL_MEMBER_GETONE = URL_HOME + "member/getOne"
let URL_MEMBER_LEVEL_KIND = URL_HOME + "member/levelKind"
let URL_MEMBER_LIKELIST = URL_HOME + "member/likelist"
let URL_MEMBER_SIGNUP_CALENDAR = URL_HOME + "member/signup_calendar"
let URL_MEMBER_SUBSCRIPTION = URL_HOME + "member/subscription"
let URL_MEMBER_UPDATE = URL_HOME + "member/update"
let URL_MOBILE_VALIDATE = URL_HOME + "member/mobile_validate"
let URL_ONE = "\(URL_HOME)%@/one"
let URL_ORDER = "\(URL_HOME)order/payment"
let URL_ORDER_LIST = "\(URL_HOME)order/list"
let URL_ORDER_RETURN = "\(URL_HOME)order/ezship_return_code"
let URL_ORDER_UPDATE = "\(URL_HOME)order/update"
let URL_PRODUCT_LIKE = "\(URL_HOME)product/like"
let URL_PRODUCT_LIST = "\(URL_HOME)product/list"
let URL_REGISTER = URL_HOME + "register"
let URL_REQUEST_MANAGER = "\(URL_HOME)request_manager/update"
let URL_SHOW = "\(URL_HOME)%@/show/%@?device=app"
let URL_SEND_EMAIL_VALIDATE = URL_HOME + "member/sendEmailValidate"
let URL_SEND_MOBILE_VALIDATE = URL_HOME + "member/sendMobileValidate"
let URL_SIGNUP = "\(URL_HOME)%@/signup/%@"
let URL_SIGNUP_DATE = "\(URL_HOME)%@/signup_date/%@"
let URL_SIGNUP_LIST = "\(URL_HOME)%@/signup_list"
let URL_STORE_LIKE = "\(URL_HOME)store/like"
let URL_STORE_LIST = "\(URL_HOME)store/list"
let URL_TEACH_LIKE = "\(URL_HOME)teach/like"
let URL_TEACH_LIST = "\(URL_HOME)teach/list"
let URL_TEAM_LIST = "\(URL_HOME)team/list"
let URL_TT = "\(URL_HOME)%@/tt"
let URL_TEAM = URL_HOME + "team/"
let URL_TEAM_CANCELPLUSONE = BASE_URL + "/team/tempPlay/cancelPlusOne/"
let URL_TEAM_LIKE = "\(URL_HOME)team/like"
let URL_TEAM_PLUSONE = BASE_URL + "/team/tempPlay/plusOne/"
let URL_TEAM_TEMP_PLAY = URL_TEAM + "tempPlay/onoff"
let URL_TEAM_TEMP_PLAY_BLACKLIST = URL_TEAM + "tempPlay/blacklist"
let URL_TEAM_TEMP_PLAY_DATE = URL_TEAM + "tempPlay/date"
let URL_TEAM_TEMP_PLAY_DATE_PLAYER = URL_TEAM + "tempPlay/datePlayer"
let URL_TEAM_TEMP_PLAY_LIST = URL_TEAM + "tempPlay/list"
let URL_TT_DELETE = "\(URL_HOME)%@/tt/delete"
let URL_TT_UPDATE = "\(URL_HOME)%@/tt/update"
let URL_UPDATE = "\(URL_HOME)%@/update"

// Font
let FONT_NAME: String = "HelveticaNeue"
let FONT_BOLD_NAME: String = "Arial-BoldMT"
let FONT_SIZE_TITLE: CGFloat = 21
let FONT_SIZE_GENERAL: CGFloat = 15
let FONT_SIZE_TABBAR: CGFloat = 14

// List pages
let IPHONE_CELL_ON_ROW: Int = 1
let IPAD_CELL_ON_ROW:Int = 2
let CELL_EDGE_MARGIN: CGFloat = 8
let TITLE_HEIGHT: CGFloat = 27
let FEATURED_HEIGHT: CGFloat = 200
let PERPAGE: Int = 20

let STATUSBAR_HEIGHT:CGFloat = 16

// spinner
let LOADING: String = "努力加載中..."
let LOADING_WIDTH: Int = 200
let LOADING_HEIGHT: Int = 40

// segues
let UNWIND: String = "unwindToMenu"
let MENU_TABLE: String = "meunTable"

let TO_ADD_CART: String = "toAddCart"
let TO_AREA: String = "toArea"
let TO_ARENA: String = "toArena"
let TO_BLACKLIST: String = "toBlacklist"
let TO_CITY: String = "toCity"
let TO_COACH: String = "toCoach"
let TO_COACH_MANAGER_FUNCTION: String = "toCoachManagerFunction"
let TO_COACH_SIGNUP: String = "toCoachSignup"
let TO_COACH_SUBMIT: String = "toCoachSubmit"
let TO_CONTENT_EDIT: String = "toContentEdit"
let TO_COURSE: String = "toCourse"
let TO_DEGREE: String = "toDegree"
let TO_DELETE: String = "toDelete"
let TO_EDIT: String = "toEdit"
let TO_EDIT_COURSE: String = "toEditCourse"
let TO_EDIT_PROFILE: String = "toEditProfile"
let TO_EDIT_STORE: String = "toEditStore"
let TO_HOME: String = "toHome"
//let TO_LASTSIGNUPLIST: String = "toLastSignupList"
let TO_LIKE: String = "toLike"
let TO_LOGIN: String = "toLogin"
let TO_MANAGER: String = "toManager"
let TO_MANAGER_COURSE: String = "toManagerCourse"
let TO_MANAGER_FUNCTION: String = "toManagerFunction"
let TO_MANAGER_SIGNUP: String = "toManagerSignup"
let TO_MANAGER_STORE: String = "toManagerStore"
let TO_MANAGER_SIGNUPLIST: String = "toManagerSignupList"
let TO_MAP: String = "toMap"
let TO_MEMBER_BANK: String = "toMemberBank"
let TO_MEMBER_CART_LIST: String = "toMemberCartList"
let TO_MEMBER_COIN_LIST: String = "toMemberCoinList"
let TO_MEMBER_LEVELUP: String = "toMemberLevelUp"
let TO_MEMBER_LEVELUPPAY: String = "toMemberLevelUpPay"
let TO_MEMBER_LIKE_LIST: String = "toMemberLikeList"
let TO_MEMBER_ORDER_LIST: String = "toMemberOrderList"
let TO_MEMBER_SIGNUPLIST: String = "toMemberSignuplist"
let TO_MULTI_SELECT: String = "toMultiSelect"
let TO_ORDER: String = "toOrder"
let TO_PASSWORD: String = "toPassword"
let TO_PRODUCT: String = "toProduct"
let TO_PN: String = "toPN"
let TO_PAYMENT: String = "toPayment"
let TO_PROFILE: String = "toProfile"
let TO_REGISTER: String = "toRegister"
let TO_REFRESH: String = "toRefresh"
let TO_REQUEST_MANAGER_TEAM: String = "toRequestManagerTeam"
let TO_SEARCH: String = "toSearch"
let TO_SELECT_AREA: String = "toSelectArea"
let TO_SELECT_AREAS: String = "toSelectAreas"
let TO_SELECT_CITY: String = "toSelectCity"
let TO_SELECT_CITYS: String = "toSelectCitys"
let TO_SELECT_DEGREE: String = "toSelectDegree"
let TO_SELECT_MANAGERS: String = "toSelectManagers"
let TO_SELECT_WEEKDAY: String = "toWeekday"
let TO_SELECT_DATE: String = "toSelectDate"
let TO_SELECT_TIME: String = "toSelectTime"
let TO_SELECT_COLOR: String = "toSelectColor"
let TO_SELECT_STATUS: String = "toSelectStatus"
let TO_SHOW: String = "toShow"
let TO_SHOW_ARENA: String = "toShowArena"
let TO_SHOW_COACH: String = "toShowCoach"
let TO_SHOW_COURSE: String = "toShowCourse"
let TO_SHOW_PRODUCT: String = "toShowProduct"
let TO_SHOW_STORE: String = "toShowStore"
let TO_SHOW_TEACH: String = "toShowTeach"
let TO_SHOW_TEAM: String = "toShowTeam"
let TO_SHOW_TIMETABLE: String = "toShowTimeTable"
let TO_SIGNUPLIST: String = "toSignupList"
let TO_SINGLE_SELECT: String = "toSingleSelect"
let TO_STORE: String = "toStore"
let TO_TEACH: String = "toTeach"
let TO_TEAM_TEMP_PLAY: String = "toTeamTempPlay"//臨打編輯
let TO_TEMP_PLAY_DATE: String = "toTempPlayDate"
let TO_TEMP_PLAY_DATE_PLAYER: String = "toTempPlayDatePlayer"
let TO_TEMP_PLAY_LIST: String = "toTempplayList"
let TO_TEMP_PLAY_SHOW: String = "toTempPlayShow"
let TO_TEMP_PLAY_SIGNUP_ONE: String = "toTempPlaySignupOne"
let TO_TEXT_INPUT: String = "toTextInput"
let TO_TIMETABLE: String = "toTimeTable"
let TO_VALIDATE: String = "toValidate"
let TO_WEBVIEW: String = "toWebView"
let TO_YOUTUBE_PLAYER: String = "toYoutubePlayer"

// color
let BOTTOM_VIEW_BACKGROUND = "#5D5D5D"
let CELL_SELECTED = "#444444"
let CELL_SELECTED1 = "#402424"
let MEMBER_COIN_BUY = "#0D8504"
let MEMBER_COIN_GIFT = "#0794EA"
let MEMBER_COIN_PAY = "#893FFF"
let MY_BLACK = "#000000"
let MY_GREEN = "#a6d903"
let MY_RED = "#f11b90"
let MY_LIGHT_WHITE = "#AAAAAA"
let MY_LIGHT_RED = "#FF4081"
let MY_PURPLE = "#893FFE"
let MY_WEIGHT_RED = "#FF3030"
let MY_GRAY = "#717171"
let MY_PAY = "#893FFF"
let MY_WHITE = "#FFFFFF"
let LIKE_BUTTON = "#a6d903"
let CANCEL_BUTTON = "#444444"
let CITY_BUTTON = "#555555"
let CLEAR_BUTTON = "#999999"
let STATUS_GREEN = "#658501"
let TABBAR_BACKGROUND = "#0d0d0d"
let TAG_UNSELECTED_BACKGROUND = "#b9b9b9"
//let TAG_UNSELECTED_BOLDCOLOR = UIColor.clear
let TAG_UNSELECTED_TEXTCOLOR = MY_BLACK
let TAG_SELECTED_BACKGROUND = MY_BLACK
let TAG_SELECTED_BOLDCOLOR = MY_RED
let TAG_SELECTED_TEXTCOLOR = MY_WHITE
let TEXTBORDER = MY_GREEN
let TEXTDATETIME = "#AAAAAA"
let TEXTGRAY = "#BFBFBF"
let TEXT_WHITE = "#d1d1d1"
let PLACEHOLDER = "#8b8f90"
let TEXTBACKGROUND = "#3d3f41"
let DARKBACKGROUND = "#282828"
let MONDAY_COLOR = "#389DAD"
let TUESDAY_COLOR = "#659B2C"
let WEDNESDAY_COLOR = "#F4BA00"
let THURSDAY_COLOR = "#E47417"
let FRIDAY_COLOR = "#B04444"
let SATURDAY_COLOR = "#1aff5e"
let SEARCH_BACKGROUND = "#393939"
let SEARCH_BACKGROUND_PLACEHOLDER = "#C6C6C6"
let SUNDAY_COLOR = "#795bff"

// User Defaults
let NICKNAME_KEY = "nickname"
let ISLOGGEDIN_KEY = "isLoggedIn"
let UID_KEY = "uid"
let NAME_KEY = "name"
let COIN_KEY = "coin"
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
let MEMBER_FIELD_STRING = [TOKEN_KEY,EMAIL_KEY,NICKNAME_KEY,NAME_KEY,UID_KEY,CHANNEL_KEY,DOB_KEY,SEX_KEY,TEL_KEY,MOBILE_KEY,
                           PID_KEY,AVATAR_KEY,MEMBER_ROLE_KEY,SOCIAL_KEY,PLAYERID_KEY,ROAD_KEY,FB_KEY,LINE_KEY]
let MEMBER_FIELD_INT = [ID_KEY,VALIDATE_KEY,MEMBER_TYPE_KEY,"city_id","area_id",ZIP_KEY]
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
let MEMBER_MUST_ARRAY = [
    NAME_KEY, NICKNAME_KEY, EMAIL_KEY, MOBILE_KEY, SEX_KEY, CITY_KEY, AREA_KEY, ROAD_KEY
]

let MEMBER_MUST_ARRAY_WARNING = [
    NAME_KEY: "會員資料沒有填寫姓名",
    NICKNAME_KEY: "會員資料沒有填寫暱稱",
    EMAIL_KEY: "會員資料沒有填寫email",
    MOBILE_KEY: "會員資料沒有填寫手機",
    SEX_KEY: "會員資料沒有選擇性別",
    CITY_KEY: "會員資料沒有選擇縣市",
    AREA_KEY: "會員資料沒有選擇區域",
    ROAD_KEY: "會員資料沒有填寫路名"
]

// Team key
let TEAM_LEADER_KEY = "leader"
let TEAM_PLAY_START_KEY = "play_start"
let TEAM_PLAY_END_KEY = "play_end"
let TEAM_INTERVAL_KEY = "interval"
let TEAM_BALL_KEY = "ball"
let TEAM_DEGREE_KEY = "degree"
let TEAM_WEEKDAYS_KEY = "weekdays"
let TEAM_NEAR_DATE_KEY = "near_date"

let TEAM_TEMP_FEE_M_KEY = "temp_fee_M"
let TEAM_TEMP_FEE_F_KEY = "temp_fee_F"
let TEAM_TEMP_DATE_KEY = "temp_date"
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

// Timetalbe key
let TT_TITLE: String = "title"
let TT_WEEKDAY: String = "weekday"
let TT_START_DATE: String = "start_date"
let TT_END_DATE: String = "end_date"
let TT_START_TIME: String = "start_time"
let TT_END_TIME: String = "end_time"
let TT_LIMIT: String = "limit"
let TT_CHARGE: String = "charge"
let TT_COLOR: String = "color"
let TT_STATUS: String = "status"
let TT_CONTENT: String = "content"

// Course key
let COURSE_PROVIDER_KEY: String = "provider_url"
let COURSE_DATE_KEY: String = "able_date"
let COURSE_DEADLINE_KEY: String = "cancel_deadline"

// General key
let ADDRESS_KEY = "address"
let AMOUNT_KEY = "amount"
let AREA_KEY = "area"
//let AREA_ID_KEY = "area_id"
let ARENA_KEY = "arena"
let ATTRIBUTE_KEY = "attribute"
let BANK_BANK_KEY = "bank"
let BANK_BRANCH_KEY = "branch"
let BANK_CODE_KEY = "bank_code"
let BANK_ACCOUNT_KEY = "account"
let BARCODE1_KEY = "barcode1"
let BARCODE2_KEY = "barcode2"
let BARCODE3_KEY = "barcode3"
let CAT_KEY = "cat_id"
let CHARGE_KEY = "charge"
let CITY_KEY = "city"
//let CITY_ID_KEY = "city_id"
let CITYS_KEY = "citys"
let CLOSE_TIME_KEY = "close_time"
let CLOTHES_SIZE_KEY = "clothes_size"
let COLOR_KEY = "color"
let COMPANY_KEY = "company"
let CONTACT_KEY = "contact"
let CONTENT_KEY = "content"
let CORNER_RADIUS = 6.0
let CELL_KEY = "cell"
let CREATED_AT_KEY = "created_at"
let CREATED_ID_KEY = "created_id"
let CREDIT_CARD_KEY = "credit_card"
let DEGREE_KEY = "degree"
let DIRECT_KEY = "direct"
let DISCOUNT_KEY = "discount"
let EMAIL_KEY = "email"
let END_DATE_KEY: String = "end_date"
let END_TIME_KEY: String = "end_time"
let EXPIRE_AT_KEY: String = "expire_at"
let FAMILY_KEY = "family"
let FB_KEY = "fb"
let FEATURED_KEY = "featured_path"
let GATEWAY_KEY = "gateway"
let GATEWAY_AT_KEY = "gateway_at"
let GATEWAY_METHOD_KEY = "gateway_method"
let GATEWAY_PROCESS_KEY = "gateway_process"
let GRAND_TOTAL_KEY = "grand_total"
let ID_KEY = "id"
let INVOICE_KEY = "invoice"
let INVOICE_COMPANY_KEY = "invoice_company"
let INVOICE_COMPANY_NAME_KEY = "invoice_company_name"
let INVOICE_COMPANY_TAX_KEY = "invoice_company_tax"
let INVOICE_TYPE_KEY = "invoice_type"
let INVOICE_EMAIL_KEY = "invoice_email"
let INVOICE_NO_KEY = "invoice_no"
let INVOICE_AT_KEY = "invoice_at"
let INVOICE_PERSONAL_KEY = "invoice_personal"
let KEY_KEY = "key"
let KEYWORD_KEY = "keyword"
let LEVEL_KEY = "level"
let LINE_KEY = "line"
let MANAGER_ID_KEY = "manager_id"
let MANAGERS_KEY = "managers_id"
let MEMBER_KEY = "member"
let MEMO_KEY = "memo"
let MOBILE_KEY = "mobile"
let NUMBER_KEY = "number"
let OPEN_TIME_KEY = "open_time"
let ORDER_KEY = "order"
let ORDER_NO_KEY = "order_no"
let ORDER_PROCESS_KEY = "order_process"
let PASSWORD_KEY = "password"
let PAYMENT_KEY = "payment"
let PAYMENT_NO_KEY = "payment_no"
let PEOPLE_LIMIT_KEY: String = "people_limit"
let PERSONAL_KEY: String = "personal"
let PRIVACY_KEY: String = "privacy"
let PRICE_DESC_KEY: String = "price_desc"
let PRICE_KEY = "price"
let PRICE_UNIT_KEY: String = "price_unit"
let PRODUCT_KEY = "product"
let PV_KEY = "pv"
let QUANTITY_KEY = "quantity"
let REPASSWORD_KEY = "repassword"
let RETURN_KEY = "return"
let RETURN_SN_ID_KEY = "return_sn_id"
let RETURN_EXPIRE_AT_KEY = "return_expire_at"
let RETURN_CREATED_AT_KEY = "return_created_at"
let ROAD_KEY = "road"
let SEVEN_KEY = "SEVEN"
let SHIPPING_AT_KEY = "shipping_at"
let SHIPPING_RETURN_AT_KEY = "shipping_back_at"
let SHIPPING_COMPLETE_AT_KEY = "shipping_complete_at"
let SHIPPING_FEE_KEY = "shipping_fee"
let SHIPPING_KEY = "shipping"
let SHIPPING_METHOD_KEY = "shipping_method"
let SHIPPING_PROCESS_KEY = "shipping_process"
let SHIPPING_STORE_AT_KEY = "shipping_store_at"
let SHOW_KEY = "show"
let SLUG_KEY = "slug"
let SORT_ORDER_KEY = "sort_order"
let START_DATE_KEY: String = "start_date"
let START_TIME_KEY: String = "start_time"
let STATUS_KEY = "status"
let SUBTOTAL_KEY = "sub_total"
let TAG_KEY = "tag"
let TAX_KEY = "tax"
let TEL_KEY = "tel"
let THUMB_KEY = "thumb"
let TITLE_KEY = "title"
let TOKEN_KEY = "token"
let TOTAL_KEY = "total"
let UPDATED_AT_KEY = "updated_at"
let VALUE_KEY = "value"
let VIMEO_KEY = "vimeo"
let WEBSITE_KEY = "website"
let WEEKDAY_KEY: String = "weekday"
let WEEKDAYS_KEY: String = "weekdays"
let WEIGHT_KEY: String = "weight"
let YOUTUBE_KEY = "youtube"
let ZIP_KEY = "zip"

let MY_BUTTON_CORNER: CGFloat = 6.0

// Course key
let CYCLE_UNIT_KEY: String = "cycle_unit"
let COURSE_KIND_KEY: String = "kind"

// Notification Constants
let NOTIF_MEMBER_DID_CHANGE = Notification.Name("notifMemberChanged")
let NOTIF_MEMBER_UPDATE = Notification.Name("notifMemberUpdate")
let NOTIF_TEAM_UPDATE = Notification.Name("notifTeamUpdate")

// Push Notification
let PUSH_TEST_PLAYID = "53e3238c-d78b-40b0-abf4-90174a7a9b67"
let PUSH_LANGUAGE = "zh-Hant"

//Iden
let IDEN_SINGLE_SELECT = "UIViewController-Exi-DF-oVO"
let IDEN_MULTI_SELECT = "UIViewController-RNp-jr-1LT"

// Header
let HEADER: HTTPHeaders = ["Content-Type": "application/json; charset=utf-8"]

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











