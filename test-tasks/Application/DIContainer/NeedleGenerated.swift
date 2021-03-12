

import MoyaNetworkClient_Combine
import NeedleFoundation
import UIKit

// MARK: - Registration

public func registerProviderFactories() {
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponentImpl") { component in
        return EmptyDependencyProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponentImpl->PexesoComponent") { component in
        return PexesoModuleDependencycf9b73615cbf04704ae7Provider(component: component)
    }
    
}

// MARK: - Providers

/// ^->RootComponentImpl->PexesoComponent
private class PexesoModuleDependencycf9b73615cbf04704ae7Provider: PexesoModuleDependency {
    var pexesoViewModel: PexesoViewModel {
        return rootComponentImpl.pexesoViewModel
    }
    private let rootComponentImpl: RootComponentImpl
    init(component: NeedleFoundation.Scope) {
        rootComponentImpl = component.parent as! RootComponentImpl
    }
}
