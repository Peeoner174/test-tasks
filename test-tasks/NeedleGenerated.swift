

import NeedleFoundation

// MARK: - Registration

public func registerProviderFactories() {
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponentImpl->TestTaskListComponent") { component in
        return TestTaskListDependencybb7c084038f1bd01ebd3Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponentImpl") { component in
        return EmptyDependencyProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponentImpl->PexesoComponent") { component in
        return PexesoModuleDependencycf9b73615cbf04704ae7Provider(component: component)
    }
    
}

// MARK: - Providers

/// ^->RootComponentImpl->TestTaskListComponent
private class TestTaskListDependencybb7c084038f1bd01ebd3Provider: TestTaskListDependency {
    var testTaskListCoordinator: TestTasksListCoordinator {
        return rootComponentImpl.testTaskListCoordinator
    }
    private let rootComponentImpl: RootComponentImpl
    init(component: NeedleFoundation.Scope) {
        rootComponentImpl = component.parent as! RootComponentImpl
    }
}
/// ^->RootComponentImpl->PexesoComponent
private class PexesoModuleDependencycf9b73615cbf04704ae7Provider: PexesoModuleDependency {
    var pexesoViewModel: PexesoViewModel {
        return rootComponentImpl.pexesoViewModel
    }
    var pexesoCoordinator: PexesoCoordinator {
        return rootComponentImpl.pexesoCoordinator
    }
    private let rootComponentImpl: RootComponentImpl
    init(component: NeedleFoundation.Scope) {
        rootComponentImpl = component.parent as! RootComponentImpl
    }
}
