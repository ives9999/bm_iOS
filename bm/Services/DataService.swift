//
//  DataService.swift
//  bm
//
//  Created by ives on 2017/10/4.
//  Copyright © 2017年 bm. All rights reserved.
//

import Foundation
class DataService {
    static let instance = DataService()
    
    private let homes = [
        Home(featured: "1.jpg", title: "艾傑早安羽球團8月份會內賽"),
        Home(featured: "2.jpg", title: "永遠支持的戴資穎"),
        Home(featured: "3.jpg", title: "外媒評十大羽毛球美女，馬琳竟上榜！")
    ]
    
    func getHomes() -> [Home] {
        return homes
    }
}
