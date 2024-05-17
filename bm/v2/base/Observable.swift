//
//  Observable.swift
//  bm
//
//  Created by ives on 2024/5/15.
//  Copyright © 2024 bm. All rights reserved.
//

import Foundation

class Observable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?) -> Void)?
        
    func bind(observer: @escaping (T?) -> Void) {
        self.observer = observer
    }
}
