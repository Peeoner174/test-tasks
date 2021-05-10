//
//  FetchRandomCardsPairsUseCase.swift
//  test-tasks
//
//  Created by Pavel Kochenda on 15.03.2021.
//

import Combine
import Foundation
import UseCase_Combine

enum FetchCardsCommand: Command {
    typealias State = FetchState<[Card]>
    case fetchRandomCardsPairs(numberOfPairs: Int)
    case resetCards
}

extension UseCase {
    static func fetchCardsDefault() -> UseCase<FetchCardsCommand> {
        .store(.unknown) { store in
            var bindings = Set<AnyCancellable>()
            let cardsRepository = CardsRepositoryImpl()
            
            let standartOnStartFetchCommandBlock: VoidClosure = {
                logger.debug("use case start")
                print(Thread.current)
                store.update { $0 = .loading }
            }
                        
            let standartOnReceiveCompletionBlock: ((Subscribers.Completion<Error>) -> Void)? = { completion in
                logger.debug("use case complete")
                print(Thread.current)
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
                    standartOnStartFetchCommandBlock()
                    let fetchResult = cardsRepository.fetchRandomEntity(count: numberOfPairs).handleEvents(
                        receiveOutput: { cards in
                            logger.debug("use case value receive")
                            print(Thread.current)
                            let cardsPairs = cards.reduce(into: []) { result, card in
                                result.append(contentsOf: [card, card])
                            }.shuffled()
                            store.update { $0 = .object(cardsPairs)}
                        },
                        receiveCompletion: standartOnReceiveCompletionBlock
                    )
                    fetchResult.sink().store(in: &bindings)
                case .resetCards:
                    break
                }
            }
        }
    }
}
