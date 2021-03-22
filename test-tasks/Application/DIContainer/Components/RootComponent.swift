//
//  RootComponent.swift
//  test-tasks
//
//  Created by MSI on 20.01.2021.
//

import NeedleFoundation
import MoyaNetworkClient_Combine
import UIKit

protocol RootComponent: Scope {
    var pexesoComponent: PexesoComponent { get }
    var networkClient: NetworkClient { get }
    var coreDataClient: CoreDataStorage { get }
}

class RootComponentImpl: BootstrapComponent, RootComponent {
    
    private override init() {
        registerProviderFactories()
        super.init()
    }
    fileprivate static let instance: RootComponentImpl = .init()
    
    var networkClient: NetworkClient {
        shared { NetworkClient(jsonDecoder: JSONDecoder()) }
    }
    
    var coreDataClient: CoreDataStorage {
        shared { CoreDataStorage() }
    }

    // MARK: Pexeso
    
    var pexesoComponent: PexesoComponent {
        PexesoComponent(parent: self)
    }
     
    var pexesoViewModel: PexesoViewModel {
        shared { PexesoViewModelOfflineImpl(withLevel: 1, levelRange: 1...5) }
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
