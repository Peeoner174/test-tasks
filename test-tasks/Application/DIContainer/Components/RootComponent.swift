//
//  RootComponent.swift
//  test-tasks
//
//  Created by MSI on 20.01.2021.
//

import NeedleFoundation
import UIKit

protocol RootComponent: Scope {
    var pexesoComponent: PexesoComponent { get }
}

class RootComponentImpl: BootstrapComponent, RootComponent {
    
    private override init() {
        registerProviderFactories()
        super.init()
    }
    static let instance: RootComponentImpl = .init()

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
