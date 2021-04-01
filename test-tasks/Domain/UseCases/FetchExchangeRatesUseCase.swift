//
//  FetchExchangeRatesUseCase.swift
//  test-tasks
//
//  Created by Pavel Kochenda on 31.03.2021.
//

import UseCaseKit
import Combine

enum FetchExchangeRatesCommand: Command {
    typealias State = FetchState<ConversionRates>
    case fetchLast(base: String)
}

extension UseCase {
    static func fetchLastDefault() -> UseCase<FetchExchangeRatesCommand> {
        .store(.unknown) { store in
            var bindings = Set<AnyCancellable>()
            let cardsRepository = ExchangeRatesRepositoryImpl(networkClient: resolve(\.networkClient))
            
            return {
                switch $0 {
                case .fetchLast(let base):
                    break
                }
            }
        }
    }
    
    static func fetchLastMock() -> UseCase<FetchExchangeRatesCommand> {
        .store(.unknown) { store in
            var bindings = Set<AnyCancellable>()
            let cardsRepository = ExchangeRatesRepositoryImpl(networkClient: resolve(\.networkClient))
            
            return {
                switch $0 {
                case .fetchLast(let base):
                    break
                }
            }
        }
    }
}
