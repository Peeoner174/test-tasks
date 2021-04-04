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
            let exchangeRatesRepository = ExchangeRatesRepositoryImpl(networkClient: resolve(\.networkClient))
            
            let standartOnStartFetchCommandBlock: ((Subscribers.Demand) -> Void)? = { _ in
                logger.debug("use case start")
                store.update { $0 = .loading }
            }
            
            let standartOnReceiveCompletionBlock: ((Subscribers.Completion<Error>) -> Void)? = { completion in
                logger.debug("use case complete")
                switch completion {
                case .finished:
                    store.update { $0 = .complete }
                case .failure(let error):
                    store.update { $0 = .error(error) }
                }
            }
            
            let standartOnReveiveValueBlock: ((ConversionRates) -> Void)? = { object in
                logger.debug("use case receive value")
                store.update { $0 = .object(object) }
            }
            
            return {
                switch $0 {
                case .fetchLast(let base):
                    let fetchResult = exchangeRatesRepository.fetchLastUpdates(base: base).handleEvents(
                        receiveOutput: standartOnReveiveValueBlock,
                        receiveCompletion: standartOnReceiveCompletionBlock,
                        receiveRequest: standartOnStartFetchCommandBlock)
                    
                    fetchResult.sink().store(in: &bindings)
                }
            }
        }
    }
    
    static func fetchLastMock() -> UseCase<FetchExchangeRatesCommand> {
        .store(.unknown) { store in
            var bindings = Set<AnyCancellable>()
            let exchangeRatesRepository = ExchangeRatesRepositoryImpl(networkClient: resolve(\.networkClientRemoteMock))
            
            let standartOnStartFetchCommandBlock: ((Subscribers.Demand) -> Void)? = { _ in
                logger.debug("MOCK use case start")
                store.update { $0 = .loading }
            }
            
            let standartOnReceiveCompletionBlock: ((Subscribers.Completion<Error>) -> Void)? = { completion in
                logger.debug("MOCK use case complete")
                switch completion {
                case .finished:
                    store.update { $0 = .complete }
                case .failure(let error):
                    store.update { $0 = .error(error) }
                }
            }
            
            let standartOnReveiveValueBlock: ((ConversionRates) -> Void)? = { object in
                logger.debug("MOCK use case receive value")
                store.update { $0 = .object(object) }
            }
            
            return {
                switch $0 {
                case .fetchLast(let base):
                    let fetchResult = exchangeRatesRepository.fetchLastUpdates(base: base).handleEvents(
                        receiveOutput: standartOnReveiveValueBlock,
                        receiveCompletion: standartOnReceiveCompletionBlock,
                        receiveRequest: standartOnStartFetchCommandBlock)
                    
                    fetchResult.sink().store(in: &bindings)
                }
            }
        }
    }
}

