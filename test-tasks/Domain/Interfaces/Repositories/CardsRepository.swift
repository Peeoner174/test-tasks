//
//  CardsRepository.swift
//  test-tasks
//
//  Created by Pavel Kochenda on 16.03.2021.
//

import Combine
import MoyaNetworkClient_Combine
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

protocol CardsRepository: Repository & NetworkRepository {
    func fetchRandomEntity(count: Int) -> AnyPublisher<[Entity], Error>
}

final class CardsRepositoryImpl: CardsRepository {
    typealias NetworkClient = MoyaNetworkClient_Combine.NetworkClient
    typealias Entity = Card
    
    let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchRandomEntity(count: Int) -> AnyPublisher<[Card], Error> {
        let cards = Array(0...count).map { index -> Card in
            let symbol = SFSymbol.allCases.randomElement()
            return Card(refKey: index, image: symbol?.rawValue)
        }
        return Result<[Card], Error>.success(cards).publisher.eraseToAnyPublisher()
    }
}
