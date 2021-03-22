//
//  FetchRandomCardsPairsUseCase.swift
//  test-tasks
//
//  Created by Pavel Kochenda on 15.03.2021.
//

import UseCaseKit
import Combine

enum FetchCardsCommand: Command {
    typealias State = FetchState<[Card]>
    case fetchRandomCardsPairs(numberOfPairs: Int)
}

extension UseCase {
    static func fetchCardsDefault() -> UseCase<FetchCardsCommand> {
        .store(.unknown) { store in
            var bindings = Set<AnyCancellable>()
            let cardsRepository = CardsRepositoryImpl()
            
            let onStartFetchCommandBlock: ((Subscribers.Demand) -> Void)? = { _ in
                store.update { $0 = .loading }
            }
            
            let onReceiveValueBlock: (([Card]) -> Void)? = { cards in
                let cardsPairs = cards.reduce(into: []) { result, card in
                    result.append(contentsOf: [card, card])
                }.shuffled()
                store.update { $0 = .object(cardsPairs)}
            }
            
            let onReceiveCompletionBlock: ((Subscribers.Completion<Error>) -> Void)? = { completion in
                switch completion {
                case .finished:
                    store.update { $0 = .complete }
                case .failure(let error):
                    store.update { $0 = .error(error) }
                }
            }
            
            return {
                switch $0 {
                case .fetchRandomCardsPairs(let numberOfPairs):
                    let fetchResult = cardsRepository.fetchRandomEntity(count: numberOfPairs).handleEvents(
                        receiveOutput: onReceiveValueBlock,
                        receiveCompletion: onReceiveCompletionBlock,
                        receiveRequest: onStartFetchCommandBlock
                    )
                    fetchResult.sink().store(in: &bindings)
                }
            }
        }
    }
}
