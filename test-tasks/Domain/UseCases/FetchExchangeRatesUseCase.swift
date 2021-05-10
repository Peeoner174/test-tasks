//
//  FetchExchangeRatesUseCase.swift
//  test-tasks
//
//  Created by Pavel Kochenda on 31.03.2021.
//

import Combine
import UseCase_Combine

enum FetchExchangeRatesCommand: Command {
    typealias State = FetchState<Сurrency.ConversionRates>
    case fetchLast(base: String)
}

extension UseCase {
    static func fetchLastDefault() -> UseCase<FetchExchangeRatesCommand> {
        .store(.unknown) { store in
            var bindings = Set<AnyCancellable>()
            let exchangeRatesRepository = ExchangeRatesRepositoryImpl(networkClient: resolve(\.networkClient))
            
            let standartOnStartFetchCommandBlock: ((Subscribers.Demand) -> Void)? = { _ in
                store.update { $0 = .loading }
            }
            
            let standartOnReceiveCompletionBlock: ((Subscribers.Completion<Error>) -> Void)? = { completion in
                switch completion {
                case .finished:
                    store.update { $0 = .complete }
                case .failure(let error):
                    store.update { $0 = .error(error) }
                }
            }
            
            let standartOnReveiveValueBlock: ((Сurrency.ConversionRates) -> Void)? = { object in
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
                store.update { $0 = .loading }
            }
            
            let standartOnReceiveCompletionBlock: ((Subscribers.Completion<Error>) -> Void)? = { completion in
                switch completion {
                case .finished:
                    store.update { $0 = .complete }
                case .failure(let error):
                    store.update { $0 = .error(error) }
                }
            }
            
            let standartOnReveiveValueBlock: ((Сurrency.ConversionRates) -> Void)? = { object in
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

