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
let URL_LIST = "\(BASE_URL)/app/%@"
let URL_SHOW = "\(BASE_URL)/app/%@/show/%@?device=app"

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

// color
let TABBAR_BACKGROUND = "#0d0d0d"
let SELECTED_COLOR = "#03f505"
