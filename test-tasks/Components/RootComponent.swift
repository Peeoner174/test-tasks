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
    var appCoordinator: AppCoordinator { get }
}

class RootComponentImpl: BootstrapComponent, RootComponent {
    
    private override init() {}
    static let instance: RootComponentImpl = .init()

    // MARK: Pexeso
    
    var pexesoComponent: PexesoComponent {
        PexesoComponent(parent: self)
    }
     
    var pexesoViewModel: PexesoViewModel {
        shared { PexesoViewModelOfflineImpl(withLevel: 1, levelRange: 1...5) }
    }
    
    // MARK: Root
    
    var appCoordinator: AppCoordinator {
        shared { AppCoordinator(window: (UIApplication.shared.delegate as! AppDelegate).window!) }
    }
}

@propertyWrapper
struct Subcomponent<Value: Scope> {
    var wrappedValue: Value {
        RootComponentImpl.instance[keyPath: keyPath]
    }
    
    private let keyPath: KeyPath<RootComponent, Value>
    
    init(_ keyPath: KeyPath<RootComponent, Value>) {
        self.keyPath = keyPath
    }
}

@propertyWrapper
struct Injected<Value> {
    var wrappedValue: Value {
        RootComponentImpl.instance[keyPath: keyPath]
    }
    
    private let keyPath: KeyPath<RootComponent, Value>
    
    init(_ keyPath: KeyPath<RootComponent, Value>) {
        self.keyPath = keyPath
    }
}





