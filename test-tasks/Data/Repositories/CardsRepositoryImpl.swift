//
//  CardsRepositoryImpl.swift
//  test-tasks
//
//  Created by Pavel Kochenda on 16.03.2021.
//

import Combine

final class CardsRepositoryImpl: CardsRepository {
    func fetchRandomCards<T>(quantity: Int) -> AnyPublisher<[Card], T> where T : Error {
        unimplemented()
    }
}
