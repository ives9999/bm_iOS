//
//  ApiService.swift
//  bm
//
//  Created by ives on 2024/5/10.
//  Copyright © 2024 bm. All rights reserved.
//

import Foundation


class ApiService {
    
    static let instance = ApiService()
    
    func get(_url: String, params: [String: String]) async throws -> ArenaReadDao {
        var query: String = ""
        for (key, value) in params {
            query += key + "=" + value + "&"
        }
        query = String(query.dropLast())
        
        let url = _url + "?" + query
        print(url)
        
        let (data, _) = try await URLSession.shared.data(from: URL(string: url)!)
        let arenaReadDao: ArenaReadDao = try JSONDecoder().decode(ArenaReadDao.self, from: data)
        print(arenaReadDao)
        
        return arenaReadDao
    }
}
