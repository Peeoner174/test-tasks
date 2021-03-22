//
//  Repository.swift
//  test-tasks
//
//  Created by Pavel Kochenda on 22.03.2021.
//

protocol Repository {
    associatedtype Entity
}

protocol NetworkRepository: Repository {
    associatedtype NetworkClient
    
    var networkClient: NetworkClient { get }
}

protocol StorageRepository: Repository {
    associatedtype DatabaseClient
    
    var databaseClient: DatabaseClient { get }
}
