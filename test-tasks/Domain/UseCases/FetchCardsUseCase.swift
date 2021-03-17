//
//  FetchRandomCardsPairsUseCase.swift
//  test-tasks
//
//  Created by Pavel Kochenda on 15.03.2021.
//

import UseCaseKit
import SFSafeSymbols

enum FetchCardsCommand: Command {
    typealias State = FetchState<[Card]>
    case fetchRandomCardsPairs(numberOfPairs: Int)
}

extension UseCase {
    static func fetchCardsDefault() -> UseCase<FetchCardsCommand> {
        .store(.unknown) { store in
            return {
                switch $0 {
                case .fetchRandomCardsPairs(let numberOfPairs):
                    store.update { $0 = .empty }
                }
            }
        }
    }
}

