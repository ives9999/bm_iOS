//
//  ApiService.swift
//  bm
//
//  Created by ives on 2024/5/10.
//  Copyright © 2024 bm. All rights reserved.
//

import Foundation


class ApiService<T: BaseDao> {
    
    //static let instance = ApiService()
    
    func get(_url: String, params: [String: String]) async throws -> BaseResult<T> {
        var query: String = ""
        for (key, value) in params {
            query += key + "=" + value + "&"
        }
        
        // 將最後一個"="拿掉
        query = String(query.dropLast())
        
        let url = _url + "?" + query
        print(url)
        
        let (data, _) = try await URLSession.shared.data(from: URL(string: url)!)
        //data.prettyPrintedJSONString
        let dao: T = try JSONDecoder().decode(T.self, from: data) as T
        //print(dao)
        
        if (dao.status == 200) {
            return .success(dao)
        } else {
            return .failure("fail")
        }
        
        //return arenaReadDao
    }
}

enum BaseResult<T: Codable> {
  case loading(Bool)
  case success(T)
  case failure(String)
}
