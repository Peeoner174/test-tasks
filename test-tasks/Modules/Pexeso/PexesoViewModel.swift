//
//  GameViewModel.swift
//  test-tasks
//
//  Created by MSI on 20.01.2021.
//

import Combine
import SFSafeSymbols

protocol PexesoViewModelInput {
    func getCards()
    func updateLevel(_ level: Int)
}

protocol PexesoViewModelOutput {
    var cards: CurrentValueSubject<[Card]> { get }
    var level: CurrentValueSubject<Int> { get }
    var levelRange: ClosedRange<Int> { get }
}

protocol PexesoViewModel: class, PexesoViewModelInput, PexesoViewModelOutput {}

class PexesoViewModelOfflineImpl: PexesoViewModel {
    private var bindings = Set<AnyCancellable>()
    
    // MARK: - Business logic properties
    
    private(set) var level: CurrentValueSubject<Int>
    private(set) var cards: CurrentValueSubject<[Card]> = .init([])
    
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
        func getRandomSymbolPairs(numberOfCards: Int) -> [SFSymbol] {
            var array: [SFSymbol] = []
            
            for _ in stride(from: 0, to: numberOfCards, by: 2) {
                let nextRandomSymbol = SFSymbol.allCases.randomElement() ?? SFSymbol.xCircle
                array.append(contentsOf: [nextRandomSymbol, nextRandomSymbol])
            }
            return array.shuffled()
        }
        var cards: [Card] = []
        for (index, symbol) in getRandomSymbolPairs(numberOfCards: 2 << level.value).enumerated() {
            cards.append(Card(refKey: index, image: symbol.rawValue))
        }
        self.cards.value = cards
    }
}

class PexesoViewModelRestImpl: PexesoViewModel {
    private var bindings = Set<AnyCancellable>()
    
    // MARK: - Business logic properties
    
    var level: CurrentValueSubject<Int>
    var cards: CurrentValueSubject<[Card]> = .init([])
    
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
