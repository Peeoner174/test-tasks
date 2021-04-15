//
//  TimerUseCase.swift
//  test-tasks
//
//  Created by MSI on 18.03.2021.
//

import Foundation
import UseCase_Combine

enum TimerState: Equatable {
    case pause(Int)
    case counting(Int)
    case stopped
    
    var count: Int {
        switch self {
        case let .counting(num): return num
        case let .pause(num): return num
        case .stopped: return 0
        }
    }
}

enum TimerCommand: Command {
    typealias State = TimerState
    case start
    case stop
    case reset
}

extension UseCase {
    
    static func timer() -> UseCase<TimerCommand> {
        .store(.stopped) { store in
            var timer: Timer?
            
            return {
                switch $0 {
                case .stop:
                    timer?.invalidate()
                    store.update { $0 = .pause($0.count) }
                    
                case .start:
                    timer?.invalidate()
                    store.update { $0 = .counting($0.count) }
                    timer = .scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                        store.update { $0 = .counting($0.count + 1) }
                    }
                    
                case .reset:
                    guard case .pause = store.currentState else { return }
                    timer?.invalidate()
                    store.update { $0 = .stopped }
                }
            }
        }
    }
    
    static func timerWithStart(on number: Int) -> UseCase<TimerCommand> {
        .store(.pause(number)) { store in
            var timer: Timer?
        
            return {
                switch $0 {
                case .stop:
                    timer?.invalidate()
                    store.update { $0 = .pause($0.count) }
                    
                case .start:
                    timer?.invalidate()
                    store.update { $0 = .counting($0.count) }
                    timer = .scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                        store.update { $0 = .counting($0.count + 1) }
                    }
                    
                case .reset:
                    guard case .pause = store.currentState else { return }
                    timer?.invalidate()
                    store.update { $0 = .stopped }
                }
            }
        }
    }
}

