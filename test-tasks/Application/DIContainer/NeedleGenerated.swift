

import MoyaNetworkClient_Combine
import NeedleFoundation
import UIKit

// swiftlint:disable unused_declaration
private let needleDependenciesHash : String? = nil

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

private class PexesoModuleDependencycf9b73615cbf04704ae7BaseProvider: PexesoModuleDependency {
    var pexesoViewModel: PexesoViewModel {
        return rootComponentImpl.pexesoViewModel
    }
    private let rootComponentImpl: RootComponentImpl
    init(rootComponentImpl: RootComponentImpl) {
        self.rootComponentImpl = rootComponentImpl
    }
}
/// ^->RootComponentImpl->PexesoComponent
private class PexesoModuleDependencycf9b73615cbf04704ae7Provider: PexesoModuleDependencycf9b73615cbf04704ae7BaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init(rootComponentImpl: component.parent as! RootComponentImpl)
    }
}
