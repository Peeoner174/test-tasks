//
//  FetchRandomCardsPairsUseCase.swift
//  test-tasks
//
//  Created by Pavel Kochenda on 15.03.2021.
//

import Combine

enum FetchRandomCardsPairsError: Error {}

final class FetchRandomCardsPairsUseCase {
    typealias Publisher = AnyPublisher<ResultValue.Publisher.Output, ResultValue.Publisher.Failure>
    
    struct RequestValue {
        let numberOfPairs: Int
    }
    typealias ResultValue = Result<[Card], FetchRandomCardsPairsError>
    
    private let cardsRepository: CardsRepository
    
    init(cardsRepository: CardsRepository) {
        self.cardsRepository = cardsRepository
    }
    
    func execute(requestValue: RequestValue) -> Publisher {
        cardsRepository.fetchRandomCards(quantity: requestValue.numberOfPairs)
    }
}
