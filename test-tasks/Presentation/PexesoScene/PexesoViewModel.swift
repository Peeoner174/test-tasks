//
//  GameViewModel.swift
//  test-tasks
//
//  Created by MSI on 20.01.2021.
//

import Combine
import UseCaseKit

protocol PexesoViewModelInput {
    func getCards()
    func updateLevel(_ level: Int)
}

protocol PexesoViewModelOutput {
    var cards: CurrentValueSubject<[Card], Error> { get }
    var level: CurrentValueSubject<Int, Never> { get }
    var levelRange: ClosedRange<Int> { get }
    var fetchCardsUseCase: UseCase<FetchCardsCommand> { get }
}

protocol PexesoViewModel: class, PexesoViewModelInput, PexesoViewModelOutput {}

class PexesoViewModelOfflineImpl: PexesoViewModel {
    private var bindings = Set<AnyCancellable>()
    
    // MARK: - Business logic properties
    
    private(set) var level: CurrentValueSubject<Int, Never>
    private(set) var cards: CurrentValueSubject<[Card], Error> = .init([])
    private(set) var fetchCardsUseCase: UseCase<FetchCardsCommand> = .fetchCardsDefault()
    
    var levelRange: ClosedRange<Int>
    
    init(withLevel level: Int, levelRange: ClosedRange<Int>) {
        self.levelRange = levelRange
        self.level = .init(levelRange.clamp(level))
    }
    
    // MARK: - PexesoViewModelInput
    
    func updateLevel(_ level: Int) {
        self.level.value = levelRange.clamp(level)
    }
    
    func getCards() {
        fetchCardsUseCase.dispatcher.dispatch(.fetchRandomCardsPairs(numberOfPairs: 2 << level.value))
    }
}

class PexesoViewModelRestImpl: PexesoViewModel {
    
    private var bindings = Set<AnyCancellable>()
    
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
    
    func getCards() {
        unimplemented()
    }
}
