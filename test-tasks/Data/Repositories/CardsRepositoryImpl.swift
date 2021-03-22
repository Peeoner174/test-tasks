//
//  CardsRepositoryImpl.swift
//  test-tasks
//
//  Created by Pavel Kochenda on 16.03.2021.
//

import Combine
import SFSafeSymbols

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
