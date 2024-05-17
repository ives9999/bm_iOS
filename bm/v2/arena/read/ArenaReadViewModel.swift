//
//  ArenaReadViewModel.swift
//  bm
//
//  Created by ives on 2024/5/10.
//  Copyright © 2024 bm. All rights reserved.
//

import Foundation

class ArenaReadViewModel {
    
    //let repository: ArenaReadRepository
    var isLoading: Observable = Observable<Bool>()
    
    init(repository: ArenaReadRepository) {
        
        //self.repository = repository
        
    }
    
    func getData() {
        isLoading.value = true
        let url: String = URL_ARENA_LIST
        Task {
            var params: [String: String] = ["page": "1", "perpage": String(PERPAGE)]
            //params = otherParams != nil ? params.merging(otherParams!, uniquingKeysWith: {$1}) : params
            
            do {
                let apiService = ApiService()
                let result = try await apiService.get(_url: url, params: params)
                switch result {
                case .success(let dao):
                    dao.printDao()
                    //return dao
                case .failure(let error):
                    print(error)
                }
                isLoading.value = false
            } catch {
                //return ArenaReadDao()
                isLoading.value = false
            }
        }
    }
}
