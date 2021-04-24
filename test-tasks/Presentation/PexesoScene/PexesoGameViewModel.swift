//
//  GameViewModel.swift
//  test-tasks
//
//  Created by MSI on 20.01.2021.
//

import Combine
import UseCase_Combine

protocol PexesoMainMenuViewModelInput {
    func updateLevel(_ level: Int)
}

protocol PexesoMainMenuViewModelOutput {
    var level: CurrentValueSubject<Int, Never> { get }
    var levelRange: ClosedRange<Int> { get }
}

typealias PexesoMainMenuViewModel = BaseViewModel & PexesoMainMenuViewModelInput & PexesoMainMenuViewModelOutput

final class PexesoMainMenuViewModelImpl: PexesoMainMenuViewModel {
    
    private(set) var level: CurrentValueSubject<Int, Never>
    
    let levelRange: ClosedRange<Int>

    init(withLevel level: Int, levelRange: ClosedRange<Int>) {
        self.levelRange = levelRange
        self.level = .init(levelRange.clamp(level))
        super.init()
    }
    
    // MARK: - PexesoMainMenuViewModelInput
    
    func updateLevel(_ level: Int) {
        self.level.value = levelRange.clamp(level)
    }
}

protocol PexesoGameViewModelOutput {
    var fetchCardsUseCase: UseCase<FetchCardsCommand> { get }
    var timerUseCase: UseCase<TimerCommand> { get }
}

typealias PexesoGameViewModel = BaseViewModel & PexesoGameViewModelOutput

final class PexesoGameViewModelOfflineImpl: PexesoGameViewModel {
    
    let fetchCardsUseCase: UseCase<FetchCardsCommand>
    let timerUseCase: UseCase<TimerCommand>
    
    init(timerUseCase: UseCase<TimerCommand>, fetchCardsUseCase: UseCase<FetchCardsCommand>) {
        self.fetchCardsUseCase = fetchCardsUseCase
        self.timerUseCase = timerUseCase
        super.init()
    }
}

final class PexesoGameViewModelRestImpl: PexesoGameViewModel {
    
    // MARK: - Business logic properties
    
    var cards: CurrentValueSubject<[Card], Error> = .init([])
    var fetchCardsUseCase: UseCase<FetchCardsCommand> = .fetchCardsDefault()
    var timerUseCase: UseCase<TimerCommand> = .timer()
    
    init(timerUseCase: UseCase<TimerCommand>, fetchCardsUseCase: UseCase<FetchCardsCommand>) {
        self.fetchCardsUseCase = fetchCardsUseCase
        self.timerUseCase = timerUseCase
        super.init()
    }
}

final class AnyPexesoMainMenuViewModel: PexesoMainMenuViewModel {
    
    var level: CurrentValueSubject<Int, Never> {
        wrappedValue.level
    }
    
    var levelRange: ClosedRange<Int> {
        wrappedValue.levelRange
    }

    private var wrappedValue: PexesoMainMenuViewModel
    
    init(wrappedValue: PexesoMainMenuViewModel) {
        self.wrappedValue = wrappedValue
        super.init()
    }
    
    func updateLevel(_ level: Int) {
        wrappedValue.updateLevel(level)
    }
}

final class AnyPexesoGameViewModel: PexesoGameViewModel {

    private var wrappedValue: PexesoGameViewModel
    
    init(wrappedValue: PexesoGameViewModel) {
        self.wrappedValue = wrappedValue
        super.init()
                
        let publusher = self.wrappedValue.viewDidLoad.multicast(subject: self.viewDidLoad)
        publusher.sink { [weak self] _ in
            guard let self = self else { return }
     //       self.fetchCardsUseCase.dispatcher.dispatch(.fetchRandomCardsPairs(numberOfPairs: self.level.value), async: true)
        }.store(in: &bindings)
    }
    
    var fetchCardsUseCase: UseCase<FetchCardsCommand> {
        wrappedValue.fetchCardsUseCase
    }
    
    var timerUseCase: UseCase<TimerCommand> {
        wrappedValue.timerUseCase
    }
}
