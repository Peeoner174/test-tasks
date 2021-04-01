//
//  ExchangeRatesRepository.swift
//  test-tasks
//
//  Created by Pavel Kochenda on 31.03.2021.
//

import Combine

protocol ExchangeRatesRepository: NetworkRepository {
    func fetchLastUpdates(base: String) -> AnyPublisher<Entity, Error>
}

