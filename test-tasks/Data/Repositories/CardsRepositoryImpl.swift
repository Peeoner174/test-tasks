//
//  CardsRepositoryImpl.swift
//  test-tasks
//
//  Created by Pavel Kochenda on 16.03.2021.
//

import Combine
import SFSafeSymbols

import Combine
import SFSafeSymbols

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

final class CardsRepositoryImpl: CardsRepository {
    typealias Entity = Card
    
    func fetchRandomEntity(count: Int) -> AnyPublisher<[Card], Error> {
        let cards = Array(0...count).map { index -> Card in
            let symbol = SFSymbol.allCases.randomElement()
            return Card(refKey: index, image: symbol?.rawValue)
        }
        return Result<[Card], Error>.success(cards).publisher.eraseToAnyPublisher()
    }
}
