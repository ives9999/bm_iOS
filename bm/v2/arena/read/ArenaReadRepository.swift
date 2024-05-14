//
//  ArenaRepository.swift
//  bm
//
//  Created by ives on 2024/5/10.
//  Copyright © 2024 bm. All rights reserved.
//

import Foundation

class ArenaReadRepository {
    var apiService: ApiService
    
    init() {
        apiService = ApiService()
    }
    
    func getRead(page: Int, perpage: Int, otherParams: [String: String]? = nil)-> Result<ArenaReadDao, Error> {
        let url: String = URL_ARENA_LIST
        
        Task {
            var params: [String: String] = ["page": String(page), "perpage": String(perpage)]
            params = otherParams != nil ? params.merging(otherParams!, uniquingKeysWith: {$1}) : params
        
            do {
                let dao: ArenaReadDao = try await apiService.get(_url: url, params: params)
                return dao
            } catch {
                return ArenaReadDao()
            }
        }
        return ArenaReadDao()
    }
}
