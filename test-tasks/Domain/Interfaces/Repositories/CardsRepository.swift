//
//  CardsRepository.swift
//  test-tasks
//
//  Created by Pavel Kochenda on 16.03.2021.
//

import Combine

protocol CardsRepository {
    func fetchRandomCards<T: Error>(quantity: Int) -> AnyPublisher<[Card], T>
}
