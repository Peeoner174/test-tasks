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
            
            // MARK: - Helpers funcs
            
            func makePairsAndShuffled(_ cards: [Card]) -> [Card] {
                cards.reduce(into: []) { result, card in
                    result.append(contentsOf: [card, card])
                }.shuffled()
            }
            
            // MARK: - Response handle blocks
            
            let onReceiveRequestBlock: ((Subscribers.Demand) -> Void)? = { _ in
                store.update { $0 = .loading }
            }
                        
            let onCompletionBlock: ((Subscribers.Completion<Error>) -> Void)? = { completion in
                switch completion {
                case .finished:
                    store.update { $0 = .complete }
                case .failure(let error):
                    store.update { $0 = .error(error) }
                }
            }
            
            let onReseiveValueBlock: VoidOutputClosure<[Card]> = { cards in
                store.update { $0 = .object(makePairsAndShuffled(cards)) }
            }
            
            return {
                switch $0 {
                case .fetchRandomCardsPairs(let numberOfPairs):
                    let fetchResult = cardsRepository.fetchRandomEntity(count: numberOfPairs).handleEvents(
                        receiveOutput: onReseiveValueBlock,
                        receiveCompletion: onCompletionBlock,
                        receiveRequest: onReceiveRequestBlock
                    )
                    fetchResult.sink().store(in: &bindings)
                case .resetCards:
                    guard case let .object(objects) = store.eventsRelay.value.filter({ state in
                        switch state {
                        case .object:
                            return true
                        default:
                            return false
                        }
                    }).last else {
                        return
                    }
                    let fetchResult = cardsRepository.fetchRandomEntity(count: objects.count / 2)
                        .handleEvents(
                            receiveOutput: onReseiveValueBlock,
                            receiveCompletion: onCompletionBlock,
                            receiveRequest: onReceiveRequestBlock
                        )
                    fetchResult.sink().store(in: &bindings)
                }
            }
        }
    }
}
