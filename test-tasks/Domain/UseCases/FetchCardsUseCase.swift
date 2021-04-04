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
            
            return {
                switch $0 {
                case .fetchRandomCardsPairs(let numberOfPairs):
                    let fetchResult = cardsRepository.fetchRandomEntity(count: numberOfPairs).handleEvents(
                        receiveOutput: { cards in
                            logger.debug("use case value receive")
                            let cardsPairs = cards.reduce(into: []) { result, card in
                                result.append(contentsOf: [card, card])
                            }.shuffled()
                            store.update { $0 = .object(cardsPairs)}
                        },
                        receiveCompletion: standartOnReceiveCompletionBlock,
                        receiveRequest: standartOnStartFetchCommandBlock
                    )
                    fetchResult.sink().store(in: &bindings)
                }
            }
        }
    }
}
