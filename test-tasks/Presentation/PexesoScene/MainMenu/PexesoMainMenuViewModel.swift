//
//  PexesoMainMenuViewModel.swift
//  test-tasks
//
//  Created by Pavel Kochenda on 10.05.2021.
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
