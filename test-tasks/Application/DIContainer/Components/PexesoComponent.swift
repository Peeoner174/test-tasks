//
//  Pexeso.swift
//  test-tasks
//
//  Created by MSI on 20.01.2021.
//

import NeedleFoundation

protocol PexesoModuleDependency: Dependency {
    var pexesoGameViewModel: PexesoGameViewModel { get }
    var pexesoMainMenuViewModel: PexesoMainMenuViewModel { get }
}

class PexesoComponent: Component<PexesoModuleDependency> {
    
    var mainMenuViewController: PexesoMainMenuViewController {
        .instantiate(fromStoryboard: .pexeso) { coder in
            PexesoMainMenuViewController(coder: coder, viewModel: AnyPexesoMainMenuViewModel(wrappedValue: self.dependency.pexesoMainMenuViewModel))
        }
    }
    
    var gameViewController: PexesoGameViewController {
        .instantiate(fromStoryboard: .pexeso) { coder in
            PexesoGameViewController(coder: coder, viewModel: AnyPexesoGameViewModel(wrappedValue: self.dependency.pexesoGameViewModel))
        }
    }
}

