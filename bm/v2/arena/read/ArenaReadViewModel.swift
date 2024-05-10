//
//  ArenaReadViewModel.swift
//  bm
//
//  Created by ives on 2024/5/10.
//  Copyright © 2024 bm. All rights reserved.
//

import Foundation

class ArenaReadViewModel {
    let repository: ArenaReadRepository
    init(repository: ArenaReadRepository) {
        self.repository = repository
        repository.getRead(page: 1, perpage: PERPAGE)
    }
}
