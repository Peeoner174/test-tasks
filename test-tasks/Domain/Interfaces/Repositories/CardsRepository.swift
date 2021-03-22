//
//  CardsRepository.swift
//  test-tasks
//
//  Created by Pavel Kochenda on 16.03.2021.
//

import Combine
import SFSafeSymbols

protocol CardsRepository: Repository {
    func fetchRandomEntity(count: Int) -> AnyPublisher<[Entity], Error>
}
