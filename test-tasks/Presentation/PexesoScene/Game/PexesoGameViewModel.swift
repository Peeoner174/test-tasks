//
//  PexesoGameViewModel.swift
//  test-tasks
//
//  Created by Pavel Kochenda on 10.05.2021.
//

import Combine
import UseCase_Combine

protocol PexesoGameViewModelInput {
    func setLevel(_ level: Int)
}

protocol PexesoGameViewModelOutput {
    var fetchCardsUseCase: UseCase<FetchCardsCommand> { get }
    var timerUseCase: UseCase<TimerCommand> { get }
}

typealias PexesoGameViewModel = BaseViewModel & PexesoGameViewModelOutput & PexesoGameViewModelInput

final class PexesoGameViewModelOfflineImpl: PexesoGameViewModel {
    
    let fetchCardsUseCase: UseCase<FetchCardsCommand>
    let timerUseCase: UseCase<TimerCommand>
    
    init(timerUseCase: UseCase<TimerCommand>, fetchCardsUseCase: UseCase<FetchCardsCommand>) {
        self.fetchCardsUseCase = fetchCardsUseCase
        self.timerUseCase = timerUseCase
        super.init()
    }
    
    func setLevel(_ level: Int) {
        fetchCardsUseCase.dispatcher.dispatch(.fetchRandomCardsPairs(numberOfPairs: level), async: true)
        timerUseCase.dispatcher.dispatch(.start)
    }
}

final class PexesoGameViewModelRestImpl: PexesoGameViewModel {
    
    // MARK: - Business logic properties
    
    let fetchCardsUseCase: UseCase<FetchCardsCommand>
    let timerUseCase: UseCase<TimerCommand>
    
    init(timerUseCase: UseCase<TimerCommand>, fetchCardsUseCase: UseCase<FetchCardsCommand>) {
        self.fetchCardsUseCase = fetchCardsUseCase
        self.timerUseCase = timerUseCase
        super.init()
    }
    
    func setLevel(_ level: Int) {
        fetchCardsUseCase.dispatcher.dispatch(.fetchRandomCardsPairs(numberOfPairs: level), async: true)
        timerUseCase.dispatcher.dispatch(.start)
    }
}

final class AnyPexesoGameViewModel: PexesoGameViewModel {
    
    var fetchCardsUseCase: UseCase<FetchCardsCommand> {
        wrappedValue.fetchCardsUseCase
    }
    
    var timerUseCase: UseCase<TimerCommand> {
        wrappedValue.timerUseCase
    }

    private var wrappedValue: PexesoGameViewModel
    
    init(wrappedValue: PexesoGameViewModel) {
        self.wrappedValue = wrappedValue
        super.init()
    }
    
    func setLevel(_ level: Int) {
        wrappedValue.setLevel(level)
    }
}

