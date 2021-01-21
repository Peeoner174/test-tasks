//
//  Pair.swift
//  test-tasks
//
//  Created by MSI on 21.01.2021.
//

struct Pair<T> {

  private(set) var storage: (T?, T?)
    var onPairCompleteClosure: ((_ first: T, _ second: T) -> Void)?
    
    init(first: T? = nil, second: T? = nil) {
        storage.0 = first
        storage.1 = second
        
        guard let _ = storage.0, let _ = storage.1 else { return }
        onPairCompleteClosure?(storage.0!, storage.1!)
        storage.0 = nil; storage.1 = nil
    }

    var count: Int8 {
        if storage.0 != nil {
            return storage.1 == nil ? 1 : 2
        } else {
            return 0
        }
    }
    
    mutating func append(_ element: T) {
        if storage.0 == nil || storage.1 != nil {
            storage.0 = element
        } else {
            storage.1 = element
        }
        
        guard let _ = storage.0, let _ = storage.1 else { return }
        onPairCompleteClosure?(storage.0!, storage.1!)
        storage.0 = nil; storage.1 = nil
    }
    
    var first: T? {
        storage.0
    }
    
    var second: T? {
        storage.1
    }
}
