//
//  ArenaRepository.swift
//  bm
//
//  Created by ives on 2024/5/10.
//  Copyright © 2024 bm. All rights reserved.
//

import Foundation

class ArenaReadRepository {
    var apiService: ApiService<ArenaReadDao>
    
    init() {
        apiService = ApiService<ArenaReadDao>()
    }
    
    
    func getRead(page: Int, perpage: Int, otherParams: [String: String]? = nil)-> ArenaReadDao {
        let url: String = URL_ARENA_LIST
                
        Task {
            var params: [String: String] = ["page": String(page), "perpage": String(perpage)]
            params = otherParams != nil ? params.merging(otherParams!, uniquingKeysWith: {$1}) : params
            
            do {
                let result = try await apiService.get(_url: url, params: params)
                switch result {
                case .success(let dao):
                    return dao
                case .failure(let error):
                    print(error)
                case .loading(let isLoading):
                    print(isLoading)
                }
            } catch {
                return ArenaReadDao()
            }
            return ArenaReadDao()
        
//            do {
//                let dao: ArenaReadDao = try await apiService.get(_url: url, params: params)
//                return .success(dao)
//            } catch {
//                return .failure(.MyFail)
//            }
        }
        return ArenaReadDao()
    }
}

