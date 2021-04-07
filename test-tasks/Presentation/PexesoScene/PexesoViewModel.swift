//
//  GameViewModel.swift
//  test-tasks
//
//  Created by MSI on 20.01.2021.
//

import Combine
import UseCaseKit

protocol PexesoViewModelInput {
    func updateLevel(_ level: Int)
}

protocol PexesoViewModelOutput {
    var level: CurrentValueSubject<Int, Never> { get }
    var levelRange: ClosedRange<Int> { get }
    var fetchCardsUseCase: UseCase<FetchCardsCommand> { get }
}

typealias PexesoViewModel = BaseViewModel & PexesoViewModelInput & PexesoViewModelOutput

final class PexesoViewModelOfflineImpl: PexesoViewModel {
    
    // MARK: - Business logic properties
    
    private(set) var level: CurrentValueSubject<Int, Never>
    private(set) var fetchCardsUseCase: UseCase<FetchCardsCommand> = .fetchCardsDefault()
    
    var levelRange: ClosedRange<Int>
    
    init(withLevel level: Int, levelRange: ClosedRange<Int>) {
        self.levelRange = levelRange
        self.level = .init(levelRange.clamp(level))
        super.init()
    }
    
    // MARK: - PexesoViewModelInput
    
    func updateLevel(_ level: Int) {
        self.level.value = levelRange.clamp(level)
    }
}

final class PexesoViewModelRestImpl: PexesoViewModel {
    
    // MARK: - Business logic properties
    
    var level: CurrentValueSubject<Int, Never>
    var cards: CurrentValueSubject<[Card], Error> = .init([])
    var fetchCardsUseCase: UseCase<FetchCardsCommand> = .fetchCardsDefault()
    
    var levelRange: ClosedRange<Int>
    
    init(level: Int, levelRange: ClosedRange<Int>) {
        self.levelRange = levelRange
        self.level = .init(levelRange.clamp(level))
    }
    
    // MARK: - PexesoViewModelInput
    
    func updateLevel(_ level: Int) {
        self.level.value = levelRange.clamp(level)
    }
}

final class AnyPexesoViewModel: PexesoViewModel {
    private var wrappedValue: PexesoViewModel
    
    init(wrappedValue: PexesoViewModel) {
        self.wrappedValue = wrappedValue
        super.init()
        
        viewDidLoad.sink { [weak self] _ in
            guard let self = self else { return }
            self.fetchCardsUseCase.dispatcher.dispatch(.fetchRandomCardsPairs(numberOfPairs: self.level.value))
        }.store(in: &bindings)
    }
    
    func updateLevel(_ level: Int) {
        wrappedValue.updateLevel(level)
    }
    
    var level: CurrentValueSubject<Int, Never> {
        wrappedValue.level
    }
    
    var levelRange: ClosedRange<Int> {
        wrappedValue.levelRange
    }
    
    var fetchCardsUseCase: UseCase<FetchCardsCommand> {
        wrappedValue.fetchCardsUseCase
    }
}
