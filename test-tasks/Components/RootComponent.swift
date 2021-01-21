//
//  RootComponent.swift
//  test-tasks
//
//  Created by MSI on 20.01.2021.
//

import NeedleFoundation

fileprivate let sharedDIContainer: DIContainer = DIContainerImpl()

protocol Injector {
    var DIContainer: DIContainer { get }
}

extension Injector {
    var DIContainer: DIContainer {
        return sharedDIContainer
    }
}

protocol AppCoordinatorResolver {
    var appCoordinator: AppCoordinator { get }
}

extension AppCoordinatorResolver {
    var appCoordinator: AppCoordinator {
        return sharedDIContainer.resolve(AppCoordinator.self)
    }
}

protocol DIContainer {
    func resolve<Type>(_ type: Type.Type) -> Type
    func resolve<Type>() -> Type
    func register<Type>(wireframe: KeyPath<DIStorable, Type>)
}

protocol DIStorable {
    var rootComponent: RootComponent { get }
}

private class DIContainerImpl: DIContainer, DIStorable {
    
    init() {
        registerProviderFactories()
    }
    
    lazy var rootComponent: RootComponent = RootComponentImpl()
    
    private lazy var storage: [ObjectIdentifier : PartialKeyPath<DIStorable>] = [
        ObjectIdentifier(PexesoComponent.self) : \DIStorable.rootComponent.pexesoComponent,
        ObjectIdentifier(TestTaskListComponent.self) : \DIStorable.rootComponent.testTaskListComponent,
        ObjectIdentifier(RootComponent.self) : \DIStorable.rootComponent,
        ObjectIdentifier(AppCoordinator.self) : \DIStorable.rootComponent.appCoordinator
    ]
        
    func resolve<Type>(_ type: Type.Type) -> Type {
        guard let key = storage[ObjectIdentifier(type)] else { fatalError(String(describing: type) + " type not exist in storage of DIContainer" ) }
        return self[keyPath: key] as! Type
    }
    
    func resolve<Type>() -> Type {
        return resolve(Type.self)
    }
    
    func register<Type>(wireframe: KeyPath<DIStorable, Type>) {
        storage[ObjectIdentifier(Type.self)] = wireframe
    }
}

protocol RootComponent: Scope {
    var pexesoComponent: PexesoComponent { get }
    var testTaskListComponent: TestTaskListComponent { get }
    var appCoordinator: AppCoordinator { get }
}

class RootComponentImpl: BootstrapComponent, RootComponent {

    // MARK: Pexeso
    
    var pexesoComponent: PexesoComponent {
        PexesoComponent(parent: self)
    }
     
    var pexesoViewModel: PexesoViewModel {
        shared { PexesoViewModelOfflineImpl(withLevel: 1, levelRange: 1...5) }
    }
    
    var pexesoCoordinator: PexesoCoordinator {
        appCoordinator.childCoordinators.compactMap { $0 as? PexesoCoordinator }.first!
    }
    
    // MARK: TestTaskList
    
    var testTaskListComponent: TestTaskListComponent {
        TestTaskListComponent(parent: self)
    }
    
    var testTaskListCoordinator: TestTasksListCoordinator {
        appCoordinator.childCoordinators.compactMap { $0 as? TestTasksListCoordinator }.first!
    }
    
    // MARK: Root
    
    var appCoordinator: AppCoordinator {
        let appCoordinatorFactory: (() -> AppCoordinator) = {
            let window = (UIApplication.shared.delegate as! AppDelegate).window!
            let navigationController = NavigationController()
            let router: Router = RouterImpl(navigationController: navigationController)
            return AppCoordinator(window: window, router: router, navigationController: navigationController)
        }
        return shared(appCoordinatorFactory)
    }
}
 
