//
//  RootComponent.swift
//  test-tasks
//
//  Created by MSI on 20.01.2021.
//

import NeedleFoundation
import MoyaNetworkClient_Combine
import UIKit
import UseCase_Combine

protocol RootComponent: Scope {
    
    // MARK: Presentation layer
    
    var pexesoComponent: PexesoComponent { get }
    
    // MARK: Data layer
    
    var networkClient: NetworkClient { get }
    var networkClientRemoteMock: NetworkClient { get }
    var networkClientLocalMock: NetworkClient { get }
    var coreDataClient: CoreDataStorage { get }
}

class RootComponentImpl: BootstrapComponent, RootComponent {
    
    private override init() {
        registerProviderFactories()
        super.init()
    }
    fileprivate static let instance: RootComponentImpl = .init()
    
    // MARK: Presentation layer
    
    // 1. Pexeso
    
    var pexesoComponent: PexesoComponent {
        PexesoComponent(parent: self)
    }
     
    var pexesoGameViewModel: PexesoGameViewModel {
        PexesoGameViewModelOfflineImpl(timerUseCase: .timer(), fetchCardsUseCase: .fetchCardsDefault())
    }
    
    var pexesoMainMenuViewModel: PexesoMainMenuViewModel {
        PexesoMainMenuViewModelImpl(withLevel: 1, levelRange: 1...6)
    }
    
    // 2. ExchangeRates
    
    var exchangeRatesComponent: ExchangeRatesComponent {
        ExchangeRatesComponent(parent: self)
    }
    
    var exchangeRatesViewModel: ExchangeRatesViewModel {
        shared { ExchangeRatesViewModelImpl() }
    }
    
    // MARK: Data layer
    
    var networkClient: NetworkClient {
        shared { NetworkClient(jsonDecoder: JSONDecoder()) }
    }
    
    var networkClientRemoteMock: NetworkClient {
        shared { NetworkClient(jsonDecoder: JSONDecoder(), stubBehaviour: .withMockServer) }
    }
    
    var networkClientLocalMock: NetworkClient {
        shared { NetworkClient(jsonDecoder: JSONDecoder(), stubBehaviour: .delayed(seconds: 0.3)) }
    }
    
    var coreDataClient: CoreDataStorage {
        shared { CoreDataStorage() }
    }
}

@propertyWrapper
struct Subcomponent<Value: Scope> {
    private var value: Value
    
    var wrappedValue: Value {
        get { value }
        mutating set { value = newValue }
    }
    
    private let keyPath: KeyPath<RootComponent, Value>
    
    init(_ keyPath: KeyPath<RootComponent, Value>) {
        self.keyPath = keyPath
        self.value = RootComponentImpl.instance[keyPath: keyPath]
    }
}

@propertyWrapper
struct Injected<Value> {
    private var value: Value
    
    var wrappedValue: Value {
        get { value }
        mutating set { value = newValue }
    }
    
    private let keyPath: KeyPath<RootComponent, Value>
    
    init(_ keyPath: KeyPath<RootComponent, Value>) {
        self.keyPath = keyPath
        self.value = RootComponentImpl.instance[keyPath: keyPath]
    }
}

func resolve<Value>(_ keyPath: KeyPath<RootComponent, Value>) -> Value {
    return RootComponentImpl.instance[keyPath: keyPath]
}

func subcomponent<Value: Scope>(_ keyPath: KeyPath<RootComponent, Value>) -> Value {
    return RootComponentImpl.instance[keyPath: keyPath]
}
