//
//  ArenaShowViewModel.swift
//  bm
//
//  Created by ives on 2024/5/26.
//  Copyright © 2024 bm. All rights reserved.
//

import Foundation

class ArenaShowViewModel {
    var isLoading: Observable = Observable<Bool>()
    var dao: Observable = Observable<ArenaShowDao>()
    
    func getOne(token: String) {
        isLoading.value = true
        let url: String = URL_ARENA_ONE
        
        Task {
            var params: [String: String] = ["arena_token": token]
            //params = otherParams != nil ? params.merging(otherParams!, uniquingKeysWith: {$1}) : params
            
            do {
                let apiService = ApiService<ArenaShowDao>()
                let result = try await apiService.get(_url: url, params: params)
                switch result {
                case .success(let dao):
                    //dao.printDao()
                    self.dao.value = dao
                    //return dao
                case .failure(let error):
                    print(error)
                case .loading(let isLoading):
                    print(isLoading)
                }
                self.isLoading.value = false
            } catch {
                print(error)
                self.isLoading.value = false
            }
        }
    }
}
