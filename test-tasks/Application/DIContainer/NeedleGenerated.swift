

import MoyaNetworkClient_Combine
import NeedleFoundation
import UIKit
import UseCase_Combine

// swiftlint:disable unused_declaration
private let needleDependenciesHash : String? = nil

// MARK: - Registration

public func registerProviderFactories() {
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponentImpl->ExchangeRatesComponent") { component in
        return ExchangeRatesDependencycef0384644d727ea885dProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponentImpl") { component in
        return EmptyDependencyProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponentImpl->PexesoComponent") { component in
        return PexesoModuleDependencycf9b73615cbf04704ae7Provider(component: component)
    }
    
}

// MARK: - Providers

private class ExchangeRatesDependencycef0384644d727ea885dBaseProvider: ExchangeRatesDependency {
    var exchangeRatesViewModel: ExchangeRatesViewModel {
        return rootComponentImpl.exchangeRatesViewModel
    }
    private let rootComponentImpl: RootComponentImpl
    init(rootComponentImpl: RootComponentImpl) {
        self.rootComponentImpl = rootComponentImpl
    }
}
/// ^->RootComponentImpl->ExchangeRatesComponent
private class ExchangeRatesDependencycef0384644d727ea885dProvider: ExchangeRatesDependencycef0384644d727ea885dBaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init(rootComponentImpl: component.parent as! RootComponentImpl)
    }
}
private class PexesoModuleDependencycf9b73615cbf04704ae7BaseProvider: PexesoModuleDependency {
    var pexesoGameViewModel: PexesoGameViewModel {
        return rootComponentImpl.pexesoGameViewModel
    }
    var pexesoMainMenuViewModel: PexesoMainMenuViewModel {
        return rootComponentImpl.pexesoMainMenuViewModel
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
